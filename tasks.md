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

## HZ-003 本地提醒工具链路

- 状态：`done`
- 目标：将 AgentLoop 接入工具注册表和 ReminderTool，完成本地提醒请求的规划与结果回填。
- 范围：工具契约、注册表、参数校验、执行超时边界、聊天页本地 Agent。
- 不包含：系统 Reminder Kit、真实网络模型、持久化和语音。
- 验收：ArkTS 构建通过；提醒输入经过 AgentLoop 返回结构化模拟结果；未知工具和空参数有明确返回。
- 证据：`core/agent/LocalDemoAgent.ets`、`tools/ToolRegistry.ets`、`tools/ReminderTool.ets`。

## HZ-004 OpenAI 兼容 LLM 与 SSE 传输层

- 状态：`done`
- 目标：接入可配置的 OpenAI 风格 `/chat/completions` 客户端，为真实模型和本地 mock 服务提供统一传输层。
- 范围：LLM 请求/响应契约、跨分块 SSE 解析、HTTP 流式请求、超时和错误边界。
- 约束：不写入真实 API Key；默认聊天页仍使用本地演示 Agent，避免未配置模型时影响原型。
- 验收：ArkTS 编译通过；空配置、非 2xx、空响应、网络异常和超时有明确失败；请求结束释放 HTTP 资源。
- 证据：`entry/src/main/ets/core/llm/LLMModels.ets`、`StreamParser.ets`、`LLMClient.ets`。
