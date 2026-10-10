import 'package:flutter/material.dart';

import 'package:flutter_application_1/service.dart';
import 'package:fl_chart/fl_chart.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  Map<String, double> categoryTotals = {
    "Food": 0,
    "Travel": 0,
    "Bills": 0,
    "Shopping": 0,
    "Others": 0,
  };

  double totalExpense = 0;

  @override
  void initState() {
    super.initState();
    loadCategoryTotals();
  }

  Future<void> loadCategoryTotals() async {
    List<Map<String, String>> allExpenses = HiveService.getExpenses();

    Map<String, double> totals = {
      "Food": 0,
      "Travel": 0,
      "Bills": 0,
      "Shopping": 0,
      "Others": 0,
    };

    for (var exp in allExpenses) {
      String category = exp['category'] ?? 'Others';
      double amount = double.tryParse(exp['amount'] ?? '0') ?? 0;

      if (totals.containsKey(category)) {
        totals[category] = totals[category]! + amount;
      } else {
        totals["Others"] = totals["Others"]! + amount;
      }
    }

    double sum = totals.values.fold(0, (a, b) => a + b);

    setState(() {
      categoryTotals = totals;
      totalExpense = sum;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF121212) : const Color(0xFFF0F1F1);
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      appBar: AppBar(title: const Text('  Reports')),
      backgroundColor: scaffoldBg,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Monthly Summary",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 30),

              SizedBox(
                height: 250,
                child: ExpensePieChart(
                  categoryTotals: categoryTotals,
                  totalExpense: totalExpense,
                ),
              ),

              SizedBox(height: 30),

              ExpenseLegend(
                categoryTotals: categoryTotals,
                totalExpense: totalExpense,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------- PIE CHART ----------------
class ExpensePieChart extends StatelessWidget {
  final Map<String, double> categoryTotals;
  final double totalExpense;

  const ExpensePieChart({
    super.key,
    required this.categoryTotals,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    if (totalExpense == 0) {
      return Center(child: Text("No expenses yet"));
    }

    final colors = {
      "Food": Colors.green,
      "Travel": Colors.blue,
      "Bills": Colors.orange,
      "Shopping": Colors.purple,
      "Others": Colors.red,
    };

    return PieChart(
      PieChartData(
        sectionsSpace: 3,
        centerSpaceRadius: 40,
        sections: categoryTotals.entries.map((entry) {
          final percent = (entry.value / totalExpense) * 100;
          return PieChartSectionData(
            value: entry.value,
            color: colors[entry.key],
            title: "${percent.toStringAsFixed(1)}%",
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// ---------------- LEGEND ----------------
class ExpenseLegend extends StatelessWidget {
  final Map<String, double> categoryTotals;
  final double totalExpense;

  const ExpenseLegend({
    super.key,
    required this.categoryTotals,
    required this.totalExpense,
  });

  Widget buildLegendItem(Color color, String text, double percent) {
    return Row(
      children: [
        Container(
          height: 14,
          width: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 8),
        Text("$text - ${percent.toStringAsFixed(1)}%"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = {
      "Food": Colors.green,
      "Travel": Colors.blue,
      "Bills": Colors.orange,
      "Shopping": Colors.purple,
      "Others": Colors.red,
    };

    if (totalExpense == 0) {
      return Text("No data available");
    }

    return Column(
      children: categoryTotals.entries.map((entry) {
        final percent = (entry.value / totalExpense) * 100;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: buildLegendItem(colors[entry.key]!, entry.key, percent),
        );
      }).toList(),
    );
  }
}
