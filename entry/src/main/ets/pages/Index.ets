import { DesignTokens } from '../common/DesignTokens';

@Entry
@Component
struct Index {
  @State input: string = '';

  build() {
    Column() {
      // 顶部
      Row() {
        Text('鸿智 Agent').fontSize(16).fontColor('#FFFFFF').fontWeight(FontWeight.Bold)
        Blank()
        Text('DeepSeek-R1').fontSize(11).fontColor('#94A3B8')
      }
      .width('100%')
      .padding(16)
      .backgroundColor(DesignTokens.BG_DEEP)

      // 对话区（占位）
      Column() {
        Text('🤖').fontSize(44)
        Text('Agent 骨架已就绪').fontSize(14).fontColor(DesignTokens.TEXT_MAIN)
        Text('一句话描述需求，AI 自主规划执行').fontSize(12).fontColor(DesignTokens.TEXT_SUB)
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(DesignTokens.BG_DEEP)

      // 输入栏
      Row() {
        Text('🎤').fontSize(18)
        TextInput({ placeholder: '一句话描述需求…' })
          .layoutWeight(1)
          .height(40)
          .backgroundColor(DesignTokens.PANEL)
          .fontColor(DesignTokens.TEXT_MAIN)
        Text('➤').fontSize(18).fontColor(DesignTokens.SKY).padding({ left: 8, right: 8 })
      }
      .width('100%')
      .padding(12)
      .backgroundColor(DesignTokens.PANEL_DARK)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(DesignTokens.BG_DEEP)
  }
}
