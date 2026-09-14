# 黛玉Agent · Task 派发协议（平台中立）

派发前必须读取 [agent-registry.md](agent-registry.md) 与 [control-plane.md](control-plane.md)；报告按 [evidence-schema.md](evidence-schema.md) 生成。

Lead 用 `Task` 工具开槽。每条派发 = **一个槽、一个报告文件**。

## 通用外壳

```text
你是黛玉Agent「<槽名>」槽。严格按槽位规则工作。
禁止：<禁区摘要>
完成定义：<Done>

工作区：<repo>/work/DaiYu-Agent/<slug>/
必读：
- ledger.md（只读进度，勿重做已勾闸）
- plan.md（若已存在）
- ownership.md（写码槽必读）
- security.md（④⑤必读）：DaiYu-Agent/security.md
- 槽位细则：DaiYu-Agent/slot-prompts.md 中「<槽>」节

本闸报告必须写入：work/DaiYu-Agent/<slug>/reports/<file>.md
对话最终只输出一行：
STATUS: DONE|DONE_WITH_CONCERNS|NEEDS_CONTEXT|BLOCKED|SKIP
SUMMARY: <≤20字>
REPORT: <报告相对路径>
```

再追加本闸「输入」块（目标、`goal_id`、Goal 状态、批次、路径列表、授权状态、并发批次 ID、`token_budget`、`usage_source`、`output_max_lines`、registry profile）。

## 按闸推荐

| 闸 | description（短标题） | subagent_type | 并行 | 报告文件 |
|----|----------------------|---------------|------|----------|
| ① | 黛玉①摸底 | `explore` 或 `generalPurpose` | 否 | `g1-scout.md` |
| ② | 黛玉②方案 | `generalPurpose` | 否 | `plan.md` + `ownership.md`；摘要 `g2-plan.md` |
| ③FE | 黛玉③前端 | `generalPurpose` 或 `coldbrew-ishii` | **必须并发** | `g3-fe.md` |
| ③BE | 黛玉③后端 | `generalPurpose` 或 `coldbrew-ishii` | **必须并发** | `g3-be.md` |
| ③V | 黛玉③独立验证/影响分析 | `explore` 或 `generalPurpose` | 与单侧实现同发 | `g3-verify.md` |
| ④ | 黛玉④审查+安全 | `generalPurpose` | 否 | `g4-review.md`（同一 Task，须含两专节） |
| ⑤ | 黛玉⑤功能+攻防 | `generalPurpose` | 否 | `g5-test.md`（须含「## 攻防测试」） |
| ⑥ | 黛玉⑥收口 | Lead 或 `explore` | 否 | `g6-close.md` |

`model`：默认 `inherit`。单文件机械修复可用 `composer-2.5-fast`。  
**禁止**编造列表外的 model slug。

## ③ 并行检查单（同发前）

- [ ] `plan.md` 已冻结且验收清单非空  
- [ ] `plan.md` 含「## 威胁面」  
- [ ] `ownership.md` 已写，FE/BE 路径无交集（契约文件最多一侧）  
- [ ] 两个 Task 的 `prompt` 都含 **只改所有权内路径**  
- [ ] 除此之外无第三个写码 Task  
- [ ] **并发硬门槛：至少两个 Task 已同发；单侧项目为实现 + 独立验证/影响分析**  
- [ ] 记录 `parallel_batch_id`、两个 Task 的启动时间、报告路径和完成状态  

## ④ 审查+安全派发要点

- prompt 写明：**禁止修改产品代码**；同一 reviewer 必须完成质量与安全两专节  
- 必读：`plan.md`（验收+威胁面）+ `g3-*.md` + diff 范围 + `security.md`  
- 报告必须同时有质量结论与 **「## 安全审查」**  
- 结论标签：过 / 打回方案 / 打回前端 / 打回后端 / **打回安全**  
- Lead 收报告后：无安全专节 → 判未过并重派，禁止进⑤  

## ⑤ 功能+攻防派发要点

- prompt 写明：必须真跑功能命令；必须执行/记录攻防用例；禁止未跑报绿  
- 遵守仓库 `background-test-verify` / `post-task-review`（若存在）  
- 必读：`plan.md` 威胁面 + `security.md` + 授权状态（`attack_act=…`）  
- 未授权外网/生产 → 只做静态/本地攻防项，报告标注 `attack_act=skipped_no_auth`  
- 红：归属标签（含 `打回安全`）+ 复现；临时文件测完删除  
- Lead：无「## 攻防测试」→ 判红并重派  

## Lead 收报告后

1. 读 `REPORT` 文件（不要只信 SUMMARY）  
2. 校验统一 evidence schema：`goal_id`、`gate`、`batch_id`、`task_id`、`attempt_id`、`parallel_batch_id`、`status`、`evidence_path`、`commands`、`exit_codes`。不一致则当前闸失败  
3. 校验③是否确有至少两个并发 Task 报告，并核对同一 `parallel_batch_id` 的启动/完成记录；不足则不得进入④  
4. 校验④⑤安全专节是否存在且可执行  
5. 更新 `ledger.md` 勾选、Goal 状态与闸日志  
6. 默认模式 → 一页结论等人（含 **安全** 和 Goal 状态）  
7. 连续模式 → 按 SKILL 自进或停（安红/测红/阻塞必停）

## 修复单派发

```text
batch: fix-<n>
goal_id: <same-goal-id>
原因标签: 打回前端|打回后端|打回安全|仅修测障|打回方案
只修审查/安全/攻防指出的项；禁止顺手重构。
仍须③→④→⑤（含安全与攻防复验）。
```

## 控制面批次协议（MUST）

每次派发前先在 ledger 写入批次清单，再调用 Task。fan-out 要求所有预期 Task 同一调度回合发出并记录启动证据；heartbeat 必须包含 task_id、goal_id、parallel_batch_id、status、started_at、finished_at；fan-in 仅在所有报告存在且绑定同一 Goal/批次、无越界写入时将批次标记 JOINED。

Task 状态映射：`DONE|DONE_WITH_CONCERNS` 可计入 completed；`SKIP` 仅当预期槽明确标记 optional；`NEEDS_CONTEXT|BLOCKED` 保持批次 OPEN；`STALE` 可重派新 `attempt_id`；`FAILED` 结束当前 attempt 并按控制面规则暂停/重试。

每次重派必须写 `retry_of`、`attempt_id`、`terminal_reason`，不得复用终态 `task_id`。

超时一回合标记 STALE，连续两回合先重派一次，仍无心跳则 FAILED 并停闸。终态 task_id 不得重复派发；修复批次使用新 batch_id。
