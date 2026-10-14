# Exness HFT Forex Bot

Safety-first MT4 Expert Advisor and offline Python research toolkit. This project begins in **DRY_RUN** mode. It may be deliberately moved through demo validation and, only after the documented checks and explicit user action, live trading.

This is not a claim of profitability or 10,000 daily round trips. MT4, broker limits, latency, data quality, and costs must be measured on the intended Exness account. See `docs/COMPLETION_CHECKLIST.md`.

## Local quick start

1. Install Python 3.11+ and run `python -m unittest discover -s python/tests -v`.
2. Copy `.env.example` to a private `.env` and adjust research-only inputs if required.
3. Copy `mql4/Experts/ExnessHFTBot.mq4` and `mql4/Include/ExnessHFT/` into the matching MT4 data-folder directories (use **File > Open Data Folder** in MT4), then compile in MetaEditor.
4. Attach to a demo chart with `ExecutionMode=DRY_RUN`; do not alter live safeguards until all gates in `docs/LIVE_DEPLOYMENT.md` pass.

No account credentials belong in this repository.
