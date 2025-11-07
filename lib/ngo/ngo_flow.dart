import 'package:flutter/material.dart';

// --- MOCK DATA STRUCTURES (Copied from main.dart for compilation safety) ---

class Ngo {
  final String id;
  final String name;
  final String category;
  final String area;
  final String need;
  final double rating;
  final String imageUrl;

  Ngo({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.need,
    required this.rating,
    required this.imageUrl,
  });
}

class Donation {
  final String ngoName;
  final String item;
  final String date;
  final String status;

  Donation({
    required this.ngoName,
    required this.item,
    required this.date,
    required this.status,
  });
}

// --- MOCK NGO DATA (Future Leaders Academy is the logged-in NGO) ---
final Ngo currentNgo = Ngo(
    id: '2', 
    name: 'Future Leaders Academy', 
    category: 'Education', 
    area: 'Delhi', 
    need: 'Laptops, Notebooks', 
    rating: 4.5, 
    imageUrl: 'https://placehold.co/600x400/4169E1/ffffff?text=Education'
);

// Mock received pledges/donations for this NGO
final List<Donation> mockReceivedPledges = [
  Donation(ngoName: 'Future Leaders Academy', item: '10 Laptops (In-kind)', date: 'Nov 01, 2024', status: 'Pending Pickup'),
  Donation(ngoName: 'Future Leaders Academy', item: '₹5000 (Monetary)', date: 'Oct 25, 2024', status: 'Received'),
  Donation(ngoName: 'Future Leaders Academy', item: '50 Notebooks (In-kind)', date: 'Oct 10, 2024', status: 'Completed'),
];


// ***************************************************************
// --- NEW WIDGETS: NGO DRAWER AND SETTING TILE ---
// ***************************************************************

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

// ***************************************************************
// --- NGO HOME SCREEN (UPDATE WITH DRAWER) ---
// ***************************************************************

class NgoHomeScreen extends StatefulWidget {
  const NgoHomeScreen({super.key});

  @override
  State<NgoHomeScreen> createState() => _NgoHomeScreenState();
}

class _NgoHomeScreenState extends State<NgoHomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    NgoDashboard(ngo: currentNgo),
    const NgoRequestsScreen(),
    const NgoProfileScreen(),
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
        return 'Pledge Management';
      case 2:
        return 'My NGO Profile';
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
      drawer: const NgoAppDrawer(), // <--- DRAWER ADDED HERE
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Pledges',
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

// ***************************************************************
// --- 1. NGO DASHBOARD (UNCHANGED) ---
// ***************************************************************

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
              _StatCard(label: 'Active Pledges', value: '1', color: Colors.orange.shade100, icon: Icons.pending_actions),
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
                const Spacer(),
                const Icon(Icons.star, color: Colors.amber, size: 18),
                Text(ngo.rating.toString()),
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
        trailing: TextButton(
          onPressed: () {
            // Mock update action
          },
          child: const Text('Update'),
        ),
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

// ***************************************************************
// --- 2. PLEDGE MANAGEMENT SCREEN (UNCHANGED) ---
// ***************************************************************

class NgoRequestsScreen extends StatelessWidget {
  const NgoRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Manage Donor Pledges', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text('You have ${mockReceivedPledges.length} active and past pledges.', style: TextStyle(color: Colors.grey.shade600)),
          const Divider(height: 30),
          
          // List of Pledges
          ...mockReceivedPledges.map((pledge) => _PledgeManagementTile(pledge: pledge)).toList(),
        ],
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
      case 'Pending Pickup':
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (pledge.status == 'Pending Pickup')
                  ElevatedButton.icon(
                    onPressed: () {
                      // Mock action to contact donor
                    },
                    icon: const Icon(Icons.chat, size: 18, color: Colors.white),
                    label: const Text('Contact Donor', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade500),
                  ),
                const SizedBox(width: 8),
                if (pledge.status == 'Pending Pickup')
                  ElevatedButton.icon(
                    onPressed: () {
                      // Mock action to complete pickup
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

// ***************************************************************
// --- 3. NGO PROFILE SCREEN (UNCHANGED) ---
// ***************************************************************

class NgoProfileScreen extends StatelessWidget {
  const NgoProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal.shade100,
              child: const Icon(Icons.business_center, size: 50, color: Colors.teal),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(currentNgo.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Center(
            child: Text(currentNgo.category, style: TextStyle(color: Colors.teal.shade600, fontSize: 16)),
          ),
          const SizedBox(height: 30),

          const Text('Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Divider(),
          _DetailTile(icon: Icons.location_on, label: 'Area of Operation', value: currentNgo.area),
          _DetailTile(icon: Icons.star, label: 'Rating', value: currentNgo.rating.toString()),
          _DetailTile(icon: Icons.lightbulb_outline, label: 'Key Needs', value: currentNgo.need),
          _DetailTile(icon: Icons.public, label: 'Website', value: 'futureleaders.org'),
          
          const SizedBox(height: 30),

          Center(
            child: ElevatedButton.icon(
              // This is a redundant logout button, but kept for full file integrity.
              // The main logout is now in the drawer.
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false); // Logout
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text('Logout', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper: Detail Tile
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