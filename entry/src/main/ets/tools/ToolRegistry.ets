import { ToolRequest, ToolRegistration, ToolSchema } from '../model/ToolModels';
import { ReminderTool } from './ReminderTool';

export class ToolRegistry {
  private readonly registrations: ToolRegistration[] = [ReminderTool];
  private readonly timeoutMs: number;

  constructor(timeoutMs: number = 3000) {
    this.timeoutMs = timeoutMs;
  }

  listSchemas(): ToolSchema[] {
    return this.registrations.map((registration: ToolRegistration) => registration.schema);
  }

  async execute(request: ToolRequest): Promise<string> {
    const registration: ToolRegistration | undefined = this.find(request.name);
    if (registration === undefined) {
      return '未知工具：' + request.name;
    }
    return this.executeWithTimeout(registration, request.arguments);
  }

  private find(name: string): ToolRegistration | undefined {
    for (const registration of this.registrations) {
      if (registration.schema.name === name) {
        return registration;
      }
    }
    return undefined;
  }

  private executeWithTimeout(registration: ToolRegistration, argumentsJson: string): Promise<string> {
    return new Promise<string>((resolve) => {
      let finished: boolean = false;
      const finish = (value: string): void => {
        if (finished) {
          return;
        }
        finished = true;
        resolve(value);
      };
      const timer = setTimeout(() => {
        finish('工具执行超时');
      }, this.timeoutMs);

      try {
        registration.execute(argumentsJson)
          .then((value: string) => {
            clearTimeout(timer);
            finish(value);
          })
          .catch(() => {
            clearTimeout(timer);
            finish('工具执行失败');
          });
      } catch (error) {
        clearTimeout(timer);
        finish('工具执行失败');
      }
    });
  }
}
