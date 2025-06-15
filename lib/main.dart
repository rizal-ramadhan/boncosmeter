import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Selector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CurrencySelectionScreen(),
    );
  }
}

class Currency {
  final String code;
  final String name;
  final String flag;

  Currency({required this.code, required this.name, required this.flag});
}

class CurrencySelectionScreen extends StatefulWidget {
  const CurrencySelectionScreen({super.key});

  @override
  State<CurrencySelectionScreen> createState() =>
      _CurrencySelectionScreenState();
}

class _CurrencySelectionScreenState extends State<CurrencySelectionScreen> {
  String _selectedCurrencyCode = 'USD';

  final List<Currency> currencies = [
    Currency(code: 'EUR', name: 'Euro', flag: '🇪🇺'),
    Currency(code: 'USD', name: 'US Dollar', flag: '🇺🇸'),
    Currency(code: 'CAD', name: 'Canadian Dollar', flag: '🇨🇦'),
    Currency(code: 'AUD', name: 'Australian Dollar', flag: '🇦🇺'),
    Currency(code: 'CHF', name: 'Swiss Franc', flag: '🇨🇭'),
    Currency(code: 'MXN', name: 'Mexican Peso', flag: '🇲🇽'),
    Currency(code: 'RUB', name: 'Russian Ruble', flag: '🇷🇺'),
    Currency(code: 'INR', name: 'Indian Rupee', flag: '🇮🇳'),
    Currency(code: 'BRL', name: 'Brazilian Real', flag: '🇧🇷'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text('Currency', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                final currency = currencies[index];
                return ListTile(
                  leading: Text(
                    currency.flag,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text('${currency.code}   ${currency.name}'),
                  trailing: _selectedCurrencyCode == currency.code
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedCurrencyCode = currency.code;
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Simpan pilihan mata uang di sini
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Currency ${_selectedCurrencyCode} saved successfully.'),
                    ),
                  );
                },
                icon: const Icon(Icons.check),
                label: const Text('SAVE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
