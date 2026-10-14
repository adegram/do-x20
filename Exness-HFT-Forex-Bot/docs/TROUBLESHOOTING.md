# Troubleshooting

If compilation cannot resolve `ExnessHFT/...`, confirm the folder is exactly `MQL4/Include/ExnessHFT`. If the EA logs a closed execution gate, read the precise reason and do not defeat it. If lot size is zero, inspect tick value/size, stop distance, risk budget, and broker lot limits. If orders are rejected, preserve the MT4 error/log evidence, reconcile the terminal/history before retrying, and update preflight findings.
