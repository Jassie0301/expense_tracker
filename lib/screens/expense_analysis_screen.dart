import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../models/expense.dart';

class ExpenseAnalysisScreen extends StatefulWidget {
  final String currency;
  const ExpenseAnalysisScreen({Key? key, required this.currency}) : super(key: key);
  @override
  _ExpenseAnalysisScreenState createState() => _ExpenseAnalysisScreenState();
}

class _ExpenseAnalysisScreenState extends State<ExpenseAnalysisScreen> {
  late Future<String> chartUrl;

  @override
  void initState() {
    super.initState();
    chartUrl = fetchChartUrl();
  }

  Future<String> fetchChartUrl() async {
    final expenseBox = Hive.box<Expense>('expenses');
    final expenses = expenseBox.values.toList();

    final Map<String, double> monthlyTotals = {};
    for (final expense in expenses) {
      final month = '${expense.date.year}-${expense.date.month.toString().padLeft(2, '0')}';
      monthlyTotals[month] = (monthlyTotals[month] ?? 0) + expense.amount;
    }

    final chartData = {
      "type": "bar",
      "data": {
        "labels": monthlyTotals.keys.toList(),
        "datasets": [
          {
            "label": "Monthly Expenses",
            "data": monthlyTotals.values.toList(),
            "backgroundColor": "#36A2EB"
          }
        ]
      }
    };

    final response = await http.post(
      Uri.parse('https://quickchart.io/chart/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"chart": chartData}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['url'];
    } else {
      throw Exception('Failed to generate chart');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Monthly Expense Analysis')),
      body: FutureBuilder<String>(
        future: chartUrl,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(
              child: Image.network(
                snapshot.data!,
                fit: BoxFit.cover,
              ),
            );
          }
        },
      ),
    );
  }
}