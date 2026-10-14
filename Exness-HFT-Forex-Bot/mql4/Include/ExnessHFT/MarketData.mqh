#ifndef EXNESS_HFT_MARKET_DATA_MQH
#define EXNESS_HFT_MARKET_DATA_MQH

struct QuoteSnapshot {
   double bid;
   double ask;
   datetime server_time;
   double spread_points;
};

bool GetValidQuote(QuoteSnapshot &quote, int stale_seconds, string &reason) {
   RefreshRates();
   quote.bid=Bid; quote.ask=Ask; quote.server_time=TimeCurrent();
   if(quote.bid <= 0 || quote.ask <= quote.bid || Point <= 0) { reason="invalid bid/ask"; return(false); }
   quote.spread_points=(quote.ask-quote.bid)/Point;
   if(TimeCurrent()-quote.server_time > stale_seconds) { reason="stale quote"; return(false); }
   reason="ok"; return(true);
}
#endif
