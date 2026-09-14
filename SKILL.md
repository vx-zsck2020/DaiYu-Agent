---
name: daiyu-agent
metadata:
  canonical_name: DaiYu-Agent
  canonical_id: daiyu-agent
  display_name: 黛玉Agent
  short_name: 黛玉
  legacy_aliases: 六闸, six-gates, dai-yu, 6gates, solo-team
  repository: https://github.com/vx-zsck2020/DaiYu-Agent.git
description: >-
  Use when the user says 黛玉, 黛玉连续, 六闸, 六闸连续, 6gates, 6gates go, solo-team,
  solo-agent-dev-team, or asks for one-human multi-agent development with
  统筹/方案/前端/后端/审查/测试; also when the run must include project
  security review and authorized 攻防/abuse testing under those gates.
---

# 黛玉Agent（简称：黛玉；原六闸 / Six Gates）

一人 Owner + 多 Agent 槽位的自动开发流水线。  
**你（本会话）= Lead 调度。人 = 唯一合并/关单权。**  
**安全审查 + 授权攻防测试是④⑤的强制内容，不是可选项。**  
**多 Agent 协同与并发是硬要求：③ 开发闸必须同时运行至少 2 个 Task；单侧项目也不得退化为单 Agent。**

## ACTION REQUIRED（启动后立刻做）

1. 解析口令 → 模式：`默认` | `连续` | `到<闸>`
2. 建本轮工作区与台账（见下）；**只信任台账，不靠会话记忆**
3. 从台账下一未完成闸开跑；已完成闸禁止重派
4. 每闸用 Task 开槽；写法见 [dispatch.md](dispatch.md)
5. 闸末写「一页结论」；默认模式等人拍板，连续模式按规则自进
6. 凡涉网络/鉴权/token/代理/外部 API：**先确认授权边界**（见 [security.md](security.md)）
7. **Goal 任务生命周期**：启动时登记或恢复唯一 Goal；每闸只推进该 Goal；仅⑥收口后允许 `COMPLETED`；同一外部阻塞连续 3 个调度回合仍无进展才允许 `BLOCKED`。所有 Task、报告和验收必须绑定同一 `goal_id`。

口令表与示例：[examples.md](examples.md)  
槽位全文：[slot-prompts.md](slot-prompts.md)  
安全与攻防清单：[security.md](security.md)  
关系图：[diagrams.md](diagrams.md)
Agent 注册表：[agent-registry.md](agent-registry.md)  
控制面协议：[control-plane.md](control-plane.md)  
证据 schema：[evidence-schema.md](evidence-schema.md)

## 调用

| 口令 | 模式 |
|------|------|
| `六闸` / `6gates` | 默认：每闸等人确认 |
| `六闸 连续` / `6gates go` | 连续：少问；测红/安红必停 |
| `六闸 到<闸>` | 只跑到：摸底/方案/开发/审查/测试/收口 |
| `六闸 <目标>` | 带目标开跑 |
| `继续六闸` / `六闸 继续` | **恢复**：读已有 ledger，从下一未勾闸接着跑；模式沿用 ledger 的 `mode`（可用 `继续六闸 连续` 覆盖） |

## 工作区与台账（MUST）

### Goal 绑定（MUST）

- 每轮必须有稳定的 `goal_id`；所有 Task、报告和验收绑定同一 Goal。
- Goal 状态只能是：`ACTIVE`、`PAUSED`、`BLOCKED`、`COMPLETED`、`CANCELLED`。
- 黛玉六阶段映射：①澄清 Goal，②冻结验收，③并发执行，④质量/安全审查，⑤功能/攻防验证，⑥完成 Goal。
- `PAUSED`/`BLOCKED` 恢复时读取同一 `goal_id` 的 ledger，不得新建重复 Goal。
- 只有⑥验收全绿、残留风险已记录且人确认后，Goal 才能变为 `COMPLETED`。
- 新目标调用 `create_goal` 并保存返回的 `goal_id`；恢复调用 `get_goal` 校验 objective/status；闸推进、暂停、阻塞、收口调用 `update_goal` 并把证据写入 `## Goal 事件`。工具不可用时使用 `goal_backend: ledger-fallback`，不得伪造工具结果。
- 状态迁移仅允许 `ACTIVE→PAUSED|BLOCKED|COMPLETED|CANCELLED`、`PAUSED→ACTIVE|CANCELLED`、`BLOCKED→ACTIVE|CANCELLED`；`COMPLETED` 与 `CANCELLED` 为终态。

路径（相对仓库根；新项目使用 `work/DaiYu-Agent`，恢复时兼容扫描 `work/six-gates`）：

```text
work/DaiYu-Agent/<slug>/
  ledger.md          # 进度真相源
  plan.md            # 冻结方案（②产出，须含威胁面）
  ownership.md       # 文件所有权锁
  stack-decision.md  # 前端设计系统与后端技术栈决策
  token-budget.md    # Token 预算与上下文策略
  reports/
    g1-scout.md …
    g4-review.md     # 含安全审查专节
    g5-test.md       # 含功能 + 攻防专节
```

- `<slug>`：目标短横线 slug（去掉标点、空格变 `-`，≤40 字符），冲突时加 `-YYYYMMDD-HHMM`
- **同目标判定（恢复 vs 新建）**：
  1. 用户给了路径/`work/DaiYu-Agent/<slug>` 或历史路径 `work/six-gates/<slug>` → 用该目录
  2. 否则先扫 `work/DaiYu-Agent/*/ledger.md`，再兼容扫 `work/six-gates/*/ledger.md`；首行 `goal:` 与用户目标归一化后相等 → 恢复
  3. 多个命中 → 选 `updated` 最新的一档，一页结论里注明
  4. 无命中 → 新建
- 恢复时：禁止重派已勾闸；未勾闸从第一处缺口继续
- 台账首行必须是：`# 黛玉Agent ledger — goal: <目标原句>`

台账最小模板：

```markdown
# 黛玉Agent ledger — goal: <目标>
goal_id: goal-<slug>-<日期>
goal_status: ACTIVE|PAUSED|BLOCKED|COMPLETED|CANCELLED
goal_backend: codex-tool|cursor-tool|ledger-fallback
mode: 默认|连续|到<闸>
updated: <ISO时间>
security_required: true
goal_objective: <不可变目标原句>
goal_acceptance: <可验证完成条件摘要>
retry_count: 0
last_error: —
control_plane_version: 1
schema_version: 1
last_event_id: 0

## 进度
- [ ] ① 摸底
- [ ] ② 方案冻结
- [ ] ③ 开发批
- [ ] ④ 审查通过（含安全）
- [ ] ⑤ 测试通过（含攻防）
- [ ] ⑥ 收口

## 批次
- batch: —
- ownership: ownership.md
- threat_surface: —   # 来自 plan.md

## 闸日志
<!-- Gate N | status | report path | note -->
## Goal 事件
<!-- timestamp | event=start|advance|pause|complete|blocked | gate | evidence | note -->

## Goal 验收
- acceptance_source: plan.md
- acceptance_status: pending|passed|failed|deferred
- blocked_reason: —
- resume_from: —
```

## 流水线

```text
①摸底 → ②方案(含威胁面) → ③FE∥BE → ④审查+安全 → ⑤功能+攻防 → ⑥收口
```

| 闸 | 槽 | 写码 | 默认等人 | 连续模式 | 产物文件 |
|----|-----|------|----------|----------|----------|
| ① | 统筹 | 否 | 确认目标 | 口令已有目标则自进 | `reports/g1-scout.md` |
| ② | 方案 | 否 | 「方案通过」 | **自冻**写入 `plan.md` | `plan.md` + `ownership.md` |
| ③ | 前端∥后端或实现∥验证 | 是 | 可进审查 | 至少两槽并发完成后自进④ | `reports/g3-fe.md` `g3-be.md` 或 `g3-impl.md` `g3-verify.md` |
| ④ | 审查（质量+**安全**） | 否 | 「过审」 | 过→⑤；打回/安红→**停** | `reports/g4-review.md` |
| ⑤ | 测试（功能+**攻防**） | 否 | — | **红/安红→停**；全绿→⑥ | `reports/g5-test.md` |
| ⑥ | 统筹 | 否 | 关单 | 写总结后停 | `reports/g6-close.md` |

③ 开槽规则（禁止 Lead 臆测 SKIP）：
- **并发硬门槛：至少同时启动 2 个 Task。** 两侧路径皆非空时开 FE∥BE；仅一侧路径非空时，开该侧实现 Task + 独立验证/影响分析 Task（验证槽只读，不得修改产品代码），分别写报告。
- `ownership.md` / `plan.md` 写明「仅前端」或前端路径非空、后端为空 → 开 FE 实现 + 独立验证/影响分析槽；不得以 BE `SKIP` 替代第二个并发槽。
- 同理「仅后端」→ 开 BE 实现 + 独立验证/影响分析槽；不得以 FE `SKIP` 替代第二个并发槽。
- **两侧路径皆非空** → 必须 FE∥BE 并行
- **方案未写清一侧是否需要** → 回②补 `ownership.md`，禁止凭①摸底报告抢开③

④⑤ **安全强制规则**见下一节与 [security.md](security.md)。

## 硬规则

1. 无冻结 `plan.md` → 禁止开③写码  
2. ④未过（含安全专节）→ 禁止开⑤  
3. ⑤红或**攻防未通过** → 只开**修复单**回③（带标签），禁止新需求批  
4. ③ 必须多 Agent 并发：同时运行 Task 数量至少 2；双侧时为 FE+BE，单侧时为实现+独立验证/影响分析；审查与测试不同时开；**禁止 ≥3 写码 Agent**  
5. `ownership.md` 未列路径禁止改；契约文件同时只允许一侧改  
6. 不 `git commit` / 不 push，除非人明确要求  
7. 回流标签：`打回方案` | `打回前端` | `打回后端` | `仅修测障` | **`打回安全`**  
8. 子 Agent 回报只允许：`DONE` | `DONE_WITH_CONCERNS` | `NEEDS_CONTEXT` | `BLOCKED` | `SKIP`  
9. ⑤必须**真跑**功能测试 + 攻防项（遵守仓库 background-test / smoke）；禁止口头「应该过了」  
10. 临时测文件测完删除  
11. **④ 无「## 安全审查」专节或结论含糊 → ④视为未过**  
12. **⑤ 无「## 攻防测试」专节或未执行声明的攻防项 → ⑤视为红**  
13. **未授权禁止对外网/生产做攻防 ACT**（只读本地 diff/证据除外）；需 ACT 时走仓库 reverse-skill / case-init 授权门
14. **Goal 不可越级**：`COMPLETED` 只能在⑥产物存在且①-⑤均通过、验收和安全/攻防证据齐全后写入；否则保持 `ACTIVE`。
15. **Goal 阻塞判定**：Task `FAILED` 只结束当前 Task/批次，不自动把 Goal 置为 `BLOCKED`；同一外部阻塞 fingerprint 连续复现至少 3 个调度回合且补上下文/拆批/换策均无进展，才可写 `BLOCKED`。心跳失败先置 `PAUSED`，恢复或重派后重新计数。
16. **Goal 完成守卫**：任何 `update_goal(COMPLETED)` 必须原子校验 `gate=6`、①-⑤均 PASS、`g6-close.md` 存在、验收通过、残留风险已记录且有人确认；失败写入拒绝事件，不得越级。
17. **到闸语义**：`到<闸>` 表示完成该闸后停止，不自动进入下一闸；若阻塞/安红，Goal 保持 `PAUSED` 或 `BLOCKED` 并写入 `resume_from`。

## Lead 自动调度（Cursor）

1. **本会话只调度**：大块实现/审查/测试一律 Task；Lead 可做轻量读文件与写台账  
2. 派发前读 [dispatch.md](dispatch.md)，按槽填 Task：
   - 探索/摸底：`explore` 或 `generalPurpose`
   - 写码：`generalPurpose` 或 `coldbrew-ishii`（强执行）
   - 审查/安全/测试/攻防：`generalPurpose`（强调禁止擅自改码；攻防遵守授权）
3. `model`：默认 `inherit`；机械小改可用 `composer-2.5-fast`  
4. **并行**：仅③允许并要求两个 Task 同发；Verifier 必须与实现 Task 在同一调度回合启动且时间差 ≤60 秒；其它闸串行。
5. 子 Agent **零闲聊历史**：只给目标、`plan.md`/`ownership` 路径、本闸 Done、报告路径、`security.md` 清单路径  
6. 子 Agent 须把完整报告写入指定文件，对话里只回状态行  
7. `NEEDS_CONTEXT` / `BLOCKED`：补上下文或拆批后重派；同一提示空转不超过 2 次  
8. 压缩/失忆后：先读 `ledger.md` + `git status`，从不凭记忆重开已完成闸  

## 一页结论（对人）

```markdown
## Gate: ①|②|③|④|⑤|⑥
**状态:** 待确认 | 通过 | 打回(<标签>) | 停止(测红|安红|阻塞)
**目标:** …
**产物:** work/DaiYu-Agent/<slug>/…
**安全:** ④威胁/发现摘要 | ⑤攻防结果（绿/红）
**风险:** …
**下一闸:** …
**请拍板:** …（连续模式可写「连续：已自进」）
```

## 连续模式细则

- ①→②：口令含目标则不等人确认目标  
- ②→③：`plan.md` 含非空验收清单 + **威胁面小节** 即可自冻；③ 必须按 ownership 同发至少两个 Task  
- ④打回 / 安红 或 ⑤红 / 攻防红：**立即停**，一页结论等人；不得自行开新功能批  
- 修复单：台账标记 `batch: fix-<n>`，仍走③→④→⑤（含安全与攻防复验）  

## 常见失败（禁止）

| 错误 | 正确 |
|------|------|
| Lead 自己写完前后端 | ③派 FE/BE 槽 |
| 无 plan 直接改代码 | 先② |
| ④只做风格/功能审查跳过安全 | ④必须含安全专节 |
| ⑤只跑单测跳过攻防 | ⑤必须含攻防专节 |
| 未授权打生产/外网 | 先授权门；否则只做静态/本地 |
| 12 个全栈并行 | ≤2 写码 |
| 测红/安红继续开需求 | 停 + 修复单 |
| 只记 todo 不写 ledger | 必须写 ledger |

## Do not use

- 单文件小修、纯问答、只读探查  
- 用户未触发黛玉或兼容别名且明显一步可完成

## 前端、后端与 Token 默认工程规范（MUST）

- 管理后台默认使用 DevUI Admin Page：<https://devui.design/admin-page/docs/getting-started>；普通前端默认使用 DevUI：<https://devui.design/home>；图标默认使用 DevUI Icon：<https://devui.design/icon/ruleResource>。
- ② 必须产出 `stack-decision.md`，记录产品形态、组件库、图标来源、主题/响应式/无障碍策略、后端候选矩阵、评分、最终选择、放弃项、迁移回滚方案与验证指标。
- 后端选型必须基于语言约束、流量/延迟、数据模型、部署环境、现有依赖、团队能力、合规与安全边界；③ 只实现冻结选型，变化先回流②。
- ② 必须产出 `token-budget.md`：按 Goal/闸/Task 分配预算；上下文采用稳定前缀→闸上下文→Task 增量；70% 触发压缩、85% 停止非必要探索、95% 只允许收口/阻塞处理。
- 每个 Task 声明 `token_budget`、`context_files`、`output_max_lines`；超限时证据写文件、消息仅返状态和路径并记录 `token_event`。

## 控制面状态机

- 合法跃迁：ACTIVE -> PAUSED|BLOCKED|COMPLETED|CANCELLED；PAUSED -> ACTIVE|CANCELLED；BLOCKED -> ACTIVE|CANCELLED。COMPLETED/CANCELLED 为终态。
- 每个批次必须有 parallel_batch_id、batch_status、batch_expected、batch_completed、batch_failed。
- BLOCKED 必须记录 blocked_rounds、last_blocker_fingerprint、resume_from；恢复不得新建 Goal。
- 台账必须维护 control_plane_version 与 last_event_id，事件号单调递增。
- ④ 固定由一个 `reviewer` Task 同时完成质量审查与安全审查，统一写入 `g4-review.md`；不得拆成未定义合并器的双报告模式。
- 事件追加必须 append-only；写入使用 ledger lock 或 compare-and-swap。`batch_id+task_id+attempt_id` 是唯一键。
- 恢复扫描优先按 `goal_id`，排除 `COMPLETED/CANCELLED`；`updated` 缺失或非法按最早创建时间与路径字典序稳定排序。
