param([ValidateSet("DRY_RUN","DEMO","LIVE")][string]$Mode = "DRY_RUN", [switch]$BrokerPreflightPassed, [switch]$LivePreflightPassed, [switch]$AllowLiveTrading, [string]$Acknowledgement = "")
if($Mode -eq "LIVE" -and (-not ($BrokerPreflightPassed -and $LivePreflightPassed -and $AllowLiveTrading -and $Acknowledgement -eq "I_ACCEPT_LIVE_RISK"))) { throw "LIVE configuration is incomplete; gate remains closed." }
if($Mode -eq "DEMO" -and -not $BrokerPreflightPassed) { throw "DEMO requires completed broker preflight." }
Write-Output "Configuration shape valid. Actual broker/account validation is performed by MT4 at runtime."
