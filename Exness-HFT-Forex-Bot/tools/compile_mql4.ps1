param(
  [Parameter(Mandatory=$true)][string]$Mt4DataFolder,
  [Parameter(Mandatory=$true)][string]$MetaEditorPath
)
$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
if(-not (Test-Path (Join-Path $Mt4DataFolder "MQL4"))) { throw "Mt4DataFolder must be the folder reported by MT4 File > Open Data Folder." }
if(-not (Test-Path $MetaEditorPath)) { throw "MetaEditor executable was not found." }
Copy-Item (Join-Path $root "mql4\Experts\ExnessHFTBot.mq4") (Join-Path $Mt4DataFolder "MQL4\Experts\ExnessHFTBot.mq4") -Force
New-Item -ItemType Directory -Path (Join-Path $Mt4DataFolder "MQL4\Include\ExnessHFT") -Force | Out-Null
Copy-Item (Join-Path $root "mql4\Include\ExnessHFT\*") (Join-Path $Mt4DataFolder "MQL4\Include\ExnessHFT") -Recurse -Force
& $MetaEditorPath "/compile:$Mt4DataFolder\MQL4\Experts\ExnessHFTBot.mq4" "/log:$Mt4DataFolder\mql4_compile.log"
Write-Output "Inspect $Mt4DataFolder\mql4_compile.log and MetaEditor for actual compiler errors/warnings."
