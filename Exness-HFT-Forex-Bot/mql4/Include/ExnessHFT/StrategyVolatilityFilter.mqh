#ifndef EXNESS_HFT_STRATEGY_VOLATILITY_FILTER_MQH
#define EXNESS_HFT_STRATEGY_VOLATILITY_FILTER_MQH
bool PassesVolatilityFilter(double &mids[], int count, double min_range_points, double max_range_points, double point) {
   if(count < 2 || point <= 0) return(false);
   double lo=mids[0], hi=mids[0];
   for(int i=1; i<count; i++) { if(mids[i]<lo) lo=mids[i]; if(mids[i]>hi) hi=mids[i]; }
   double range=(hi-lo)/point;
   return(range >= min_range_points && range <= max_range_points);
}
#endif
