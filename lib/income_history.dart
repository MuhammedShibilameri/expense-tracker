import 'package:flutter/material.dart';
import 'package:flutter_application_1/income.dart';
import 'package:flutter_application_1/service.dart';

class IncomeHistoryPage extends StatefulWidget {
  @override
  _IncomeHistoryPageState createState() => _IncomeHistoryPageState();
}

class _IncomeHistoryPageState extends State<IncomeHistoryPage> {
  List<Map<String, String>> incomes = [];

  @override
  void initState() {
    super.initState();
    loadIncomes();
  }

  Future<void> loadIncomes() async {
    setState(() {
      incomes = HiveService.getIncomes().reversed.toList();
    });
  }

  Future<void> saveIncomes() async {
    await HiveService.saveIncomes(incomes.reversed.toList());
  }

  void addIncome() async {
    final newIncome = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddIncomePage()),
    );

    if (newIncome != null) {
      setState(() {
        incomes.insert(0, Map<String, String>.from(newIncome));
      });
      await saveIncomes();
    }
  }

  void editIncome(int index) async {
    final updatedIncome = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddIncomePage(existingIncome: incomes[index]),
      ),
    );

    if (updatedIncome != null) {
      setState(() {
        incomes[index] = Map<String, String>.from(updatedIncome);
      });
      await saveIncomes();
    }
  }

  void deleteIncome(int index) async {
    setState(() {
      incomes.removeAt(index);
    });
    await saveIncomes();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Income deleted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Income History")),
      body: incomes.isEmpty
          ? Center(child: Text("No incomes yet"))
          : ListView.builder(
              itemCount: incomes.length,
              itemBuilder: (context, index) {
                final inc = incomes[index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.attach_money, color: Colors.green),
                    title: Text("${inc['amount']} - ${inc['source']}"),
                    subtitle: Text("${inc['date']}\n${inc['note']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => editIncome(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteIncome(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addIncome,
      ),
    );
  }
}