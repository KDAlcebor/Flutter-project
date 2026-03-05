# expense_app

A new Flutter project.
# note 
This project is built as a training exercise to practice Flutter list widgets. The entire app lives in a single file (lib/main.dart) and can be run immediately with flutter run. It covers three main requirements: a reusable expense item widget, a scrollable list using ListView.separated, and an empty state screen shown when there are no expenses.
You sent

The app starts with a simple Expense class that holds three fields: a title (the name of the expense), an amount (stored as a double), and a date (a plain string like "Mar 12"). Five dummy expenses are hardcoded as a constant list so the UI has data to display right away.

ExpenseItem is a stateless widget that accepts a single Expense object and renders it as a Card with a ListTile inside. The leading section shows a CircleAvatar with a category icon and a color that are both determined automatically by reading keywords in the expense title — for example, the word "grocery" maps to a green shopping cart icon, while "gym" maps to a blue fitness icon. The title of the expense is displayed in bold, the date appears below it in grey, and the amount is shown on the right side formatted as a dollar value in the matching category color.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
