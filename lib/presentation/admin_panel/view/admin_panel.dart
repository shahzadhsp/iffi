// admin_panel.dart
import 'package:flutter/material.dart';
import 'package:iffi_store/data/services/firebase_auth_services.dart';

class AdminPanel extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacementNamed(context, '/login');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logged Out Successfully')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Admin Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Administrative Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildAdminButton(
                      context,
                      icon: Icons.people,
                      label: 'Manage Users',
                      onPressed: () {
                        // Add user management functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User Management Clicked')),
                        );
                      },
                    ),
                    _buildAdminButton(
                      context,
                      icon: Icons.settings,
                      label: 'System Settings',
                      onPressed: () {
                        // Add settings functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Settings Clicked')),
                        );
                      },
                    ),
                    _buildAdminButton(
                      context,
                      icon: Icons.analytics,
                      label: 'View Analytics',
                      onPressed: () {
                        // Add analytics functionality
                               ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Analytices Clicked'),),
              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}
