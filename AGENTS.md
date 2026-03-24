# Codex 游戏团队工作约定

这是一个面向 Roblox 项目的 Codex 原生仓库骨架，来源于对 `Claude Code Game Studios` 的结构化改造。

目标不是把 AI 当成“自动驾驶”，而是把 Codex 变成一个有清晰分工和上下文约束的开发搭档：能规划、能写文档、能改代码、能联动 Roblox Studio、也能留下可持续的项目痕迹。

## 仓库定位

这个仓库主要解决 4 件事：

- 让项目从一开始就有统一目录和文档落点
- 让需求、系统设计、实现、验证之间形成闭环
- 让 Codex 每次进入仓库都能快速恢复上下文
- 让 Roblox 项目在客户端、服务端、共享层之间保持边界清晰

## 这套结构最适合什么项目

最适合：

- 1 到 5 人的 Roblox 独立团队
- 以玩法系统为核心的项目
- 需要快速原型，但又不想后期失控的项目
- 需要持续迭代、持续联调、持续 playtest 的小中型在线游戏

典型例子：

- 轻中度战斗闯关
- 回合或局内循环明确的 PvE / PvP
- Tycoon / Simulator / Incremental
- 小队协作、塔防、生存、小型社交玩法
- 有持续更新需求的中型 live game

不太适合直接照搬：

- 超大型 MMO 或复杂开放世界
- 强后台平台化产品
- 以大规模 UGC 创作链路为核心的产品
- 10 人以上且有严格职能拆分的大团队项目

更细的项目适配与规模建议，见 `docs/项目适配与规模建议.md`。

## 建议读取顺序

Codex 在开始工作时，优先按这个顺序建立上下文：

1. `AGENTS.md`
2. `production/session-state/active.md`
3. `design/gdd/game-concept.md`
4. `design/gdd/systems-index.md`
5. `design/systems/` 下与当前任务最相关的系统文档
6. `src/` 下与当前任务最相关的代码

## 目录约定

```text
src/
  client/        客户端逻辑、输入、镜头、UI、表现层
  server/        服务端权威逻辑、结算、存档、反作弊校验
  shared/        共享常量、协议、配置、纯工具模块
design/
  gdd/           项目级设计文档，如概念文档、系统总表
  systems/       单个系统的详细设计文档
docs/
  templates/     模板
  *.md           使用说明、流程说明、项目定位说明
production/
  session-state/ 会话接力文档
tests/
  playtest/      Playtest、复现、QA 报告
scripts/
  *.ps1          本地脚本和辅助工具
codex/
  skills-src/    仓库内维护的 Codex skills 源文件
```

详细说明见 `docs/目录结构说明.md`。

## Roblox 代码边界

- `src/server/`
  - 负责服务端权威逻辑
  - 负责奖励发放、进度结算、存档写入、经济系统、匹配与反作弊校验
- `src/client/`
  - 负责输入、镜头、UI、动画驱动、反馈、局部手感优化
  - 不应持有真正的最终结算权
- `src/shared/`
  - 放共享枚举、常量、远程通信协议、通用配置、纯函数工具
  - 尽量避免把有副作用的逻辑堆到这里

## 联机与安全默认规则

- 默认假设客户端不可信
- Remote 的命名要明确，不要用模糊名称
- 远程调用的数据结构要么写在代码注释里，要么写在系统设计文档里
- 奖励、货币、抽卡、成长、排行榜、存档等逻辑默认归服务端最终裁决
- 如果系统存在刷取、伪造、越权风险，设计文档里必须单独写出校验策略

## Roblox Studio MCP 使用规则

只要任务涉及 Studio 内实时状态、场景对象、或在线脚本：

1. 先调用 `list_roblox_studios`
2. 确认正确实例后再调用 `set_active_studio`
3. 优先读，再改
4. 优先改工作区源码，Studio MCP 更适合验证、检查和处理仅存在于 Studio 的内容

## 推荐工作流

### 路线 A：从概念开始

1. `roblox-start`
2. 完成 `design/gdd/game-concept.md`
3. `roblox-map-systems`
4. `roblox-design-system`
5. `roblox-implement-feature`
6. `roblox-playtest-report`

### 路线 B：已有代码，补结构

1. `roblox-start`
2. 补 `design/gdd/game-concept.md`
3. 生成或补齐 `design/gdd/systems-index.md`
4. 先为当前高频改动系统写设计文档
5. 再进入实现和验证

完整流程见 `docs/工作流总览.md`。

## 会话接力规则

`production/session-state/active.md` 用来保存：

- 当前任务
- 当前状态
- 正在关注的文件
- 已做决定
- 风险和假设
- 下一步最值得继续的动作

只要完成了较大一段工作，就更新一次这个文件。

## 当前仓库内置的技能

- `roblox-start`
- `roblox-map-systems`
- `roblox-design-system`
- `roblox-implement-feature`
- `roblox-playtest-report`

重新安装或刷新这些技能：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-codex-skills.ps1
```

## 辅助脚本

快速查看仓库当前状态：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check-project.ps1
```
