import 'package:flutter/material.dart';

// --- NGO PROFILE EDIT SCREEN (Adapted from ProfileEditScreen) ---

class NgoProfileEditScreen extends StatefulWidget {
  const NgoProfileEditScreen({super.key});

  @override
  State<NgoProfileEditScreen> createState() => _NgoProfileEditScreenState();
}

class _NgoProfileEditScreenState extends State<NgoProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _descriptionController;
  late TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _contactController = TextEditingController();
    _descriptionController = TextEditingController();
    _websiteController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>? ?? {};
    if (_nameController.text.isEmpty) {
      _nameController.text = args['name'] ?? '';
      _contactController.text = args['contact'] ?? '';
      _descriptionController.text = args['description'] ?? '';
      _websiteController.text = args['website'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'name': _nameController.text,
        'contact': _contactController.text,
        'description': _descriptionController.text,
        'website': _websiteController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit NGO Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.business_center, size: 70, color: Colors.white),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).hintColor,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 18, color: Colors.black87),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Change logo feature not implemented.')),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _buildTextField(_nameController, 'NGO Name', Icons.business_center),
              const SizedBox(height: 15),
              _buildTextField(_contactController, 'Contact Number', Icons.phone, keyboardType: TextInputType.phone),
              const SizedBox(height: 15),
              _buildTextField(_descriptionController, 'Description/Bio (Max 200 chars)', Icons.info_outline, maxLines: 4, maxLength: 200),
              const SizedBox(height: 15),
              _buildTextField(_websiteController, 'Website', Icons.public, keyboardType: TextInputType.url),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Changes', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType keyboardType = TextInputType.text, int maxLines = 1, int? maxLength}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }
}
