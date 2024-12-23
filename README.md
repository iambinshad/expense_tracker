# Expense Tracker

An **Expense Tracker** application built using **Flutter**, following the **Clean Architecture** principles, and implementing **Provider** for state management. The app enables users to track their daily expenses, manage reminders, filter and sort data, and much more. It is designed to be lightweight and user-friendly.

---

## Features

### Core Features
- **Add, Edit, and Delete Expenses**
- **Category Management:** Assign categories with custom icons for each expense.
- **Filter and Sort Expenses:** Sort by date, amount, or category.
- **Expense Summary:** View monthly or yearly summaries.

### Additional Features
- **Daily Reminder Notifications:** Get notified to log your daily expenses.
- **Currency Settings:** Support for different currencies.
- **Multi-Language Support:** Currently supports English, Khmer, and Japanese.
- **Dark Mode:** Switch between light and dark themes.
- **Biometric Authentication:** Ensure secure access to the app.

---

## Tech Stack

### **Frontend:**
- Flutter (Dart)
- Hive (Local Storage)

### **Backend:**
- Firebase (Authentication)
- Notification Service (Custom)

### **State Management:**
- Provider

### **Architecture:**
- Clean Architecture

### **Localization:**
- `flutter_localization` package

### **Other Tools:**
- Timezone support using `timezone` package
- SharedPreferences for storing user settings

---

## Project Structure
The project structure is based on Clean Architecture:

```
lib/
├── core/                    # Core utilities and services
├── data/                    # Data layer with repositories and datasources
├── domain/                  # Domain layer with entities and use cases
├── presentation/            # UI Layer (screens, widgets, providers)
├── main.dart                # Entry point of the app
```

---

## Installation

### Prerequisites
- Flutter SDK installed ([Flutter Installation Guide](https://docs.flutter.dev/get-started/install))
- Firebase configured ([Firebase Setup Guide](https://firebase.google.com/docs/flutter/setup))
- Hive Database dependencies added

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/expense-tracker.git
   ```
2. Navigate to the project directory:
   ```bash
   cd expense-tracker
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

---

## Usage

1. **Login/Register:** Use Firebase Authentication for secure access.
2. **Track Expenses:** Add your daily expenses with details like amount, category, and date.
3. **Reminders:** Set daily reminders to log your expenses.
4. **Currency Settings:** Configure your preferred currency from settings.
5. **Localization:** Switch between supported languages from the settings menu.
6. **Dark Mode:** Toggle between light and dark themes for a better user experience.

---

## Screenshots
### [Add images or screenshots here for better documentation.]

---

## Contributing
Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a new branch (`feature/your-feature-name`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/your-feature-name`).
5. Open a pull request.

---

## License
This project is licensed under the MIT License. See the LICENSE file for details.

---

## Acknowledgements
- Flutter team for the amazing framework.
- Contributors for improving and enhancing the app.

