import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_expense_screen.dart';
import 'screens/edit_expense_screen.dart';
import 'screens/expense_list_screen.dart';
import 'screens/expense_analysis_screen.dart';
import 'models/expense.dart';
import 'models/user.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<Expense>('expenses');
  await Hive.openBox<User>('users');
  await Hive.openBox('settings'); // New box for settings
  runApp(ProviderScope(child: ExpenseTrackerApp()));
}

class ExpenseTrackerApp extends StatefulWidget {
  const ExpenseTrackerApp({super.key});

  @override
  _ExpenseTrackerAppState createState() => _ExpenseTrackerAppState();
}


class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  late Box settingsBox;
  ThemeMode _themeMode = ThemeMode.system;
  late String _currency;



  @override
  void initState() {
    super.initState();
    settingsBox = Hive.box('settings');
    _themeMode = ThemeMode.values[settingsBox.get('themeMode', defaultValue: ThemeMode.system.index)];
    _currency = settingsBox.get('currency', defaultValue: 'USD');
  }

  void updateTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
      settingsBox.put('themeMode', mode.index);
    });
  }

  void updateCurrency(String currency) {
    setState(() {
      _currency = currency;
      settingsBox.put('currency', currency);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(updateTheme: updateTheme, updateCurrency: updateCurrency, currency: _currency),
        '/add': (context) => AddExpenseScreen(currency: _currency),
        '/edit': (context) => EditExpenseScreen(
              expense: Expense(title: '', amount: 0.0, date: DateTime.now()),
              index: 0,
              currency: _currency,
            ),
        '/list': (context) => ExpenseListScreen(currency: _currency),
        '/analysis': (context) => ExpenseAnalysisScreen(currency: _currency),
      },
    );
  }
}
