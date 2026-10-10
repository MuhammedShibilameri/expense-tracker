import 'package:flutter/material.dart';
import 'package:flutter_application_1/catogorydetail.dart';
import 'package:flutter_application_1/service.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final List<Map<String, dynamic>> type = [
    {"title": "Food", "icon": Icons.fastfood, "color": Colors.blue},
    {"title": "Travel", "icon": Icons.directions_car, "color": Colors.orange},
    {"title": "Bills", "icon": Icons.receipt_long, "color": Colors.purple},
    {"title": "Shopping", "icon": Icons.shopping_bag, "color": Colors.pink},
    {"title": "Others", "icon": Icons.category, "color": Colors.teal},
  ];

  Map<String, double> categoryTotals = {};

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

    setState(() {
      categoryTotals = totals;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Read brightness from theme — responds automatically to dark/light
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color scaffoldBg =
        isDark ? const Color(0xFF121212) : const Color.fromARGB(255, 240, 241, 241);
    final Color cardBg =
        isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color amountTextColor =
        isDark ? Colors.grey[300]! : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text("Categories"),
      ),
      backgroundColor: scaffoldBg, // ✅ Dark-aware background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: type.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final category = type[index];
            final String title = category["title"];
            final Color color = category["color"] as Color;
            final double totalAmount = categoryTotals[title] ?? 0;

            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        CategoryDetailPage(categoryName: title),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  // ✅ In dark mode: use solid dark card; in light: colored tint
                  color: isDark
                      ? cardBg
                      : color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  // ✅ In dark mode: add colored border so category is still visible
                  border: isDark
                      ? Border.all(color: color.withOpacity(0.6), width: 1.5)
                      : null,
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(category["icon"] as IconData,
                        size: 40, color: color),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color, // category color works in both modes
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "₹${totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 14,
                        color: amountTextColor, // ✅ Dark-aware amount text
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}