import 'package:flutter/material.dart';

// --- 1. WELCOME / LOGIN CHOICE SCREEN ---

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade700,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // ... (Rest of WelcomeScreen content) ...
              const Icon(
                Icons.volunteer_activism,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              const Text(
                'Karuna',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Connecting Hearts with Causes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 60),

              // Donor Login Button
              _LoginButton(
                icon: Icons.person,
                label: 'Login as Donor',
                color: Colors.white,
                textColor: Colors.teal.shade900,
                onPressed: () {
                  Navigator.pushNamed(context, '/login', arguments: {'userType': 'donor'});
                },
              ),
              const SizedBox(height: 20),

              // NGO Login Button
              _LoginButton(
                icon: Icons.business,
                label: 'Login as an NGO',
                color: Theme.of(context).hintColor, // Accent color
                textColor: Colors.black87,
                onPressed: () {
                  Navigator.pushNamed(context, '/login', arguments: {'userType': 'ngo'});
                },
              ),

              const SizedBox(height: 40),
              TextButton(
                onPressed: () {
                  // Action for signing up
                  Navigator.pushNamed(context, '/signUp'); // <--- UPDATED NAVIGATION
                },
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper widget for login buttons
class _LoginButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  const _LoginButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: textColor),
      label: Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
    );
  }
}