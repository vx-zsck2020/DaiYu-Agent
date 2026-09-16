$root = Split-Path -Parent $PSScriptRoot
$need = @("SKILL.md", "README.md", "LICENSE", "VERSION", "CHANGELOG.md", "dispatch.md", "slot-prompts.md", "diagrams.md", "examples.md", "agent-registry.md", "control-plane.md", "evidence-schema.md")
$fail = $false

foreach ($f in $need) {
  $p = Join-Path $root $f
  if (-not (Test-Path $p)) {
    Write-Output "MISSING $f"
    $fail = $true
  }
  else {
    Write-Output "OK $f $((Get-Item $p).Length)b"
  }
}

if (Test-Path (Join-Path $root "security.md")) {
  Write-Output "FAIL security.md must be removed from the pipeline"
  $fail = $true
}

$skillPath = Join-Path $root "SKILL.md"
$desc = Get-Content $skillPath -Raw -Encoding utf8

if ($desc -notmatch '(?m)^description:') { Write-Output "FAIL no description"; $fail = $true }
if ($desc -notmatch '六闸') { Write-Output "FAIL missing trigger 六闸"; $fail = $true }
if ($desc -notmatch '黛玉') { Write-Output "FAIL missing primary trigger 黛玉"; $fail = $true }
if ($desc -notmatch 'ACTION REQUIRED') { Write-Output "FAIL missing ACTION REQUIRED"; $fail = $true }
if ($desc -notmatch 'work/six-gates') { Write-Output "FAIL missing ledger path"; $fail = $true }
if ($desc -notmatch 'dispatch\.md') { Write-Output "FAIL missing dispatch link"; $fail = $true }
if ($desc -match 'security\.md') { Write-Output "FAIL SKILL.md must not require security.md"; $fail = $true }
if ($desc -match '打回安全') { Write-Output "FAIL leftover 打回安全 label"; $fail = $true }
if ($desc -notmatch 'CHECKPOINT') { Write-Output "FAIL missing CHECKPOINT marker"; $fail = $true }
if ($desc -notmatch '一线修复') { Write-Output "FAIL missing fallback first-line repair"; $fail = $true }
if ($desc -notmatch '仍失败兜底') { Write-Output "FAIL missing fallback last resort"; $fail = $true }
if ($desc -notmatch 'Token 装箱') { Write-Output "FAIL missing token packing protocol"; $fail = $true }
if ($desc -notmatch '多 Agent 协同与并发是硬要求[\s\S]*?至少 2 个 Task') { Write-Output "FAIL missing mandatory multi-agent concurrency"; $fail = $true }
if ($desc -notmatch 'goal_id') { Write-Output "FAIL missing goal_id contract"; $fail = $true }
if ($desc -notmatch 'goal_status') { Write-Output "FAIL missing goal_status contract"; $fail = $true }
if ($desc -notmatch 'COMPLETED') { Write-Output "FAIL missing goal completion state"; $fail = $true }
if ($desc -notmatch 'canonical_name: DaiYu-Agent') { Write-Output "FAIL missing canonical name metadata"; $fail = $true }
if ($desc -notmatch 'display_name: 黛玉Agent') { Write-Output "FAIL missing display name metadata"; $fail = $true }
if ($desc -notmatch 'repository: https://github.com/vx-zsck2020/DaiYu-Agent.git') { Write-Output "FAIL missing repository metadata"; $fail = $true }
if ($desc -notmatch '(?m)^name: daiyu-agent\r?$') { Write-Output "FAIL invalid standard skill id"; $fail = $true }
if ($desc -notmatch 'legacy_aliases') { Write-Output "FAIL missing legacy alias metadata"; $fail = $true }
if ($desc -notmatch 'control_plane_version') { Write-Output "FAIL missing control plane version"; $fail = $true }
if ($desc -notmatch 'last_event_id') { Write-Output "FAIL missing event cursor"; $fail = $true }
if ($desc -notmatch 'DevUI Admin Page') { Write-Output "FAIL missing DevUI admin default"; $fail = $true }
if ($desc -notmatch 'devui.design/home') { Write-Output "FAIL missing DevUI frontend default"; $fail = $true }
if ($desc -notmatch 'devui.design/icon/ruleResource') { Write-Output "FAIL missing DevUI icon default"; $fail = $true }
if ($desc -notmatch 'stack-decision\.md') { Write-Output "FAIL missing stack decision artifact"; $fail = $true }
if ($desc -notmatch 'token-budget\.md') { Write-Output "FAIL missing token budget artifact"; $fail = $true }
if ($desc -notmatch 'agent-registry\.md') { Write-Output "FAIL missing agent registry link"; $fail = $true }
if ($desc -notmatch 'control-plane\.md') { Write-Output "FAIL missing control plane link"; $fail = $true }
if ($desc -notmatch 'evidence-schema\.md') { Write-Output "FAIL missing evidence schema link"; $fail = $true }
if ($desc -notmatch '70%.*85%.*95%') { Write-Output "FAIL missing token thresholds"; $fail = $true }
if (($desc -split 'goal_id:').Count -ne 2) { Write-Output "FAIL ledger template must define exactly one goal_id field"; $fail = $true }
if ($desc -match 'goal_status:[\s]*ACTIVE\|PAUSED\|BLOCKED\|COMPLETE\|') { Write-Output "FAIL legacy COMPLETE status found"; $fail = $true }
if ($desc -notmatch 'create_goal') { Write-Output "FAIL missing create_goal binding"; $fail = $true }
if ($desc -notmatch 'get_goal') { Write-Output "FAIL missing get_goal binding"; $fail = $true }
if ($desc -notmatch 'update_goal') { Write-Output "FAIL missing update_goal binding"; $fail = $true }
if ($desc -notmatch '独立 reviewer|独立质量审查') { Write-Output "FAIL missing independent reviewer contract"; $fail = $true }

$fm = [regex]::Match($desc, '(?s)^---\r?\n(.*?)\r?\n---')
if ($fm.Success -and $fm.Groups[1].Value -match '①.*②.*③.*④.*⑤') {
  Write-Output "WARN description may over-summarize workflow (SDO risk)"
}

$dispatch = Join-Path $root "dispatch.md"
if (-not (Select-String -Path $dispatch -Pattern 'STATUS: DONE' -Quiet)) {
  Write-Output "FAIL dispatch missing STATUS protocol"
  $fail = $true
}
if (-not (Select-String -Path $dispatch -Pattern '质量审查' -Quiet)) {
  Write-Output "FAIL dispatch missing 质量审查"
  $fail = $true
}
if (-not (Select-String -Path $dispatch -Pattern 'Token 装箱' -Quiet)) {
  Write-Output "FAIL dispatch missing Token packing"
  $fail = $true
}
if (-not (Select-String -Path $dispatch -Pattern 'packed_diff_path' -Quiet)) {
  Write-Output "FAIL dispatch missing packed_diff_path"
  $fail = $true
}
if (-not (Select-String -Path $dispatch -Pattern '只改所有权内路径' -Quiet)) {
  Write-Output "FAIL dispatch missing ownership boundary"
  $fail = $true
}
if (-not (Select-String -Path $dispatch -Pattern 'parallel_batch_id' -Quiet)) {
  Write-Output "FAIL dispatch missing parallel batch audit field"
  $fail = $true
}
if (-not (Select-String -Path $dispatch -Pattern 'goal_id' -Quiet)) { Write-Output "FAIL dispatch missing goal binding"; $fail = $true }
if (-not (Select-String -Path $dispatch -Pattern 'platform-neutral|平台中立' -Quiet)) { Write-Output "FAIL dispatch missing platform-neutral contract"; $fail = $true }
if (-not (Select-String -Path $dispatch -Pattern '禁止修改产品代码' -Quiet)) { Write-Output "FAIL dispatch missing reviewer no-code contract"; $fail = $true }
if (-not (Select-String -Path $dispatch -Pattern 'token_budget' -Quiet)) { Write-Output "FAIL dispatch missing token budget input"; $fail = $true }
if (-not (Select-String -Path $dispatch -Pattern 'agent-registry' -Quiet)) { Write-Output "FAIL dispatch missing registry contract"; $fail = $true }
if (-not (Select-String -Path $dispatch -Pattern 'evidence-schema' -Quiet)) { Write-Output "FAIL dispatch missing evidence contract"; $fail = $true }
if (-not (Select-String -Path $dispatch -Pattern 'same-goal-id' -Quiet)) { Write-Output "FAIL dispatch missing same-goal repair binding"; $fail = $true }
if (-not (Select-String -Path $dispatch -Pattern 'g3-verify.md' -Quiet)) {
  Write-Output "FAIL dispatch missing single-side verification report"
  $fail = $true
}
if (Select-String -Path $dispatch -Pattern '安全审查|攻防测试|打回安全' -Quiet) {
  Write-Output "FAIL dispatch still contains security/attack gates"
  $fail = $true
}

$slots = Join-Path $root "slot-prompts.md"
if (-not (Select-String -Path $slots -Pattern '③V 独立验证' -Quiet)) {
  Write-Output "FAIL slot-prompts missing verifier slot"
  $fail = $true
}
if (-not (Select-String -Path $slots -Pattern '## 质量审查' -Quiet)) {
  Write-Output "FAIL slot-prompts missing quality review section name"
  $fail = $true
}
if (Select-String -Path $slots -Pattern 'security.md|攻防测试|打回安全' -Quiet) {
  Write-Output "FAIL slot-prompts still contains security/attack gates"
  $fail = $true
}

$examples = Join-Path $root "examples.md"
if (-not (Select-String -Path $examples -Pattern '单侧项目也必须并发' -Quiet)) {
  Write-Output "FAIL examples missing single-side concurrency case"
  $fail = $true
}
if (-not (Select-String -Path $examples -Pattern 'Goal 恢复' -Quiet)) { Write-Output "FAIL examples missing Goal recovery case"; $fail = $true }
if (-not (Select-String -Path $examples -Pattern 'Token 装箱' -Quiet)) { Write-Output "FAIL examples missing token packing case"; $fail = $true }
if (-not (Select-String -Path $examples -Pattern 'work/DaiYu-Agent' -Quiet)) { Write-Output "FAIL examples missing current workspace path"; $fail = $true }

$evidence = Join-Path $root "evidence-schema.md"
foreach ($field in @('attempt_id','parallel_batch_id','evidence_path','packed_diff_path','registry_profile','usage_source','token_event','context_files','output_max_lines')) {
  if (-not (Select-String -Path $evidence -Pattern ([regex]::Escape($field)) -Quiet)) { Write-Output "FAIL evidence schema missing $field"; $fail = $true }
}
if (Select-String -Path $evidence -Pattern 'attack_scope|attack_act|auth_evidence' -Quiet) {
  Write-Output "FAIL evidence schema still contains attack fields"
  $fail = $true
}

if ($fail) {
  Write-Output "FAIL DaiYu-Agent selfcheck"
  exit 1
}

Write-Output "PASS DaiYu-Agent selfcheck"
exit 0
