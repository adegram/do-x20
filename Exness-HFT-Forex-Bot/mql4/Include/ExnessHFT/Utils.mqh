#ifndef EXNESS_HFT_UTILS_MQH
#define EXNESS_HFT_UTILS_MQH
string CorrelationId() { return("EHFT_"+IntegerToString((int)TimeCurrent())+"_"+IntegerToString(GetTickCount())); }
#endif
