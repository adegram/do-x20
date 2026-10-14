# Strategy research policy

Candidates implemented in both intent and testable form are short-horizon momentum and mean reversion. The EA also applies a volatility-range and spread filter. These are hypotheses, not approved strategies.

Before looking at a final holdout, freeze: symbols, timestamps/timezone, data source, train/validation/holdout splits, parameter grid count, cost model, and thresholds. Compare with no-trade; use bid/ask whenever available; model variable spread, commission, latency, slippage, missed fills, and rejections; then conduct walk-forward and adverse-cost tests. Reject candidates with unstable out-of-sample results, unacceptable drawdown, or weak sensitivity. Record failures rather than retuning until they pass.

No historical data has been supplied in this workspace, so no performance, profitability, or throughput result exists.
