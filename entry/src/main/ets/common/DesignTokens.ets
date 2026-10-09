/**
 * 鸿智 Agent 设计 Token —— UI 中所有颜色必须引用此处，禁止硬编码色值。
 * 与 docs/design.html 的视觉风格保持一致。
 */
export class DesignTokens {
  // 背景与面板
  static readonly BG_DEEP: string = '#0B1120'         // 深底
  static readonly PANEL: string = '#111A2E'           // 面板
  static readonly PANEL_DARK: string = '#0F172A'      // 卡片底

  // 品牌色
  static readonly SKY: string = '#38BDF8'             // 天青（主）
  static readonly VIOLET: string = '#8B5CF6'          // 紫罗兰（辅）

  // 状态色（语义约定：规划=蓝 / 执行=琥珀 / 完成=绿）
  static readonly STATUS_PLAN: string = '#38BDF8'
  static readonly STATUS_RUN: string = '#F59E0B'
  static readonly STATUS_DONE: string = '#22C55E'

  // 文字
  static readonly TEXT_MAIN: string = '#E2E8F0'
  static readonly TEXT_SUB: string = '#7C8BA1'
  static readonly TEXT_ON_DARK: string = '#FFFFFF'

  // 字号（vp）
  static readonly FONT_TITLE: number = 16
  static readonly FONT_BODY: number = 13
  static readonly FONT_SUB: number = 12
  static readonly FONT_LABEL: number = 11
  static readonly FONT_ICON: number = 18

  // 圆角
  static readonly RADIUS: number = 12
  static readonly RADIUS_CARD: number = 16

  // 间距（vp）
  static readonly SPACE_1: number = 4
  static readonly SPACE_2: number = 8
  static readonly SPACE_3: number = 12
  static readonly SPACE_4: number = 16
}
