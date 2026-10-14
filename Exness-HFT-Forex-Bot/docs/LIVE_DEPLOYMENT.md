# Deliberate live-trading activation

The live lock is configurable, but it is intentionally multi-factor. It is not permanent demo-only design. The EA permits a live request only when all are true:

1. `ExecutionMode=LIVE`.
2. MT4 reports a non-demo account.
3. `BrokerPreflightPassed=true` for that exact account/symbol.
4. `LivePreflightPassed=true` after reviewed backtest, stress-test, compile, and demo evidence.
5. `AllowLiveTrading=true`.
6. `LiveAcknowledgement="I_ACCEPT_LIVE_RISK"`.
7. Configuration, market data, risk checks, and terminal trade permissions all pass.

Changing any item does not happen automatically. Before a controlled live pilot, export test evidence, review risk limits and open-position policy, confirm the server/account identity in logs, use the minimum valid risk size, and supervise it. This project does not currently meet live-review acceptance criteria.
