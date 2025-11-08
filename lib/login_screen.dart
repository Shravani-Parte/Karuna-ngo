import 'package:flutter/material.dart';

// --- LOGIN SCREEN (For Donor or NGO Login based on navigation) ---

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _userType;
  late String _title;
  late String _route;
  late String _message;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    _userType = args['userType']!;
    if (_userType == 'donor') {
      _title = 'Donor Login';
      _route = '/donorHome';
      _message = 'Donor logged in successfully!';
    } else {
      _title = 'NGO Login';
      _route = '/ngoHome';
      _message = 'NGO logged in successfully!';
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_message)),
      );
      // Navigate to respective Home
      Navigator.pushNamedAndRemoveUntil(context, _route, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildTextField(context, 'Email Address', Icons.mail, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 15),
              _buildTextField(context, 'Password', Icons.lock, isPassword: true),
              const SizedBox(height: 20),
              _buildLoginButton(context, 'Login', _submitForm),
            ],
          ),
        ),
      ),
    );
  }

// --- GLOBAL HELPER WIDGETS ---

InputDecoration _inputDecoration(BuildContext context, String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: Theme.of(context).primaryColor.withOpacity(0.7)),
    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
  );
}

Widget _buildTextField(BuildContext context, String label, IconData icon, {TextInputType keyboardType = TextInputType.text, bool isPassword = false}) {
  return TextFormField(
    keyboardType: keyboardType,
    obscureText: isPassword,
    decoration: _inputDecoration(context, label, icon),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your $label';
      }
      return null;
    },
  );
}

Widget _buildLoginButton(BuildContext context, String label, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).primaryColor,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
    ),
    child: Text(label, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
  );
}
}
