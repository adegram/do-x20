#ifndef EXNESS_HFT_CONFIG_MQH
#define EXNESS_HFT_CONFIG_MQH

enum EExecutionMode { DRY_RUN = 0, DEMO = 1, LIVE = 2 };
enum EStrategyMode { MOMENTUM = 0, MEAN_REVERSION = 1 };

struct BotConfig {
   EExecutionMode execution_mode;
   EStrategyMode strategy;
   int magic;
   double risk_fraction;
   double daily_loss_fraction;
   double max_drawdown_fraction;
   double max_spread_points;
   int max_slippage_points;
   int max_hold_seconds;
   int stale_quote_seconds;
   int stop_points;
   int take_profit_points;
   bool broker_preflight_passed;
   bool live_preflight_passed;
   bool allow_live_trading;
   string live_acknowledgement;
};

bool IsFinitePositive(double value) { return(value > 0.0 && value < 1.0e100); }

bool ValidateConfig(BotConfig &cfg, string &reason) {
   if(cfg.magic <= 0 || !IsFinitePositive(cfg.risk_fraction) || cfg.risk_fraction > 0.01) { reason="invalid risk or magic"; return(false); }
   if(cfg.daily_loss_fraction <= 0 || cfg.daily_loss_fraction > 0.10 || cfg.max_drawdown_fraction <= 0 || cfg.max_drawdown_fraction > 0.25) { reason="invalid circuit-breaker limits"; return(false); }
   if(cfg.max_spread_points <= 0 || cfg.max_slippage_points < 0 || cfg.stop_points <= 0 || cfg.take_profit_points <= 0) { reason="invalid execution limits"; return(false); }
   reason="ok"; return(true);
}

bool ExecutionGatePassed(BotConfig &cfg, string &reason) {
   if(!cfg.broker_preflight_passed) { reason="broker preflight is not confirmed"; return(false); }
   if(cfg.execution_mode == DRY_RUN) { reason="dry run"; return(true); }
   if(cfg.execution_mode == DEMO) {
      if(!IsDemo()) { reason="DEMO mode requires a demo account"; return(false); }
      reason="demo gate passed"; return(true);
   }
   if(IsDemo()) { reason="LIVE mode cannot run on a demo account"; return(false); }
   if(!cfg.allow_live_trading || !cfg.live_preflight_passed) { reason="live controls not explicitly enabled"; return(false); }
   if(cfg.live_acknowledgement != "I_ACCEPT_LIVE_RISK") { reason="live acknowledgement is missing"; return(false); }
   reason="live gate passed"; return(true);
}
#endif
