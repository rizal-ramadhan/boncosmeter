import 'package:flutter/material.dart';
import 'database_helper.dart';

class EditTransactionScreen extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const EditTransactionScreen({super.key, required this.transaction});

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String? _selectedType;
  String? _selectedTag;
  DateTime? _selectedDate;

  final String selectedCurrencySymbol = 'Rp ';

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.transaction['title'];
    _amountController.text = widget.transaction['amount'].toString();
    _selectedDate = DateTime.tryParse(widget.transaction['date'] ?? '');
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _updateTransaction() async {
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final date = _selectedDate?.toIso8601String().split('T').first ?? '';

    if (title.isEmpty || amount <= 0 || date.isEmpty) return;

    final updatedTx = {
      'id': widget.transaction['id'],
      'title': title,
      'amount': amount,
      'date': date,
    };

    await DatabaseHelper.instance.updateTransaction(updatedTx);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Berhasil'),
        content: const Text('Transaksi berhasil diperbarui.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // dialog
              Navigator.pop(context, true); // screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Edit Transaction',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: selectedCurrencySymbol,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              items: const [
                DropdownMenuItem(value: 'Income', child: Text('Income')),
                DropdownMenuItem(value: 'Expense', child: Text('Expense')),
              ],
              onChanged: (value) => setState(() => _selectedType = value),
              decoration: const InputDecoration(
                labelText: 'Transaction type',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedTag,
              items: const [
                DropdownMenuItem(value: 'Food', child: Text('Food')),
                DropdownMenuItem(value: 'Transport', child: Text('Transport')),
                DropdownMenuItem(value: 'Shopping', child: Text('Shopping')),
                DropdownMenuItem(value: 'Housing', child: Text('Housing')),
                DropdownMenuItem(value: 'Utilities', child: Text('Utilities')),
                DropdownMenuItem(value: 'Insurance', child: Text('Insurance')),
                DropdownMenuItem(value: 'Healthcare', child: Text('Healthcare')),
                DropdownMenuItem(value: 'Saving & Debts', child: Text('Saving & Debts')),
                DropdownMenuItem(value: 'Personal Spending', child: Text('Personal Spending')),
                DropdownMenuItem(value: 'Entertaintment', child: Text('Entertaintment')),
                DropdownMenuItem(value: 'Miscellaneous', child: Text('Miscellaneous')),
              ],
              onChanged: (value) => setState(() => _selectedTag = value),
              decoration: const InputDecoration(
                labelText: 'Tags',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              readOnly: true,
              controller: TextEditingController(
                text: _selectedDate == null
                    ? ''
                    : '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
              ),
              onTap: _pickDate,
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _updateTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'EDIT TRANSACTION',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
