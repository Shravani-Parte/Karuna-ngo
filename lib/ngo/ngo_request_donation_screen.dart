import 'package:flutter/material.dart';
import '../models.dart'; // Import Ngo model

// --- NGO REQUEST DONATION SCREEN (Form to Request New Donations) ---

class NgoRequestDonationScreen extends StatefulWidget {
  final VoidCallback? onRedirectToDashboard;
  const NgoRequestDonationScreen({super.key, this.onRedirectToDashboard});

  @override
  State<NgoRequestDonationScreen> createState() => _NgoRequestDonationScreenState();
}

class _NgoRequestDonationScreenState extends State<NgoRequestDonationScreen> {
  final TextEditingController itemController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    itemController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create a new donation request for your NGO',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const Divider(height: 30),
            
            // Item Name
            TextField(
              controller: itemController,
              decoration: const InputDecoration(
                labelText: 'Item Name (e.g., Rice, Books, Blankets)',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
            const SizedBox(height: 15),
            
            // Quantity
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Required Quantity (e.g., 50 kg, 100 units)',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
            const SizedBox(height: 15),

            // Description / Purpose
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description or Purpose (e.g., for orphanage food drive)',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
            const SizedBox(height: 30),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                if (itemController.text.isEmpty || quantityController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all required fields.')),
                  );
                  return;
                }

                // Mock submission - data not saved to DB
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Request posted')),
                );

                // Redirect to dashboard screen (set index to 0 in NgoHomeScreen)
                widget.onRedirectToDashboard?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Submit Request',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
