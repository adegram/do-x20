# do-x20

A development workspace for the **Exness HFT Forex Bot** and its supporting research outputs. The project focuses on building, testing, and validating a safety-first MetaTrader 4 (MT4) Expert Advisor alongside offline Python tools for strategy research and risk checks.

> **Current status: Development only.** The bot has been compiled and locally unit-tested, but it has not yet been validated with historical market data, the MT4 Strategy Tester, a demo account, or live broker execution. It is not approved for live trading. See the [implementation report](outputs/IMPLEMENTATION_REPORT.md).

## Where the MT4 program is located on this Mac

The project's MT4 Expert Advisor source files are located at:

```text
/Users/user1/Downloads/do-x20/Exness-HFT-Forex-Bot/mql4/Experts
```

This is the **project source directory** inside your Downloads folder. Open this path in Finder or your code editor to access the Expert Advisor source files.

### Important: source folder vs. MT4 installation folder

The path above is not necessarily the folder MT4 loads Expert Advisors from. To install the bot in your MT4 terminal:

1. Open the relevant **Exness MetaTrader 4** terminal.
2. Select **File → Open Data Folder**.
3. Open `MQL4/Experts` inside that data folder.
4. Copy the required `.mq4` Expert Advisor file from the project source directory above into that MT4 `MQL4/Experts` folder.
5. Copy any required project include files from `mql4/Include/` into the matching `MQL4/Include/` location in the same MT4 data folder, preserving the directory structure.
6. Open the copied `.mq4` file in MetaEditor and compile it. Check that compilation completes successfully, then refresh the Expert Advisors list in MT4 or restart the terminal if needed.

Use the `MQL4/Experts` location displayed by **File → Open Data Folder** for the terminal you intend to run. Do not assume the Downloads project directory is the terminal's active installation directory. Follow the bot-specific documentation before attaching it to a chart.

## Repository contents

The repository contains the MT4 Expert Advisor itself plus supporting files used to develop, maintain, configure, test, and validate the application. **Only the required Expert Advisor source and its dependencies belong in the matching MT4 data-folder locations**; the maintenance and testing folders are not meant to be copied wholesale into `MQL4/Experts`.

| Path | Purpose |
| --- | --- |
| [`Exness-HFT-Forex-Bot/mql4/Experts/`](Exness-HFT-Forex-Bot/mql4/Experts/) | Main MT4 Expert Advisor source files. This is the project source directory identified above. |
| [`Exness-HFT-Forex-Bot/mql4/Include/`](Exness-HFT-Forex-Bot/mql4/Include/) | Supporting MQL4 modules used by the Expert Advisor; preserve their folder structure when installing them into the MT4 data folder. |
| [`Exness-HFT-Forex-Bot/python/`](Exness-HFT-Forex-Bot/python/) | Offline Python research and testing code, including automated unit tests. |
| [`Exness-HFT-Forex-Bot/tools/`](Exness-HFT-Forex-Bot/tools/) | Helper scripts for development, checks, and validation. |
| [`Exness-HFT-Forex-Bot/docs/`](Exness-HFT-Forex-Bot/docs/) | Maintenance, setup, risk, testing, deployment, troubleshooting, and completion-checklist documentation. |
| [`Exness-HFT-Forex-Bot/data/`](Exness-HFT-Forex-Bot/data/) | Supporting data area for research and testing workflows. Do not place private account data or credentials in the repository. |
| [`Exness-HFT-Forex-Bot/reports/`](Exness-HFT-Forex-Bot/reports/) | Project research and testing reports. |
| [`Exness-HFT-Forex-Bot/pyproject.toml`](Exness-HFT-Forex-Bot/pyproject.toml) and [`.env.example`](Exness-HFT-Forex-Bot/.env.example) | Python project configuration and an example environment configuration for local development. Never commit secrets or a real private `.env` file. |
| [`outputs/IMPLEMENTATION_REPORT.md`](outputs/IMPLEMENTATION_REPORT.md) | Overall implementation status, delivered components, verification evidence, and remaining validation work. |

These supporting folders and files are part of the application's **maintenance and testing workspace**. They help with development, diagnostics, risk checks, research, and validation; they are not all runtime files that MT4 needs to load to run the Expert Advisor.

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
