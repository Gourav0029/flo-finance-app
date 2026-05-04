# Flo Finance — Personal Finance Companion

> *"Your money, your sanctuary."*

A premium personal finance companion app built with Flutter, designed to help everyday users understand their spending habits, set meaningful goals, and receive intelligent financial guidance — all from the privacy of their own device, protected by enterprise-grade security.

---

## 📱 Demo & Repository

| Resource | Link |
|---|---|
| GitHub Repository | https://github.com/Gourav0029/flo-finance-app |
| Built by | Gourav Kumar Jha |
| Framework | Flutter (Dart) |
| Platform | Android & iOS |

---

## 🧠 The Product Thinking Behind Flo

Most personal finance apps feel like spreadsheets disguised as mobile apps — cold, transactional, and anxiety-inducing. I wanted to build something different.

The design philosophy behind Flo is what I called the **"Financial Sanctuary"** — a space where users feel calm and in control of their money, not overwhelmed by it. Every design decision was made through this lens:

- **No aggressive red alerts** for spending — we use soft, informative tones
- **No cluttered dashboards** — every element earns its place on screen
- **No cold data dumps** — information is presented with context and meaning
- **Privacy first** — all data lives locally on the user's device, encrypted with AES-256
- **Security by default** — biometric lock, hardware-backed key storage, zero cloud exposure

The result is an app that feels personal, structured, genuinely pleasant to use every single day, and trustworthy with your most sensitive financial information.

---

## ✨ Features

### 👋 Onboarding
- One-time personalised welcome screen on first launch
- User enters their name (required) and profile picture (optional)
- **Biometric lock setup** — if the device supports fingerprint or face unlock, the user is asked during onboarding whether they want to enable it
- If no picture is selected, a coloured avatar with the user's initial is shown
- All profile data saved to encrypted Hive storage permanently
- Never shown again after first setup

### 🔐 Security

**Biometric Lock:**
- Fingerprint and Face ID support via `local_auth`
- Lock screen appears on every cold app launch when enabled
- Beautiful lock screen with Flo logo, mint green fingerprint icon, and "Tap to unlock" prompt
- Automatic biometric prompt on screen load
- "Try again" button on authentication failure
- PIN fallback automatically handled by the OS
- Toggle on/off from the onboarding screen and Settings page anytime
- Only shown if the device actually supports biometrics

**Hive AES-256 Encryption:**
- All local data encrypted at rest using AES-256 cipher
- Encryption key generated using `Hive.generateSecureKey()`
- Key stored in `flutter_secure_storage` which uses Android Keystore / iOS Keychain — hardware-backed secure enclave
- Key is never stored in plain text, shared preferences, or app code
- All five Hive boxes encrypted: transactions, user profile, settings, challenges, goals
- Data is permanently deleted when the app is uninstalled — key is destroyed with it

### 🏠 Home Dashboard
The first thing a user sees every morning. Designed to give a complete financial snapshot in under 5 seconds.

- **Personalised greeting** based on time of day ("Good morning, Gourav 👋")
- **Profile avatar** — shows profile picture or initial, taps to Settings
- **Total balance card** with deep navy premium design
- **Income and Expense summary cards** with real-time reactive data
- **Weekly spending bar chart** showing the last 7 days at a glance
- **Recent Transactions** section with last 3 entries and a "View All" shortcut
- Reactive — updates instantly when any transaction is added, edited, or deleted

### 💳 Transaction Tracking
The core of the app. Designed to make data entry as frictionless as possible.

- **Add transactions** via a beautiful bottom sheet with:
  - Income / Expense toggle
  - Amount input with ₹ formatting
  - Category picker (Food, Transport, Shopping, Bills, Entertainment, Health, Other)
  - Date picker (defaults to today)
  - Notes/description field
- **Full CRUD** — view, edit (long press), and delete (swipe left with confirmation dialog)
- **Real-time search** — filters transactions as you type
- **Category filter chips** — All, Food, Transport, Utilities
- **Empty states** — friendly prompts when no transactions exist
- All amounts formatted in Indian number system (₹1,24,500 not ₹124500)

### 🎯 Goals & Challenges
The feature that makes Flo feel like more than just a tracker. This is where habit-building happens.

- **No-Spend Streak** — automatically counts consecutive days with zero expense transactions. Resets the moment an expense is logged. A 🔥 flame card makes it feel rewarding to maintain.
- **Savings Goal** — set a target amount (e.g. ₹1,00,000 for a trip). Saved amount calculated dynamically from real income minus expenses — never hardcoded.
- **Challenge System** — create custom spending challenges:
  - Name your challenge (e.g. "No Zomato for 7 days")
  - Set a category and budget limit
  - Choose a duration (7, 14, 30 days or custom)
  - Status auto-calculates as ACTIVE, COMPLETED, or FAILED from real transaction data
  - Live progress bar for active challenges showing amount spent vs limit
  - Swipe to delete completed challenges
- **Active Challenge Summary** — shows the most urgent active challenge with a live progress bar
- **Challenge History** — full list of all past challenges with ACTIVE/COMPLETED/FAILED badges

### 📊 Insights
Not just charts — actionable intelligence about your money patterns.

- **Portfolio Analytics header** with total monthly spending
- **Category Breakdown** — top 5 spending categories with horizontal progress bars and category icons
- **Most Frequent** card — the category you transact in most often with transaction count
- **Week Comparison** card — deep navy card showing % change vs last week with directional arrow
- **Top Spending** highlight — biggest expense category with mint green accent border
- **6-Month Trend** bar chart — spending pattern across the last 6 months
- **Wealth Momentum** banner — tells you at a glance whether finances are growing or need attention
- All insights update reactively when transactions change — computed off the UI thread using Dart's `compute()`

### 🤖 AI Spending Coach
The feature that sets Flo apart from every other finance tracker.

- Powered by **Google Gemini 2.5 Flash**
- Accessible via a ✨ floating action button on every screen
- Sends **aggregated category totals** to the AI — not raw transaction data — for privacy
- Context-aware — the AI knows your actual spending, income, and balance
- Responds with personalised, actionable financial guidance in plain language
- Beautiful chat UI with user and AI message bubbles
- "Flo is thinking..." typing indicator while waiting for response
- Graceful error handling for network failures

### ⚙️ Settings
- **Edit profile** — change name, take a new photo, choose from gallery, or remove photo
- **Profile picture options** — camera capture, gallery selection, or remove, via a clean action bottom sheet
- **Dark / Light mode toggle** — persists across app restarts via encrypted Hive
- **Biometric lock toggle** — enable or disable at any time (only shown if device supports it)
- **Export transactions** — generates a CSV of all transactions via the OS share sheet
- **Clear all data** — with a confirmation dialog before proceeding
- App version and attribution

### 🌙 Dark Mode
Full dark mode support across every screen including the AI Coach, Settings, onboarding, and lock screen. The deep navy and mint green palette was designed specifically to look stunning in dark mode. Theme preference persists in encrypted Hive storage.

### 👤 Profile Management
- Profile picture supports camera capture, gallery selection, and removal
- Initials avatar as fallback — single letter in a coloured circle
- Profile updates reflect instantly on Home screen without any manual refresh — powered by `UserProfileNotifier` watching Riverpod state
- Profile management available both on onboarding and in Settings

---

## 🏗️ Architecture & Technical Decisions

### Clean Architecture
The project follows a strict 3-layer Clean Architecture:

```
lib/
├── core/
│   ├── theme/           # AppTheme, light/dark themes, ThemeExtension
│   ├── constants/       # App-wide constants
│   ├── security/        # EncryptionService, BiometricService
│   └── utils/           # CurrencyFormatter, date helpers
├── domain/
│   ├── models/          # Transaction, UserProfile, Challenge Hive models
│   └── repositories/    # Abstract repository interfaces
├── infrastructure/
│   └── hive_transaction_repository.dart
├── application/
│   ├── transactions_list_notifier.dart
│   ├── insights_notifier.dart
│   ├── goals_notifier.dart
│   ├── challenges_notifier.dart
│   ├── ai_coach_notifier.dart
│   ├── theme_notifier.dart
│   ├── user_profile_notifier.dart
│   └── dashboard_notifier.dart
└── presentation/
    ├── home/
    ├── transactions/
    ├── goals/
    ├── insights/
    ├── settings/
    ├── onboarding/
    ├── lock/            # Biometric lock screen
    └── widgets/         # Shared reusable widgets, shimmer loading
```

### State Management — Riverpod
Every piece of state in the app is managed through Riverpod providers. UI and business logic are strictly separated — no `setState` anywhere outside pure local widget state.

Key providers and their relationships:
- `transactionsListNotifierProvider` — single source of truth for all transactions
- `insightsNotifierProvider` — watches transactions, recomputes reactively via `compute()`
- `goalsNotifierProvider` — calculates streak and savings from real transaction data
- `challengesNotifierProvider` — manages challenges with dynamic status computation
- `aiCoachNotifierProvider` — handles Gemini API state and chat message list
- `themeNotifierProvider` — persists theme preference in encrypted Hive
- `userProfileNotifierProvider` — reactive profile state, updates Home instantly on change
- `dashboardNotifierProvider` — computes weekly bar chart data asynchronously

### Local Storage — Hive (AES-256 Encrypted)
All data is stored locally on device. No internet connection required for any core feature. Five encrypted Hive boxes:

| Box | Contents | Encrypted |
|---|---|---|
| `transactionsBox` | All Transaction objects | ✅ AES-256 |
| `userProfileBox` | User name and image path | ✅ AES-256 |
| `settingsBox` | Theme mode, biometric preference | ✅ AES-256 |
| `challengesBox` | All spending challenges | ✅ AES-256 |
| `goalsBox` | Savings target amount | ✅ AES-256 |

### Security Architecture

```
App cold start
      ↓
EncryptionService.getEncryptionCipher()
      ↓
flutter_secure_storage reads key from Android Keystore
      ↓
HiveAesCipher initialized with 256-bit key
      ↓
All 5 Hive boxes opened with cipher
      ↓
Check settingsBox — biometric enabled?
   YES ↓              NO ↓
Lock screen        Home screen
      ↓
local_auth prompts fingerprint/face
      ↓
Home screen
```

### Navigation — GoRouter
Declarative routing with `StatefulShellRoute` for persistent bottom navigation. Custom redirect logic handles biometric lock on cold start only — not on every navigation. Page transitions use a custom fade + slide animation for a premium feel.

### Charts — fl_chart
All chart data computed asynchronously using Dart's `compute()` function to prevent UI thread blocking on large transaction datasets.

---

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Flutter 3.29+ | UI framework |
| Dart | Programming language |
| Riverpod 2.x | State management |
| Hive + hive_flutter | Encrypted local NoSQL database |
| GoRouter | Declarative navigation |
| fl_chart | Data visualisation |
| google_generative_ai | Gemini 2.5 Flash AI integration |
| flutter_dotenv | Secure API key management |
| flutter_secure_storage | Hardware-backed encryption key storage |
| local_auth | Biometric authentication (fingerprint/face) |
| intl | INR number formatting |
| image_picker | Camera and gallery profile pictures |
| shimmer | Loading state animations |
| share_plus | CSV transaction export |
| google_fonts | Manrope + Inter typography |
| flutter_launcher_icons | Custom app icon generation |
| path_provider | App directory access |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.29 or higher
- Dart SDK 3.x
- Android Studio or VS Code
- A physical device or emulator
- Note: Biometric lock requires a physical device with fingerprint or face unlock enrolled

### Installation

**1. Clone the repository:**
```bash
git clone https://github.com/Gourav0029/flo-finance-app.git
cd flo-finance-app
```

**2. Install dependencies:**
```bash
flutter pub get
```

**3. Generate Hive adapters and Riverpod code:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

**4. Set up environment variables:**

Create a `.env` file in the project root:
```
GEMINI_API_KEY=your_gemini_api_key_here
```

Get a free Gemini API key from: https://aistudio.google.com

**5. Run the app:**
```bash
flutter run
```

**6. Build release APK:**
```bash
flutter build apk --release --split-per-abi
```
Use `app-arm64-v8a-release.apk` for most modern Android devices.

### First Launch
On first launch you will see the onboarding welcome screen. Enter your name, optionally set a profile picture using camera or gallery, and optionally enable biometric lock. All data stored locally and encrypted. Never asked again after setup.

### Notes
- The `.env` file is listed in `.gitignore` and will never be committed to version control
- Biometric lock requires a physical device — emulators do not support biometric authentication
- All data is stored locally — no internet connection required except for the AI Coach feature
- The AES-256 encryption key is generated fresh on first install and stored in Android Keystore
- Data is permanently and irrecoverably deleted when the app is uninstalled

---

## 🔑 Key Design Decisions & Assumptions

| Decision | Rationale |
|---|---|
| Local-first with Hive | User financial data is sensitive. Keeping it on-device eliminates privacy risks and works fully offline |
| AES-256 encryption | Standard for financial data at rest. Hardware-backed key storage prevents extraction even on rooted devices |
| Biometric opt-in not forced | Security should be a choice. Users who don't need it shouldn't be slowed down by authentication on every launch |
| Riverpod over BLoC | More concise, testable, and composable for this project size. Providers watch each other — no manual event wiring needed |
| Proactive AI insights | More valuable than a chatbot — the app surfaces insights from your actual data |
| Aggregated data to AI | Raw transactions never sent to Gemini — only category totals — preserving transaction-level privacy |
| INR as currency | App designed for Indian market as per the fintech context |
| No-spend streak as core feature | Behavioural psychology shows streaks are the most effective habit-building mechanism in consumer apps |
| Single initial in avatar | Cleaner than two letters at small sizes. Standard in premium apps like Google, Notion, Linear |
| flutter_secure_storage for key | Android Keystore is hardware-backed — the encryption key cannot be extracted even with root access |
| compute() for chart data | Prevents dropped frames on large datasets by running aggregation off the UI thread |

---

## 📋 Assignment Coverage

| Requirement | Implementation |
|---|---|
| Home Dashboard with balance | ✅ Balance card, income/expense cards, weekly chart |
| Transaction CRUD | ✅ Add, view, edit (long press), delete (swipe with confirmation) |
| Filter and search | ✅ Real-time search + category filter chips |
| Goal or Challenge feature | ✅ No-spend streak + savings goal + full custom challenge system |
| Insights screen | ✅ Category breakdown, week comparison, trends, most frequent, wealth momentum |
| Smooth mobile UX | ✅ Empty states, shimmer loading, page transitions, error handling |
| Local data handling | ✅ Hive NoSQL — fully offline, AES-256 encrypted |
| State management | ✅ Riverpod throughout, Clean Architecture |
| Dark mode (optional) | ✅ Full dark mode with toggle and persistence |
| Data export (optional) | ✅ CSV export via OS share sheet |
| Profile settings (optional) | ✅ Full profile management with camera/gallery/remove |
| Biometric lock (optional) | ✅ Fingerprint/Face ID with onboarding setup and settings toggle |
| AI integration (bonus) | ✅ Gemini 2.5 Flash powered spending coach with chat UI |
| Encrypted storage (bonus) | ✅ AES-256 + Android Keystore hardware-backed key |

---

## 📸 Screens

| Screen | Description |
|---|---|
| Lock screen | Biometric authentication on cold start when enabled |
| Onboarding | One-time personalised welcome with biometric and photo setup |
| Home | Balance, income/expense summary, weekly chart, recent transactions |
| Transactions | Full list with real-time search, category filter, CRUD operations |
| Goals | No-spend streak, savings goal progress, custom challenge system |
| Insights | Category analytics, week comparison, 6-month trend, AI coach |
| Settings | Theme toggle, biometric toggle, profile edit, CSV export, data clear |

---

## 🔒 Security Notes

- All Hive data is encrypted with AES-256. Inspecting the app's data directory on an Android device reveals binary encrypted files — not readable JSON or plain text.
- The encryption key lives in Android Keystore. It cannot be extracted without the user's device lock screen credentials, even with root access.
- The Gemini API key is stored in `.env` which is bundled with the app at build time. For a production deployment this should be moved to a backend proxy server. For this assignment, the `.env` approach is appropriate and the key is never committed to version control.
- Biometric authentication uses the `local_auth` package which delegates entirely to the OS biometric stack — no biometric data ever enters the Flutter layer or is stored anywhere in the app.
- On app uninstall, both the encrypted Hive data and the Android Keystore key are deleted — there is no way to recover the data after uninstall.

---

## 🙏 Acknowledgements

This project was built as part of the Zorvyn FinTech internship assignment. The goal was not just to build a working app, but to demonstrate how a thoughtful mobile developer thinks about product experience, architecture, user trust, and security — especially in the sensitive domain of personal finance.

The "Financial Sanctuary" design philosophy was the north star throughout: every screen, every interaction, and every line of code was written with the question — *does this make the user feel more in control of, and more secure about, their money?*

---

*Built with ❤️ by Gourav Kumar Jha*