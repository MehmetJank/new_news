import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_news/localizations/localizations.dart';

import 'components/settings_body.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslatedText(context, "settings")),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/news');
          },
        ),
      ),
      body: const Body(),
    );
  }
}
