#property strict
#property version   "1.000"
#property description "Safety-gated Exness/MT4 research EA. Defaults to dry-run."
#include <ExnessHFT/Config.mqh>
#include <ExnessHFT/MarketData.mqh>
#include <ExnessHFT/StrategyInterface.mqh>
#include <ExnessHFT/StrategyMomentum.mqh>
#include <ExnessHFT/StrategyMeanReversion.mqh>
#include <ExnessHFT/StrategyVolatilityFilter.mqh>
#include <ExnessHFT/PositionSizer.mqh>
#include <ExnessHFT/RiskManager.mqh>
#include <ExnessHFT/OrderManager.mqh>
#include <ExnessHFT/ExecutionEngine.mqh>
#include <ExnessHFT/TradeLedger.mqh>
#include <ExnessHFT/CircuitBreaker.mqh>
#include <ExnessHFT/Diagnostics.mqh>
#include <ExnessHFT/Utils.mqh>

input EExecutionMode ExecutionMode=DRY_RUN;
input EStrategyMode StrategyMode=MOMENTUM;
input int MagicNumber=2601013;
input double RiskPerTradeFraction=0.0025;
input double DailyLossFraction=0.02;
input double MaxDrawdownFraction=0.05;
input double MaxSpreadPoints=20;
input int MaxSlippagePoints=10;
input int StopPoints=100;
input int TakeProfitPoints=120;
input int MaxHoldSeconds=300;
input int StaleQuoteSeconds=5;
input bool BrokerPreflightPassed=false;
input bool LivePreflightPassed=false;
input bool AllowLiveTrading=false;
input string LiveAcknowledgement="";
input bool ManualEmergencyStop=false;
input bool ShowStatusPanel=true;

BotConfig g_cfg; TradeCounters g_counters; double g_mids[8]; int g_mid_count=0; double g_opening_equity=0, g_high_water=0, g_realized_today=0; bool g_halted=false;
double g_last_spread=0; int g_last_signal=0; string g_status_stage="INITIALIZING", g_status_detail="";

string ExecutionModeName() {
   if(g_cfg.execution_mode==DRY_RUN) return("DRY_RUN");
   if(g_cfg.execution_mode==DEMO) return("DEMO");
   return("LIVE");
}

string SignalName(int signal) {
   if(signal>0) return("BUY");
   if(signal<0) return("SELL");
   return("NONE");
}

void SetStatus(string stage, string detail) {
   g_status_stage=stage; g_status_detail=detail;
   if(!ShowStatusPanel) return;
   Comment("ExnessHFTBot v1.000\n",
           "State: ",g_status_stage,"\n",
           "Detail: ",g_status_detail,"\n",
           "Mode: ",ExecutionModeName()," | Strategy: ",(g_cfg.strategy==MOMENTUM ? "MOMENTUM" : "MEAN_REVERSION"),"\n",
           "Symbol: ",Symbol()," | Tick samples: ",IntegerToString(g_mid_count),"/8\n",
           "Spread: ",DoubleToString(g_last_spread,1)," points (limit ",DoubleToString(g_cfg.max_spread_points,1),")\n",
           "Last signal: ",SignalName(g_last_signal)," | Managed positions: ",IntegerToString(CountManagedOpenOrders(g_cfg.magic)),"\n",
           "Risk/trade: ",DoubleToString(g_cfg.risk_fraction*100.0,2),"% | Emergency stop: ",(ManualEmergencyStop ? "ON" : "OFF"));
}

int OnInit() {
   g_cfg.execution_mode=ExecutionMode; g_cfg.strategy=StrategyMode; g_cfg.magic=MagicNumber; g_cfg.risk_fraction=RiskPerTradeFraction; g_cfg.daily_loss_fraction=DailyLossFraction; g_cfg.max_drawdown_fraction=MaxDrawdownFraction; g_cfg.max_spread_points=MaxSpreadPoints; g_cfg.max_slippage_points=MaxSlippagePoints; g_cfg.stop_points=StopPoints; g_cfg.take_profit_points=TakeProfitPoints; g_cfg.max_hold_seconds=MaxHoldSeconds; g_cfg.stale_quote_seconds=StaleQuoteSeconds; g_cfg.broker_preflight_passed=BrokerPreflightPassed; g_cfg.live_preflight_passed=LivePreflightPassed; g_cfg.allow_live_trading=AllowLiveTrading; g_cfg.live_acknowledgement=LiveAcknowledgement;
   string reason; if(!ValidateConfig(g_cfg,reason)) { Print("INIT FAILED: ",reason); SetStatus("INIT FAILED",reason); return(INIT_PARAMETERS_INCORRECT); }
   g_opening_equity=AccountEquity(); g_high_water=g_opening_equity; LogPreflight(g_cfg);
   if(!ExecutionGatePassed(g_cfg,reason)) { Print("EXECUTION GATE CLOSED: ",reason); SetStatus("GATE CLOSED",reason); } else { Print("EXECUTION GATE: ",reason); SetStatus("READY",reason); }
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) { LogCounters(g_counters); Print("EA stopped reason=",reason); }

void OnTick() {
   if(AccountEquity()>g_high_water) g_high_water=AccountEquity();
   string reason;
   if(ManualEmergencyStop) { if(!g_halted) Print("HALT manual emergency stop"); g_halted=true; SetStatus("HALTED","manual emergency stop is ON"); return; }
   if(CircuitBreakerTriggered(g_opening_equity,g_high_water,g_realized_today,g_cfg,reason)) { Print("HALT ",reason); g_halted=true; SetStatus("HALTED",reason); return; }
   QuoteSnapshot quote; if(!GetValidQuote(quote,g_cfg.stale_quote_seconds,reason)) { Print("QUOTE REJECT: ",reason); SetStatus("WAITING FOR QUOTE",reason); return; }
   g_last_spread=quote.spread_points;
   double mid=(quote.bid+quote.ask)/2.0;
   if(g_mid_count<8) g_mids[g_mid_count++]=mid; else { for(int i=0;i<7;i++) g_mids[i]=g_mids[i+1]; g_mids[7]=mid; }
   if(g_halted) { SetStatus("HALTED","circuit breaker latched"); return; }
   if(g_mid_count<3) { SetStatus("COLLECTING TICKS","need "+IntegerToString(3-g_mid_count)+" more quote samples"); return; }
   if(!PassesVolatilityFilter(g_mids,g_mid_count,2,500,Point)) { SetStatus("WAITING FOR VOLATILITY","last tick range is outside the 2-500 point filter"); return; }
   int signal=EvaluateSignal(g_mids,g_mid_count,(int)g_cfg.strategy,2,Point); g_last_signal=signal;
   if(signal==0) { SetStatus("WAITING FOR SIGNAL","strategy has no valid momentum/mean-reversion entry"); return; }
   g_counters.signals++;
   if(!RiskApprove(g_cfg,quote,CountManagedOpenOrders(g_cfg.magic),g_opening_equity,g_high_water,g_realized_today,reason)) { Print("RISK REJECT: ",reason); SetStatus("RISK REJECT",reason); return; }
   if(!ExecutionGatePassed(g_cfg,reason)) { Print("GATE REJECT: ",reason); SetStatus("GATE REJECT",reason); return; }
   double lots=CalculateLots(AccountEquity(),g_cfg.risk_fraction,g_cfg.stop_points); string correlation=CorrelationId(); g_counters.requests++;
   SetStatus("ORDER REQUEST",SignalName(signal)+" "+DoubleToString(lots,2)+" lots");
   int ticket=SubmitEntry(g_cfg,signal,lots,quote,correlation,reason);
   if(ticket<0) { g_counters.rejected++; Print("ORDER REJECT: ",reason); SetStatus("ORDER REJECT",reason); return; }
   if(ticket>0) { g_counters.accepted++; if(HasManagedOrder(g_cfg.magic,ticket)) g_counters.entry_fills++; }
   Print("ORDER: ",reason);
   SetStatus((ticket==0 ? "DRY-RUN REQUEST" : "ORDER ACCEPTED"),reason);
}
