import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../localizations/localizations.dart';
import 'components/settings_body.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  void _launchURL(String url) async {
    final Uri urlLocal = Uri.parse(url);
    if (!await launchUrl(urlLocal)) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $url'),
        ),
      );
    }
  }

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
      bottomSheet: SizedBox(
        height: 50,
        width: double.infinity,
        child: Center(
          child: InkWell(
            onTap: () {
              _launchURL("https://github.com/MehmetJank");
            },
            child: Text(
              "Made with ❤️ by Mehmet Jank",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
