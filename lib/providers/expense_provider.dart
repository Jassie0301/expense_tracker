import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';

final expenseProvider = StateNotifierProvider<ExpenseNotifier, List<Expense>>((ref) {
  final box = Hive.box<Expense>('expenses');
  return ExpenseNotifier(box);
});

class ExpenseNotifier extends StateNotifier<List<Expense>> {
  final Box<Expense> _box;

  ExpenseNotifier(this._box) : super(_box.values.toList());

  void addExpense(Expense expense) {
    _box.add(expense);
    state = _box.values.toList();
  }

  void removeExpense(int index) {
    _box.deleteAt(index);
    state = _box.values.toList();
  }

  void editExpense(int index, Expense updatedExpense) {
    _box.putAt(index, updatedExpense);
    state = _box.values.toList();
  }
}
