import 'package:flutter/material.dart';

class AddExpensePage extends StatefulWidget {
  final Map<String, String>? existingExpense;

  const AddExpensePage({super.key, this.existingExpense});

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  late TextEditingController amountController;
  late TextEditingController noteController;
  late TextEditingController dateController;
  String selectedCategory = "Food";

  final List<Map<String, dynamic>> categories = [
    {"title": "Food", "icon": Icons.fastfood, "color": Colors.green},
    {"title": "Travel", "icon": Icons.directions_car, "color": Colors.blue},
    {"title": "Bills", "icon": Icons.receipt_long, "color": Colors.orange},
    {"title": "Shopping", "icon": Icons.shopping_bag, "color": Colors.purple},
    {"title": "Others", "icon": Icons.category, "color": Colors.red},
  ];

  @override
  void initState() {
    super.initState();
    amountController =
        TextEditingController(text: widget.existingExpense?['amount'] ?? '');
    noteController =
        TextEditingController(text: widget.existingExpense?['note'] ?? '');
    dateController =
        TextEditingController(text: widget.existingExpense?['date'] ?? '');
    selectedCategory = widget.existingExpense?['category'] ?? 'Food';
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingExpense != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Expense" : "Add Expense"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputContainer(
                context: context,
                controller: amountController,
                label: "Amount",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Text("Category",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: categories.map((cat) {
                  final isSelected = cat['title'] == selectedCategory;
                  return ChoiceChip(
                    avatar: Icon(cat['icon'] as IconData,
                        size: 18,
                        color: isSelected ? Colors.white : cat['color'] as Color),
                    label: Text(cat['title']),
                    selected: isSelected,
                    selectedColor: cat['color'] as Color,
                    backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    labelStyle: TextStyle(
                      color:
                          isSelected ? Colors.white : (isDark ? Colors.white : Colors.black),
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) {
                      setState(() => selectedCategory = cat['title']);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              _buildDateInputContainer(
                context: context,
                controller: dateController,
                label: "Date",
              ),
              const SizedBox(height: 16),
              _buildInputContainer(
                context: context,
                controller: noteController,
                label: "Note",
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final expense = {
                      'amount': amountController.text,
                      'category': selectedCategory,
                      'date': dateController.text,
                      'note': noteController.text,
                      'type': 'expense',
                    };
                    Navigator.pop(context, expense);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: Text(
                    isEditing ? "Save Changes" : "Save Expense",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputContainer({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          filled: true,
          fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        ),
      ),
    );
  }

  Widget _buildDateInputContainer({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          filled: true,
          fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                String formattedDate =
                    "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
                setState(() {
                  controller.text = formattedDate;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}