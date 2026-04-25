# Digital Compass iOS App

A comprehensive digital compass iOS application with real-time heading display, calibration, Qibla direction, multi-language support, and subscription features.

## Features

### Core Features
- **Real-time Compass**: Display current heading with accurate degree readings
- **16-point Direction System**: Shows direction names (N, NE, E, SE, S, SW, W, NW and intermediates)
- **Accuracy Indicator**: Visual feedback on compass accuracy status
- **Calibration Guide**: Step-by-step 8-figure calibration process
- **Qibla Direction**: Calculates direction to Mecca based on current location
- **Sound Feedback**: Optional audio feedback when facing cardinal directions

### Multi-Language Support (10 Languages)
- English (en)
- Simplified Chinese (zh-Hans)
- Traditional Chinese (zh-Hant)
- German (de)
- French (fr)
- Korean (ko)
- Japanese (ja)
- Spanish (es)
- Portuguese (pt)
- Arabic (ar) - with RTL layout support

### Subscription Model
- Monthly subscription: $2.99/month
- Yearly subscription: $19.99/year (Save 44%)
- Pro Benefits:
  - Ad-free experience
  - Premium themes (Ocean, Sunset)
  - Extended compass dial styles
  - Priority access to new features

### Theme Support
- Classic Blue (Default)
- Dark Mode
- Light Mode
- Pro Ocean (Premium)
- Pro Sunset (Premium)

## Project Structure

```
DigitalCompass/
├── DigitalCompassApp.swift          # App entry point
├── Info.plist                       # App configuration
├── Models/
│   ├── AppSettings.swift            # App settings & preferences
│   ├── CompassManager.swift          # Compass sensor management
│   ├── QiblaManager.swift            # Qibla calculation
│   └── SubscriptionManager.swift     # IAP handling
├── Views/
│   ├── ContentView.swift             # Main container
│   ├── CompassHomeView.swift         # Main compass screen
│   ├── CalibrationView.swift         # Calibration guide
│   ├── QiblaView.swift               # Qibla direction
│   ├── SettingsView.swift            # App settings
│   ├── SubscriptionView.swift        # Subscription purchase
│   ├── LanguagePickerView.swift      # Language selection
│   ├── ThemePickerView.swift          # Theme selection
│   └── LegalDocumentView.swift        # Legal terms display
└── Localizations/
    ├── en.lproj/Localizable.strings   # English
    ├── zh-Hans.lproj/                 # Simplified Chinese
    ├── zh-Hant.lproj/                 # Traditional Chinese
    ├── de.lproj/                       # German
    ├── fr.lproj/                       # French
    ├── ko.lproj/                       # Korean
    ├── ja.lproj/                       # Japanese
    ├── es.lproj/                       # Spanish
    ├── pt.lproj/                       # Portuguese
    └── ar.lproj/                       # Arabic (RTL)
```

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+
- Device with compass capability (iPhone/iPad)

## Setup Instructions

### 1. Create Xcode Project
1. Open Xcode
2. Create new iOS App project
3. Name: "DigitalCompass"
4. Organization: Your organization
5. Interface: SwiftUI
6. Language: Swift

### 2. Copy Source Files
1. Copy all `.swift` files to the project
2. Copy `Info.plist` configuration
3. Add localization files to project

### 3. Configure In-App Purchases
1. Log in to App Store Connect
2. Create app record
3. Configure IAP products:
   - Product ID: `com.digitalcompass.pro.monthly`
   - Product ID: `com.digitalcompass.pro.yearly`
4. Add products to the app's capability

### 4. Build and Run
1. Select target device
2. Build (Cmd+B)
3. Run (Cmd+R)

## App Store Configuration

### Required Capabilities
- Location When In Use (for Qibla calculation)
- In-App Purchase

### App Store Screenshots Required
1. Main compass view
2. Calibration screen
3. Qibla direction view
4. Settings screen
5. Subscription screen

### App Store Metadata
- **Name**: Digital Compass / 数字指南针
- **Subtitle**: Accurate direction · Real-time angle · Qibla finder
- **Keywords**: compass, digital compass, direction, angle, qibla, navigation

## Design Specifications

### Colors (Dark Theme - Default)
- Background Primary: `#1A1A2E`
- Background Secondary: `#0F0F1A`
- Background Tertiary: `#2D2D44`
- Accent Primary: `#00E676` (Green)
- Accent Warning: `#FF5252` (Red)
- Accent Orange: `#FFB74D` (Orange)
- Text Primary: `#FFFFFF`
- Text Secondary: `#8A8AA0`
- Text Tertiary: `#5A5A7A`

### Typography
- Heading: Inter/System 20pt Semibold
- Direction Label: Inter/System 18pt Regular
- Angle Value: Inter/System 80pt Bold
- Cardinal Directions: Inter/System 32pt/24pt Bold/Semibold

### Layout
- Screen Design Size: 393×852pt (iPhone 14/15 baseline)
- Compass Dial: 300×300pt
- Button Height: 44-48pt
- Corner Radius: 12-28pt

## Subscription Logic

### Display Rules
1. **After onboarding**: Subscription sheet is shown once when the user finishes onboarding (if not Pro).
2. **Cold start**: On each new process (app launched after being terminated), if the user is not subscribed, the subscription sheet is shown again. Implemented via `AppDelegate` (`application(_:didFinishLaunchingWithOptions:)`) and `ContentView` — not on every resume from the background.
3. **Feature-gated**: Shown from **Upgrade Pro**, theme pickers for Pro themes, and related entry points.

### Remote repository

- **GitHub**: [https://github.com/xure123-liu/ios_digitalcompass](https://github.com/xure123-liu/ios_digitalcompass)

After [installing Git](https://git-scm.com/download/win), from the project root you can use `scripts/sync-to-github.ps1` (PowerShell) or:

```bash
git remote add origin https://github.com/xure123-liu/ios_digitalcompass.git
git add -A
git commit -m "feat: your message"
git branch -M main
git push -u origin main
```

If the repo already has commits on GitHub, you may need `git pull --rebase origin main` before the first `push`, or use `git push -u origin main --force` only if you intend to replace remote history (use with care).

## RTL Support (Arabic)

The app automatically handles RTL layout for Arabic language:
- All horizontal layouts are mirrored
- Arrow directions are reversed (→ becomes ←)
- List indicators are reversed
- Compass rotation maintains physical correctness

## Legal Documents

### Privacy Policy
- Data collection disclosure
- Location usage explanation
- No cloud sync or account system
- Local data storage only

### Terms of Service
- Tool reference disclaimer
- Safe usage guidelines
- Limitation of liability
- Modification rights

### Subscription Terms
- Auto-renewal disclosure
- Cancellation instructions
- Refund policy reference
- Restore purchase information

## Resources

See `Resources.md` for complete image and icon specifications.

## License

Proprietary - All rights reserved.

## Support

For support, contact: support@digitalcompass.app
