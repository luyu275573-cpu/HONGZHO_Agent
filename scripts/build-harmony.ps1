$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Push-Location $root
try {
  & hvigorw assembleHap --no-daemon
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }

  $hap = Get-ChildItem 'entry/build' -Filter '*.hap' -File -Recurse |
    Sort-Object LastWriteTime |
    Select-Object -Last 1
  if ($null -eq $hap -or $hap.Length -le 0) {
    Write-Error 'HAP artifact was not found'
    exit 1
  }
  Write-Output ('HAP: ' + $hap.FullName)
  Write-Output ('SIZE: ' + $hap.Length + ' bytes')
} finally {
  Pop-Location
}
