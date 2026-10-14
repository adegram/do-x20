# Architecture

The live execution path is entirely MQL4: `ExnessHFTBot.mq4` samples terminal quotes, evaluates a deterministic strategy, applies independent risk gates, and uses MT4 trade functions only after the execution gate passes. Python is offline research/testing only.

`Config` validates static safety inputs. `MarketData` validates prices. Strategies emit only `buy`, `sell`, or `no signal`. `RiskManager` and `CircuitBreaker` may reject any signal. `PositionSizer` uses current MT4 symbol metadata. `ExecutionEngine` prepares and submits one bounded request; `OrderManager` prevents duplicate managed entries. `TradeLedger` keeps distinct lifecycle counters. The EA never infers that a request is a fill.

The current EA is an initial research build: it creates a server-side stop-loss/take-profit on entry, tracks confirmed entries, and defaults to dry-run. Full live reconciliation, controlled timed exits, and broker-demo fault testing remain validation work before live review.
