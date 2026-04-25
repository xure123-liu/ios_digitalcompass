# Digital Compass Pro — 订阅权益说明（上架与内购对照）

> 与 `digital-compass-prd.md` 第 9 节及 App 内 `SubscriptionView` 权益文案一致，供产品、法务与 App Store 描述使用。价格以 App Store Connect / 各市场货币为准（PRD 示例为美元）。

## SKU 与基础信息

| SKU 概念 | 建议 Product ID（工程内占位） | PRD 定价（示例） | 计费周期 |
|----------|------------------------------|------------------|----------|
| 月订 | `com.digitalcompass.pro.monthly` | US$2.99 / 月 | 自动续费 |
| 年订 | `com.digitalcompass.pro.yearly` | US$19.99 / 年 | 自动续费（推荐档位） |

请在 App Store Connect 中创建同名或已替换为最终 ID 的自动续订订阅，并与工程内 `SubscriptionManager` 的 `monthlyProductID` / `yearlyProductID` 一致。

## Pro 会员权益（文案级）

1. **去广告** — 使用过程无广告打扰（若免费版将来含广告，Pro 覆盖该体验）。
2. **高级主题与视觉样式** — 含「Pro Ocean」「Pro Sunset」等主题变体及高对比界面能力（与 `AppTheme` 中 `isPro == true` 项对应）。
3. **扩展圆盘样式** — 更丰富指南针圆盘与方向呈现（随版本扩展，Pro 解锁完整视觉方案）。
4. **后续高级能力优先开放** — 新功能在 Pro 通道优先或完整开放（与 PRD「持续更新」表述一致）。

## 与免费版差异（摘要）

| 能力 | 免费版 | Pro |
|------|--------|-----|
| 实时方向 / 角度 / 基础校准 / 麦加方向 | ✓ | ✓ |
| 广告 | 可能有 | 无 |
| 高级主题与扩展样式 | 受限或不可用 | 解锁 |
| 后续高级功能 | 依版本策略 | 优先或完整 |

## 恢复购买与条款

- 用户可在 **设置** 与 **订阅页** 使用「恢复购买」，与当前 **同意条款的 Apple ID** 下的有效订阅一致时恢复权益。
- 自动续费、取消与退款说明以 **应用内《订阅条款》** 及 Apple 官方政策为准；上线前请由法务定稿。

---

**文档版本**：与 PRD V1.0 / 工程 1.0 对齐  
**更新说明**：权益列表与 `Localizable.strings` 中 `benefit_*` 键及订阅页 UI 同步维护。
