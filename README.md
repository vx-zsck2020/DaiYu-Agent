# DaiYu-Agent

**黛玉Agent** 是面向多种 coding agent runtime 的通用多 Agent 软件开发工作流，简称 **黛玉**。

它把一个人的需求转化为可恢复、可审计的 Goal，通过方案冻结、并发开发、独立质量审查与真实功能测试，让一个人能够稳定调度多个 Agent 完成交付。

[![Version](https://img.shields.io/badge/version-1.1.1-8b3a62)](./VERSION)
[![License](https://img.shields.io/badge/license-MIT-2f855a)](./LICENSE)
[![Validate](https://github.com/vx-zsck2020/DaiYu-Agent/actions/workflows/ci.yml/badge.svg)](https://github.com/vx-zsck2020/DaiYu-Agent/actions/workflows/ci.yml)

## 核心能力

- **一人控制多个 Agent**：Lead 管理目标、文件所有权、批次和闸门，Agent 只处理分配任务。
- **真正并发开发**：开发阶段至少同时运行两个 Task；全栈项目采用 FE/BE 并发，单侧项目采用实现/独立验证并发。
- **Goal 驱动**：Task、报告、修复批次和验收全部绑定同一个 Goal，中断后可从 ledger 精确恢复。
- **证据优先**：完成声明必须附带报告、命令、退出码、改动文件和风险记录。
- **独立质量审查**：④ 由未写本批产品代码的 reviewer 对照验收清单审查；禁止 Lead 自评自过。
- **智能节省 Token**：派发前装箱（稳定前缀 → 闸指针 → packed diff）；超限落盘；对话只回状态行。
- **小范围快路径**：验收少、ownership 窄且不改栈时复用现有技术栈；③ 仍双槽，③V 只出影响清单，④ 只勾验收。
- **技术栈可审计**：前端有统一设计规范，后端按项目特性形成候选矩阵；快路径可 `mode: reuse`。
- **黛玉腔交互**：面向用户的进度与结论含蓄、清丽、克制；状态行、Schema、代码块、命令和证据字段保持机器可解析原样。
- **质量棘轮**：优化先记基线，再做单维度变更；只有同一验证严格改善才保留，退步可追溯恢复。

本流程**不包含**安全检测闸、威胁面冻结或攻防测试。

## 工作流

```mermaid
flowchart LR
    G1[① 摸底] --> G2[② 方案冻结]
    G2 --> G3[③ 多 Agent 并发开发]
    G3 --> G4[④ 独立质量审查]
    G4 --> G5[⑤ 功能测试]
    G5 --> G6[⑥ 收口与 Goal 完成]
    G4 -. 打回 .-> G3
    G5 -. 修复批次 .-> G3
```

| 阶段 | 主要职责 | 强制产物 |
|---|---|---|
| ① 摸底 | 读取项目、未提交改动、风险与断点 | `g1-scout.md` |
| ② 方案 | 冻结验收、所有权、技术栈和 Token 预算；判定 `fast_path` | `plan.md`、`ownership.md`、`stack-decision.md`、`token-budget.md` |
| ③ 开发 | FE/BE 或实现/验证并发执行（始终 ≥2 Task） | `g3-*.md`、`g3-verify.md` |
| ④ 审查 | 独立 reviewer 对照验收清单 | `g4-review.md` |
| ⑤ 测试 | 运行真实功能测试并记录退出码 | `g5-test.md` |
| ⑥ 收口 | 汇总证据并完成 Goal | `g6-close.md` |

默认模式在①目标确认、②方案冻结、④过审、⑥关单处 **CHECKPOINT**，等人拍板。连续模式少问，遇④打回或⑤测红立即停止。

## 小范围快路径

当且仅当②冻结时**同时**满足，本批标记 `fast_path: true`：

1. `plan.md` 验收清单条目 ≤ 5
2. `ownership.md` 路径/glob 条目 ≤ 8，且指向已存在文件或目录
3. `plan.md` 写明 `stack_change: none`

| 项 | 快路径 | 全量 |
|---|---|---|
| `stack-decision.md` | 仅 `mode: reuse`，禁止候选矩阵 | 完整选型与后端候选矩阵 |
| `token-budget.md` | 可抄默认预算表 | 写全 Goal/闸/Task 预算与阈值 |
| ③ | 仍必须双 Task | 同左 |
| ③V | 只写「## 影响清单」3–5 条 | 可附越权/契约/遗漏，仍不得下过/打回 |
| ④ | 只逐条勾验收；禁止复述 ③V / diff | 另查范围漂移、所有权、契约 |
| ⑤ | 仍真跑可执行验收项 | 同左 |

谓词任一不满足 → 全量②。禁止把快路径用于新栈或新项目脚手架。`fast_path` 写入 `plan.md` 与 ledger「批次」。

示例口令：`黛玉 连续 只改前端空状态文案`。

## 安装

### Codex

```powershell
git clone https://github.com/vx-zsck2020/DaiYu-Agent.git "$HOME/.codex/skills/DaiYu-Agent"
& "$HOME/.codex/skills/DaiYu-Agent/scripts/selfcheck.ps1"
```

### Cursor

```powershell
git clone https://github.com/vx-zsck2020/DaiYu-Agent.git "$HOME/.cursor/skills/DaiYu-Agent"
& "$HOME/.cursor/skills/DaiYu-Agent/scripts/selfcheck.ps1"
```

Skill 的标准机器标识是 `daiyu-agent`，安装目录和正式英文品牌名是 `DaiYu-Agent`。安装或升级后建议开启新会话，使宿主重新发现 Skill。

## 快速使用

```text
黛玉 为现有项目增加用户与权限管理
黛玉 连续 修复订单并发重复扣款
黛玉 连续 只改前端空状态文案
黛玉 到方案 设计高并发消息推送服务
继续黛玉
```

| 口令 | 行为 |
|---|---|
| `黛玉 <目标>` | 默认模式，CHECKPOINT 闸等待 Owner 确认 |
| `黛玉 连续 <目标>` | 自动推进；审查打回、测试失败或阻塞时停止 |
| `黛玉 到<闸> <目标>` | 完成指定阶段后停止 |
| `继续黛玉` | 读取原 Goal 和 ledger，从下一未完成阶段恢复；扫不到台账时询问，禁止静默新建 |

兼容旧口令：`六闸`、`6gates`、`6gates go`、`solo-team`、`继续六闸`。

完整口令与验收用例见 [examples.md](./examples.md)。Lead 宪法见 [SKILL.md](./SKILL.md)。

## 工作区

黛玉Agent 不依赖对话记忆推进任务。每个 Goal 都有独立工作目录：

```text
work/DaiYu-Agent/<slug>/
├── ledger.md
├── plan.md
├── ownership.md
├── stack-decision.md
├── token-budget.md
└── reports/
    ├── g1-scout.md
    ├── g2-plan.md
    ├── g3-fe.md / g3-be.md / g3-impl.md / g3-verify.md
    ├── g4-review.md
    ├── g5-test.md
    └── g6-close.md
```

`ledger.md` 是唯一进度真相源，保存 Goal 状态、批次（含 `fast_path`）、事件号、阻塞原因和恢复位置。历史 `work/six-gates` 工作区仍可识别和恢复。

## 多 Agent 控制面

- `Agent Registry`：规定每类 Agent 的能力、读写路径、网络范围、预算和报告。
- `ownership.md`：同一时刻每个文件只能由一个写码 Agent 持有。
- `fan-out / fan-in`：Lead 先登记批次，再并发派发；证据全部满足后才合流。
- `heartbeat`：记录 Task 启动、心跳、完成与超时状态。
- 幂等重派：终态 `task_id` 不复用，重试使用新 attempt 并记录 `retry_of`。
- Goal 守卫：只有六个阶段全部通过后，Goal 才能进入 `COMPLETED`。
- 独立验证：结构检查与效果测试分离；无法启动独立验证时明确标记 `dry_run`。
- 低收益止损：连续两轮边际收益低于 2 分时进入 Owner 检查点。

详细协议：

- [SKILL.md](./SKILL.md) — Lead 调度宪法
- [Task 派发协议](./dispatch.md) — Token 装箱与按闸派发
- [槽位提示词](./slot-prompts.md)
- [Agent Registry](./agent-registry.md)
- [Control Plane](./control-plane.md)
- [Evidence Schema](./evidence-schema.md)
- [调用示例](./examples.md)

## 前端规范

默认设计资源（**新建**前端时）：

- 管理后台：[DevUI Admin Page](https://devui.design/admin-page/docs/getting-started)
- 普通前端：[DevUI](https://devui.design/home)
- 图标：[DevUI Icon](https://devui.design/icon/ruleResource)

已有项目优先尊重现有设计系统，不得为过默认规范而改栈。采用其他组件库时必须在 `stack-decision.md` 中说明兼容性与例外理由。快路径下 `stack-decision.md` 仅写 `mode: reuse`。

## 后端自动选型

黛玉Agent 不固定后端框架。全量方案会根据以下条件比较候选技术栈：

- 项目现有语言、框架和依赖
- 流量、吞吐、延迟和并发模型
- 数据结构、一致性、事务与索引需求
- 部署环境、运维能力和可观测性
- 团队维护成本、迁移成本和回滚能力
- 合规与运行边界

最终决策写入 `stack-decision.md`。小范围快路径只需 `mode: reuse`，不必重写候选矩阵。

## Token 治理

派发前装箱，禁止把 Skill 正文或方案全文贴进每个 Task。

- 稳定前缀：Goal、闸、ownership glob、预算
- 闸指针：plan / ownership / 报告路径
- Task 增量：allowed_paths 的 diff；超过 200 行写入 `packed_diff_path`，prompt 只传路径

默认预算（Goal = 100 单位）：① 8、② 12、③ 每槽 22、④ 12、⑤ 14、⑥ 10。用量优先读宿主 usage，没有则 `estimated`。

阈值：70% 压缩并只留证据路径；85% 停止非必要探索；95% 只允许收口或阻塞处理。长报告写入文件，对话仅返回状态、摘要和报告路径。

## 审查与测试

- ④ 必须包含 `## 质量审查`。全量另查范围漂移、所有权越界和契约偷改；快路径只逐条勾验收。
- reviewer 不得是本批写码槽；Lead 不得代写 `g4-review.md`。
- ⑤ 必须包含功能测试命令与退出码。
- 测试失败或审查打回后，只允许创建修复批次，不得继续加入新需求。

## 验证与开发

```powershell
./scripts/selfcheck.ps1
```

Codex 环境还可运行官方 Skill validator：

```powershell
python "$HOME/.codex/skills/.system/skill-creator/scripts/quick_validate.py" .
```

提交与 Pull Request 会通过 GitHub Actions 自动执行基础契约检查。版本记录见 [CHANGELOG.md](./CHANGELOG.md)。

## 兼容性

- 正式名称：DaiYu-Agent
- Skill ID：`daiyu-agent`
- 中文名称：黛玉Agent
- 简称：黛玉
- 旧称：六闸 / Six Gates
- 支持平台：Cursor、Codex 及其他兼容 Agent Skills 目录的 runtime

## License

[MIT](./LICENSE) © 2026 vx-zsck2020
