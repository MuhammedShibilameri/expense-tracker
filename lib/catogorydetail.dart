

//succes 


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/add.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'add.dart';

// class CategoryDetailPage extends StatefulWidget {
//   final String categoryName;

//   const CategoryDetailPage({super.key, required this.categoryName});

//   @override
//   State<CategoryDetailPage> createState() => _CategoryDetailPageState();
// }

// class _CategoryDetailPageState extends State<CategoryDetailPage> {
//   List<Map<String, String>> transactions = [];

//   @override
//   void initState() {
//     super.initState();
//     loadTransactions();
//   }

//   Future<void> loadTransactions() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> expenseStrings = prefs.getStringList('expenses') ?? [];

//     List<Map<String, String>> allExpenses =
//         expenseStrings.map((e) => Map<String, String>.from(jsonDecode(e))).toList();

//     setState(() {
//       transactions = allExpenses
//           .where((exp) => (exp['category'] ?? 'Others') == widget.categoryName)
//           .toList()
//           .reversed
//           .toList();
//     });
//   }

//   Future<void> saveTransactions() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> expenseStrings = transactions.map((e) => jsonEncode(e)).toList();
//     await prefs.setStringList('expenses', expenseStrings);
//   }

//   void editTransaction(int index) async {
//     final updatedExpense = await Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => AddExpensePage(), // reuse AddExpensePage
//       ),
//     );

//     if (updatedExpense != null) {
//       setState(() {
//         transactions[index] = Map<String, String>.from(updatedExpense);
//       });
//       await saveTransactions();
//     }
//   }

//   void deleteTransaction(int index) async {
//     setState(() {
//       transactions.removeAt(index);
//     });
//     await saveTransactions();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Transaction deleted')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("${widget.categoryName} Transactions")),
//       body: transactions.isEmpty
//           ? Center(child: Text("No transactions in ${widget.categoryName}"))
//           : ListView.builder(
//               itemCount: transactions.length,
//               itemBuilder: (context, index) {
//                 final txn = transactions[index];
//                 return Card(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Row(
//                       children: [
//                         Icon(Icons.attach_money, color: Colors.red),
//                         SizedBox(width: 8),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("₹${txn['amount'] ?? ''}",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold, fontSize: 16)),
//                               Text("${txn['note'] ?? ''}"),
//                               Text("${txn['date'] ?? ''}",
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.grey.shade600)),
//                             ],
//                           ),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.edit, color: Colors.blue),
//                           onPressed: () => editTransaction(index),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.delete, color: Colors.red),
//                           onPressed: () => deleteTransaction(index),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_application_1/add.dart';
import 'package:flutter_application_1/service.dart';

class CategoryDetailPage extends StatefulWidget {
  final String categoryName;

  const CategoryDetailPage({super.key, required this.categoryName});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  List<Map<String, String>> transactions = [];

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    List<Map<String, String>> allExpenses = HiveService.getExpenses();

    setState(() {
      transactions = allExpenses
          .where((exp) => (exp['category'] ?? 'Others') == widget.categoryName)
          .toList()
          .reversed
          .toList();
    });
  }

  Future<void> deleteTransaction(Map<String, String> txn) async {
    await HiveService.deleteExpenseByFields(txn);
    await loadTransactions();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction deleted')),
      );
    }
  }

  void editTransaction(Map<String, String> txn) async {
    final updatedExpense = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddExpensePage(existingExpense: txn),
      ),
    );

    if (updatedExpense != null) {
      await loadTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.categoryName} Transactions")),
      body: transactions.isEmpty
          ? Center(child: Text("No transactions in ${widget.categoryName}"))
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final txn = transactions[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.attach_money, color: Colors.red),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("₹${txn['amount'] ?? ''}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16)),
                              Text("${txn['note'] ?? ''}"),
                              Text("${txn['date'] ?? ''}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => editTransaction(txn),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteTransaction(txn),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}