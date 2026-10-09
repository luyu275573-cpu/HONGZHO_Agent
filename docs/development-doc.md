# 阶段④｜「鸿智 Agent」一句话个人助理（鸿蒙 #2）—— 详细开发文档

> 时间区间：**2026.5 – 2026.10**
> 定位：鸿蒙第二个项目，收官重项目，主打「AI 工程化深度」。从阶段②的「会用 AI」、阶段③的「用系统 AI 能力」，进阶到「自己搭 Agent」——工具编排、RAG、记忆、多模型、智能体生态。

---

## 1. 项目概述

一句话：**一句话描述需求，AI 自主规划、调用系统工具（提醒/日历/天气/文件/搜索/记忆）完成任务，支持多模型接入、流式对话、RAG 知识库、语音交互与智能体生态（意图框架 / 元服务 / 小艺 Claw）的个人助理 Agent。**

- **平台**：HarmonyOS NEXT / HarmonyOS 6
- **语言**：ArkTS（纯 ArkTS 实现）
- **UI**：ArkUI
- **对标开源**：[灵犀流序 Lingxi Flow](https://github.com/XCNXNXNX/lingxi-flow-agent)、[NextAI](https://github.com/Chen-ce/NextAI)

---

## 2. 选题理由

| 维度 | 说明 |
|---|---|
| 收官最重 | Agent / 智能体是 2026 年 AI 应用最主流形态，作为整套作品集的压轴 |
| 时间点契合 | HDC 2026（6月）发布小艺 Claw 智能体生态，正是接入的最佳时机 |
| 能力全面 | Function Calling、规划循环、记忆、RAG、多模型——面试高频考点 |
| 呼应主线 | 把阶段②的 LLM/流式/RAG 能力在鸿蒙上做到工程化深度 |

---

## 3. 目标用户与核心场景

1. **效率党**：语音说「明天上午十点提醒我开会」，自动建提醒。
2. **信息整理**：把本地文档投喂进知识库，问「上季度项目总结里写了什么」。
3. **多设备用户**：手机发起，结果/提醒在平板、手表同步。

---

## 4. 核心功能清单

### 4.1 MVP
- [ ] 多模型接入（DeepSeek-R1/V3.x、Qwen3、Kimi K2、智谱 GLM）
- [ ] 流式对话 UI（SSE，逐字渲染 + Markdown）
- [ ] 基础工具调用：天气查询、设置提醒、新建日历
- [ ] 会话管理（多会话 + 上下文）

### 4.2 完整版
- [ ] 工具编排（25+ 系统工具：文件/搜索/记忆/日历/天气）
- [ ] 记忆系统（长期记忆 + 用户画像）
- [ ] RAG 知识库（本地文档向量化 + 检索问答）
- [ ] 语音交互（ASR 转写 + TTS 播报）
- [ ] JSON 技能包热插拔（可增删自定义技能）
- [ ] 智能体生态：意图框架 + 元服务 + 小艺 Claw
- [ ] 多设备协同（任务/提醒同步）

---

## 5. 技术选型与架构

### 5.1 技术栈
| 能力 | 选型 |
|---|---|
| UI | ArkUI |
| 大模型接入 | HTTP/SSE，兼容 OpenAI 风格接口（DeepSeek/Qwen/Kimi/智谱） |
| 工具调用 | Function Calling（JSON Schema 定义工具） |
| 知识库 | RAG：文本切分 + 向量化 + 检索 |
| 语音 | Core Speech Kit（ASR/TTS） |
| 智能体生态 | 意图框架 + 元服务 + 小艺 Claw |
| 存储 | RDB（会话/记忆）+ 文件（知识库） |

### 5.2 Agent 核心循环架构
```
用户输入
   │
   ▼
意图理解 ──► 规划器（LLM 决定是否调用工具）
   │              │
   │              ├── 需要工具 ──► 工具执行器 ──► 结果回填 LLM
   │              │                    │
   │              ▼                    ▼
   │            再次规划（循环，直到得出最终答案）
   ▼
流式输出最终答案（逐字渲染）
   │
   ▼
记忆更新（长期记忆 / 会话摘要）
```

---

## 6. 项目结构

```
AgentAssistant/
├── entry/src/main/ets/
│   ├── entryability/
│   ├── pages/                  # Chat / Settings / Knowledge
│   ├── components/             # MessageBubble / ToolCallCard
│   ├── core/                   # ★ AI 核心层
│   │   ├── agent/              # AgentLoop / Planner / ToolExecutor
│   │   ├── llm/                # LLMClient / StreamParser
│   │   ├── rag/                # DocumentLoader / Embedder / Retriever
│   │   └── memory/             # ConversationMemory / LongTermMemory
│   ├── tools/                  # WeatherTool / ReminderTool / CalendarTool / SearchTool
│   ├── service/                # ReminderService / CalendarService
│   └── model/
```

---

## 7. 核心模块设计

### 7.1 工具定义（Function Calling）
```typescript
// tools/WeatherTool.ets
export const WeatherToolSchema = {
  name: 'get_weather',
  description: '查询指定城市今天的天气',
  parameters: {
    type: 'object',
    properties: { city: { type: 'string', description: '城市名' } },
    required: ['city']
  }
};

export class WeatherTool {
  static async execute(args: { city: string }): Promise<string> {
    // 调用天气服务，返回自然语言描述
  }
}
```

### 7.2 多模型统一客户端
```typescript
// core/llm/LLMClient.ets
export interface LLMConfig {
  baseUrl: string;   // 各厂商 OpenAI 兼容地址
  apiKey: string;
  model: string;     // deepseek-chat / qwen-plus / ...
}

export class LLMClient {
  static async chat(config: LLMConfig, messages: Message[], tools?: ToolSchema[]): Promise<ChatResponse> {}
  static async chatStream(config: LLMConfig, messages: Message[], onDelta: (text: string) => void): Promise<void> {}
}
```

### 7.3 Agent 循环
```typescript
// core/agent/AgentLoop.ets
export class AgentLoop {
  async run(userInput: string, memory: ConversationMemory): Promise<string> {
    const messages = memory.buildMessages(userInput);
    for (let i = 0; i < MAX_LOOPS; i++) {
      const resp = await LLMClient.chat(config, messages, ALL_TOOLS);
      if (resp.toolCalls && resp.toolCalls.length > 0) {
        for (const call of resp.toolCalls) {
          const result = await ToolExecutor.execute(call);
          messages.push({ role: 'tool', content: result });
        }
        continue; // 再次规划
      }
      return resp.content; // 最终答案
    }
    return '任务过于复杂，请拆解后再试。';
  }
}
```

### 7.4 RAG 检索问答
```typescript
// core/rag/Retriever.ets
export class Retriever {
  static async search(query: string, topK: number = 5): Promise<Chunk[]> {
    // query 向量化 → 相似度检索 → 返回 topK 片段
  }
  static async buildContext(chunks: Chunk[]): Promise<string> {
    // 拼成 prompt 上下文注入 LLM
  }
}
```

---

## 8. 关键难点与解决方案

| 难点 | 方案 |
|---|---|
| SSE 流式解析不完整 | 维护缓冲区，按 `\n` 切行，处理跨 chunk 半行 |
| 多模型接口差异 | 统一成 OpenAI 风格，baseUrl 与鉴权配置化 |
| 工具调用死循环 | `MAX_LOOPS` 上限 + 循环检测 |
| 上下文超长 | 会话摘要 / 滑动窗口 + 记忆系统 |
| RAG 检索不准 | 切分粒度调优、重排序（rerank）、元数据过滤 |
| 语音转写延迟 | 分段流式 ASR，边转写边送入对话 |
| 小艺 Claw 接入 | 遵循智能体生态的意图/元服务规范接入 |

---

## 9. 开发里程碑

| 阶段 | 目标 | 周期 |
|---|---|---|
| M1 | 工程 + 流式对话 UI | 2–3 天 |
| M2 | 多模型 + 工具调用 | 1 周 |
| M3 | 记忆 + 会话管理 | 1 周 |
| M4 | RAG 知识库 | 1 周 |
| M5 | 语音 + 技能包 + 智能体生态 | 1 周 |

---

## 10. 测试要点

- [ ] 不同模型切换下的流式稳定性
- [ ] 工具调用返回异常（超时、空返回）
- [ ] 长会话上下文超限处理
- [ ] 知识库大文档切分与检索准确率
- [ ] 语音在噪声环境下的识别率

---

## 11. 交付/上架要点

- API Key 不硬编码，做服务端中转或安全存储
- 隐私政策：大模型数据流向、知识库本地存储声明
- 「AI 生成内容」免责声明

---

## 12. 简历亮点 + 时间锚点

> **时间区间**：2026.5 – 2026.10（鸿蒙 #2，收官）
> **可用技术**：HarmonyOS 6、DeepSeek-R1/V3.x、Qwen3、Kimi K2、智谱 GLM、意图框架 + 元服务 + 小艺 Claw

**简历写法**：负责鸿蒙原生 AI 个人助理 Agent，基于 Function Calling 实现工具编排与规划循环，支持多模型接入、SSE 流式输出、RAG 知识库问答与记忆系统，覆盖 20+ 系统工具，并接入小艺 Claw 智能体生态，可在多设备协同完成任务。
