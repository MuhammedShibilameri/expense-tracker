import 'package:hive/hive.dart';

class HiveService {
  static final box = Hive.box('expenseBox');

  // ── Expenses ──
  static List<Map<String, String>> getExpenses() {
    final raw = box.get('expenses', defaultValue: []);
    return (raw as List).map((e) => Map<String, String>.from(e)).toList();
  }

  static Future<void> saveExpenses(List<Map<String, String>> expenses) async {
    await box.put('expenses', expenses);
  }

  static Future<void> addExpense(Map<String, String> expense) async {
    final expenses = getExpenses();
    expenses.add(expense);
    await saveExpenses(expenses);
  }

  static Future<void> deleteExpense(int index) async {
    final expenses = getExpenses();
    if (index >= 0 && index < expenses.length) {
      expenses.removeAt(index);
      await saveExpenses(expenses);
    }
  }

  // ── Incomes ──
  static List<Map<String, String>> getIncomes() {
    final raw = box.get('incomes', defaultValue: []);
    return (raw as List).map((e) => Map<String, String>.from(e)).toList();
  }

  static Future<void> saveIncomes(List<Map<String, String>> incomes) async {
    await box.put('incomes', incomes);
  }

  static Future<void> addIncome(Map<String, String> income) async {
    final incomes = getIncomes();
    incomes.add(income);
    await saveIncomes(incomes);
  }

  static Future<void> deleteIncome(int index) async {
    final incomes = getIncomes();
    if (index >= 0 && index < incomes.length) {
      incomes.removeAt(index);
      await saveIncomes(incomes);
    }
  }

  // ── User (signup/login) ──
  static String getString(String key, {String defaultValue = ''}) {
    return box.get(key, defaultValue: defaultValue);
  }

  static Future<void> setString(String key, String value) async {
    await box.put(key, value);
  }

  static bool getBool(String key) {
    final value = box.get(key, defaultValue: false);
    return value is bool ? value : false;
  }

  static Future<void> setBool(String key, bool value) async {
    await box.put(key, value);
  }

  // ── Dark mode ──
  static bool getDarkMode() {
    return box.get('darkMode', defaultValue: false);
  }

  static Future<void> setDarkMode(bool value) async {
    await box.put('darkMode', value);
  }

  // ── Delete expense by matching fields (for category detail page) ──
  static Future<void> deleteExpenseByFields(Map<String, String> txn) async {
    final expenses = getExpenses();
    expenses.removeWhere((e) =>
        e['amount'] == txn['amount'] &&
        e['note'] == txn['note'] &&
        e['date'] == txn['date'] &&
        e['category'] == txn['category']);
    await saveExpenses(expenses);
  }
}