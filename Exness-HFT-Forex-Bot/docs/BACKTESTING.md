# Backtesting and validation

Run Python unit tests first. Add timestamped bid/ask data only under `data/raw/` (ignored by Git), validate gaps/duplicates/timezone, then produce a versioned report under `reports/`. Use matching fixtures to compare Python and MT4 signals.

Validation order: unit tests; cost-aware historical simulation; out-of-sample/walk-forward; stress tests; MT4 Strategy Tester; isolated demo execution; broker-history reconciliation; controlled live pilot. A Strategy Tester result is not evidence of real fill quality.
