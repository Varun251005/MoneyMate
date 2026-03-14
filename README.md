# MoneyMate - Personal Finance Tracker

A modern Flutter application for comprehensive personal finance management, transaction tracking, EMI monitoring, and financial analytics with PDF report generation.

![MoneyMate](assets/images/moneymate.png)

## 📱 About MoneyMate

MoneyMate is a feature-rich personal finance management application built with Flutter. It helps users track their income and expenses, manage EMI/bill payments, monitor spending patterns, and generate detailed financial reports.

### Key Features

- ✅ **Transaction Management**
  - Record income and expense transactions
  - Categorize transactions (Food, Travel, Shopping, Bills, Salary, Other)
  - Add detailed notes for each transaction
  - Track transactions by date

- ✅ **EMI/Bills Tracking**
  - Create and manage EMI payment schedules
  - Track bill due dates
  - Automatic payment reminders (one day before due date)
  - View total EMI obligations

- ✅ **Financial Dashboard**
  - Real-time balance calculation
  - Total income and expense summary
  - Visual transaction history
  - Category-wise expense breakdown

- ✅ **Reports & Analytics**
  - Generate PDF financial reports
  - Visual charts and graphs (using fl_chart)
  - Category-wise spending analysis
  - Period-wise financial summaries

- ✅ **Theme Support**
  - Dark mode and light mode
  - Persistent theme preference
  - Beautiful gradient UI components

- ✅ **Local Database**
  - Offline-first architecture using SQLite
  - Secure local data storage
  - No cloud dependency

- ✅ **Additional Features**
  - Refresh indicator on main screens
  - Gesture-based navigation
  - Responsive design for all screen sizes
  - Notification system for payment reminders

## 🛠️ Tech Stack

### Frontend
- **Flutter 3.11+** - UI Framework
- **Material Design 3** - Design system
- **Dart** - Programming language

### Database & Storage
- **SQLite** (sqflite) - Local database
- **Shared Preferences** - User preferences storage

### Libraries & Dependencies
- **path** - File path handling
- **intl** - Date/time formatting
- **fl_chart** - Charts and graphs
- **flutter_local_notifications** - Push notifications
- **pdf** - PDF generation
- **printing** - Print service integration
- **image_picker** - Image selection
- **sqflite** - SQLite database access

## 📋 Prerequisites

- Flutter SDK 3.11.1 or higher
- Dart SDK (comes with Flutter)
- Android SDK (API level 31+) for Android builds
- Xcode 14+ for iOS builds
- Git

## 🚀 Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/MoneyMate.git
cd MoneyMate
```

### 2. Get Dependencies
```bash
flutter pub get
```

### 3. Run on Development Device/Emulator

**For Android Emulator:**
```bash
flutter run
```

**For iOS Simulator:**
```bash
open -a Simulator
flutter run -d all
```

**For Physical Device:**
```bash
flutter run
```

## 📦 Building for Production

### Build APK (Android)
```bash
# Debug APK
flutter build apk --debug

# Release APK (optimized)
flutter build apk --release
```

**Output**: `build/app/outputs/flutter-apk/app-release.apk`

### Build AAB (Google Play)
```bash
flutter build appbundle --release
```

**Output**: `build/app/outputs/bundle/release/app-release.aab`

### Build for iOS
```bash
flutter build ios --release
```

## 📁 Project Structure

```
MoneyMate/
├── lib/
│   ├── main.dart              # Entry point
│   ├── database/
│   │   └── database_helper.dart   # SQLite operations
│   ├── models/
│   │   ├── transaction_model.dart
│   │   └── emi_model.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── home_screen.dart
│   │   ├── add_transaction_screen.dart
│   │   ├── emi_screen.dart
│   │   ├── add_emi_screen.dart
│   │   ├── report_screen.dart
│   │   ├── settings_screen.dart
│   │   └── main_screen.dart
│   ├── services/
│   │   ├── notification_service.dart
│   │   └── pdf_service.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── widgets/
│       ├── transaction_card.dart
│       └── category_card.dart
├── assets/
│   └── images/
│       ├── moneymate.png
│       └── moneymate1.png
├── pubspec.yaml
└── README.md
```

## 💾 Database Schema

### Transactions Table
```sql
CREATE TABLE transactions(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  type TEXT,           -- 'income' or 'expense'
  amount REAL,
  category TEXT,
  note TEXT,
  date TEXT            -- YYYY-MM-DD format
)
```

### EMI Table
```sql
CREATE TABLE emi(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT,
  amount REAL,
  date TEXT            -- Next payment due date
)
```

## 🔐 Android Permissions

The following permissions are required (automatically added to AndroidManifest.xml):
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.INTERNET" />
```

## 🐛 Troubleshooting

### Database Not Saving
- Ensure `WidgetsFlutterBinding.ensureInitialized()` is called in main()
- Check that `/app/build.gradle.kts` has proper Java version compatibility
- Verify Android permissions are added to AndroidManifest.xml

### Notifications Not Working
- Enable notification permissions in app settings
- Check that NotificationService is properly initialized
- For Android 13+, runtime permissions are required

### PDF Export Issues
- Ensure external storage permissions are granted
- Check device has sufficient free storage
- Verify pdf and printing packages are properly installed

### Build Failures
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub upgrade
flutter build apk --release
```

## 🚁 Deployment

### Google Play Store
1. Build AAB: `flutter build appbundle --release`
2. Sign the bundle with a keystore
3. Upload to Google Play Console
4. Set up app details, pricing, and release strategy

### Firebase Distribution (Testing)
1. Build APK: `flutter build apk --release`
2. Use Firebase App Distribution to share with testers

## 📊 App Configuration

### Theme Customization
Edit `lib/theme/app_theme.dart` to change colors and styling.

### Database Configuration
Modify database version and upgrade logic in `lib/database/database_helper.dart`

### Notification Settings
Configure notification timing in `lib/services/notification_service.dart`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Developer

Created as a modern financial management solution for personal use and learning.

## 📞 Support

For issues, feature requests, or questions:
- Open an issue on GitHub
- Check existing documentation

## 🎯 Future Enhancements

- [ ] Cloud backup with Firebase
- [ ] Budget planning features
- [ ] Recurring transaction automation
- [ ] Multi-currency support
- [ ] Data export to CSV/Excel
- [ ] Bill payment integration
- [ ] Investment tracking
- [ ] Financial goals management
- [ ] Advanced analytics dashboard
- [ ] Multi-user support

## 📈 Version History

**v1.0.0** (Current)
- Initial release
- Transaction management
- EMI tracking
- PDF report generation
- Dark/Light theme support
- All core features implemented

---

**Happy Budgeting with MoneyMate! 💰**

