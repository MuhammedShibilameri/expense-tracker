import 'package:flutter/material.dart';

class AddIncomePage extends StatefulWidget {
  final Map<String, String>? existingIncome;

  const AddIncomePage({super.key, this.existingIncome});

  @override
  _AddIncomePageState createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  late TextEditingController amountController;
  late TextEditingController sourceController;
  late TextEditingController noteController;
  late TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    amountController =
        TextEditingController(text: widget.existingIncome?['amount'] ?? '');
    sourceController =
        TextEditingController(text: widget.existingIncome?['source'] ?? '');
    noteController =
        TextEditingController(text: widget.existingIncome?['note'] ?? '');
    dateController =
        TextEditingController(text: widget.existingIncome?['date'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingIncome != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit Income" : "Add Income")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputContainer(
              context: context,
              controller: amountController,
              label: "Amount",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            _buildInputContainer(
              context: context,
              controller: sourceController,
              label: "Source",
            ),
            const SizedBox(height: 12),
            _buildInputContainer(
              context: context,
              controller: noteController,
              label: "Note",
            ),
            const SizedBox(height: 12),
            _buildDateInputContainer(
              context: context,
              controller: dateController,
              label: "Date",
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final income = {
                  'amount': amountController.text,
                  'source': sourceController.text,
                  'note': noteController.text,
                  'date': dateController.text,
                  'type': 'income',
                };
                Navigator.pop(context, income);
              },
              child: Text(isEditing ? "Save Changes" : "Add Income"),
            ),
          ],
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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