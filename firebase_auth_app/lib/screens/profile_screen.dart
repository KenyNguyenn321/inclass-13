import 'package:flutter/material.dart';

// temporary profile screen used after successful auth
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('profile screen'),
      ),
    );
  }
}