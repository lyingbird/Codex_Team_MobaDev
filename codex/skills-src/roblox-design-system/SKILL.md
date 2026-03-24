---
name: roblox-design-system
description: 为单个 Roblox 系统撰写或补全详细设计文档，明确数据流、复制策略、权威边界、交互体验、滥用风险和验收标准。
---

# Roblox Design System

当用户希望为某个系统补完整设计，并准备后续进入 Luau 实现时，使用这个 skill。

## 先读取

1. `AGENTS.md`
2. `design/gdd/game-concept.md`
3. `design/gdd/systems-index.md`
4. 如果存在，读取目标系统在 `design/systems/` 下的文档
5. 读取 `design/systems/` 下与目标系统强相关的其他系统文档
6. `docs/templates/system-design-document.md`

## 输出路径

写入或更新 `design/systems/<system-name>.md`。

如果用户没有给系统名，就从 `design/gdd/systems-index.md` 里选择优先级最高且尚未设计的系统，并明确告知正在这样做。

## 必须覆盖的章节

- 系统概述
- 玩家体验目标
- 核心职责
- 输入与输出
- 规则与状态变化
- 服务端权威与复制策略
- 数据模型
- 玩家交互流程
- 边界情况
- 可调参数
- 监控与审核注意点
- 验收标准
- 未决问题

## Roblox 设计检查点

- 必须写清服务端信任什么、不信任什么、具体校验什么。
- 需要实现的 RemoteEvent 或 RemoteFunction 要明确命名和用途。
- 涉及 datastore、匹配、购买的流程要标注为高风险。
- 相关时要补移动端、弱网、高延迟等边界情况。
- 规则和数值要具体到“批准后就能开始实现”。

## 完成规则

- 如果 `design/gdd/systems-index.md` 记录了进度，要同步更新该系统状态。
- 更新 `production/session-state/active.md`。
