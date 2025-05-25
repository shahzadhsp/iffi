import 'package:flutter/material.dart';
import 'package:iffi_store/data/services/firebase_auth_services.dart';
import 'package:iffi_store/presentation/ui/sign_up/login/login_screen.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
