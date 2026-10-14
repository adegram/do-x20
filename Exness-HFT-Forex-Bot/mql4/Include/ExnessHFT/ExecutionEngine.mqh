#ifndef EXNESS_HFT_EXECUTION_ENGINE_MQH
#define EXNESS_HFT_EXECUTION_ENGINE_MQH
int SubmitEntry(BotConfig &cfg, int direction, double lots, QuoteSnapshot &quote, string correlation_id, string &reason) {
   if(lots<=0) { reason="lot size below broker minimum or risk budget"; return(-1); }
   if(cfg.execution_mode==DRY_RUN) { Print("DRY_RUN entry ",correlation_id," direction=",direction," lots=",DoubleToString(lots,2)); reason="dry run request recorded"; return(0); }
   int type=(direction>0 ? OP_BUY : OP_SELL);
   double price=(type==OP_BUY ? quote.ask : quote.bid);
   double stop_distance=cfg.stop_points*Point, target_distance=cfg.take_profit_points*Point;
   double sl=(type==OP_BUY ? price-stop_distance : price+stop_distance);
   double tp=(type==OP_BUY ? price+target_distance : price-target_distance);
   int stop_level=(int)MarketInfo(Symbol(),MODE_STOPLEVEL);
   if(stop_level>0 && cfg.stop_points<stop_level) { reason="stop distance below broker stop level"; return(-1); }
   ResetLastError();
   int ticket=OrderSend(Symbol(),type,lots,NormalizeDouble(price,Digits),cfg.max_slippage_points,NormalizeDouble(sl,Digits),NormalizeDouble(tp,Digits),correlation_id,cfg.magic,0,clrBlue);
   if(ticket<0) { reason="OrderSend error="+IntegerToString(GetLastError()); return(-1); }
   reason="entry accepted ticket="+IntegerToString(ticket); return(ticket);
}
#endif
