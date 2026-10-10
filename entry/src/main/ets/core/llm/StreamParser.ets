/**
 * OpenAI SSE 响应解析器。
 *
 * 网络层可以任意大小分块传入文本；解析器会保留最后一行的半截内容，
 * 只把完整的 data 帧转换成增量文本。解析异常帧会被忽略，避免单个脏帧
 * 终止整条对话流。
 */
export class StreamParser {
  private buffer: string = '';
  private done: boolean = false;

  push(chunk: string): string[] {
    if (this.done || chunk.length === 0) {
      return [];
    }

    this.buffer += chunk;
    const lines: string[] = this.buffer.split('\n');
    const remainder: string | undefined = lines.pop();
    this.buffer = remainder === undefined ? '' : remainder;

    const deltas: string[] = [];
    for (let index = 0; index < lines.length; index++) {
      const delta: string | undefined = this.parseLine(lines[index]);
      if (delta !== undefined && delta.length > 0) {
        deltas.push(delta);
      }
    }
    return deltas;
  }

  finish(): string[] {
    if (this.done || this.buffer.length === 0) {
      return [];
    }

    const lastLine: string = this.buffer;
    this.buffer = '';
    const delta: string | undefined = this.parseLine(lastLine);
    if (delta === undefined || delta.length === 0) {
      return [];
    }
    return [delta];
  }

  isDone(): boolean {
    return this.done;
  }

  private parseLine(rawLine: string): string | undefined {
    const line: string = rawLine.endsWith('\r') ? rawLine.slice(0, -1) : rawLine;
    if (line.length === 0 || line.startsWith(':')) {
      return undefined;
    }
    if (!line.startsWith('data:')) {
      return undefined;
    }

    const payload: string = line.slice(5).trim();
    if (payload === '[DONE]') {
      this.done = true;
      return undefined;
    }
    if (payload.length === 0) {
      return undefined;
    }

    try {
      const frame: Object = JSON.parse(payload) as Object;
      const choices: Object[] | undefined = (frame as Record<string, Object>)['choices'] as Object[];
      if (choices === undefined || choices.length === 0) {
        return undefined;
      }
      const firstChoice: Record<string, Object> = choices[0] as Record<string, Object>;
      const delta: Record<string, Object> | undefined = firstChoice['delta'] as Record<string, Object>;
      if (delta === undefined) {
        return undefined;
      }
      const content: Object | undefined = delta['content'];
      return typeof content === 'string' ? content : undefined;
    } catch (error) {
      return undefined;
    }
  }
}
