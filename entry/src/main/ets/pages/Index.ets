import { DesignTokens } from '../common/DesignTokens';
import { ChatPage } from './Chat';
import { KnowledgePage } from './Knowledge';
import { SettingsPage } from './Settings';

@Entry
@Component
struct Index {
  @State selectedTab: number = 0;

  build() {
    Column() {
      if (this.selectedTab === 0) {
        ChatPage()
      } else if (this.selectedTab === 1) {
        KnowledgePage()
      } else {
        SettingsPage()
      }
      this.BottomNav()
    }
    .width('100%')
    .height('100%')
    .backgroundColor(DesignTokens.BG_DEEP)
  }

  @Builder
  BottomNav() {
    Row() {
      this.TabItem('💬', '对话', 0)
      this.TabItem('📚', '知识库', 1)
      this.TabItem('⚙️', '设置', 2)
    }
    .width('100%')
    .height(60)
    .backgroundColor(DesignTokens.PANEL_DARK)
    .border({ width: 1, color: DesignTokens.PANEL })
  }

  @Builder
  TabItem(icon: string, label: string, index: number) {
    Column({ space: DesignTokens.SPACE_1 }) {
      Text(icon).fontSize(DesignTokens.FONT_ICON)
      Text(label)
        .fontSize(DesignTokens.FONT_LABEL)
        .fontColor(this.selectedTab === index ? DesignTokens.SKY : DesignTokens.TEXT_SUB)
        .fontWeight(this.selectedTab === index ? FontWeight.Bold : FontWeight.Normal)
    }
    .layoutWeight(1)
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.selectedTab = index
    })
  }
}
