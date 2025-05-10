// pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/globalProvider.dart';
import 'login_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const Color bgPink     = Color(0xFFFFF0F6);
  static const Color accentPink = Color(0xFFea9ab2);

  @override
  Widget build(BuildContext context) {
    return Consumer<Global_provider>(
      builder: (context, provider, child) {
        if (!provider.isLoggedIn) return const LoginPage();
        final user = provider.currentUser!;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: const Text('Profile', style: TextStyle(color: Colors.black87)),
            iconTheme: const IconThemeData(color: Colors.black54),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  child: Image.network(user.image,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),

                // Contact Info Card
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildContactItem(Icons.email, 'Email', user.email),
                        const SizedBox(height: 12),
                        _buildContactItem(Icons.phone, 'Phone', user.phone),
                        const SizedBox(height: 12),
                        _buildContactItem(
                          Icons.location_on,
                          'Address',
                          '${user.address.street}, ${user.address.city}',
                        ),
                        const SizedBox(height: 12),
                        _buildContactItem(
                          Icons.person,
                          'Full name',
                          '${user.name.firstname}, ${user.name.lastname}',
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: provider.logout,
                            icon: const Icon(Icons.logout),
                            label: const Text('LOGOUT'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.grey.shade700),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                )),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                )),
          ],
        ),
      ],
    );
  }
}