import http from '@ohos.net.http';
import util from '@ohos.util';
import { ChatResponse, LLMConfig, Message, ToolCall, ToolSchema } from './LLMModels';
import { StreamParser } from './StreamParser';

interface ChatRequestBody {
  model: string;
  messages: Message[];
  stream: boolean;
  tools?: WireTool[];
}

interface WireTool {
  type: 'function';
  function: {
    name: string;
    description: string;
    parameters: Object;
  };
}

interface ChatResponsePayload {
  choices?: Object[];
}

/** OpenAI 风格 /chat/completions 客户端。 */
export class LLMClient {
  static readonly DEFAULT_TIMEOUT_MS: number = 60000;

  static async chat(
    config: LLMConfig,
    messages: Message[],
    tools?: ToolSchema[]
  ): Promise<ChatResponse> {
    LLMClient.validateConfig(config);
    const request: http.HttpRequest = http.createHttp();
    const body: ChatRequestBody = LLMClient.createBody(config, messages, false, tools);
    try {
      const response: http.HttpResponse = await request.request(
        LLMClient.endpoint(config.baseUrl),
        LLMClient.options(config, body, false)
      );
      if (response.responseCode < 200 || response.responseCode >= 300) {
        throw new Error('LLM HTTP 状态异常：' + response.responseCode.toString());
      }
      if (typeof response.result !== 'string' || response.result.trim().length === 0) {
        throw new Error('LLM 返回为空');
      }
      return LLMClient.parseChatResponse(response.result);
    } finally {
      request.destroy();
    }
  }

  static async chatStream(
    config: LLMConfig,
    messages: Message[],
    onDelta: (text: string) => void,
    tools?: ToolSchema[]
  ): Promise<ChatResponse> {
    LLMClient.validateConfig(config);
    const request: http.HttpRequest = http.createHttp();
    const parser: StreamParser = new StreamParser();
    const decoder: util.TextDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
    const body: ChatRequestBody = LLMClient.createBody(config, messages, true, tools);
    const timeoutMs: number = config.timeoutMs === undefined
      ? LLMClient.DEFAULT_TIMEOUT_MS
      : config.timeoutMs;

    return new Promise<ChatResponse>((resolve, reject) => {
      let responseCode: number | undefined;
      let streamEnded: boolean = false;
      let settled: boolean = false;
      let content: string = '';
      const timer: number = setTimeout(() => {
        settleError(new Error('LLM 请求超时'));
      }, timeoutMs);

      const emit = (text: string): void => {
        if (text.length === 0 || settled) {
          return;
        }
        content += text;
        onDelta(text);
      };

      const complete = (): void => {
        if (settled || responseCode === undefined || !streamEnded) {
          return;
        }
        if (content.trim().length === 0) {
          settleError(new Error('LLM 返回为空'));
          return;
        }
        settle({ content: content, toolCalls: [], finishReason: 'stop' });
      };

      const settle = (value: ChatResponse): void => {
        if (settled) {
          return;
        }
        settled = true;
        clearTimeout(timer);
        request.destroy();
        resolve(value);
      };

      const settleError = (error: Error): void => {
        if (settled) {
          return;
        }
        settled = true;
        clearTimeout(timer);
        request.destroy();
        reject(error);
      };

      const handleChunk = (data: ArrayBuffer): void => {
        if (settled) {
          return;
        }
        try {
          const text: string = decoder.decodeToString(new Uint8Array(data), { stream: true });
          const deltas: string[] = parser.push(text);
          for (let index = 0; index < deltas.length; index++) {
            emit(deltas[index]);
          }
        } catch (error) {
          settleError(new Error('LLM 流解析失败'));
        }
      };

      request.on('dataReceive', handleChunk);
      request.on('dataEnd', () => {
        if (settled) {
          return;
        }
        try {
          const tail: string = decoder.decodeToString(new Uint8Array(0), { stream: false });
          const deltas: string[] = parser.push(tail).concat(parser.finish());
          for (let index = 0; index < deltas.length; index++) {
            emit(deltas[index]);
          }
          streamEnded = true;
          complete();
        } catch (error) {
          settleError(new Error('LLM 流解析失败'));
        }
      });

      request.requestInStream(
        LLMClient.endpoint(config.baseUrl),
        LLMClient.options(config, body, true)
      ).then((code: number) => {
        if (settled) {
          return;
        }
        responseCode = code;
        if (code < 200 || code >= 300) {
          settleError(new Error('LLM HTTP 状态异常：' + code.toString()));
          return;
        }
        complete();
      }).catch(() => {
        settleError(new Error('LLM 网络请求失败'));
      });
    });
  }

  private static validateConfig(config: LLMConfig): void {
    if (config.baseUrl.trim().length === 0) {
      throw new Error('LLM baseUrl 未配置');
    }
    if (config.apiKey.trim().length === 0) {
      throw new Error('LLM apiKey 未配置');
    }
    if (config.model.trim().length === 0) {
      throw new Error('LLM model 未配置');
    }
  }

  private static endpoint(baseUrl: string): string {
    const normalized: string = baseUrl.trim().replace(/\/+$/, '');
    return normalized.endsWith('/chat/completions')
      ? normalized
      : normalized + '/chat/completions';
  }

  private static createBody(
    config: LLMConfig,
    messages: Message[],
    stream: boolean,
    tools?: ToolSchema[]
  ): ChatRequestBody {
    const body: ChatRequestBody = {
      model: config.model,
      messages: messages,
      stream: stream
    };
    if (tools !== undefined && tools.length > 0) {
      body.tools = tools.map((tool: ToolSchema): WireTool => {
        return {
          type: 'function',
          function: {
            name: tool.name,
            description: tool.description,
            parameters: tool.parameters
          }
        };
      });
    }
    return body;
  }

  private static options(
    config: LLMConfig,
    body: ChatRequestBody,
    stream: boolean
  ): http.HttpRequestOptions {
    const timeoutMs: number = config.timeoutMs === undefined
      ? LLMClient.DEFAULT_TIMEOUT_MS
      : config.timeoutMs;
    return {
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + config.apiKey,
        'Accept': stream ? 'text/event-stream' : 'application/json'
      },
      extraData: JSON.stringify(body),
      expectDataType: http.HttpDataType.STRING,
      connectTimeout: timeoutMs,
      readTimeout: timeoutMs,
      usingCache: false
    };
  }

  private static parseChatResponse(raw: string): ChatResponse {
    try {
      const payload: ChatResponsePayload = JSON.parse(raw) as ChatResponsePayload;
      if (payload.choices === undefined || payload.choices.length === 0) {
        throw new Error('LLM 响应缺少 choices');
      }
      const choice: Record<string, Object> = payload.choices[0] as Record<string, Object>;
      const message: Record<string, Object> | undefined = choice['message'] as Record<string, Object>;
      const content: Object | undefined = message === undefined ? undefined : message['content'];
      const finishReason: Object | undefined = choice['finish_reason'];
      const toolCalls: ToolCall[] = LLMClient.parseToolCalls(message);
      if (typeof content !== 'string' && toolCalls.length === 0) {
        throw new Error('LLM 响应内容为空');
      }
      return {
        content: typeof content === 'string' ? content : '',
        toolCalls: toolCalls,
        finishReason: typeof finishReason === 'string' ? finishReason : 'stop'
      };
    } catch (error) {
      throw new Error('LLM JSON 响应无效');
    }
  }

  private static parseToolCalls(message: Record<string, Object> | undefined): ToolCall[] {
    if (message === undefined) {
      return [];
    }
    const rawCalls: Object | undefined = message['tool_calls'];
    if (!Array.isArray(rawCalls)) {
      return [];
    }

    const calls: ToolCall[] = [];
    for (let index = 0; index < rawCalls.length; index++) {
      const rawCall: Record<string, Object> = rawCalls[index] as Record<string, Object>;
      const functionValue: Record<string, Object> | undefined = rawCall['function'] as Record<string, Object>;
      const id: Object | undefined = rawCall['id'];
      const name: Object | undefined = functionValue === undefined ? undefined : functionValue['name'];
      const args: Object | undefined = functionValue === undefined ? undefined : functionValue['arguments'];
      if (typeof name === 'string' && typeof args === 'string') {
        calls.push({
          id: typeof id === 'string' ? id : 'tool-' + index.toString(),
          name: name,
          arguments: args
        });
      }
    }
    return calls;
  }
}
