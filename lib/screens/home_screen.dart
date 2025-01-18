import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode) updateTheme;
  final Function(String) updateCurrency;
  final String currency;

  const HomeScreen({super.key, required this.updateTheme, required this.updateCurrency, required this.currency});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Expense> expenseBox;

  @override
  void initState() {
    super.initState();
    expenseBox = Hive.box<Expense>('expenses');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Expense'),
              onTap: () {
                Navigator.pushNamed(context, '/add');
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Expense List'),
              onTap: () {
                Navigator.pushNamed(context, '/list');
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Expense Analysis'),
              onTap: () {
                Navigator.pushNamed(context, '/analysis');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Settings'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButton<ThemeMode>(
                            value: ThemeMode.values[Hive.box('settings').get('themeMode', defaultValue: ThemeMode.system.index)],
                            items: ThemeMode.values.map((mode) {
                              return DropdownMenuItem(
                                value: mode,
                                child: Text(mode.toString().split('.')[1]),
                              );
                            }).toList(),
                            onChanged: (mode) {
                              widget.updateTheme(mode!);
                              Navigator.pop(context);
                            },
                          ),
                          DropdownButton<String>(
                            value: widget.currency,
                            items: ['USD', 'EUR', 'PLN'].map((currency) {
                              return DropdownMenuItem(
                                value: currency,
                                child: Text(currency),
                              );
                            }).toList(),
                            onChanged: (currency) {
                              widget.updateCurrency(currency!);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: expenseBox.listenable(),
        builder: (context, Box<Expense> box, _) {
          if (box.isEmpty) {
            return Center(child: Text('No expenses added yet!'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final expense = box.getAt(index);
              return ListTile(
                title: Text(expense!.title),
                subtitle: Text('Amount: ${widget.currency} ${expense.amount.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    Text('${expense.date.toLocal()}'.split(' ')[0]),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add'),
        child: Icon(Icons.add),
      ),
    );
  }
}
