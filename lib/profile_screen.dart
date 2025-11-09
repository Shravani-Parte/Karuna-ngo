import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models.dart'; // Import Donation and mockDonationHistory
import 'home_content.dart'; // Import SectionHeader
import 'services/firestore_service.dart';

// --- PROFILE PAGE (Stateful, Editable, with Donor ID/Bio) ---

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  // User data from Firestore
  UserModel? _userData;
  List<Donation> _donations = mockDonationHistory; // Use static mock data
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userDoc = await _firestoreService.getUser(currentUserId);
      _userData = UserModel.fromFirestore(userDoc);
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_userData == null) {
      return const Scaffold(
        body: Center(child: Text('Failed to load profile data')),
      );
    }

    final int totalDonations = _donations.where((d) => d.status.contains('Completed')).length;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person_rounded, size: 60, color: Colors.teal),
                  ),
                  const SizedBox(height: 12),
                  Text(_userData!.name ?? 'Donor', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('Donor ID: ${currentUserId.substring(0, 8).toUpperCase()}', style: TextStyle(color: Colors.teal.shade100, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('Total Impact: $totalDonations Donations', style: TextStyle(color: Colors.teal.shade100, fontSize: 16)),
                  const SizedBox(height: 12),
                  // Edit Button
                  TextButton.icon(
                    icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                    label: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      final updatedData = await Navigator.pushNamed(context, '/profileEdit', arguments: {
                        'name': _userData!.name ?? '',
                        'contact': _userData!.contact ?? '',
                        'bio': _userData!.bio ?? '',
                      }) as Map<String, String>?;

                      if (updatedData != null) {
                        await _firestoreService.updateUser(currentUserId, {
                          'name': updatedData['name'],
                          'contact': updatedData['contact'],
                          'bio': updatedData['bio'],
                        });
                        _loadUserData(); // Reload data
                      }
                    },
                  )
                ],
              ),
            ),

            // Core Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(title: 'Contact & Bio'),
                  _ProfileDetailTile(icon: Icons.mail, label: 'Email', value: _userData!.email),
                  _ProfileDetailTile(icon: Icons.phone, label: 'Contact', value: _userData!.contact ?? 'Not provided'),
                  _ProfileDetailTile(icon: Icons.info_outline, label: 'Bio', value: _userData!.bio ?? 'No bio added yet'),
                  const Divider(height: 30),

                  // Donation History
                  const SectionHeader(title: 'Donation Activity'),
                  DefaultTabController(
                    length: 3,
                    initialIndex: 0,
                    child: Column(
                      children: [
                        const TabBar(
                          labelColor: Colors.teal,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.teal,
                          tabs: [
                            Tab(text: 'All Posts'),
                            Tab(text: 'Ongoing'),
                            Tab(text: 'History'),
                          ],
                        ),
                        SizedBox(
                          height: 300,
                          child: TabBarView(
                            children: [
                              // All Posts/Activity
                              _ActivityList(donations: _donations),
                              // Currently Ongoing Posts/Pledges
                              _ActivityList(
                                  donations: _donations.where((d) => d.status.contains('Ongoing') || d.status == 'pending').toList()),
                              // Donation History
                              _ActivityList(
                                  donations: _donations.where((d) => d.status.contains('Completed')).toList()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper for Profile Details
class _ProfileDetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileDetailTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Expanded( 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper for Donation Activity List
class _ActivityList extends StatelessWidget {
  final List<Donation> donations;
  const _ActivityList({required this.donations});

  @override
  Widget build(BuildContext context) {
    if (donations.isEmpty) {
      return const Center(child: Text('No activity found for this section.', style: TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      itemCount: donations.length,
      itemBuilder: (context, index) {
        final d = donations[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: d.status.contains('Completed') ? Colors.teal : Colors.deepOrange,
            child: Icon(d.status.contains('Completed') ? Icons.check : Icons.delivery_dining, color: Colors.white),
          ),
          title: Text('${d.item} to ${d.ngoName}'),
          subtitle: Text(d.date),
          trailing: Text(d.status.split('(').first.trim(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: d.status.contains('Completed') ? Colors.green.shade700 : Colors.deepOrange)),
        );
      },
    );
  }
}