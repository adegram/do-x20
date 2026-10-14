#ifndef EXNESS_HFT_CIRCUIT_BREAKER_MQH
#define EXNESS_HFT_CIRCUIT_BREAKER_MQH
bool CircuitBreakerTriggered(double opening_equity, double high_water_equity, double realized_today, BotConfig &cfg, string &reason) {
   if(realized_today <= -opening_equity*cfg.daily_loss_fraction) { reason="daily loss breach"; return(true); }
   if(high_water_equity>0 && (high_water_equity-AccountEquity())/high_water_equity >= cfg.max_drawdown_fraction) { reason="drawdown breach"; return(true); }
   return(false);
}
#endif
