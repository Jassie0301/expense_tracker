import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;
  final int index;
  final String currency;

  const EditExpenseScreen({Key? key, required this.expense, required this.index, required this.currency}) : super(key: key);

  @override
  _EditExpenseScreenState createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.title);
    _amountController = TextEditingController(text: widget.expense.amount.toString());
    _selectedDate = widget.expense.date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount (${widget.currency})'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
                Spacer(),
                TextButton(
                  onPressed: () async {
                    final selected = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selected != null) {
                      setState(() {
                        _selectedDate = selected;
                      });
                    }
                  },
                  child: Text('Select Date'),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                final expenseBox = Hive.box<Expense>('expenses');
                final updatedExpense = Expense(
                  title: _titleController.text,
                  amount: double.parse(_amountController.text),
                  date: _selectedDate,
                );
                expenseBox.putAt(widget.index, updatedExpense);
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}