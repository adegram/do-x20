#ifndef EXNESS_HFT_TRADE_LEDGER_MQH
#define EXNESS_HFT_TRADE_LEDGER_MQH
struct TradeCounters { int signals; int requests; int accepted; int rejected; int entry_fills; int exit_fills; int completed; int reconciled; };
void LogCounters(TradeCounters &c) { Print("COUNTERS signals=",c.signals," requests=",c.requests," accepted=",c.accepted," rejected=",c.rejected," entry_fills=",c.entry_fills," exit_fills=",c.exit_fills," round_trips=",c.completed," reconciled=",c.reconciled); }
#endif
