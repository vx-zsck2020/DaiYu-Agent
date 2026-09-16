# Independent Review — daiyu-agent

- **Judge:** independent (blind to “改完更好”叙事；只读现行文件)
- **Repo:** `E:\Exploitation\VS_Tools\DaiYu-Agent`
- **Rubric:** Darwin Skill 3.0 / SkillLens 9 维（维分 1–10 × 权重 / 10）
- **EVAL_MODE:** `dry_run`（dim8 未 spawn with_skill / baseline 子 Agent）
- **Date:** 2026-09-17
- **VERSION:** 1.1.0
- **selfcheck:** PASS（`scripts/selfcheck.ps1` exit 0）

Darwin 原文：结构维权重合计写「59」但表内 7+12+12+6+17+4=58；本评按任务给定权重计分（dim8=23）。**dry_run 占比 100% > 30% → 评估失效警告：dim8 与总分不可当作 full_test。**

权重：dim1=7, dim2=12, dim3=12, dim4=6, dim5=17, dim6=4, dim7=12, dim8=23, dim9=6。

---

## 必读文件清单

| 文件 | 现行状态 |
|------|----------|
| `SKILL.md` | 17149b；frontmatter `name: daiyu-agent`；288 行 |
| `dispatch.md` | 6696b；装箱顺序、外壳、③并发检查单、④⑤派发要点 |
| `slot-prompts.md` | 2827b；①–⑥ + ③V |
| `examples.md` | 3168b；U1–U9 |
| `scripts/selfcheck.ps1` | 关键词契约；禁止 `security.md` / `打回安全` |
| `test-prompts.json` | 3 条 |
| 辅读 | `control-plane.md`、`evidence-schema.md`、`agent-registry.md`、`diagrams.md`、`README.md` |

无 `security.md`。`CHANGELOG.md` 1.0.0 条仍写「安全门」，属历史记录，不构成现行闸门。

---

## 专项检查（任务第 2 点）

### 1. 流水线是否仍强制安全审查 / 攻防 / 威胁面

**结论：否。**

- `SKILL.md` 开篇：「本流程不含安全检测、威胁面冻结或攻防测试闸。」
- 闸表：④「独立质量审查」；⑤「功能测试」。回流标签无「打回安全」。
- `Do not use`：禁止把本流程当成安全审计或攻防测试框架。
- `dispatch.md` / `slot-prompts.md` 无「安全审查」「攻防测试」「打回安全」。
- `evidence-schema.md` 无 `attack_scope` / `attack_act` / `auth_evidence`。
- `selfcheck.ps1`：存在 `security.md` 即 FAIL；SKILL 引用 `security.md` 或残留「打回安全」即 FAIL。

现行强制审查面是验收清单、ownership、契约与双槽报告，不是威胁面冻结或攻防 ACT。

### 2. Token 装箱是否可执行（前缀 / 指针 / packed diff / 阈值）

**结论：协议可执行；用量计量偏软。**

| 层 | 现行规定 | 可执行性 |
|----|----------|----------|
| 稳定前缀 | Goal、闸、ownership glob、`token_budget`、`output_max_lines` | 可写进 Task 输入块 |
| 闸指针 | `plan.md#验收清单`、`ownership.md`、报告路径；禁止贴 SKILL/examples/diagrams/plan 全文 | 可执行 |
| packed diff | `git diff -- <allowed_paths>`；>200 行写入 `reports/_diff-<task_id>.txt`，prompt 只传 `packed_diff_path` | 可执行 |
| 阈值 | ≥70% compress / ≥85% stop-exploration / ≥95% close-only | 动作有名；**如何读取「用量」未给出命令或 API**，允许 `usage_source: estimated` |

④ 装箱范围（验收摘录 + ownership glob + packed diff）有写。Lead fan-in：先读 YAML 头。缺省 `output_max_lines` 已按槽给出。**缺省 `token_budget` 数值未给。**

### 3. CHECKPOINT 与失败三段式

**结论：都存在。**

- 专节标题：`## CHECKPOINT · STOP`。默认①②④⑥停；连续仅④打回或⑤测红 STOP；`到<闸>` 完成后 STOP。
- 失败表三列：`触发 | 一线修复 | 仍失败兜底`（NEEDS_CONTEXT / STALE / ④打回 / ⑤测红 / Task 不可用 / Goal 工具不可用）。
- 未使用 Darwin 建议的 🔴 / 🛑 视觉标记；文本标记 `CHECKPOINT` / `STOP` 已满足「显性标记」最低条件。

内部摩擦：Lead 调度「同一提示空转不超过 2 次」与表「同一提示第 3 次 → 停闸」可同读为「空转两次、第三次停」，但未写死 attempt 计数口径。

### 4. selfcheck 是否与正文一致

**结论：关键词层一致；语义层未覆盖正文全部契约。**

一致处：必填文件存在；禁止 `security.md`；要求 ACTION REQUIRED、CHECKPOINT、一线修复、仍失败兜底、Token 装箱、70/85/95、双 Task、独立 reviewer、Goal 三工具名、DevUI、registry/control-plane/evidence 链接；dispatch 要求 `packed_diff_path`、`g3-verify.md`、`禁止修改产品代码`。本机 **PASS**。

不一致 / 盲区：

- SKILL 主路径是 `work/DaiYu-Agent`；selfcheck 对 **SKILL.md** 只断言 `work/six-gates`，不断言新路径（新路径只查 `examples.md`）。
- 不检查 ledger 模板是否含 control-plane MUST 字段（`batch_status`、`batch_expected`、`blocked_rounds`、`last_blocker_fingerprint`）。模板只有 `batch: —` 与 `blocked_reason` / `resume_from`。
- 不检查「本流程不含安全检测」正文句，只查危险词缺席。
- 不检查 packed-diff 200 行规则、④不得由 Lead 代写的运行时行为。
- `create_goal` / `get_goal` / `update_goal` 仅字符串出现；无参数 schema，Cursor 本会话亦无对应动态工具——正文依赖 `ledger-fallback`，selfcheck 仍当工具绑定已落地。

---

## 维度评分

### dim1 Frontmatter质量 — **7 / 10** ×7 = 49

- `name: daiyu-agent` 合法；无「灵活应用」类尾巴；description 远低于 1024 字符。
- description 含何时用 + 触发词（黛玉 / 六闸 / 6gates / solo-team），「做什么」只压缩为 one-human multi-agent development + 闸名。
- **未列入** `继续黛玉`、`到<闸>`，恢复与截流口令对路由不可见。
- 未在 description 写清独立审查 / 非安全闸 / Token 装箱（非硬性，但触发精度偏触发词堆砌）。

### dim2 工作流清晰度 — **8 / 10** ×12 = 96

- `ACTION REQUIRED` 六步有序号；闸表有槽、是否写码、默认/连续、产物路径。
- ③ 开槽规则（双侧 FE∥BE；单侧实现∥验证；禁止 SKIP 冒充第二槽）可执行。
- 每闸输入/输出：报告路径 + 一页结论模板 + dispatch 外壳。
- 缺口：Goal 工具无调用参数；⑥「Lead 或 explore」无裁决规则；ledger 最小模板与文末控制面 MUST 字段不等价，只读模板会漏批次审计列。

### dim3 失败模式编码 — **8 / 10** ×12 = 96

- 已用 Darwin HL-2 三段式表，不是纯正向流程。
- 另有硬规则 1–16、Goal BLOCKED（同一 fingerprint 连续 3 回合）、心跳 STALE、dry_run 连续 2 槽 → CHECKPOINT。
- 未进失败表：fan-in schema 不合格之后的一线/兜底；并行批一侧 FAILED；`继续黛玉` 且无 ledger（正文「无命中 → 新建」与「继续」语义冲突）；`SKIP` 何谓 optional；「ledger lock / compare-and-swap」无失败与实现步骤。

### dim4 检查点设计 — **8 / 10** ×6 = 48

- 专节 `CHECKPOINT · STOP`，闸表用粗体标停点，满足 STOP/CHECKPOINT 显性标记。
- 默认模式关键决策（目标、方案、过审、关单）等人；连续模式打回/测红必停；棘轮「连续两轮 Δ<2 → CHECKPOINT」。
- 无 🔴/🛑。默认模式③「可进审查」不等人——设计如此，不是漏标，但人闸集中在④而非写码前（写码前闸是②方案冻结）。

### dim5 可执行具体性 — **8 / 10** ×17 = 136

- 可直接抄的产物：ledger 模板、一页结论、dispatch 通用外壳、STATUS 五行、evidence YAML、`output_max_lines` 分槽、packed diff 200 行、ownership 边界检查单。
- 软化禁语（建议/可以考虑/根据情况/灵活把握/视情况而定）在 SKILL/dispatch/slot-prompts/examples **未形成 ≥3 处指令性软化**；「建议批次」是摸底输出节名；README「建议开启新会话」1 处，不触发 ≥3 扣分。
- 仍不可直接执行：token **用量**采集；`token_budget` 默认数字；CAS/文件锁；后端候选「评分」无权重表；③a/③b 槽位 Done 只有三行。

### dim6 资源整合度 — **8 / 10** ×4 = 32

- SKILL 所链 `dispatch.md`、`slot-prompts.md`、`examples.md`、`diagrams.md`、`agent-registry.md`、`control-plane.md`、`evidence-schema.md` 均存在且路径正确。
- `scripts/selfcheck.ps1` 存在且 README 引用；**SKILL 正文不引用该脚本**。无 `references/`、`assets/`。
- `control-plane.md`（1113b）薄于 SKILL 文末状态机，资源存在但不完整承载 MUST。

### dim7 整体架构 — **7 / 10** ×12 = 84

- 层次清楚：口令 → 台账/Goal → 六闸 → 硬规则 → 调度/装箱 → 失败表 → 反例。
- 未检出「说白了/换句话说/首先其次综上」花叔禁用段。
- 冗余：Token 装箱在 SKILL 与 dispatch 各写一遍；控制面在 SKILL 文末与 `control-plane.md` 重复且详略不一。
- 结构混入 Darwin **优化棘轮**（基线/单维改/独立评分），与产品交付流水线同文。Lead 可能把「边际收益 < 2 分」误套到业务闸。
- 遗漏已见 dim2/3：模板字段、无 ledger 的「继续」、Goal 工具形态。

Runtime 扫描（Darwin gate，不计入 9 维）：SKILL/README 无「在 Claude Code」「~/.claude/skills/」红灯。README 给出 Cursor/Codex 安装路径，属多 runtime 说明，不判 gate 红。

### dim8 实测表现 — **8 / 10** ×23 = 184 — **dry_run**

未跑 with_skill vs baseline 子 Agent。按 `test-prompts.json` 三条，假设 Lead **遵守现行 SKILL/dispatch** 的执行提纲与违规判断如下。

#### Prompt 1 — `黛玉 为现有后台增加角色列表页`

1. 口令→默认模式；slug 自目标生成；`work/DaiYu-Agent/<slug>/ledger.md`；Goal `ACTIVE`（工具不可用则 `ledger-fallback`）。
2. 装箱派① scout（explore/generalPurpose）：前缀+指针，不贴 SKILL 全文；禁止写码。
3. 写 `g1-scout.md` + 一页结论；**CHECKPOINT 确认目标**；本回合不开③。
4. 不读、不派安全/攻防槽；④⑤本回合不存在。
5. 人未拍板不得自进②。
6. 与 expected 对齐：建 ledger、①不写码、默认停、不启用安全闸。

**违规判断：否。**

#### Prompt 2 — `黛玉 连续 只改前端空状态文案`

1. 口令→连续；建台账 `mode: 连续`；①有目标自进②。
2. ②必须非空验收 + `ownership.md`（仅前端路径）+ `stack-decision.md` + `token-budget.md` 才自冻。
3. ③同回合双 Task：前端实现 + ③V 只读验证（`g3-fe.md`/`g3-impl.md` + `g3-verify.md`），同一 `parallel_batch_id`；prompt 装箱，禁止 BE SKIP 冒充第二槽。
4. ④独立 `reviewer`（非 Lead、非本批写码槽），只给验收摘录+glob+`packed_diff_path`；须有「## 质量审查」。
5. ⑤只跑功能命令+退出码；不开攻防；打回或测红 **STOP**。
6. `Do not use` 首条含「单文件小修」，但 U4 反例以「未喊口令」为准；喊了「黛玉 连续」则走满闸。属过重而非安全闸回潮。

**违规判断：按 ACTION REQUIRED 则否**（不启安全闸；③双 Task；④独立 reviewer；prompt 装箱）。残留：小改仍强制栈决策/双槽，技能自带成本，不是测试失败。

#### Prompt 3 — `继续黛玉`

1. 先扫 `work/DaiYu-Agent/*/ledger.md`，再兼容 `work/six-gates`；禁止凭记忆重开已勾闸。
2. `get_goal` 或读 ledger：同一 `goal_id` / `goal_status`；`PAUSED`/`BLOCKED` 从 `resume_from` 续。
3. 下一未勾闸派 Task；派发前装箱。
4. 若下一闸是③：仍须双 Task；若是④：仍须独立 reviewer。
5. 不新建 Goal（有命中时）；不启安全闸。
6. **无命中时正文写「新建」**，与 expected「不新建 Goal」及口令「继续」冲突——失败表无此分支。

**违规判断：有 ledger 时否；无 ledger 时会违反 expected / 继续语义。**

dim8 给 8 不给 9：三条主路径与 expected 在「有台账、遵守装箱」下可对齐；无台账的「继续」未编码；本维未经 full_test。

### dim9 反例与黑名单 — **9 / 10** ×6 = 54

- 独立章节：`## 常见失败（禁止）`（错误/正确对照）、`## Do not use`。
- 另有硬规则禁令、dispatch「禁止全文粘贴」、U4 反例、禁止自评 `g4-review.md`、禁止未跑报绿。
- 未单列「红灯动作」章名；「继续却无 ledger 不得新建」未进入常见失败表。不构成「只有正向没有反例」。

---

## 计分

| # | 维度 | 维分 | 权重 | 加权 |
|---|------|------|------|------|
| 1 | Frontmatter质量 | 7 | 7 | 49 |
| 2 | 工作流清晰度 | 8 | 12 | 96 |
| 3 | 失败模式编码 | 8 | 12 | 96 |
| 4 | 检查点设计 | 8 | 6 | 48 |
| 5 | 可执行具体性 | 8 | 17 | 136 |
| 6 | 资源整合度 | 8 | 4 | 32 |
| 7 | 整体架构 | 7 | 12 | 84 |
| 8 | 实测表现（dry_run） | 8 | 23 | 184 |
| 9 | 反例与黑名单 | 9 | 6 | 54 |
| | **合计** | | **99** | **779** |

**总分 = 779 / 10 = 77.9**

结构短板：description 触发不全；ledger 模板与控制面字段分裂；Goal 工具/锁/用量计量不可运行时落地；达尔文棘轮与交付流水线混写。

效果短板：dim8 全为 dry_run；「继续」无台账未定义；小改口令仍走满闸（过约束，非安全闸残留）。

专项四问：安全闸未强制；装箱协议可执行但用量软；CHECKPOINT 与三段式在；selfcheck 与正文关键词一致、语义覆盖不全。

---

## 声明

- 未采信 CHANGELOG/README 的优化叙事。
- 未做 with_skill / baseline 对照跑测。
- 本文件只记录现行仓库静态结构 + 三条 prompt 的 Lead 干跑。
