param([string]$Python = "python")
$ErrorActionPreference = "Stop"
& $Python -m unittest discover -s "$PSScriptRoot\..\python\tests" -v
exit $LASTEXITCODE
