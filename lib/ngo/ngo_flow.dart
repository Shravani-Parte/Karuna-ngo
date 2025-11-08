import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Note: You must add the import for 'ngo_chat_screen.dart' here for compilation.
import 'ngo_chat_screen.dart';
import 'ngo_profile_edit_screen.dart';
import 'ngo_request_donation_screen.dart';
import '../models.dart';
import '../services/firestore_service.dart';



// --- MOCK NGO DATA (Future Leaders Academy is the logged-in NGO) ---
final Ngo currentNgo = Ngo(
    id: '2',
    name: 'Future Leaders Academy',
    category: 'Education',
    area: 'Delhi',
    need: 'Laptops, Notebooks',
    rating: 4.5,
    imageUrl: 'https://placehold.co/600x400/4169E1/ffffff?text=Education',
    description: 'Providing quality education and resources to children in need, preparing them to be the leaders of tomorrow.',
    contact: null,
    website: null
);

// Mock received pledges/donations for this NGO
final List<Donation> mockReceivedPledges = [
  Donation(id: '1', ngoId: '2', donorId: 'donor1', item: '10 Laptops (In-kind)', date: 'Nov 01, 2024', status: 'Pending', ngoName: 'Future Leaders Academy'),
  Donation(id: '2', ngoId: '2', donorId: 'donor1', item: '₹5000 (Monetary)', date: 'Oct 25, 2024', status: 'Received', ngoName: 'Future Leaders Academy'),
  Donation(id: '3', ngoId: '2', donorId: 'donor1', item: '50 Notebooks (In-kind)', date: 'Oct 10, 2024', status: 'Completed', ngoName: 'Future Leaders Academy'),
];


// --- NGO HOME SCREEN (The main entry for NGO users) ---

class NgoHomeScreen extends StatefulWidget {
  const NgoHomeScreen({super.key});

  @override
  State<NgoHomeScreen> createState() => _NgoHomeScreenState();
}

class _NgoHomeScreenState extends State<NgoHomeScreen> {
  int _selectedIndex = 0;

  // New list of tabs, Request Donation at index 1, Chat at index 2, Profile at index 3
  static final List<Widget> _widgetOptions = <Widget>[
    NgoDashboard(ngo: currentNgo),
    const NgoRequestDonationScreen(), // <--- NEW REQUEST DONATION SCREEN at Index 1
    const NgoRequestsScreen(), // <--- PLEDGE MANAGEMENT shifted to Index 2
    const NgoChatScreen(), // <--- CHAT shifted to Index 3
    const NgoProfileScreen(), // <--- Profile shifted to Index 4
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'NGO Dashboard';
      case 1:
        return 'Request Donations'; // <--- NEW TITLE for Request Donation
      case 2:
        return 'Pledge Management'; // <--- SHIFTED
      case 3:
        return 'Chat with Donors'; // <--- SHIFTED
      case 4:
        return 'My NGO Profile'; // <--- SHIFTED
      default:
        return 'NGO Connect';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getPageTitle()),
        backgroundColor: Colors.teal.shade700,
        elevation: 4,
        actions: [
          // Optional: Add notification button here if needed
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              // TODO: Navigate to Notification Screen
            },
          ),
        ],
      ),
      drawer: const NgoAppDrawer(),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Pledges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 8,
      ),
    );
  }
}

// --- NGO DRAWER AND SETTING TILE (Unchanged) ---

class NgoAppDrawer extends StatelessWidget {
  const NgoAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.teal.shade700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.business_center, size: 40, color: Colors.white),
                const SizedBox(height: 8),
                Text('${currentNgo.name} Options', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text(currentNgo.category, style: TextStyle(color: Colors.teal.shade100, fontSize: 14)),
              ],
            ),
          ),
          _SettingTile(
            icon: Icons.vpn_key_outlined,
            title: 'Change Password',
            onTap: () {
              Navigator.pop(context); 
              // TODO: Navigate to a change password screen
            },
          ),
          _SettingTile(
            icon: Icons.settings,
            title: 'App Settings',
            onTap: () {
              Navigator.pop(context); 
              // TODO: Navigate to an app settings screen
            },
          ),
          const Divider(),
          _SettingTile(
            icon: Icons.logout,
            title: 'Logout',
            color: Colors.red,
            onTap: () {
              // Navigate back to the WelcomeScreen and remove all routes
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}

// Helper for Drawer Tiles (reused from Donor flow)
class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const _SettingTile({required this.icon, required this.title, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black54),
      title: Text(title, style: TextStyle(color: color ?? Colors.black87)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}


// --- 1. NGO DASHBOARD ---

class NgoDashboard extends StatelessWidget {
  final Ngo ngo;
  const NgoDashboard({required this.ngo, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NgoHeader(ngo: ngo),
          const SizedBox(height: 20),

          // Quick Stats
          const Text('At a Glance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatCard(label: 'Pending Pledges', value: '1', color: Colors.orange.shade100, icon: Icons.pending_actions),
              _StatCard(label: 'Ongoing Pledges', value: '2', color: Colors.yellow.shade100, icon: Icons.hourglass_bottom),
              _StatCard(label: 'Total Completed', value: '25', color: Colors.green.shade100, icon: Icons.check_circle),
              _StatCard(label: 'Total Donors', value: '88', color: Colors.blue.shade100, icon: Icons.people),
            ],
          ),
          const SizedBox(height: 30),

          // Urgent Needs Management (Mock)
          const Text('Urgent Needs', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Divider(),
          const SizedBox(height: 10),
          _NeedUpdateCard(currentNeed: ngo.need),
          const SizedBox(height: 30),

          // Recent Activity
          const Text('Recent Pledges', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Divider(),
          const SizedBox(height: 10),
          ...mockReceivedPledges.take(2).map((pledge) => _PledgeTile(pledge: pledge)),
        ],
      ),
    );
  }
}

// Helper: NGO Header Card
class _NgoHeader extends StatelessWidget {
  final Ngo ngo;
  const _NgoHeader({required this.ngo});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ngo.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(ngo.area, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
            const SizedBox(height: 12),
            Chip(
              label: Text(ngo.category, style: const TextStyle(color: Colors.white)),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

// Helper: Quick Stat Card
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 30),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}

// Helper: Need Update Card
class _NeedUpdateCard extends StatelessWidget {
  final String currentNeed;

  const _NeedUpdateCard({required this.currentNeed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.lightbulb, color: Colors.orange, size: 30),
        title: const Text('Current Key Need', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(currentNeed, style: const TextStyle(fontSize: 15)),
      ),
    );
  }
}

// Helper: Recent Pledge Tile
class _PledgeTile extends StatelessWidget {
  final Donation pledge;
  const _PledgeTile({required this.pledge});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.volunteer_activism, color: Colors.teal.shade400),
      title: Text(pledge.item, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text('Status: ${pledge.status}'),
      trailing: Text(pledge.date, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
    );
  }
}

// --- 2. PLEDGE MANAGEMENT SCREEN ---

class NgoRequestsScreen extends StatelessWidget {
  const NgoRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: const Column(
          children: [
            TabBar(
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.teal,
              tabs: [
                Tab(text: 'Ongoing', icon: Icon(Icons.hourglass_bottom)),
                Tab(text: 'Pending', icon: Icon(Icons.pending)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _OngoingPledgesTab(),
                  _PendingPledgesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- ONGOING PLEDGES TAB ---

class _OngoingPledgesTab extends StatelessWidget {
  const _OngoingPledgesTab();

  @override
  Widget build(BuildContext context) {
    final ongoingPledges = mockReceivedPledges.where((pledge) => pledge.status == 'Received').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ongoing Pledges (${ongoingPledges.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (ongoingPledges.isEmpty)
            const Center(child: Text('No ongoing pledges.', style: TextStyle(color: Colors.grey)))
          else
            ...ongoingPledges.map((pledge) => _OngoingPledgeTile(pledge: pledge)).toList(),
        ],
      ),
    );
  }
}

// --- ONGOING PLEDGE TILE ---

class _OngoingPledgeTile extends StatelessWidget {
  final Donation pledge;
  const _OngoingPledgeTile({required this.pledge});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pledge.item,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(pledge.status, style: const TextStyle(color: Colors.white, fontSize: 12)),
                  backgroundColor: Colors.green.shade600,
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text('Pledged on: ${pledge.date}', style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Mock action to chat with donor
                  },
                  icon: const Icon(Icons.chat, size: 18, color: Colors.white),
                  label: const Text('Chat with Donor', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade500),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // Mock action to mark as complete
                  },
                  icon: const Icon(Icons.done_all, size: 18, color: Colors.black87),
                  label: const Text('Mark Complete', style: TextStyle(color: Colors.black87)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- PENDING PLEDGES TAB ---

class _PendingPledgesTab extends StatelessWidget {
  const _PendingPledgesTab();

  @override
  Widget build(BuildContext context) {
    final pendingPledges = mockReceivedPledges.where((pledge) => pledge.status == 'Pending').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pending Pledges (${pendingPledges.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (pendingPledges.isEmpty)
            const Center(child: Text('No pending pledges.', style: TextStyle(color: Colors.grey)))
          else
            ...pendingPledges.map((pledge) => _PledgeManagementTile(pledge: pledge)).toList(),
        ],
      ),
    );
  }
}

// --- PENDING PLEDGE TILE ---

class _PendingPledgeTile extends StatelessWidget {
  final Donation pledge;
  const _PendingPledgeTile({required this.pledge});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pledge.item,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(pledge.status, style: const TextStyle(color: Colors.white, fontSize: 12)),
                  backgroundColor: Colors.orange.shade600,
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text('Pledged on: ${pledge.date}', style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}

// Helper: Pledge Management Tile
class _PledgeManagementTile extends StatelessWidget {
  final Donation pledge;
  const _PledgeManagementTile({required this.pledge});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Received':
        return Colors.green.shade600;
      case 'Pending':
        return Colors.orange.shade600;
      case 'Completed':
        return Colors.blue.shade600;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pledge.item,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(pledge.status, style: const TextStyle(color: Colors.white, fontSize: 12)),
                  backgroundColor: _getStatusColor(pledge.status),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text('Pledged on: ${pledge.date}', style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}

// --- 3. NGO PROFILE SCREEN ---

class NgoProfileScreen extends StatefulWidget {
  const NgoProfileScreen({super.key});

  @override
  State<NgoProfileScreen> createState() => _NgoProfileScreenState();
}

class _NgoProfileScreenState extends State<NgoProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  // NGO data from Firestore
  Ngo? _ngoData;
  UserModel? _userData;
  List<Donation> _pledges = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNgoData();
  }

  Future<void> _loadNgoData() async {
    try {
      // Get user data first to find NGO ID
      final userDoc = await _firestoreService.getUser(currentUserId);
      _userData = UserModel.fromFirestore(userDoc);

      // Get NGO ID: for NGO users, use their uid as ngoId; for donors, use ngoId from user data
      final ngoId = _userData!.userType == 'ngo' ? currentUserId : (_userData!.ngoId ?? currentNgo.id);
      final ngoDoc = await _firestoreService.getNgo(ngoId);
      if (!ngoDoc.exists) {
        if (_userData!.userType == 'ngo') {
          // Create default NGO document for new NGO users
          await FirebaseFirestore.instance.collection('ngos').doc(ngoId).set({
            'name': 'New NGO',
            'category': 'General',
            'area': 'Location Not Set',
            'need': 'Needs Not Specified',
            'rating': 0.0,
            'imageUrl': '',
            'description': 'A dedicated non-profit organization focused on making a difference in the local community.',
            'contact': _userData!.contact,
            'website': null,
            'ngoId': _userData!.ngoId,
          });
          // Fetch the newly created document
          final newNgoDoc = await _firestoreService.getNgo(ngoId);
          _ngoData = Ngo.fromFirestore(newNgoDoc);
        } else {
          // For donors, if NGO doesn't exist, show error
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('NGO profile not found. Please contact support.')),
          );
          return;
        }
      } else {
        _ngoData = Ngo.fromFirestore(ngoDoc);
      }

      // Fetch pledges for this NGO
      final pledgesStream = _firestoreService.getDonationsForUser(ngoId, userType: 'ngo');
      pledgesStream.listen((snapshot) {
        setState(() {
          _pledges = snapshot.docs.map((doc) => Donation.fromFirestore(doc)).toList();
          _isLoading = false;
        });
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading NGO profile: $e')),
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

    if (_ngoData == null) {
      return const Scaffold(
        body: Center(child: Text('Failed to load NGO profile data')),
      );
    }

    final int totalPledges = _pledges.length;
    final int completedPledges = _pledges.where((d) => d.status.contains('Completed')).length;

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
                    child: Icon(Icons.business_center, size: 60, color: Colors.teal),
                  ),
                  const SizedBox(height: 12),
                  Text(_ngoData!.name ?? 'NGO', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('NGO Registration ID: ${_ngoData!.registrationId ?? 'Not Set'}', style: TextStyle(color: Colors.teal.shade100, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('Total Impact: $completedPledges Completed Pledges', style: TextStyle(color: Colors.teal.shade100, fontSize: 16)),
                  const SizedBox(height: 12),
                  // Edit Button
                  TextButton.icon(
                    icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                    label: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      final updatedData = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NgoProfileEditScreen(),
                          settings: RouteSettings(arguments: {
                            'name': _ngoData!.name ?? '',
                            'contact': _userData!.contact ?? '',
                            'description': _ngoData!.description ?? '',
                            'website': _ngoData!.website ?? '',
                          }),
                        ),
                      ) as Map<String, String>?;

                      if (updatedData != null) {
                        await _firestoreService.updateNgo(_ngoData!.id, {
                          'name': updatedData['name'],
                          'description': updatedData['description'],
                          'website': updatedData['website'],
                        });
                        await _firestoreService.updateUser(currentUserId, {
                          'contact': updatedData['contact'],
                        });
                        _loadNgoData(); // Reload data
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
                  const Text('Contact & Bio', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  _NgoDetailTile(icon: Icons.phone, label: 'Contact', value: _userData!.contact ?? 'Not provided'),
                  _NgoDetailTile(icon: Icons.info_outline, label: 'Description', value: _ngoData!.description ?? 'No description added yet'),
                  _NgoDetailTile(icon: Icons.public, label: 'Website', value: _ngoData!.website ?? 'No website'),
                  const Divider(height: 30),

                  // Pledge History
                  const Text('Pledge Activity', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                            Tab(text: 'Pending'),
                            Tab(text: 'Ongoing'),
                            Tab(text: 'History'),
                          ],
                        ),
                        SizedBox(
                          height: 300,
                          child: TabBarView(
                            children: [
                              // Pending Pledges
                              _PledgeActivityList(
                                  pledges: _pledges.where((p) => p.status.contains('Pending') || p.status == 'pending').toList()),
                              // Ongoing Pledges
                              _PledgeActivityList(
                                  pledges: _pledges.where((p) => p.status.contains('Ongoing') || p.status == 'received').toList()),
                              // History (Completed)
                              _PledgeActivityList(
                                  pledges: _pledges.where((p) => p.status.contains('Completed')).toList()),
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

// Helper: NGO Detail Tile
class _NgoDetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _NgoDetailTile({required this.icon, required this.label, required this.value});

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

// Helper: Pledge Activity List
class _PledgeActivityList extends StatelessWidget {
  final List<Donation> pledges;
  const _PledgeActivityList({required this.pledges});

  @override
  Widget build(BuildContext context) {
    if (pledges.isEmpty) {
      return const Center(child: Text('No pledges found for this section.', style: TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      itemCount: pledges.length,
      itemBuilder: (context, index) {
        final p = pledges[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: p.status == 'Completed' ? Colors.teal : Colors.deepOrange,
            child: Icon(p.status == 'Completed' ? Icons.check : Icons.delivery_dining, color: Colors.white),
          ),
          title: Text(p.item),
          subtitle: Text(p.date),
          trailing: Text(p.status.split('(').first.trim(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: p.status == 'Completed' ? Colors.green.shade700 : Colors.deepOrange)),
        );
      },
    );
  }
}

// Helper: Detail Tile (for backward compatibility)
class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
