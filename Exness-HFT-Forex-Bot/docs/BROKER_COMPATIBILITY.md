# Broker compatibility and preflight

No account-specific Exness fact is currently verified. Before changing from dry-run, record from the intended terminal: company/server, demo/live status, currency/equity, exact symbol and suffix, digits/point, contract/tick size/tick value, lot limits/step, stop/freeze levels, current and session spread distribution, commission, margin, execution mode, automated-trading policy, rate limits, request/fill latency, rejection behavior, and partial close behavior.

On initialization the EA logs the broker, server, account mode, symbol, digits, point, lot limits, and stop level exposed by MT4. Review that log, compare against the broker's account documentation, then set `BrokerPreflightPassed=true` only for the tested account and symbol. This flag is a human attestation, not a substitute for evidence.
