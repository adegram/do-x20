# do-x20

A development workspace for the **Exness HFT Forex Bot** and its supporting research outputs. The project focuses on building, testing, and validating a safety-first MetaTrader 4 (MT4) Expert Advisor alongside offline Python tools for strategy research and risk checks.

> **Current status: Development only.** The bot has been compiled and locally unit-tested, but it has not yet been validated with historical market data, the MT4 Strategy Tester, a demo account, or live broker execution. It is not approved for live trading. See the [implementation report](outputs/IMPLEMENTATION_REPORT.md).

## Repository contents

| Path | Description |
| --- | --- |
| [`Exness-HFT-Forex-Bot/`](Exness-HFT-Forex-Bot/) | Main project: MT4 Expert Advisor, MQL4 modules, Python research/testing tools, configuration example, and documentation. |
| [`outputs/IMPLEMENTATION_REPORT.md`](outputs/IMPLEMENTATION_REPORT.md) | Current implementation status, delivered components, verification evidence, and remaining validation work. |

## Project overview

The bot is being developed for MetaTrader 4 and Exness, with a risk-first workflow:

- **Dry-run by default:** signal and decision processing can be evaluated without submitting live orders.
- **Explicit execution safeguards:** live trading requires multiple independent configuration, account, preflight, and acknowledgment checks.
- **Risk controls:** risk-based position sizing, spread and volatility filters, duplicate-position protection, and circuit-breaker checks.
- **Research before deployment:** historical-data evaluation, out-of-sample testing, Strategy Tester validation, and supervised demo testing remain necessary before any live pilot.
- **Python test tooling:** offline modules and unit tests support risk, sizing, strategy, tick-data, lifecycle, accounting, and slippage checks.

This repository does not claim profitability or verified high-frequency execution performance. The target of 10,000 completed round-trip trades per day is an unverified performance objective, not an achieved result. Feasibility depends on broker rules, account conditions, instrument properties, execution latency, available data, and trading costs.

## Getting started

1. Open [`Exness-HFT-Forex-Bot/README.md`](Exness-HFT-Forex-Bot/README.md) for the bot-specific setup instructions.
2. Review the deployment, risk, testing, and completion-checklist documentation inside [`Exness-HFT-Forex-Bot/docs/`](Exness-HFT-Forex-Bot/docs/).
3. Run the documented Python unit tests and compile the Expert Advisor in MetaEditor.
4. Begin with **DRY_RUN**, then validate using the MT4 Strategy Tester and a supervised demo account.
5. Do not enable live execution until every requirement in the live deployment checklist has been reviewed and explicitly approved.

Use **File → Open Data Folder** inside MT4 to locate the terminal's data directory when installing the Expert Advisor and its MQL4 include files. Follow the detailed instructions in the project README and documentation rather than assuming a compiled file alone is sufficient for deployment.

## Verification snapshot

According to the [implementation report](outputs/IMPLEMENTATION_REPORT.md):

- The MQL4 Expert Advisor compiled with 0 errors and 0 warnings in the reported local build.
- Ten Python unit tests passed in the reported test run.
- Historical performance, Strategy Tester results, demo-account behavior, broker execution, and the daily trade-volume target remain unvalidated.

These are implementation checks only; they are not evidence of profitability or readiness for live trading.

## Safety and security

- Never commit broker passwords, API keys, account credentials, or private environment files.
- Keep execution in dry-run or demo mode while validating.
- Do not bypass the live-trading gates or risk limits.
- Verify broker-specific trading conditions and all costs on the intended account.
- Treat all performance claims as unproven until independently supported by reproducible testing.

## Disclaimer

This repository is for software development, testing, and research. Forex trading involves substantial risk and can result in the loss of capital. Nothing in this repository is financial advice, a guarantee of returns, or a recommendation to trade. You are responsible for validating the software, complying with broker terms, and deciding whether to deploy it.

## Project links

[Exness-HFT-Forex-Bot](Exness-HFT-Forex-Bot/README.md) · [Implementation report](outputs/IMPLEMENTATION_REPORT.md)
