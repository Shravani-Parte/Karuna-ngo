import 'package:flutter/material.dart';

// Import models for NGO categories, if needed later
// import 'models.dart'; 

// --- SIGN UP SCREEN (For Donor and NGO Registration) ---

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Account'),
          backgroundColor: Colors.white,
          foregroundColor: Theme.of(context).primaryColor,
          elevation: 1,
          bottom: const TabBar(
            labelColor: Colors.teal,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.teal,
            tabs: [
              Tab(text: 'I am a Donor', icon: Icon(Icons.person)),
              Tab(text: 'I am an NGO', icon: Icon(Icons.business)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _DonorSignUpForm(),
            _NgoSignUpForm(),
          ],
        ),
      ),
    );
  }
}

// --- 1. DONOR SIGN-UP FORM ---

class _DonorSignUpForm extends StatefulWidget {
  const _DonorSignUpForm();

  @override
  State<_DonorSignUpForm> createState() => _DonorSignUpFormState();
}

class _DonorSignUpFormState extends State<_DonorSignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Simulate account creation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donor account created! Please log in.')),
      );
      // Navigate to Donor Login
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false, arguments: {'userType': 'donor'});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _buildTextField(context, 'Full Name', Icons.person),
            const SizedBox(height: 15),
            _buildTextField(context, 'Email Address', Icons.mail, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 15),
            _buildTextField(context, 'Contact Number', Icons.phone, keyboardType: TextInputType.phone),
            const SizedBox(height: 15),
            _buildPasswordField(context, 'Password', _passwordController),
            const SizedBox(height: 15),
            _buildPasswordField(context, 'Confirm Password', TextEditingController(), isConfirm: true, compareController: _passwordController),
            const SizedBox(height: 20),
            _buildSignUpButton(context, 'Register as Donor', _submitForm),
          ],
        ),
      ),
    );
  }
}


// --- 2. NGO SIGN-UP FORM ---

class _NgoSignUpForm extends StatefulWidget {
  const _NgoSignUpForm();

  @override
  State<_NgoSignUpForm> createState() => _NgoSignUpFormState();
}

class _NgoSignUpFormState extends State<_NgoSignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  final List<String> categories = ['Education', 'Health', 'Environment', 'Animal Welfare', 'Disaster Relief', 'Other'];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Simulate NGO registration submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('NGO registration submitted for approval! Please log in.')),
      );
      // Navigate to NGO Login
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false, arguments: {'userType': 'ngo'});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _buildTextField(context, 'NGO/Organization Name', Icons.business),
            const SizedBox(height: 15),
            _buildTextField(context, 'Registration ID / Number', Icons.credit_card),
            const SizedBox(height: 15),
            _buildDropdownField(context),
            const SizedBox(height: 15),
            _buildTextField(context, 'Contact Person Name', Icons.person_outline),
            const SizedBox(height: 15),
            _buildTextField(context, 'NGO Email (for communications)', Icons.mail, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 15),
            _buildTextField(context, 'Password', Icons.lock, isPassword: true),
            const SizedBox(height: 20),
            _buildSignUpButton(context, 'Register as NGO', _submitForm),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: _inputDecoration(context, 'Primary Category', Icons.category),
      value: _selectedCategory,
      hint: const Text('Select Primary Category'),
      items: categories.map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedCategory = newValue;
        });
      },
      validator: (value) => value == null ? 'Please select a category' : null,
    );
  }
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

Widget _buildPasswordField(BuildContext context, String label, TextEditingController controller, {bool isConfirm = false, TextEditingController? compareController}) {
  return TextFormField(
    controller: controller,
    obscureText: true,
    decoration: _inputDecoration(context, label, Icons.lock),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a $label';
      }
      if (isConfirm && value != compareController!.text) {
        return 'Passwords do not match';
      }
      if (value.length < 6) {
        return 'Password must be at least 6 characters';
      }
      return null;
    },
  );
}

Widget _buildSignUpButton(BuildContext context, String label, VoidCallback onPressed) {
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