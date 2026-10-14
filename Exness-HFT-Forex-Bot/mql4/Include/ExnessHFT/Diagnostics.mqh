#ifndef EXNESS_HFT_DIAGNOSTICS_MQH
#define EXNESS_HFT_DIAGNOSTICS_MQH
void LogPreflight(BotConfig &cfg) {
   Print("PREFLIGHT broker=",AccountCompany()," server=",AccountServer()," demo=",IsDemo()," currency=",AccountCurrency()," symbol=",Symbol()," digits=",Digits," point=",DoubleToString(Point,Digits)," minlot=",MarketInfo(Symbol(),MODE_MINLOT)," lotstep=",MarketInfo(Symbol(),MODE_LOTSTEP)," stopLevel=",MarketInfo(Symbol(),MODE_STOPLEVEL));
   Print("PREFLIGHT execution_mode=",cfg.execution_mode," broker_preflight_passed=",cfg.broker_preflight_passed," live_preflight_passed=",cfg.live_preflight_passed);
}
#endif
