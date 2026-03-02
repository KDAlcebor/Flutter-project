import 'package:flutter/material.dart';

void main() {
  runApp(const ExpenseApp());
}

// ─── App ─────────────────────────────────────────────────────────────────────

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF39FF14),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        useMaterial3: true,
      ),
      home: const ExpenseListScreen(),
    );
  }
}

// ─── Model ────────────────────────────────────────────────────────────────────

class Expense {
  String id;
  String title;
  double amount;

  Expense({required this.id, required this.title, required this.amount});
}

// ─── Screen 1: Expense List ───────────────────────────────────────────────────

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  // ✅ FOR LOOP: generates initial expense list from raw data
  final List<Map<String, dynamic>> _seedData = [
    {'title': 'Groceries', 'amount': 85.50},
    {'title': 'Electric Bill', 'amount': 120.00},
    {'title': 'Netflix Subscription', 'amount': 15.99},
    {'title': 'Gym Membership', 'amount': 45.00},
    {'title': 'Internet Bill', 'amount': 59.99},
    {'title': 'Coffee Shop', 'amount': 12.50},
    {'title': 'Gas', 'amount': 70.00},
  ];

  late List<Expense> _expenses;

  @override
  void initState() {
    super.initState();
    // ✅ FOR LOOP populating the expenses list
    _expenses = [];
    for (int i = 0; i < _seedData.length; i++) {
      _expenses.add(
        Expense(
          id: (i + 1).toString(),
          title: _seedData[i]['title'],
          amount: _seedData[i]['amount'],
        ),
      );
    }
  }

  double get _total => _expenses.fold(0, (sum, e) => sum + e.amount);

  Future<void> _openAddScreen() async {
    final result = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditExpenseScreen()),
    );
    if (result != null) setState(() => _expenses.add(result));
  }

  Future<void> _openEditScreen(int index) async {
    final result = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditExpenseScreen(existing: _expenses[index]),
      ),
    );
    if (result != null) {
      setState(() {
        _expenses[index] = Expense(
          id: result.id,
          title: result.title,
          amount: result.amount,
        );
      });
    }
  }

  void _deleteExpense(int index) {
    final removed = _expenses[index];
    setState(() => _expenses.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1A1A1A),
        content: Text(
          '"${removed.title}" deleted',
          style: const TextStyle(color: Color(0xFF39FF14)),
        ),
        action: SnackBarAction(
          label: 'Undo',
          textColor: const Color(0xFF39FF14),
          onPressed: () => setState(() => _expenses.insert(index, removed)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        title: const Text(
          'My Expenses',
          style: TextStyle(
            color: Color(0xFF39FF14),
            fontWeight: FontWeight.bold,
            fontSize: 22,
            shadows: [Shadow(color: Color(0xFF39FF14), blurRadius: 10)],
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF39FF14)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF39FF14)),
            tooltip: 'Add Expense',
            onPressed: _openAddScreen,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFF39FF14), height: 1),
        ),
      ),
      body: Column(
        children: [
          // ── Total Banner ───────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF111111),
              border: Border(
                bottom: BorderSide(color: Color(0xFF39FF14), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Expenses',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFAAAAAA),
                  ),
                ),
                Text(
                  '\$${_total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF39FF14),
                    shadows: [Shadow(color: Color(0xFF39FF14), blurRadius: 12)],
                  ),
                ),
              ],
            ),
          ),

          // ── Count Badge ────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            color: const Color(0xFF0D0D0D),
            child: Text(
              '${_expenses.length} expense${_expenses.length == 1 ? '' : 's'} loaded via for loop',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF39FF14),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          // ── Expense List ───────────────────────────────────────────────
          Expanded(
            child: _expenses.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: Color(0xFF2A2A2A),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No expenses yet',
                          style: TextStyle(color: Color(0xFF444444)),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _expenses.length,
                    itemBuilder: (context, index) => _ExpenseTile(
                      key: ValueKey(_expenses[index].id),
                      expense: _expenses[index],
                      index: index,
                      onEdit: () => _openEditScreen(index),
                      onDelete: () => _deleteExpense(index),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddScreen,
        backgroundColor: const Color(0xFF39FF14),
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Expense',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// ─── Expense Tile ─────────────────────────────────────────────────────────────

class _ExpenseTile extends StatelessWidget {
  final Expense expense;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ExpenseTile({
    super.key,
    required this.expense,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF39FF14).withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF39FF14).withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // ── Index Badge ──────────────────────────────────────────────
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF39FF14).withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Color(0xFF39FF14),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // ── Icon ─────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF39FF14).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.receipt,
                color: Color(0xFF39FF14),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // ── Title & Amount ────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${expense.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF39FF14),
                      shadows: [
                        Shadow(color: Color(0xFF39FF14), blurRadius: 6),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Edit Button ───────────────────────────────────────────────
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Color(0xFF39FF14)),
              tooltip: 'Edit',
              onPressed: onEdit,
            ),

            // ── Delete Button ─────────────────────────────────────────────
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Color(0xFFFF4444)),
              tooltip: 'Delete',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Screen 2: Add / Edit ─────────────────────────────────────────────────────

class AddEditExpenseScreen extends StatefulWidget {
  final Expense? existing;

  const AddEditExpenseScreen({super.key, this.existing});

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.existing?.title ?? '',
    );
    _amountController = TextEditingController(
      text: widget.existing != null
          ? widget.existing!.amount.toStringAsFixed(2)
          : '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final result = Expense(
      id:
          widget.existing?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
    );

    Navigator.pop(context, result);
  }

  void _cancel() => Navigator.pop(context, null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        iconTheme: const IconThemeData(color: Color(0xFF39FF14)),
        title: Text(
          _isEditing ? 'Edit Expense' : 'Add Expense',
          style: const TextStyle(
            color: Color(0xFF39FF14),
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Color(0xFF39FF14), blurRadius: 10)],
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF39FF14)),
          onPressed: _cancel,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFF39FF14), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEditing ? 'Update expense details' : 'Enter expense details',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF39FF14),
                ),
              ),
              const SizedBox(height: 24),

              // ── Title ─────────────────────────────────────────────────
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: const TextStyle(color: Color(0xFF39FF14)),
                  hintText: 'e.g. Groceries',
                  hintStyle: const TextStyle(color: Color(0xFF444444)),
                  prefixIcon: const Icon(Icons.title, color: Color(0xFF39FF14)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF39FF14),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF39FF14),
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFFF4444)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFFF4444),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF111111),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title cannot be empty';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ── Amount ────────────────────────────────────────────────
              TextFormField(
                controller: _amountController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: const TextStyle(color: Color(0xFF39FF14)),
                  hintText: '0.00',
                  hintStyle: const TextStyle(color: Color(0xFF444444)),
                  prefixIcon: const Icon(
                    Icons.attach_money,
                    color: Color(0xFF39FF14),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF39FF14),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF39FF14),
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFFF4444)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFFF4444),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF111111),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Amount cannot be empty';
                  }
                  final parsed = double.tryParse(value.trim());
                  if (parsed == null) return 'Enter a valid number';
                  if (parsed <= 0) return 'Amount must be greater than 0';
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // ── Save ──────────────────────────────────────────────────
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check, color: Colors.black),
                label: Text(
                  _isEditing ? 'Save Changes' : 'Add Expense',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF39FF14),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: const Color(0xFF39FF14),
                  elevation: 8,
                ),
              ),

              const SizedBox(height: 12),

              // ── Cancel ────────────────────────────────────────────────
              OutlinedButton.icon(
                onPressed: _cancel,
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Color(0xFF39FF14),
                ),
                label: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF39FF14)),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF39FF14)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
