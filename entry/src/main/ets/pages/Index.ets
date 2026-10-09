import { DesignTokens } from '../common/DesignTokens';

interface ChatMessage {
  id: number;
  role: 'user' | 'assistant';
  content: string;
}

@Entry
@Component
struct Index {
  @State input: string = '';
  @State messages: ChatMessage[] = [
    { id: 1, role: 'user', content: '明天上午十点提醒我开周会' },
    { id: 2, role: 'assistant', content: '已为你创建提醒：明天 10:00 周会 ✅' }
  ];
  private nextMessageId: number = 3;

  build() {
    Column() {
      this.Header()

      Scroll() {
        Column({ space: DesignTokens.SPACE_2 }) {
          ForEach(this.messages, (message: ChatMessage) => {
            this.MessageThread(message)
          }, (message: ChatMessage) => message.id.toString())
        }
        .width('100%')
        .padding(DesignTokens.SPACE_3)
      }
      .layoutWeight(1)
      .width('100%')
      .scrollBar(BarState.Off)

      this.InputBar()
    }
    .width('100%')
    .height('100%')
    .backgroundColor(DesignTokens.BG_DEEP)
  }

  @Builder
  Header() {
    Row() {
      Text('鸿智 Agent')
        .fontSize(DesignTokens.FONT_TITLE)
        .fontColor(DesignTokens.TEXT_ON_DARK)
        .fontWeight(FontWeight.Bold)
      Blank()
      Text('DeepSeek-R1')
        .fontSize(DesignTokens.FONT_LABEL)
        .fontColor(DesignTokens.TEXT_SUB)
    }
    .width('100%')
    .padding(DesignTokens.SPACE_4)
    .backgroundColor(DesignTokens.BG_DEEP)
  }

  @Builder
  MessageThread(message: ChatMessage) {
    this.MessageBubble(message)
    if (message.id === 1) {
      this.ToolCallCard()
    }
  }

  @Builder
  MessageBubble(message: ChatMessage) {
    Row() {
      Text(message.content)
        .fontSize(DesignTokens.FONT_BODY)
        .fontColor(message.role === 'user' ? DesignTokens.TEXT_ON_DARK : DesignTokens.TEXT_MAIN)
        .lineHeight(20)
        .padding({
          left: DesignTokens.SPACE_3,
          right: DesignTokens.SPACE_3,
          top: DesignTokens.SPACE_2,
          bottom: DesignTokens.SPACE_2
        })
        .borderRadius(DesignTokens.RADIUS)
        .backgroundColor(message.role === 'user' ? DesignTokens.SKY : DesignTokens.PANEL)
        .linearGradient({
          angle: 135,
          colors: message.role === 'user'
            ? [[DesignTokens.SKY, 0.0], [DesignTokens.VIOLET, 1.0]]
            : [[DesignTokens.PANEL, 0.0], [DesignTokens.PANEL, 1.0]]
        })
    }
    .width('100%')
    .justifyContent(message.role === 'user' ? FlexAlign.End : FlexAlign.Start)
  }

  @Builder
  ToolCallCard() {
    Column({ space: DesignTokens.SPACE_2 }) {
      this.ToolStep('🧠', '规划', '✓ 完成', DesignTokens.STATUS_PLAN, '意图', '创建提醒')
      this.ToolStep('⚙️', '工具调用', '✓ 完成', DesignTokens.STATUS_RUN, '工具', 'reminder.create')
      this.ToolStep('✅', '结果回填', '✓ 完成', DesignTokens.STATUS_DONE, '结果', '明天 10:00 周会')
    }
    .width('100%')
    .padding(DesignTokens.SPACE_3)
    .backgroundColor(DesignTokens.PANEL_DARK)
    .border({ width: 1, color: DesignTokens.PANEL })
    .borderRadius(DesignTokens.RADIUS)
  }

  @Builder
  ToolStep(icon: string, title: string, status: string, statusColor: string, label: string, value: string) {
    Column({ space: DesignTokens.SPACE_1 }) {
      Row() {
        Text(icon).fontSize(DesignTokens.FONT_ICON)
        Text(title)
          .fontSize(DesignTokens.FONT_BODY)
          .fontColor(statusColor)
          .fontWeight(FontWeight.Bold)
          .margin({ left: DesignTokens.SPACE_1 })
        Blank()
        Text(status)
          .fontSize(DesignTokens.FONT_LABEL)
          .fontColor(statusColor)
      }
      Row() {
        Text(label)
          .fontSize(DesignTokens.FONT_LABEL)
          .fontColor(DesignTokens.TEXT_SUB)
        Blank()
        Text(value)
          .fontSize(DesignTokens.FONT_LABEL)
          .fontColor(DesignTokens.TEXT_MAIN)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width('100%')
    }
    .width('100%')
  }

  @Builder
  InputBar() {
    Row({ space: DesignTokens.SPACE_2 }) {
      Button('🎤')
        .width(36)
        .height(36)
        .fontSize(DesignTokens.FONT_ICON)
        .backgroundColor(DesignTokens.PANEL)
        .borderRadius(18)
      TextInput({ placeholder: '一句话描述需求…', text: this.input })
        .layoutWeight(1)
        .height(40)
        .backgroundColor(DesignTokens.PANEL)
        .fontSize(DesignTokens.FONT_BODY)
        .fontColor(DesignTokens.TEXT_MAIN)
        .borderRadius(DesignTokens.RADIUS)
        .onChange((value: string) => {
          this.input = value
        })
      Button('➤')
        .width(36)
        .height(36)
        .fontSize(DesignTokens.FONT_ICON)
        .fontColor(DesignTokens.TEXT_ON_DARK)
        .backgroundColor(DesignTokens.SKY)
        .borderRadius(18)
        .onClick(() => {
          this.sendMessage()
        })
    }
    .width('100%')
    .padding(DesignTokens.SPACE_3)
    .backgroundColor(DesignTokens.PANEL_DARK)
  }

  private sendMessage(): void {
    const content: string = this.input.trim()
    if (content.length === 0) {
      return
    }
    this.messages = this.messages.concat([
      { id: this.nextMessageId++, role: 'user', content: content },
      { id: this.nextMessageId++, role: 'assistant', content: '已收到，我会继续为你处理。' }
    ])
    this.input = ''
  }
}
