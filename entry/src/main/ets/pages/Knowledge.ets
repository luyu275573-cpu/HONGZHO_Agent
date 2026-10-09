import { DesignTokens } from '../common/DesignTokens';

@Component
export struct KnowledgePage {
  build() {
    Column() {
      this.PageHeader('知识库管理', 'RAG + 引用来源')
      Scroll() {
        Column({ space: DesignTokens.SPACE_2 }) {
          this.DocumentCard('📄 农场养殖手册.pdf', '128 切片 · 向量库 v3 · 已同步')
          this.DocumentCard('📊 兽药使用说明.docx', '45 切片 · 已同步')
          this.DocumentCard('📁 病害防治指南', '23 切片 · 权限：养殖组')
          this.SourceCard()
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
  PageHeader(title: string, subtitle: string) {
    Row() {
      Text(title)
        .fontSize(DesignTokens.FONT_TITLE)
        .fontColor(DesignTokens.TEXT_ON_DARK)
        .fontWeight(FontWeight.Bold)
      Blank()
      Text(subtitle)
        .fontSize(DesignTokens.FONT_LABEL)
        .fontColor(DesignTokens.TEXT_SUB)
    }
    .width('100%')
    .padding(DesignTokens.SPACE_4)
    .backgroundColor(DesignTokens.BG_DEEP)
  }

  @Builder
  DocumentCard(title: string, metadata: string) {
    Column({ space: DesignTokens.SPACE_1 }) {
      Text(title)
        .fontSize(DesignTokens.FONT_BODY)
        .fontColor(DesignTokens.TEXT_MAIN)
        .fontWeight(FontWeight.Bold)
      Text(metadata)
        .fontSize(DesignTokens.FONT_LABEL)
        .fontColor(DesignTokens.TEXT_SUB)
    }
    .width('100%')
    .padding(DesignTokens.SPACE_3)
    .backgroundColor(DesignTokens.PANEL)
    .border({ width: 1, color: DesignTokens.PANEL_DARK })
    .borderRadius(DesignTokens.RADIUS)
  }

  @Builder
  SourceCard() {
    Column({ space: DesignTokens.SPACE_2 }) {
      Text('问：「上季度项目总结里写了什么？」')
        .fontSize(DesignTokens.FONT_BODY)
        .fontColor(DesignTokens.TEXT_MAIN)
      Row({ space: DesignTokens.SPACE_1 }) {
        Text('📄 来源：项目总结.pdf §3.2')
          .fontSize(DesignTokens.FONT_LABEL)
          .fontColor(DesignTokens.TEXT_SUB)
          .padding({ left: DesignTokens.SPACE_2, right: DesignTokens.SPACE_2, top: DesignTokens.SPACE_1, bottom: DesignTokens.SPACE_1 })
          .backgroundColor(DesignTokens.PANEL_DARK)
          .borderRadius(DesignTokens.RADIUS)
        Text('§5.1')
          .fontSize(DesignTokens.FONT_LABEL)
          .fontColor(DesignTokens.TEXT_SUB)
          .padding({ left: DesignTokens.SPACE_2, right: DesignTokens.SPACE_2, top: DesignTokens.SPACE_1, bottom: DesignTokens.SPACE_1 })
          .backgroundColor(DesignTokens.PANEL_DARK)
          .borderRadius(DesignTokens.RADIUS)
      }
    }
    .width('100%')
    .padding(DesignTokens.SPACE_3)
    .backgroundColor(DesignTokens.PANEL)
    .borderRadius(DesignTokens.RADIUS)
  }
}
