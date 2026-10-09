import { DesignTokens } from '../common/DesignTokens';

@Component
export struct SettingsPage {
  build() {
    Column() {
      this.PageHeader()
      Scroll() {
        Column({ space: DesignTokens.SPACE_2 }) {
          this.SectionTitle('技能 / 工具配置')
          this.SkillRow('🌤️ 天气查询', '启用', DesignTokens.STATUS_DONE)
          this.SkillRow('⏰ 提醒', '启用', DesignTokens.STATUS_DONE)
          this.SkillRow('📅 日历', '启用', DesignTokens.STATUS_DONE)
          this.SkillRow('📁 文件操作', '启用', DesignTokens.STATUS_DONE)
          this.SkillRow('🔎 搜索', '启用', DesignTokens.STATUS_DONE)
          this.SkillRow('🧠 记忆', '仅本地', DesignTokens.STATUS_RUN)
          this.SectionTitle('多设备协同')
          this.DeviceCard()
        }
        .width('100%')
        .padding(DesignTokens.SPACE_3)
      }
      .layoutWeight(1)
      .width('100%')
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(DesignTokens.BG_DEEP)
  }

  @Builder
  PageHeader() {
    Row() {
      Text('技能 / 工具配置')
        .fontSize(DesignTokens.FONT_TITLE)
        .fontColor(DesignTokens.TEXT_ON_DARK)
        .fontWeight(FontWeight.Bold)
      Blank()
      Text('本地假数据')
        .fontSize(DesignTokens.FONT_LABEL)
        .fontColor(DesignTokens.TEXT_SUB)
    }
    .width('100%')
    .padding(DesignTokens.SPACE_4)
    .backgroundColor(DesignTokens.BG_DEEP)
  }

  @Builder
  SectionTitle(title: string) {
    Text(title)
      .fontSize(DesignTokens.FONT_SUB)
      .fontColor(DesignTokens.TEXT_SUB)
      .fontWeight(FontWeight.Bold)
      .width('100%')
      .margin({ top: DesignTokens.SPACE_2, bottom: DesignTokens.SPACE_1 })
  }

  @Builder
  SkillRow(name: string, status: string, statusColor: string) {
    Row() {
      Text(name)
        .fontSize(DesignTokens.FONT_BODY)
        .fontColor(DesignTokens.TEXT_MAIN)
      Blank()
      Text(status)
        .fontSize(DesignTokens.FONT_LABEL)
        .fontColor(statusColor)
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .padding(DesignTokens.SPACE_3)
    .backgroundColor(DesignTokens.PANEL)
    .border({ width: 1, color: DesignTokens.PANEL_DARK })
    .borderRadius(DesignTokens.RADIUS)
  }

  @Builder
  DeviceCard() {
    Column({ space: DesignTokens.SPACE_2 }) {
      Row({ space: DesignTokens.SPACE_3 }) {
        Text('📱').fontSize(32)
        Text('⇄').fontSize(24).fontColor(DesignTokens.TEXT_SUB)
        Text('💻').fontSize(32)
      }
      Text('任务与提醒跨设备同步')
        .fontSize(DesignTokens.FONT_BODY)
        .fontColor(DesignTokens.TEXT_MAIN)
        .fontWeight(FontWeight.Bold)
      Text('手机发起 → 平板 / PC 接续，提醒同步到手表')
        .fontSize(DesignTokens.FONT_LABEL)
        .fontColor(DesignTokens.TEXT_SUB)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .padding(DesignTokens.SPACE_4)
    .backgroundColor(DesignTokens.PANEL)
    .borderRadius(DesignTokens.RADIUS_CARD)
  }
}
