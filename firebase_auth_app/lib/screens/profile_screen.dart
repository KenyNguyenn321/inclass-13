import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'authentication_screen.dart';

// profile screen shows user info and actions
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  // shows message to user
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // handles logout
  Future<void> _logout() async {
    await _authService.signOut();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthenticationScreen(),
        ),
        (route) => false,
      );
    }
  }

  // handles password update
  Future<void> _updatePassword() async {
    final newPassword = _passwordController.text.trim();

    if (newPassword.isEmpty) {
      _showMessage('enter a new password');
      return;
    }

    if (newPassword.length < 6) {
      _showMessage('password must be at least 6 characters');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.changePassword(newPassword);
      _showMessage('password updated successfully');
      _passwordController.clear();
    } catch (e) {
      _showMessage(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // display user email
            Text(
              'Logged in as:',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 4),

            Text(
              user?.email ?? 'No user',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // password update field
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),

            const SizedBox(height: 12),

            // update password button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updatePassword,
                child: const Text('Update Password'),
              ),
            ),

            const SizedBox(height: 20),

            // logout button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Logout'),
              ),
            ),

            const SizedBox(height: 12),

            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}