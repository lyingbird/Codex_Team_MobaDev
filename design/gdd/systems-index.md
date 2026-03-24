# 系统总表：裂隙先锋

> **状态**：草稿
> **创建时间**：2026-03-24
> **最后更新**：2026-03-24
> **来源文档**：`design/gdd/game-concept.md`

---

## 总览

《裂隙先锋》的第一阶段目标不是完整复刻传统长局 MOBA，而是先做出一个“英雄体验验证场”。因此系统优先级应围绕英雄移动、技能释放、命中反馈、状态异常、快速重开和训练对拼展开，地图推进、兵线、防御塔与正式对局流程都应后置。

## 系统清单

| # | 系统名 | 分类 | 优先级 | 分层 | 权威归属 | 当前状态 | 设计文档 | 依赖项 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 英雄控制 | 核心 | MVP | 基础层 | Client + Shared | 设计中 | `design/systems/hero-controller.md` | 无 |
| 2 | 技能释放与冷却 | 玩法 | MVP | 基础层 | Client + Server + Shared | 设计中 | `design/systems/skill-casting.md` | 英雄控制 |
| 3 | 战斗结算 | 玩法 | MVP | 服务层 | Server + Shared | 设计中 | `design/systems/combat-loop.md` | 英雄控制、技能释放 |
| 4 | 英雄原型流程 | 核心 | MVP | 服务层 | Server + Shared | 设计中 | `design/systems/hero-prototype-flow.md` | 英雄控制、技能释放、战斗结算 |
| 5 | 生命、死亡与快速重开 | 玩法 | MVP | 服务层 | Server + Shared | 未开始 | `design/systems/respawn-system.md` | 战斗结算、英雄原型流程 |
| 6 | HUD 与技能反馈 | UI | MVP | 表现层 | Client + Shared | 未开始 | `design/systems/hud-and-scoreboard.md` | 英雄控制、技能释放、战斗结算 |
| 7 | 命中反馈与可读性 | UI | MVP | 表现层 | Client + Shared | 未开始 | `design/systems/hit-feedback.md` | 技能释放、战斗结算 |
| 8 | 资源与状态异常 | 玩法 | MVP | 服务层 | Server + Shared | 未开始 | `design/systems/resource-and-status.md` | 技能释放、战斗结算 |
| 9 | 训练目标与测试假人 | 玩法 | MVP | 功能层 | Server + Shared | 未开始 | `design/systems/training-target.md` | 战斗结算、英雄原型流程 |
| 10 | 镜头与目标辅助 | 核心 | MVP | 表现层 | Client + Shared | 未开始 | `design/systems/camera-and-targeting.md` | 英雄控制、技能释放 |
| 11 | 对局流程 | 核心 | 垂直切片 | 基础层 | Server + Shared | 已降级 | `design/systems/match-flow.md` | 英雄原型流程 |
| 12 | 兵线刷新 | 玩法 | Alpha | 服务层 | Server | 未开始 | `design/systems/minion-wave.md` | 对局流程 |
| 13 | 防御塔与主基地 | 玩法 | Alpha | 功能层 | Server + Shared | 未开始 | `design/systems/objective-structures.md` | 兵线刷新、战斗结算 |
| 14 | 金币与经验成长 | 成长 | Alpha | 服务层 | Server + Shared | 未开始 | `design/systems/progression-loop.md` | 战斗结算 |
| 15 | 中立目标 | 玩法 | Release | 功能层 | Server + Shared | 未开始 | `design/systems/neutral-objective.md` | 对局流程、战斗结算 |
| 16 | 商店与局内购买 | 经济 | Release | 功能层 | Server + Shared | 未开始 | `design/systems/shop-system.md` | 成长系统、HUD |
| 17 | 账号数据与战绩持久化 | 存档与持久化 | Release | 服务层 | Server | 未开始 | `design/systems/profile-and-stats.md` | 对局流程 |
| 18 | 匹配与房间管理 | 运营 | Release | 服务层 | Server | 未开始 | `design/systems/matchmaking.md` | 对局流程 |
| 19 | 埋点与平衡配置 | 工具链 | Release | 打磨层 | Server + Shared | 未开始 | `design/systems/live-balance.md` | 战斗结算、技能释放 |

### 常见分类

- 核心
- 玩法
- 成长
- 经济
- 存档与持久化
- UI
- 运营
- 工具链

### 优先级建议

- MVP
- 垂直切片
- Alpha
- Release

### 分层建议

- 基础层
- 服务层
- 功能层
- 表现层
- 打磨层

## 同步与复制说明

英雄移动输入、镜头、技能按键响应和本地预瞄反馈优先在客户端处理，但涉及技能是否合法生效、伤害、控制、死亡、冷却和状态异常时，必须由服务端验证并广播。共享层主要承载技能枚举、协议、英雄定义、技能配置结构和状态字段定义。

## 推荐设计顺序

| 顺序 | 系统 | 为什么先做 | 风险或备注 |
| --- | --- | --- | --- |
| 1 | 英雄控制 | 没有稳定手感，所有后续系统都失去意义 | 需要同时考虑 PC 和 Mobile |
| 2 | 技能释放与冷却 | 这是英雄体验最核心的验证对象 | 决定前摇、后摇、预瞄、失败反馈和输入缓冲 |
| 3 | 战斗结算 | 命中、伤害、击杀与状态结果必须可信 | 依赖技能释放系统把时机和结果送对 |
| 4 | 英雄原型流程 | 需要一个能反复快速测试手感的战斗场景 | 不需要完整 MOBA 地图，只需要稳定重开 |
| 5 | HUD 与技能反馈 | 玩家必须看得懂技能什么时候准备好、什么时候失败 | 直接影响手感判断 |
| 6 | 命中反馈与可读性 | 没有明确受击和命中确认，手感会发虚 | 需要和动画、音效、飘字配合 |
| 7 | 资源与状态异常 | 决定技能限制和反制窗口 | 容易导致“技能被吞”的误解 |
| 8 | 镜头与目标辅助 | 直接影响技能命中和移动端可玩性 | PC 与 Mobile 方案可能不同 |

## 高风险系统

| 系统 | 风险类型 | 风险说明 | 处理建议 |
| --- | --- | --- | --- |
| 技能释放与冷却 | 技术 + 设计 | 手感、弱网、打断、失败反馈和输入缓冲都集中在这里 | 先统一技能生命周期，再做单英雄验证 |
| 战斗结算 | 技术 | 弱网下伤害判定、位移技能和命中反馈容易产生体验不一致 | 先做服务端权威简化版，再补表现优化 |
| 英雄控制 | 设计 | 如果移动和技能反馈不顺，玩家会直接觉得“不像 MOBA” | 先把基础手感打磨到可玩，再扩英雄差异 |
| 镜头与目标辅助 | 设计 | 没有合适的镜头和吸附，移动端技能体验会非常吃力 | 先做轻辅助，不做强锁定 |
| 对局流程 | 范围 | 如果太早进入完整地图结构，会稀释英雄体验验证效率 | 等英雄体验稳定后再升级 |

## 进度快照

| 指标 | 数量 |
| --- | --- |
| 系统总数 | 19 |
| 未开始 | 14 |
| 设计中 | 4 |
| 已降级 | 1 |
| 已确认 | 0 |
| 已实现 | 0 |

## 下一步

- [ ] 先确认这份 MOBA 系统清单是否满足当前方向
- [ ] 先把 `英雄控制`、`技能释放与冷却`、`战斗结算` 串成可反复测试的英雄原型
- [ ] 补 `英雄原型流程`，支持快速重开与训练目标
- [ ] 等英雄体验稳定后，再考虑进入正式 MOBA 地图结构
- [ ] 在可玩后再决定是否扩展商店、匹配和长线成长
