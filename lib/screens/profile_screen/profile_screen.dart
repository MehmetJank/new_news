import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_news/screens/profile_screen/components/profile_body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).replace('/settings');
          },
        ),
      ),
      body: const ProfileBody(),
    );
  }
}
