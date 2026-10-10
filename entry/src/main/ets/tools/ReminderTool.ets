import { ToolRegistration } from '../model/ToolModels';

interface ReminderArguments {
  time?: string;
  title?: string;
}

export const ReminderTool: ToolRegistration = {
  schema: {
    name: 'reminder.create',
    description: '创建一个本地提醒',
    parameterNames: ['time', 'title']
  },
  execute: async (argumentsJson: string): Promise<string> => {
    if (argumentsJson.trim().length === 0) {
      return '提醒参数为空';
    }

    let args: ReminderArguments;
    try {
      args = JSON.parse(argumentsJson) as ReminderArguments;
    } catch (error) {
      return '提醒参数格式无效';
    }

    const time: string = args.time === undefined ? '' : args.time;
    const title: string = args.title === undefined ? '' : args.title;
    if (time.trim().length === 0 || title.trim().length === 0) {
      return '提醒参数缺少 time 或 title';
    }
    return '已创建提醒：' + time + ' ' + title;
  }
};
