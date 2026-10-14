# Exness-HFT-Forex-Bot — implementation report

Date: 2026-10-13

## Status

**DEVELOPMENT** — compiled and locally unit-tested, but not validated with historical market data, MT4 Strategy Tester, a demo account, or broker execution. It is not approved for live trading and no order was placed during this work.

## Delivered

- MQL4 EA (`ExnessHFTBot.mq4`) with a dry-run default, deterministic tick processing, momentum/mean-reversion candidates, spread and volatility filters, risk-based lot sizing, duplicate-position protection, circuit-breaker checks, structured terminal logs, server-side SL/TP, and a multi-factor live activation gate.
- MQL4 modules for configuration, market data, strategies, risk, sizing, order management, execution, counters, diagnostics, and utilities.
- Python offline modules for risk/circuit breakers, sizing, lifecycle state, accounting, strategies, tick validation, and an adverse-slippage cost model.
- Ten automated Python unit tests covering sizing, minimum-lot rejection, net accounting, lifecycle reconciliation, strategies, risk, stale quotes, tick validation, and slippage direction.
- Deployment, broker preflight, risk, research, security, troubleshooting, and completion-checklist documentation, plus compile/test/config-validation tools.

## Verification evidence

- Python runtime: 3.12.14.
- Unit tests: `Ran 10 tests ... OK`.
- MQL4 compiler: installed Exness MetaEditor.
- Compilation: `Result: 0 errors, 0 warnings, 78 msec elapsed`.
- EA output: created in the Exness MT4 data folder as `MQL4/Experts/ExnessHFTBot.ex4`.
- Git: initialized, clean initial commit `d60a4ae`.

## Live activation design

Live trade submission requires all of the following: `ExecutionMode=LIVE`; MT4 reports a non-demo account; broker preflight has been affirmed; live preflight has been affirmed; `AllowLiveTrading=true`; acknowledgment exactly `I_ACCEPT_LIVE_RISK`; valid configuration, quotes, risk limits, and terminal permissions. No condition changes automatically.

## Still required

1. Collect and validate account-specific Exness conditions, including symbol properties, costs, restrictions, and behavior.
2. Supply timestamped bid/ask history; conduct cost-aware historical, out-of-sample, walk-forward, and stress experiments.
3. Run MT4 Strategy Tester and Python/MT4 signal-parity checks on shared fixtures.
4. Run dry-run then supervised demo validation, reconciling fills, rejections, costs, latency, restart behavior, and broker history.
5. Measure the 10,000-round-trip target on observed demo execution. Do not infer it from code or CPU speed.
6. Review the live deployment checklist and grant separate explicit approval before a controlled live pilot.
