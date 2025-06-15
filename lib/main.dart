import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edit Profile',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const EditProfileScreen(),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String selectedCurrency = 'USD';

  final List<Map<String, String>> currencies = [
    {'code': 'EUR', 'name': 'Euro'},
    {'code': 'USD', 'name': 'US Dollar'},
    {'code': 'CAD', 'name': 'Canadian Dollar'},
    {'code': 'AUD', 'name': 'Australian Dollar'},
    {'code': 'CHF', 'name': 'Swiss Franc'},
    {'code': 'MXN', 'name': 'Mexican Peso'},
    {'code': 'RUB', 'name': 'Russian Ruble'},
    {'code': 'INR', 'name': 'Indian Rupee'},
    {'code': 'BRL', 'name': 'Brazilian Real'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text('Edit Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Enter your name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter your name' : null,
                onSaved: (value) => name = value!,
              ),
              const SizedBox(height: 20),
              const Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Enter your email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) => email = value!,
              ),
              const SizedBox(height: 20),
              const Text("Currency", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: selectedCurrency,
                items: currencies
                    .map((currency) => DropdownMenuItem<String>(
                          value: currency['code'],
                          child: Text('${currency['code']} - ${currency['name']}'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCurrency = value!;
                  });
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Profile updated!')),
                      );
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("SAVE"),
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
            ],
          ),
        ),
      ),
    );
  }
}
