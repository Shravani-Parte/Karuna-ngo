import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'models.dart';

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
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();

  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Create user with Firebase Auth
        final userCredential = await _authService.signUp(
          _emailController.text.trim(),
          _passwordController.text,
        );

        // Add user data to Firestore
        await _firestoreService.addUser(userCredential.user!.uid, {
          'email': _emailController.text.trim(),
          'userType': 'donor',
          'name': _nameController.text.trim(),
          'contact': _contactController.text.trim(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Donor account created! Please log in.')),
          );
          // Navigate to Donor Login
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false, arguments: {'userType': 'donor'});
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
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
            _buildTextField(context, 'Full Name', Icons.person, controller: _nameController),
            const SizedBox(height: 15),
            _buildTextField(context, 'Email Address', Icons.mail, keyboardType: TextInputType.emailAddress, controller: _emailController),
            const SizedBox(height: 15),
            _buildTextField(context, 'Contact Number', Icons.phone, keyboardType: TextInputType.phone, controller: _contactController),
            const SizedBox(height: 15),
            _buildPasswordField(context, 'Password', _passwordController),
            const SizedBox(height: 15),
            _buildPasswordField(context, 'Confirm Password', _confirmPasswordController, isConfirm: true, compareController: _passwordController),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : _buildSignUpButton(context, 'Register as Donor', _submitForm),
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

  final _ngoNameController = TextEditingController();
  final _registrationIdController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  bool _isLoading = false;

  @override
  void dispose() {
    _ngoNameController.dispose();
    _registrationIdController.dispose();
    _contactPersonController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Create user with Firebase Auth
        final userCredential = await _authService.signUp(
          _emailController.text.trim(),
          _passwordController.text,
        );

        // Add NGO data to Firestore
        final ngoDocRef = await _firestoreService.addNgo({
          'name': _ngoNameController.text.trim(),
          'registrationId': _registrationIdController.text.trim(),
          'category': _selectedCategory,
          'contactPerson': _contactPersonController.text.trim(),
          'email': _emailController.text.trim(),
          'area': _locationController.text.trim(),
          'need': '', // Will be updated later
          'rating': 0.0,
          'imageUrl': 'https://placehold.co/600x400/228B22/ffffff?text=NGO',
          'description': 'New NGO registration pending approval.',
          'status': 'pending', // For admin approval
        });

        // Add user data to Firestore, linking to the NGO document
        await _firestoreService.addUser(userCredential.user!.uid, {
          'email': _emailController.text.trim(),
          'userType': 'ngo',
          'name': _contactPersonController.text.trim(),
          'contact': '',
          'ngoId': ngoDocRef.id, // Link to the NGO document ID
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('NGO registration submitted for approval! Please log in.')),
          );
          // Navigate to NGO Login
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false, arguments: {'userType': 'ngo'});
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
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
            _buildTextField(context, 'NGO/Organization Name', Icons.business, controller: _ngoNameController),
            const SizedBox(height: 15),
            _buildTextField(context, 'Registration ID / Number', Icons.credit_card, controller: _registrationIdController),
            const SizedBox(height: 15),
            _buildDropdownField(context),
            const SizedBox(height: 15),
            _buildTextField(context, 'Contact Person Name', Icons.person_outline, controller: _contactPersonController),
            const SizedBox(height: 15),
            _buildTextField(context, 'NGO Email (for communications)', Icons.mail, keyboardType: TextInputType.emailAddress, controller: _emailController),
            const SizedBox(height: 15),
            _buildTextField(context, 'Location (City, State)', Icons.location_on, controller: _locationController),
            const SizedBox(height: 15),
            _buildPasswordField(context, 'Password', _passwordController),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : _buildSignUpButton(context, 'Register as NGO', _submitForm),
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

Widget _buildTextField(BuildContext context, String label, IconData icon, {TextInputType keyboardType = TextInputType.text, bool isPassword = false, TextEditingController? controller}) {
  return TextFormField(
    controller: controller,
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