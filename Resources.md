# 数字指南针 iOS App 资源清单

> 本文档列出了 App 所需的所有图片和 Icon 资源，包含位置、尺寸和用途说明，方便后续替换。

---

## 一、App Icon 资源

> **已生成占位图**：`DigitalCompass/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png`（1024×1024px），可直接在 Xcode 中打开 Asset Catalog 替换为最终品牌稿。

### 1.1 App Store Icon
| 文件名 | 尺寸 | 用途 | 位置 |
|--------|------|------|------|
| AppIcon-1024.png | 1024×1024px | iOS 17+ 单一切图 / App Store | `DigitalCompass/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png` |

### 1.2 iPhone App Icon
| 文件名 | 尺寸 | 用途 | 位置 |
|--------|------|------|------|
| AppIcon-60@2x.png | 120×120px | iPhone App (2x) | Assets.xcassets/AppIcon.appiconset/ |
| AppIcon-60@3x.png | 180×180px | iPhone App (3x) | Assets.xcassets/AppIcon.appiconset/ |
| AppIcon-76@2x.png | 152×152px | iPad App (2x) | Assets.xcassets/AppIcon.appiconset/ |
| AppIcon-83.5@2x.png | 167×167px | iPad Pro (2x) | Assets.xcassets/AppIcon.appiconset/ |

---

## 二、UI 图标资源 (SF Symbols)

App 主要使用 **SF Symbols** 作为图标，以下为使用清单：

| 图标名称 | 用途 | 尺寸建议 | 位置 |
|----------|------|----------|------|
| gear | 设置按钮 | 24×24pt | 首页右上角 |
| questionmark.circle | 帮助按钮 | 24×24pt | 首页右上角 |
| target | 校准按钮 | 20×20pt | 首页底部 |
| location | 麦加方向按钮 | 20×20pt | 首页底部 |
| crown.fill | Pro/订阅标识 | 20×20pt | 首页/订阅页 |
| arrow.left | 返回按钮 | 20×20pt | 各页面导航 |
| paintpalette | 主题设置 | 24×24pt | 设置页 |
| globe | 语言设置 | 24×24pt | 设置页 |
| target | 精度提示 | 24×24pt | 设置页 |
| bell | 声音反馈 | 24×24pt | 设置页 |
| questionmark.circle | 帮助中心 | 24×24pt | 设置页 |
| lock.shield | 隐私协议 | 24×24pt | 设置页 |
| doc.text | 用户条款 | 24×24pt | 设置页 |
| doc.plaintext | 订阅条款 | 24×24pt | 设置页 |
| arrow.counterclockwise | 恢复购买 | 24×24pt | 设置页 |
| checkmark | 权益勾选 | 18×18pt | 订阅页 |
| arrow.clockwise | 重新定位 | 20×20pt | 麦加方向页 |
| house.fill | 回到首页 | 20×20pt | 麦加方向页 |
| arrow.up.arrow.down | 旋转指示 | 24×24pt | 麦加方向页 |
| iphone | 校准手机示意 | 24×24pt | 校准页 |

---

## 三、图片资源

### 3.1 启动页 (Launch Screen)
| 文件名 | 尺寸 | 用途 | 位置 |
|--------|------|------|------|
| launch-logo.png | 200×200px | 启动页 Logo | Assets.xcassets/ |
| launch-bg.png | 393×852px (iPhone 14) | 启动页背景 | Assets.xcassets/ |

### 3.2 校准引导图
| 文件名 | 尺寸 | 用途 | 位置 |
|--------|------|------|------|
| calibration-figure8.png | 280×200px | 8字形示意 | Assets.xcassets/ |
| calibration-phone.png | 50×80px | 手机动画示意 | Assets.xcassets/ |

### 3.3 麦加方向图标
| 文件名 | 尺寸 | 用途 | 位置 |
|--------|------|------|------|
| qibla-marker.png | 40×40px | 麦加位置标记 | Assets.xcassets/ |
| kaaba-icon.png | 40×40px | 天房图标 | Assets.xcassets/ |

### 3.4 订阅页图标
| 文件名 | 尺寸 | 用途 | 位置 |
|--------|------|------|------|
| crown-gradient.png | 80×80px | Pro 皇冠图标 | Assets.xcassets/ |
| pro-feature-adfree.png | 48×48px | 去广告权益 | Assets.xcassets/ |
| pro-feature-theme.png | 48×48px | 主题权益 | Assets.xcassets/ |
| pro-feature-style.png | 48×48px | 样式权益 | Assets.xcassets/ |
| pro-feature-update.png | 48×48px | 更新权益 | Assets.xcassets/ |

---

## 四、颜色规范

### 4.1 主题颜色 (深色主题 - 默认)
| 颜色名称 | 十六进制 | 用途 |
|----------|----------|------|
| backgroundPrimary | #1A1A2E | 主背景色 |
| backgroundSecondary | #0F0F1A | 卡片背景色 |
| backgroundTertiary | #2D2D44 | 按钮/输入框背景 |
| accentPrimary | #00E676 | 主强调色(绿) |
| accentWarning | #FF5252 | 警告色(红) |
| accentOrange | #FFB74D | 橙色强调 |
| textPrimary | #FFFFFF | 主要文字 |
| textSecondary | #8A8AA0 | 次要文字 |
| textTertiary | #5A5A7A | 辅助文字 |
| strokePrimary | #3A3A5C | 边框/分割线 |

### 4.2 浅色主题
| 颜色名称 | 十六进制 | 用途 |
|----------|----------|------|
| backgroundPrimary | #F5F5F7 | 主背景色 |
| backgroundSecondary | #FFFFFF | 卡片背景色 |
| backgroundTertiary | #E8E8ED | 按钮背景 |
| accentPrimary | #00C853 | 主强调色 |
| textPrimary | #1A1A2E | 主要文字 |
| textSecondary | #6E6E80 | 次要文字 |

---

## 五、字体规范

| 字体 | 大小 | 字重 | 用途 |
|------|------|------|------|
| Inter/System | 20pt | Semibold (600) | 页面标题 |
| Inter/System | 18pt | Regular (400) | 方向标签 |
| Inter/System | 80pt | Bold (700) | 角度数值 |
| Inter/System | 32pt | Bold (700) | 指北标记N |
| Inter/System | 24pt | Semibold (600) | 方向标记S/E/W |
| Inter/System | 16pt | Regular/600 | 正文/按钮 |
| Inter/System | 14pt | Regular | 辅助文字 |
| Inter/System | 12pt | Regular | 底部说明 |

---

## 六、尺寸规范

### 6.1 布局尺寸
| 元素 | 尺寸 | 说明 |
|------|------|------|
| 屏幕设计尺寸 | 393×852pt | iPhone 14/15 基准 |
| 指南针外圈 | 300×300pt | 首页主圆盘 |
| 指南针内圈 | 260×260pt | 内圈装饰 |
| 麦加页圆盘 | 280×280pt | 麦加方向页 |
| 顶部按钮 | 40×40pt | 设置/帮助按钮 |
| 底部功能按钮 | 100-120×44pt | 校准/麦加/Pro |
| 设置行高 | 56pt | 设置列表项 |
| 订阅卡片 | 160×160-180pt | 月订/年订卡片 |

### 6.2 间距规范
| 间距 | 数值 | 用途 |
|------|------|------|
| 页面边距 | 16pt | 左右边距 |
| 元素间距小 | 8pt | 紧密元素间 |
| 元素间距中 | 16pt | 一般元素间 |
| 元素间距大 | 24pt | 区块间 |
| 区块间距 | 40pt | 主要区块间 |

---

## 七、动效资源

### 7.1 动画标识
| 动画 | 描述 | 位置 |
|------|------|------|
| compass-rotation | 指南针旋转跟随方向 | 首页/麦加页 |
| figure8-guide | 8字形引导动画 | 校准页 |
| phone-tilt | 手机倾斜示意 | 校准页 |
| progress-fill | 精度条填充动画 | 校准页 |
| pulse-indicator | 定位状态脉冲 | 麦加页 |

---

## 八、多语言适配提示

### 8.1 文字长度适配
| 语言 | 平均文字增长 | 注意事项 |
|------|--------------|----------|
| 英语 | 基准 | - |
| 简体中文 | -20% | 较短，可能需要调整间距 |
| 繁体中文 | 0% | - |
| 德语 | +30% | 按钮文字可能换行 |
| 法语 | +25% | 按钮文字可能换行 |
| 韩语 | 0% | - |
| 日语 | 0% | - |
| 西班牙语 | +20% | 注意换行 |
| 葡萄牙语 | +20% | 注意换行 |
| 阿拉伯语 | -10% | RTL 布局，需镜像 |

### 8.2 RTL 适配 (阿拉伯语)
- 所有水平布局需镜像
- 箭头方向需反转 (← 变为 →)
- 列表箭头 (>) 变为 (<)
- 指南针旋转方向保持物理正确

---

## 九、资源替换清单

### 需要设计的资源：
1. [ ] App Icon (各尺寸)
2. [ ] 启动页 Logo
3. [ ] 8字形校准示意图
4. [ ] 麦加标记图标
5. [ ] 皇冠渐变图标 (Pro)
6. [ ] 权益图标 (4个)

### 可直接使用 SF Symbols：
- 设置、帮助、返回、主题、语言、精度、声音、隐私、条款等所有功能图标

---

**文档版本**: v1.1  
**创建日期**: 2026-04-18（图标占位更新 2026-04-25）  
**适用项目**: Digital Compass iOS App  

**订阅权益成稿**：另见同目录 `SUBSCRIPTION_BENEFITS.md`（与 PRD 第 9 节、应用内 `benefit_*` 文案一致）。
