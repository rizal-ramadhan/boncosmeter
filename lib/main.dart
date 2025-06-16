import 'package:flutter/material.dart';
import 'addtransaction.dart';
import 'edittransaction.dart';
import 'database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Transaksi',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final data = await DatabaseHelper.instance.getAllTransactions();
    setState(() {
      _transactions = data;
    });
  }

  void _navigateToAddTransaction() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddTransactionScreen()),
    );
    if (result == true) _loadTransactions();
  }

  void _navigateToEditTransaction(Map<String, dynamic> transaction) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditTransactionScreen(transaction: transaction), // ✅ ini bagian yang diganti
      ),
    );
    if (result == true) _loadTransactions();
  }

  void _deleteTransaction(int id) async {
    await DatabaseHelper.instance.deleteTransaction(id);
    _loadTransactions();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transaksi berhasil dihapus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Transaksi'),
      ),
      body: _transactions.isEmpty
          ? Center(child: Text('Belum ada transaksi'))
          : ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final tx = _transactions[index];
                return ListTile(
                  title: Text(tx['title']),
                  subtitle: Text('Rp ${tx['amount'].toStringAsFixed(0)}\n${tx['date']}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => _navigateToEditTransaction(tx),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTransaction(tx['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTransaction,
        child: Icon(Icons.add),
      ),
    );
  }
}
