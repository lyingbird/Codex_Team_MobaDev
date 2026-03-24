---
name: roblox-map-systems
description: 把 Roblox 游戏概念整理成一份可实现的系统总表，明确优先级、权威边界、依赖顺序和实现提示。
---

# Roblox Map Systems

当用户已经有概念文档，想把它拆成可落地的 Roblox 系统清单时，使用这个 skill。

## 先读取

1. `AGENTS.md`
2. `design/gdd/game-concept.md`
3. 如果已存在，读取 `design/gdd/systems-index.md`
4. 读取 `design/systems/` 下已有系统文档
5. `docs/templates/systems-index.md`

## 输出

创建或更新 `design/gdd/systems-index.md`。

## 需要提取的内容

对每个系统，至少整理出：

- 系统名称
- 系统分类
- 优先级
- 所在分层
- 权威归属：client、server、shared 或 mixed
- 当前状态
- 对应的设计文档路径
- 关键依赖项

## Roblox 特定判断原则

- 移动手感、镜头、UI 打磨默认偏客户端，除非反作弊或公平性要求更强。
- 奖励、成长、购买、匹配、存档默认由服务端权威裁决。
- 共享枚举、配置、Remote 协议优先归入 `src/shared/`。
- 下面这些高风险系统要尽早单独标记：
  - 持久化
  - 匹配
  - 经济系统
  - 程序生成
  - 含审核风险的社交系统

## 优先级建议

- MVP：能验证“这个游戏好不好玩”的最小闭环
- Vertical Slice：能体现完整体验的一段高质量切片
- Alpha：主要系统齐备，但允许比较粗糙
- Release：打磨、留存、无障碍、运营稳固性补全

## 完成规则

- 文档要面向实现，避免写成空泛概念总结。
- 明确推荐接下来最该设计的 1 到 2 个系统。
- 更新 `production/session-state/active.md`，写清下一步。
