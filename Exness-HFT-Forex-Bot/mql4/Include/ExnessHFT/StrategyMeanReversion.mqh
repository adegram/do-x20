#ifndef EXNESS_HFT_STRATEGY_MEAN_REVERSION_MQH
#define EXNESS_HFT_STRATEGY_MEAN_REVERSION_MQH
int MeanReversionSignal(double &mids[], int count, double threshold_points, double point) {
   if(count < 3 || point <= 0) return(0);
   double sum=0; for(int i=0; i<count-1; i++) sum+=mids[i];
   double deviation=(mids[count-1]-sum/(count-1))/point;
   if(deviation >= threshold_points) return(-1);
   if(deviation <= -threshold_points) return(1);
   return(0);
}

int EvaluateSignal(double &mids[], int count, int strategy, double threshold_points, double point) {
   if(strategy==0) return(MomentumSignal(mids,count,threshold_points,point));
   return(MeanReversionSignal(mids,count,threshold_points,point));
}
#endif
