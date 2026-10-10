// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/add.dart';

// import 'package:shared_preferences/shared_preferences.dart';


// class HistoryPage extends StatefulWidget {
//   @override
//   _HistoryPageState createState() => _HistoryPageState();
// }

// class _HistoryPageState extends State<HistoryPage> {
//   List<Map<String, String>> expenses = [];

//   @override
//   void initState() {
//     super.initState();
//     loadExpenses();
//   }

// Future<void> loadExpenses() async {
//   final prefs = await SharedPreferences.getInstance();
//   List<String> expenseStrings = prefs.getStringList('expenses') ?? [];
//   setState(() {
//     expenses = expenseStrings
//         .map((e) => Map<String, String>.from(jsonDecode(e)))
//         .toList();
//   });
// }
//   Future<void> saveExpenses() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> expenseStrings = expenses.map((e) => jsonEncode(e)).toList();
//     await prefs.setStringList('expenses', expenseStrings);
//   }

//   void deleteExpense(int index) async {
//     setState(() {
//       expenses.removeAt(index);
//     });
//     await saveExpenses();
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text('Expense deleted')));
//   }

//   void editExpense(int index) async {
//     final updatedExpense = await Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => AddExpensePage(existingExpense: expenses[index]),
//       ),
//     );

//     if (updatedExpense != null) {
//       setState(() {
//         expenses[index] = Map<String, String>.from(updatedExpense);
//       });
//       await saveExpenses();
//     }
//   }

//   void addExpense() async {
//     final newExpense = await Navigator.of(
//       context,
//     ).push(MaterialPageRoute(builder: (context) => AddExpensePage()));

//     if (newExpense != null) {
//       setState(() {
//         expenses.insert(0, Map<String, String>.from(newExpense));
//       });
//       await saveExpenses();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Expense History")),
//       body: expenses.isEmpty
//           ? Center(child: Text("No expenses yet"))
//           : ListView.builder(
//               itemCount: expenses.length,
//               itemBuilder: (context, index) {
//                 final exp = expenses[index];
//                 return Card(
//                   child: ListTile(
//                     leading: Icon(Icons.attach_money, color: Colors.green),
//                     title: Text("${exp['amount']} - ${exp['category']}"),
//                     subtitle: Text("${exp['date']}\n${exp['note']}"),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.edit, color: Colors.blue),
//                           onPressed: () => editExpense(index),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.delete, color: Colors.red),
//                           onPressed: () => deleteExpense(index),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: addExpense,
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_application_1/add.dart';
import 'package:flutter_application_1/service.dart';


class ExpenseHistoryPage extends StatefulWidget {
  const ExpenseHistoryPage({super.key});

  @override
  _ExpenseHistoryPageState createState() => _ExpenseHistoryPageState();
}

class _ExpenseHistoryPageState extends State<ExpenseHistoryPage> {
  List<Map<String, String>> expenses = [];

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    setState(() {
      expenses = HiveService.getExpenses().reversed.toList();
    });
  }

  Future<void> deleteExpense(int index) async {
    setState(() {
      expenses.removeAt(index);
    });
    await HiveService.saveExpenses(expenses.reversed.toList());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense deleted')),
      );
    }
  }

  void editExpense(int index) async {
    final updatedExpense = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddExpensePage(existingExpense: expenses[index]),
      ),
    );
    if (updatedExpense != null) {
      setState(() {
        expenses[index] = Map<String, String>.from(updatedExpense);
      });
      await HiveService.saveExpenses(expenses.reversed.toList());
    }
    loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Expense History")),
      body: expenses.isEmpty
          ? const Center(child: Text("No expenses yet"))
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final exp = expenses[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.money_off, color: Colors.red),
                    title: Text("${exp['amount']} - ${exp['category']}"),
                    subtitle: Text("${exp['date']}\n${exp['note']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => editExpense(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteExpense(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newExpense = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddExpensePage()),
          );
          if (newExpense != null) {
            setState(() {
              expenses.insert(0, Map<String, String>.from(newExpense));
            });
            await HiveService.saveExpenses(expenses.reversed.toList());
          }
        },
      ),
    );
  }
} 