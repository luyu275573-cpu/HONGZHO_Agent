# 任务追踪

状态只使用 `pending`、`in_progress`、`done`、`blocked`。

## HZ-001 三页基础界面

- 状态：`done`
- 目标：完成对话、知识库、设置三页和底部导航的本地假数据骨架。
- 验收：ArkTS 构建通过；三页可通过导航切换；对话页显示消息和工具调用过程。
- 证据：提交 `9af0078`，构建命令 `hvigorw assembleHap --no-daemon` 成功。

## HZ-002 AgentLoop 纯逻辑核心

- 状态：`done`
- 目标：建立可单测的规划、工具执行、结果回填循环。
- 范围：MAX_LOOPS、重复调用检测、空结果兜底、工具异常收敛。
- 不包含：真实 LLM、系统提醒 API、网络请求和 UI 接入。
- 验收：源码通过 ArkTS 编译；提供可复用的类型和运行结果；构建日志已回填到 `changes.md`。
- 证据：`entry/src/main/ets/core/agent/AgentLoop.ets`、`scripts/check-standard.ps1`、`scripts/build-harmony.ps1`。
