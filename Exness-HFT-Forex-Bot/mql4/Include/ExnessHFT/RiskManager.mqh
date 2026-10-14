#ifndef EXNESS_HFT_RISK_MANAGER_MQH
#define EXNESS_HFT_RISK_MANAGER_MQH
bool RiskApprove(BotConfig &cfg, QuoteSnapshot &quote, int open_positions, double opening_equity, double high_water_equity, double realized_today, string &reason) {
   double equity=AccountEquity();
   if(equity<=0) { reason="invalid account equity"; return(false); }
   if(quote.spread_points > cfg.max_spread_points) { reason="spread exceeds limit"; return(false); }
   if(open_positions >= 1) { reason="maximum positions reached"; return(false); }
   if(realized_today <= -opening_equity*cfg.daily_loss_fraction) { reason="daily loss circuit breaker"; return(false); }
   if((high_water_equity-equity)/high_water_equity >= cfg.max_drawdown_fraction) { reason="drawdown circuit breaker"; return(false); }
   if(!IsTradeAllowed() && cfg.execution_mode!=DRY_RUN) { reason="terminal trading is unavailable"; return(false); }
   reason="approved"; return(true);
}
#endif
