# Demo deployment

1. Complete and record broker preflight for the specific demo account and symbol.
2. Compile the EA and run Strategy Tester with the best available tick data.
3. Run attached to a demo chart in `DRY_RUN`; verify log messages, spread filters, lot sizing, and that no order appears.
4. Set `ExecutionMode=DEMO` and `BrokerPreflightPassed=true` only after step 3. Keep all conservative limits unchanged initially.
5. Reconcile every request, fill, closure, P&L, commission, swap, and broker-history record. Measure latency, rejections, slippage, disconnect recovery, and actual daily throughput.

Do not set live inputs on a demo account; the EA rejects that combination.
