# MT4 installation and compilation

Install the official Exness MT4 terminal yourself; do not place a password in this project. In the terminal choose **File > Open Data Folder**. In that data folder, copy `mql4/Experts/ExnessHFTBot.mq4` to `MQL4/Experts/` and the `mql4/Include/ExnessHFT/` folder to `MQL4/Include/ExnessHFT/`.

Open the EA in MetaEditor and compile. Confirm an `.ex4` is created with zero errors. Attach only to the intended demo chart, leave `ExecutionMode=DRY_RUN`, and ensure AutoTrading permissions match the test stage. The supplied `tools/compile_mql4.ps1` copies into an explicitly supplied data folder and invokes a supplied MetaEditor executable; inspect its output rather than assuming success.
