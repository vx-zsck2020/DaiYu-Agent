# Independent Review — daiyu-agent

- **Judge:** independent（只读现行文件；禁止采信「改完更好」叙事）
- **Repo:** `E:\Exploitation\VS_Tools\DaiYu-Agent`
- **Rubric:** Darwin Skill 3.0 / SkillLens 9 维（维分 × 权重 / 10）
- **EVAL_MODE:** `dry_run`（dim8 未 spawn with_skill / baseline 子 Agent）
- **Date:** 2026-09-17
- **VERSION:** 1.1.1（现行 `VERSION` 文件确认）
- **Baseline:** 1.1.0 dry_run **77.9**（`evals/independent-review.md`）
- **selfcheck:** PASS（`scripts/selfcheck.ps1` exit 0）

**dry_run 占比 100% > 30% → 评估失效警告：dim8 与总分不可当作 full_test。**

权重：dim1=7, dim2=12, dim3=12, dim4=6, dim5=17, dim6=4, dim7=12, dim8=23, dim9=6。

---

## 必读文件清单（现行）

| 文件 | 现行状态 |
|------|----------|
| `SKILL.md` | 19630b；含「## 小范围快路径（MUST）」；硬规则 17；失败表快路径行 |
| `dispatch.md` | 7584b；③ 并行检查单含 `fast_path`；③V/④ 快路径派发要点 |
| `slot-prompts.md` | 3005b；②/`stack_change`/`fast_path`；③V「影响清单」；④禁复述 |
| `examples.md` | 3760b；**U10 小范围快路径** |
| `test-prompts.json` | 3 条；id=2 expected 对齐快路径 |
| `scripts/selfcheck.ps1` | 断言 `小范围快路径`/`fast_path`/`mode: reuse`/`影响清单`/U10 |
| `VERSION` | `1.1.1` |

未采信 CHANGELOG/README 优化措辞；以下仅以契约正文与可核对交叉引用为准。

---

## dim8 dry_run：三条 Lead 执行提纲（各 ≤8 行）

### Prompt 1 — `黛玉 为现有后台增加角色列表页`

1. 口令→**默认**；建 `work/DaiYu-Agent/<slug>/ledger.md`，Goal `ACTIVE`（无工具则 `ledger-fallback`）。
2. 装箱派① scout；禁止写码；不贴 SKILL/examples/diagrams 全文。
3. 写 `g1-scout.md` + 一页结论；**CHECKPOINT 确认目标**；本回合不开②③。
4. 人确认后②：新列表页通常验收/ownership 可能仍 ≤ 谓词，但属**功能增量**——须审 `stack_change`；不满足三谓词则 `fast_path: false` + 完整 `stack-decision`（含 DevUI Admin）。
5. ③ 起才双 Task；④⑤本回合不存在；无安全/攻防闸。
6. 与 expected 对齐：建 ledger、①不写码、默认停、不启安全闸。
7. **违规判断：否**（主路径）。残留风险：若②误标 `fast_path: true` 跳过管理后台选型，属过用快路径，非本回合强制失败。

### Prompt 2 — `黛玉 连续 只改前端空状态文案`（快路径专项）

1. 口令→**连续**；建台账 `mode: 连续`；目标已含 →①可自进②。
2. ② 谓词齐：验收 `-` 项 ≤5、ownership 路径 ≤8 且已存在、`stack_change: none` → ledger/plan 写 **`fast_path: true`**。
3. `stack-decision.md`：**仅** `mode: reuse` + 现有栈一句 + `change: none`；**禁止候选矩阵**；`token-budget.md` 可抄默认表。
4. ③ **仍双槽同发**：FE/impl 写码 + ③V 只读；同一 `parallel_batch_id`；禁止 BE `SKIP` 冒充第二槽。
5. ③V → `g3-verify.md` **仅「## 影响清单」3–5 条**；禁止过/打回、禁止贴 diff；`output_max_lines` 40。
6. ④ 独立 reviewer：只装箱验收摘录 + ownership glob + `packed_diff_path`；**只逐条勾验收**；禁复述 ③V/diff；须有「## 质量审查」。
7. ⑤ 仍真跑可执行验收；打回/测红 **STOP**；各 Task **不贴 SKILL 全文**。
8. **违规判断：否**（与 `test-prompts.json` expected / U10 对齐）。

### Prompt 3 — `继续黛玉`

1. 扫 `work/DaiYu-Agent/*/ledger.md`，再兼容 `work/six-gates`；读 `goal_id`/`goal_status`/`resume_from`。
2. 有命中：从下一未勾闸续派；禁止重派已勾闸；禁止新建 Goal。
3. 无命中：**CHECKPOINT · STOP** 问路径/目标；失败表与常见失败均禁静默新建（≠「新建口令」规则 4）。
4. 若续③：仍 ≥2 Task；若 `fast_path: true` 则 ③V/④ 仍走瘦身契约。
5. 派发仍 Token 装箱；不启安全闸。
6. **违规判断：有台账时否；无台账时正确停问 → 符合 expected「不新建 Goal」。**

---

## 维度评分

### dim1 Frontmatter质量 — **7 / 10** ×7 = 49

- `name: daiyu-agent` 合法；description 触发词齐全（黛玉/六闸/6gates/solo-team）；长度远低于 1024。
- 仍未列入 `继续黛玉`、`到<闸>`；快路径未改变 frontmatter 路由可见性。
- **相对 1.1.0：持平。**

### dim2 工作流清晰度 — **8 / 10** ×12 = 96

- ACTION REQUIRED、闸表、③ 双侧/单侧开槽仍清晰；快路径作为②冻结后的显式分支已写入 SKILL/dispatch/examples。
- 缺口仍在：Goal 工具无参数 schema；ledger 最小模板与控制面 MUST 批次字段不等价；⑥ Lead/explore 裁决未写死。
- **相对 1.1.0：持平**（快路径补了分支，未消旧缺口）。

### dim3 失败模式编码 — **8.5 / 10** ×12 = 102

- 保留 HL-2 三段式；新增「快路径谓词失败却 reuse」「快路径 ③V 写下过/打回」一线/兜底；硬规则 17。
- `继续*` 无 ledger 已在失败表 + 常见失败；1.1.0 评中「无命中却新建」与现行正文不符（现行为 CHECKPOINT）。
- 未进表项仍在：fan-in schema 失败、并行一侧 FAILED、SKIP=optional、CAS/锁失败路径。
- **相对 1.1.0：+0.5**（快路径失败行 + 继续语义闭合可读）。

### dim4 检查点设计 — **8 / 10** ×6 = 48

- `CHECKPOINT · STOP` 专节与闸表粗体停点未变；快路径不改人闸布局。
- **相对 1.1.0：持平。**

### dim5 可执行具体性 — **9 / 10** ×17 = 153

- 快路径谓词可数（验收 ≤5、ownership ≤8、`stack_change: none`）；允许动作可抄（`mode: reuse` stub、③V 专节名与条数、④只勾、⑤仍真跑）。
- dispatch 给出快路径 ③V `output_max_lines` 40、Lead fan-in 校验点；Goal 默认 token 分闸数字在 SKILL/dispatch 可抄。
- 1.1.0 痛点「小改仍强制完整栈矩阵」在现行契约下可合法 bypass；双槽仍硬门槛（与 expected「仍双槽」一致，不算缺口）。
- 仍软：用量如何读宿主 API、ledger CAS、后端评分权重、③a/③b Done 过薄。
- **相对 1.1.0：+1.0**（本轮主收益维）。

### dim6 资源整合度 — **8 / 10** ×4 = 32

- 所链 md 均存在；U10 + selfcheck 关键词覆盖快路径。
- SKILL 仍不引用 `selfcheck.ps1`；`control-plane.md` 仍薄于文末 MUST。
- **相对 1.1.0：持平。**

### dim7 整体架构 — **7 / 10** ×12 = 84

- 层次仍清；Token/控制面双写冗余仍在；Darwin 棘轮与交付流水线同文未拆。
- 快路径是增量专节，未做结构减负。
- **相对 1.1.0：持平。**

### dim8 实测表现 — **9 / 10** ×23 = 207 — **dry_run**

- Prompt 1/3 主路径与 expected 可对齐；Prompt 2 现行条文完整覆盖 reuse / 双槽 / ③V 影响清单 / ④只勾 / 不贴 SKILL。
- 较 1.1.0 dry_run：小改过约束降为「双槽+瘦身产物」，与测试 expected 一致；继续无台账按 CHECKPOINT。
- 扣分：全程 dry_run；Prompt 1 存在过用 `fast_path` 的规划风险（见上）。
- **相对 1.1.0：+1.0**（本轮主收益维）。

### dim9 反例与黑名单 — **9 / 10** ×6 = 54

- 常见失败新增快路径相关三行；Do not use / 硬规则 / U4 仍在。
- 「继续无台账不得新建」已在常见失败；未单列「过用快路径于新功能页」红灯行。
- **相对 1.1.0：持平。**

---

## 计分

| # | 维度 | 维分 | 权重 | 加权 | vs 1.1.0 |
|---|------|------|------|------|----------|
| 1 | Frontmatter质量 | 7 | 7 | 49 | 0 |
| 2 | 工作流清晰度 | 8 | 12 | 96 | 0 |
| 3 | 失败模式编码 | 8.5 | 12 | 102 | +0.5 |
| 4 | 检查点设计 | 8 | 6 | 48 | 0 |
| 5 | 可执行具体性 | 9 | 17 | 153 | +1.0 |
| 6 | 资源整合度 | 8 | 4 | 32 | 0 |
| 7 | 整体架构 | 7 | 12 | 84 | 0 |
| 8 | 实测表现（dry_run） | 9 | 23 | 207 | +1.0 |
| 9 | 反例与黑名单 | 9 | 6 | 54 | 0 |
| | **合计** | | **99** | **825** | |

**总分 = 825 / 10 = 82.5**

**DELTA_VS_1.1.0 = +4.6**

---

## 对比 1.1.0（77.9）

| 问题 | 1.1.0 结论 | 1.1.1 现行 |
|------|------------|-----------|
| 小改强制完整栈矩阵 | dim5/dim8 过约束 | 三谓词满足 → `mode: reuse` stub；**改善 dim5/dim8** |
| ③ 单侧双槽 | 强制；小改成本高 | **仍强制**（expected 明确要求）；成本降在 ③V/④ 瘦身，非取消双槽 |
| Prompt 2 expected | 当时无 U10/快路径专节级对齐 | U10 + test-prompts + dispatch/slots 闭环 |
| 继续无 ledger | 旧评称会新建 | 现行 CHECKPOINT 禁静默新建（旧评与正文不一致处按现行计） |

**新回归 / 残留关注（非满分理由）：**

1. 快路径谓词不区分「文案级」与「新页面功能」——Prompt 1 类任务若验收写得过薄，可能误走 reuse，弱化 DevUI Admin 选型门禁。
2. selfcheck 仅关键词，不校验「验收 ≤5」等谓词数字或 ③V 禁「过/打回」语义。
3. dim8 仍全 dry_run；用量采集 / Goal 工具 / CAS 等运行时契约未落地。
4. 无「过用快路径」独立反例行（dim9 微缺口）。

---

## 声明

- 未采信 CHANGELOG/README「更好」叙事；分数仅来自现行 SKILL/dispatch/slots/examples/test-prompts/selfcheck 交叉可读性。
- 未做 with_skill / baseline 对照跑测。
- 本文件记录 1.1.1 静态结构 + 三条 prompt 的 Lead 干跑与对 1.1.0 dry_run 的维级差分。
