#ifndef EXNESS_HFT_POSITION_SIZER_MQH
#define EXNESS_HFT_POSITION_SIZER_MQH
double NormalizeLotsDown(double lots, double min_lot, double max_lot, double step) {
   if(min_lot<=0 || max_lot<min_lot || step<=0 || lots<min_lot) return(0);
   double rounded=MathFloor((lots+1e-12)/step)*step;
   if(rounded < min_lot) return(0);
   return(NormalizeDouble(MathMin(rounded,max_lot),2));
}

double CalculateLots(double equity, double risk_fraction, int stop_points) {
   double tick_value=MarketInfo(Symbol(),MODE_TICKVALUE), tick_size=MarketInfo(Symbol(),MODE_TICKSIZE);
   double min_lot=MarketInfo(Symbol(),MODE_MINLOT), max_lot=MarketInfo(Symbol(),MODE_MAXLOT), step=MarketInfo(Symbol(),MODE_LOTSTEP);
   if(equity<=0 || risk_fraction<=0 || stop_points<=0 || tick_value<=0 || tick_size<=0 || Point<=0) return(0);
   double per_lot=((stop_points*Point)/tick_size)*tick_value;
   if(per_lot<=0) return(0);
   return(NormalizeLotsDown((equity*risk_fraction)/per_lot,min_lot,max_lot,step));
}
#endif
