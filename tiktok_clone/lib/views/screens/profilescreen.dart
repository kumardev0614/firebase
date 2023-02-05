import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          authController.signOut();
        },
        child: const Text('Logout'),
      ),
    );
  }
}
