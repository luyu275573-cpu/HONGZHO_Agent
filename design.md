# 当前设计基线

## 产品结构

当前原型包含三个底部导航页面：对话、知识库、设置。设置页同时展示技能配置和多设备协同入口，后续可拆为独立页面。

## 视觉系统

- 深底：`DesignTokens.BG_DEEP`
- 面板：`DesignTokens.PANEL`
- 卡片：`DesignTokens.PANEL_DARK`
- 品牌色：`SKY`、`VIOLET`
- 状态色：规划 `STATUS_PLAN`、执行 `STATUS_RUN`、完成 `STATUS_DONE`
- 圆角：`RADIUS`、`RADIUS_CARD`
- 间距：`SPACE_1` 至 `SPACE_4`

所有页面必须从 `common/DesignTokens.ets` 取颜色、字号、圆角和间距。

## 交互基线

- 对话页从本地假数据展示“用户输入 → Agent 规划 → 工具调用 → 结果回填 → AI 回复”。
- 底部导航切换页面，页面内容当前为本地展示数据。
- 长文本使用可滚动容器；后续接入真实数据时保留空态、加载态和错误态。

## 技术取舍

原型阶段优先保持页面可运行和目录边界清晰，不提前接入网络、系统工具或发布签名。Agent、LLM、RAG 和记忆逻辑放在 `core/` 中，避免页面直接承载业务循环。
