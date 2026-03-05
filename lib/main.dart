import 'package:flutter/material.dart';

// ─── Model ───────────────────────────────────────────────────────────────────

class Expense {
  final String title;
  final double amount;
  final String date;

  const Expense({
    required this.title,
    required this.amount,
    required this.date,
  });
}

// ─── Dummy Data ───────────────────────────────────────────────────────────────

const List<Expense> dummyExpenses = [
  Expense(title: 'Grocery Shopping', amount: 54.30, date: 'Mar 1'),
  Expense(title: 'Netflix Subscription', amount: 15.99, date: 'Mar 3'),
  Expense(title: 'Electricity Bill', amount: 112.00, date: 'Mar 7'),
  Expense(title: 'Coffee & Snacks', amount: 8.75, date: 'Mar 10'),
  Expense(title: 'Gym Membership', amount: 35.00, date: 'Mar 12'),
];

// ─── Category icon helper ─────────────────────────────────────────────────────

IconData _iconForExpense(String title) {
  final t = title.toLowerCase();
  if (t.contains('grocery') || t.contains('food')) return Icons.shopping_cart;
  if (t.contains('netflix') || t.contains('subscription')) return Icons.tv;
  if (t.contains('electricity') || t.contains('bill')) return Icons.bolt;
  if (t.contains('coffee')) return Icons.coffee;
  if (t.contains('gym') || t.contains('sport')) return Icons.fitness_center;
  return Icons.receipt_long;
}

Color _colorForExpense(String title) {
  final t = title.toLowerCase();
  if (t.contains('grocery') || t.contains('food')) return Colors.green;
  if (t.contains('netflix') || t.contains('subscription')) return Colors.red;
  if (t.contains('electricity') || t.contains('bill')) return Colors.amber;
  if (t.contains('coffee')) return Colors.brown;
  if (t.contains('gym')) return Colors.blue;
  return Colors.purple;
}

// ─── Part A: ExpenseItem Widget ───────────────────────────────────────────────

class ExpenseItem extends StatelessWidget {
  final Expense expense;

  const ExpenseItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final color = _colorForExpense(expense.title);
    final icon = _iconForExpense(expense.title);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          expense.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(
          expense.date,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
        trailing: Text(
          '\$${expense.amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
      ),
    );
  }
}

// ─── Part C: Empty State Widget ───────────────────────────────────────────────

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 72,
              color: Colors.indigo[300],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No expenses yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          // BUG FIX 1: Replaced emoji 😎 with valid height value 8
          const SizedBox(height: 8),
          Text(
            'Tap + to add one',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

// ─── Part B: ExpenseListScreen ────────────────────────────────────────────────

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  // Toggle this to test empty state ↓
  List<Expense> _expenses = List.from(dummyExpenses);

  double get _total => _expenses.fold(0, (sum, e) => sum + e.amount);

  void _toggleEmpty() {
    setState(() {
      _expenses = _expenses.isEmpty ? List.from(dummyExpenses) : [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: const Text(
          'My Expenses',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Demo toggle button
          TextButton.icon(
            onPressed: _toggleEmpty,
            icon: Icon(
              _expenses.isEmpty ? Icons.list : Icons.clear_all,
              color: Colors.white70,
              size: 18,
            ),
            label: Text(
              _expenses.isEmpty ? 'Show list' : 'Clear',
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
      body: _expenses.isEmpty
          ? const EmptyState()
          : Column(
              children: [
                // Summary banner
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3F51B5), Color(0xFF7986CB)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Spending',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${_total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Items',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_expenses.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Part B: ListView.separated ──
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
                    itemCount: _expenses.length,
                    // BUG FIX 2: Added missing first parameter name '_'
                    separatorBuilder: (_, __) => const SizedBox(height: 2),
                    itemBuilder: (context, index) {
                      return ExpenseItem(expense: _expenses[index]);
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add expense — coming soon!')),
          );
        },
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// ─── Entry Point ──────────────────────────────────────────────────────────────

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const ExpenseListScreen(),
    );
  }
}
