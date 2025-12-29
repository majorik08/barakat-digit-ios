# Barakat Digit - iOS Mobile Banking Application

<div align="center">

**A full-featured digital wallet and mobile banking application for iOS**

[![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg)]()

</div>

## 📱 Overview

**Barakat Digit** is a comprehensive iOS mobile banking and digital wallet application developed in Swift. It provides users with a complete financial management solution, including account management, card operations, payments, transfers, transaction history, and identity verification.

The app is built with a modern architecture using **MVVM** pattern, **RxSwift** for reactive programming, and **Coordinator** pattern for navigation management. 

### Key Features

- 🔐 **Secure Authentication** - PIN-based authentication with biometric support (Face ID/Touch ID)
- 💳 **Card Management** - Add, manage, and control debit/credit cards
- 💰 **Digital Wallet** - Multi-currency account management with real-time balance updates
- 📤 **Payments & Transfers** - Send money via card, phone number, or account
- 📊 **Transaction History** - Detailed history with advanced filtering options
- 🎫 **QR Code Payments** - Scan and pay with QR codes
- 🎯 **Cashback & Showcase** - View promotional offers and cashback deals
- 👤 **User Profile** - Complete profile management with KYC/identity verification
- 🔔 **Push Notifications** - Real-time transaction and account notifications
- 🌐 **Multi-language Support** - English, Russian, and Tajik localization
- 🎨 **Theme Support** - Light and dark mode with customizable themes

---

## 🏗️ Architecture

### Project Structure

```
barakat-digit-ios/
├── BarakatWallet/                 # Main iOS application
│   ├── AppDelegate.swift          # Application lifecycle
│   ├── AppCoordinator.swift       # Main app coordinator
│   ├── Constants.swift            # App-wide constants and configuration
│   │
│   ├── Modules/                   # Feature modules (MVVM)
│   │   ├── Cards/                 # Card management
│   │   ├── History/               # Transaction history
│   │   ├── Home/                  # Main dashboard
│   │   ├── Identify/              # KYC/Identity verification
│   │   ├── Login/                 # User authentication
│   │   ├── NotifiyView/           # Notifications
│   │   ├── Passcode/              # PIN/Biometric auth
│   │   ├── Payments/              # Payment services
│   │   ├── Profile/               # User profile
│   │   ├── QR/                    # QR code scanning
│   │   ├── RatesAndConvertor/     # Currency rates
│   │   ├── Root/                  # Root navigation
│   │   ├── Showcase/              # Promotional content
│   │   ├── StoriesView/           # Stories feature
│   │   └── Transfer/              # Money transfers
│   │
│   ├── Models/                    # Data models
│   ├── Network/                   # API layer and networking
│   ├── Shared/                    # Shared utilities and components
│   │   ├── Coordinators/          # Navigation coordinators
│   │   ├── Extensions/            # Swift extensions
│   │   ├── Helpers/               # Helper utilities
│   │   └── Views/                 # Reusable UI components
│   │
│   ├── Assets. xcassets/           # Images and assets
│   ├── Fonts/                     # Montserrat font family
│   ├── en.lproj/                  # English localization
│   ├── ru.lproj/                  # Russian localization
│   ├── tg.lproj/                  # Tajik localization
│   └── Info.plist                 # App configuration
│
├── core-ledger/                   # Backend ledger service (Go)
│   ├── api/                       # gRPC proto definitions
│   ├── cmd/core-ledger/           # Service entrypoint
│   ├── internal/ledger/           # Core ledger implementation
│   ├── db/migrations/             # Database migrations
│   ├── docker-compose.yml         # Docker configuration
│   └── README.md                  # Ledger documentation
│
└── docs/                          # Documentation
    └── api_inventory.md           # API endpoint inventory
```

### Architecture Pattern:  MVVM + Coordinator

Each module follows the **MVVM (Model-View-ViewModel)** pattern: 

- **View** (ViewController) - Handles UI rendering and user interactions
- **ViewModel** - Business logic, data transformation, and state management
- **Model** - Data structures and entities
- **Service** - API communication and data persistence
- **Coordinator** - Navigation and flow management

**Example: Cards Module**
```
Cards/
├── CardsViewController.swift      # View layer
├── CardsViewModel.swift           # Business logic
├── CardService.swift              # API integration
├── CardsCoordinator.swift         # Navigation
└── Views/                         # Reusable card components
```

---

## 🚀 Getting Started

### Prerequisites

- **Xcode** 14.0 or later
- **iOS** 13.0+ deployment target
- **Swift** 5.0+
- **CocoaPods** or **Swift Package Manager**

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/majorik08/barakat-digit-ios. git
   cd barakat-digit-ios
   ```

2. **Install dependencies**
   
   The project uses Swift Package Manager. Dependencies are defined in the Xcode project and include:
   - **RxSwift** - Reactive programming
   - **PhoneNumberKit** - Phone number validation
   - **KeychainSwift** - Secure storage
   - **JTAppleCalendar** - Calendar views
   - **QRCode** - QR code generation
   - **Toast** - Toast notifications
   - **Atributika** - Attributed string styling

3. **Open the project**
   ```bash
   open BarakatWallet.xcodeproj
   ```

4. **Configure constants**
   
   Update `BarakatWallet/Constants. swift` with your API configuration:
   ```swift
   static var ApiUrl:  String {
       return "https://mobile. barakatmoliya.tj/"  // Your API base URL
   }
   
   static var ApiKey: String {
       return "ios"  // Your API key
   }
   ```

5. **Build and run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

---

## 🔑 Key Technologies

### Core Frameworks
- **UIKit** - UI framework
- **RxSwift & RxCocoa** - Reactive programming and MVVM bindings
- **Keychain** - Secure credential storage
- **UserDefaults** - App preferences
- **LocalAuthentication** - Biometric authentication

### Networking
- **URLSession** - HTTP networking
- **Codable** - JSON serialization
- Custom **APIManager** - Centralized API request handling

### UI Components
- Custom gradient views and animations
- Reusable form fields and buttons
- Calendar picker with **JTAppleCalendar**
- QR code scanner with AVFoundation
- Stories carousel with animations
- Toast notifications

### Security Features
- **SSL Pinning** capability (configurable)
- **Keychain** for sensitive data
- **Biometric authentication** (Face ID/Touch ID)
- **Device key service** with ECDSA signing
- **Jailbreak detection**
- **PIN encryption**

---

## 📡 API Integration

The app communicates with a RESTful backend API.  See `docs/api_inventory.md` for a complete endpoint inventory.

### Main API Endpoints

#### Authentication
- `POST /registration` - User registration
- `POST /registration/confirm` - SMS confirmation
- `POST /registration/pin` - Set PIN
- `POST /sign` - User login
- `POST /sign/confirm` - Login confirmation

#### Accounts
- `GET /accounts/accounts` - Get user accounts
- `GET /accounts/history` - Transaction history

#### Cards
- `GET /cards/card` - Get user cards
- `POST /cards/card` - Add new card
- `PUT /cards/card` - Update card settings
- `DELETE /cards/card/{id}` - Remove card

#### Payments
- `GET /services/services` - Get payment services
- `POST /services/transaction/verify` - Verify payment
- `POST /services/transaction/send` - Execute payment

#### Profile
- `GET /clients/client` - Get user profile
- `PUT /clients/client` - Update profile
- `POST /clients/client/identification` - Submit KYC documents

### API Request Structure

All API requests include:
- **Authorization header** with JWT token
- **Device information** (device ID, OS version, app version)
- **Language preference** header

Example request:
```swift
APIManager.instance.request(
    . init(AppMethods. Payments.TransactionVerify(. init(
        account: account,
        accountType: .card,
        amount: amount,
        comment: comment,
        params: params,
        serviceID: serviceID
    ))),
    auth: . auth,
    timeOut: 20
) { response in
    // Handle response
}
```

---

## 🎨 Localization

The app supports **3 languages**: 
- 🇬🇧 **English** (`en.lproj`)
- 🇷🇺 **Russian** (`ru.lproj`)
- 🇹🇯 **Tajik** (`tg.lproj`)

Localization files: 
- `Localizable.strings` - Text translations
- `Localizable.stringsdict` - Plural rules

Usage:
```swift
let title = "WELCOME_MESSAGE". localized
```

---

## 🎨 Theming

The app supports **light and dark themes** with customizable colors. 

### Theme Configuration

```swift
// Theme.swift
Theme. configure(
    currenTheme: Constants.Theme,
    darkGlobalColor: Constants.DarkGlobalColor,
    lightGlobalColor: Constants. LighGlobalColor
)
```

### Using Themes
```swift
view.backgroundColor = Theme.current.backgroundColor
label.textColor = Theme.current. textColor
button.tintColor = Theme.current.tintColor
```

---

## 🔐 Security

### Authentication Flow
1. **Phone number input** → SMS code sent
2. **SMS verification** → User confirmed
3. **PIN setup** (4 digits) → Encrypted and stored
4. **Biometric setup** (optional) → Face ID/Touch ID
5. **Token received** → Stored in Keychain

### Data Protection
- **Keychain** - Stores PIN, tokens, and biometric data
- **Secure Enclave** - Hardware-backed key storage (on supported devices)
- **App Transport Security** - HTTPS enforcement
- **Blur on background** - Hides sensitive data when app is backgrounded

### Device Security
- **Jailbreak detection** via `LSApplicationQueriesSchemes`
- **Device fingerprinting** with ECDSA signing
- **Session management** with token refresh

---

## 📦 Dependencies

### Swift Packages
| Package | Version | Purpose |
|---------|---------|---------|
| RxSwift | Latest | Reactive programming |
| PhoneNumberKit | Latest | Phone validation |
| KeychainSwift | Latest | Secure storage |
| JTAppleCalendar | Latest | Calendar UI |
| QRCode | Latest | QR generation |
| Toast | Latest | Toast notifications |
| Atributika | Latest | Rich text styling |

---

## 🧪 Testing

### Manual Testing Checklist
- [ ] User registration and login
- [ ] PIN and biometric authentication
- [ ] Card addition and management
- [ ] Payment execution
- [ ] Transfer between accounts
- [ ] QR code scanning and payment
- [ ] Transaction history filtering
- [ ] Profile editing
- [ ] KYC document upload
- [ ] Language switching
- [ ] Theme switching
- [ ] Push notification handling

---

## 🐛 Known Issues & Limitations

1. **Simulator limitations**
   - Biometric authentication not available
   - Secure Enclave not available
   - Push notifications require physical device

2. **API dependencies**
   - Requires active backend at `mobile.barakatmoliya. tj`
   - Some features depend on specific API versions

3. **Localization**
   - Some strings may still be hardcoded
   - Tajik translations may need review

---

## 🛠️ Core Ledger Service

The repository includes a **Go-based ledger service** in the `core-ledger/` directory.

### Features
- **gRPC API** for ledger operations
- **PostgreSQL** database
- **Docker Compose** setup
- **Database migrations**

### Quick Start
```bash
cd core-ledger
docker-compose up -d
go run ./cmd/core-ledger
```

See `core-ledger/README.md` for detailed documentation.

---

## 📝 Code Style

### Swift Conventions
- **Naming**: PascalCase for types, camelCase for variables/functions
- **Indentation**: 4 spaces
- **Line length**: 120 characters max
- **Comments**: Use `//` for single-line, `/* */` for multi-line

### File Organization
```swift
// 1. Imports
import UIKit
import RxSwift

// 2. Class/Protocol declaration
class MyViewController: BaseViewController {
    
    // 3. IBOutlets and UI properties
    private let titleLabel = UILabel()
    
    // 4. Data properties
    var viewModel: MyViewModel! 
    
    // 5. Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 6. Setup methods
    private func setupUI() { }
    
    // 7. Action handlers
    @objc private func handleTap() { }
}
```

---

## 🤝 Contributing

This is a private repository. For contributions: 
1. Create a feature branch
2. Follow the existing code style
3. Add appropriate comments
4. Test thoroughly
5. Submit a pull request

---

## 📄 License

This project is proprietary software. All rights reserved.

---

## 👥 Team & Support

**Developer**: km1tj  
**Organization**: Barakat Moliya  
**Support**: +992 987 010 395

### Useful Links
- App Store: [Download on App Store](https://itunes.apple.com/app/id6476505592)
- Privacy Policy:  Configured in app
- Terms of Service:  Configured in app

---

## 📊 Project Statistics

- **Language**: Swift (99.8%), Go (0.2%)
- **Lines of Code**: ~186,000 (Swift)
- **Files**: 200+ Swift files
- **Modules**: 15 feature modules
- **UI Components**: 50+ custom views
- **API Endpoints**: 70+ endpoints
- **Supported iOS**: 13.0+

---

## 🗺️ Roadmap

### Completed ✅
- [x] User authentication with biometrics
- [x] Card management
- [x] Payment services
- [x] Transaction history
- [x] QR code payments
- [x] Multi-language support
- [x] Theme support
- [x] Push notifications
- [x] KYC/Identity verification

### In Progress 🚧
- [ ] Complete API integration
- [ ] Enhanced error handling
- [ ] Offline mode support
- [ ] Unit test coverage
- [ ] UI/UX improvements

### Planned 📋
- [ ] Apple Pay integration
- [ ] Widgets support
- [ ] Watch app
- [ ] iPad optimization
- [ ] Advanced analytics

---

## 📞 Contact

For questions, issues, or support:
- **Phone**: +992 987 010 395
- **Email**: Via app support section
- **Issues**: Use GitHub Issues for bug reports

---

<div align="center">

**Built with ❤️ for Barakat Moliya**

[Download on App Store](https://itunes.apple.com/app/id6476505592) | [Privacy Policy](https://mobile.barakatmoliya. tj/)

</div>
