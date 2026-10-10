$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot

$required = @(
  'AGENTS.md',
  'README.md',
  'tasks.md',
  'changes.md',
  'design.md',
  'design-qa.md',
  'build-profile.json5',
  'entry/src/main/module.json5',
  'entry/src/main/resources/base/profile/main_pages.json',
  'entry/src/main/ets/entryability/EntryAbility.ets',
  'entry/src/main/ets/pages/Index.ets',
  'entry/src/main/ets/common/DesignTokens.ets'
)

$missing = @($required | Where-Object { -not (Test-Path (Join-Path $root $_)) })
if ($missing.Count -gt 0) {
  Write-Error ('Missing required files: ' + ($missing -join ', '))
  exit 1
}

$module = Get-Content (Join-Path $root 'entry/src/main/module.json5') -Raw
$pages = Get-Content (Join-Path $root 'entry/src/main/resources/base/profile/main_pages.json') -Raw
$tasks = Get-Content (Join-Path $root 'tasks.md') -Raw

if ($module -notmatch '"type"\s*:\s*"entry"') { Write-Error 'entry module type is missing'; exit 1 }
if ($module -notmatch '"mainElement"\s*:\s*"EntryAbility"') { Write-Error 'EntryAbility is missing'; exit 1 }
if ($pages -notmatch 'pages/Index') { Write-Error 'Index page route is missing'; exit 1 }
if ($tasks -notmatch 'pending|in_progress|done|blocked') { Write-Error 'Task status is missing'; exit 1 }

Write-Output 'STANDARD CHECK PASSED'
