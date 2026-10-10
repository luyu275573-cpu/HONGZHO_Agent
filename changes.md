# 开发日志

## 2026-10-11

### HZ-005 远程模型接入 AgentLoop

- 目标：将 OpenAI 兼容模型的 Function Calling 响应适配为现有 AgentLoop 决策，并复用本地 ToolRegistry 执行工具。
- 当前状态：`done`。
- 改动：新增 `RemoteAgent`；模型工具调用转换为 `AgentToolDecision`，工具结果以文本消息回填下一轮规划；`LLMClient` 将工具契约转换为 OpenAI 标准的 `type=function` wire 格式。
- 验证：`scripts/check-standard.ps1` 返回 `STANDARD CHECK PASSED`；`scripts/build-harmony.ps1` 返回 `BUILD SUCCESSFUL`。
- 产物：`entry/build/default/outputs/default/entry-default-unsigned.hap`，118715 bytes。
- 遗留：远程 Agent 尚未接入默认聊天页；流式工具调用增量拼接、设置页配置和真实模型地址留待后续单元。

## 2026-10-11

### HZ-004 OpenAI 兼容 LLM 与 SSE 传输层

- 目标：为真实模型和模拟器 mock 服务建立统一的 OpenAI 风格 HTTP/SSE 接入层。
- 当前状态：`done`。
- 改动：新增 `LLMModels` 请求/响应契约；新增支持跨 chunk 半行、`data:` 和 `[DONE]` 的 `StreamParser`；新增 `LLMClient`，支持 `/chat/completions`、流式增量回调、Function Calling 响应解析、超时、HTTP 状态和空响应处理。
- 安全：baseUrl、apiKey、model 均由调用方注入，仓库未写入真实密钥；默认聊天页继续使用 `LocalDemoAgent`。
- 验证：`scripts/check-standard.ps1`、`scripts/build-harmony.ps1`；构建结果 `BUILD SUCCESSFUL`。
- 产物：`entry/build/default/outputs/default/entry-default-unsigned.hap`，118561 bytes。
- 遗留：尚未配置真实模型或本地 mock 地址，尚未进行模拟器网络联调；流式 Function Calling 增量拼接将在 AgentLoop 接入阶段补齐。

## 2026-10-10

### HZ-003（进行中）

- 目标：将 AgentLoop 接入本地工具注册表和 ReminderTool，打通提醒文本的模拟执行链路。
- 当前状态：`done`。
- 改动：新增 ToolModels、ReminderTool、ToolRegistry、LocalDemoAgent；聊天页发送提醒文本时调用本地 AgentLoop。
- 验证：`scripts/check-standard.ps1` 返回 `STANDARD CHECK PASSED`；`scripts/build-harmony.ps1` 返回 `BUILD SUCCESSFUL`。
- 产物：`entry/build/default/outputs/default/entry-default-unsigned.hap`，118561 bytes。
- 遗留：ReminderTool 当前只返回模拟结果，真实 Reminder Kit 后续接入。

## 2026-10-10

### HZ-002 AgentLoop 纯逻辑核心

- 目标：建立 AgentLoop 纯逻辑核心，约束循环上限和工具结果边界。
- 当前状态：`done`。
- 改动：新增 `AgentLoop`、工具调用契约、MAX_LOOPS、重复调用检测、规划异常、空结果和工具异常收敛。
- 验证：`scripts/check-standard.ps1` 返回 `STANDARD CHECK PASSED`；`scripts/build-harmony.ps1` 构建成功。
- 产物：`entry/build/default/outputs/default/entry-default-unsigned.hap`，98662 bytes。
- 遗留：真实 LLM、工具注册表和 core 单测将在后续接入阶段补充。

## 2026-10-10

### HZ-001 三页基础界面

- 用户目标：继续推进项目基本雏形。
- 改动：新增 Chat、Knowledge、Settings 页面和底部导航，保留本地假数据工具调用轨迹。
- 文件：`entry/src/main/ets/pages/Index.ets`、`Chat.ets`、`Knowledge.ets`、`Settings.ets`。
- 验证：`hvigorw assembleHap --no-daemon`，结果 `BUILD SUCCESSFUL`。
- 提交：`9af0078`。
- 遗留：真实模型、语音、真机和签名按用户要求延后。

### HZ-000 对话主页骨架

- 改动：消息气泡、三段 ToolCallCard、输入栏和 DesignTokens 字号。
- 验证：`hvigorw assembleHap --no-daemon`，结果 `BUILD SUCCESSFUL`。
- 提交：`d0a24f5`。
