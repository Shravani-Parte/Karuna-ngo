import 'package:flutter/material.dart';

// --- IMPORT ALL SCREENS & MODELS ---
import 'models.dart';
import 'welcome_screen.dart';
import 'donor_home_flow.dart';
import 'profile_edit_screen.dart';
import 'post_detail_screen.dart';
import 'donation_form_screen.dart';
import 'signup_screen.dart';
import 'login_screen.dart';
import 'ngo/ngo_flow.dart';

// --- MAIN APP ENTRY POINT ---

void main() {
  runApp(const NgoConnectApp());
}

class NgoConnectApp extends StatelessWidget {
  const NgoConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NGO Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: const Color(0xFF008080), 
        hintColor: const Color(0xFFFFC300), 
        scaffoldBackgroundColor: Colors.grey.shade50,
        fontFamily: 'Inter',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal.shade700,
          elevation: 0,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.white), 
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/signUp': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/donorHome': (context) => const DonorHomeScreen(),
        '/ngoHome': (context) => const NgoHomeScreen(), // Route to NGO flow (assumed in ngo_flow.dart)
        '/profileEdit': (context) => const ProfileEditScreen(),
        // Note: Routes passing arguments must be handled carefully, here we pass null as a placeholder.
        '/postDetail': (context) => const PostDetailScreen(ngo: null),
        '/donationForm': (context) => const DonationFormScreen(ngo: null),
      },
    );
  }
}