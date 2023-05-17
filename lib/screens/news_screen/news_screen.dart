import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go('/settings');
            },
          ),
        ],
      ),
    );
  }
}
