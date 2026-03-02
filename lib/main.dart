import 'package:flutter/material.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00897B)),
        useMaterial3: true,
      ),
      home: const ExpensesHomePage(),
    );
  }
}

// ── HOME PAGE ──────────────────────────────────────────────────
class ExpensesHomePage extends StatefulWidget {
  const ExpensesHomePage({super.key});
  @override
  State<ExpensesHomePage> createState() => _ExpensesHomePageState();
}

class _ExpensesHomePageState extends State<ExpensesHomePage> {
  final List<String> _expenses = [];

  Future<void> _goToAddExpense() async {
    final title = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const AddExpensePage()),
    );
    if (title != null && title.isNotEmpty) {
      setState(() => _expenses.add(title));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added: $title'),
            backgroundColor: const Color(0xFF00897B),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _deleteExpense(int index) {
    final removed = _expenses[index];
    setState(() => _expenses.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"$removed" deleted'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () => setState(() => _expenses.insert(index, removed)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F2F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00897B),
        title: const Text(
          'Expense Tracker',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _goToAddExpense,
          ),
        ],
      ),
      body: _expenses.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.savings_outlined,
                    size: 80,
                    color: Colors.teal.shade200,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No expenses yet.',
                    style: TextStyle(color: Colors.teal.shade300, fontSize: 16),
                  ),
                  Text(
                    'Tap + Add to get started.',
                    style: TextStyle(color: Colors.teal.shade300, fontSize: 14),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF00897B),
                      child: Text(
                        _expenses[index][0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      _expenses[index],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => _deleteExpense(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToAddExpense,
        backgroundColor: const Color(0xFF00897B),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Expense', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// ── ADD EXPENSE PAGE ───────────────────────────────────────────
class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});
  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  void _save() {
    final title = _controller.text.trim();
    if (title.isEmpty) {
      setState(() => _errorText = 'Expense title cannot be empty.');
      return;
    }
    Navigator.pop(context, title); // ← returns data to Home
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F2F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00897B),
        title: const Text(
          'Add Expense',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Expense title',
                labelStyle: const TextStyle(color: Color(0xFF00897B)),
                errorText: _errorText,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF00897B),
                    width: 2,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.receipt_long,
                  color: Color(0xFF00897B),
                ),
              ),
              onChanged: (_) {
                if (_errorText != null) setState(() => _errorText = null);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00897B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
