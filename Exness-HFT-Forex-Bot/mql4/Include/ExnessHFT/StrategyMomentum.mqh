#ifndef EXNESS_HFT_STRATEGY_MOMENTUM_MQH
#define EXNESS_HFT_STRATEGY_MOMENTUM_MQH
int MomentumSignal(double &mids[], int count, double threshold_points, double point) {
   if(count < 2 || point <= 0) return(0);
   double change=(mids[count-1]-mids[count-2])/point;
   if(change >= threshold_points) return(1);
   if(change <= -threshold_points) return(-1);
   return(0);
}
#endif
