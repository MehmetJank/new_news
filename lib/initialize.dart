import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../localizations/localizations.dart';
import 'bloc/settings/settings_cubit.dart';
import 'storage/storage.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool loading = true;
  late SettingsCubit settings;

  loadApp() async {
    try {
      final storage = AppStorage();
      var data = await storage.readAll();

      if (data["darkMode"] == null) {
        if (ThemeMode.system == ThemeMode.dark) {
          data["darkMode"] = true;
        } else {
          data["darkMode"] = false;
        }
      }

      if (data["language"] == null) {
        if (kIsWeb) {
          data["language"] = "tr";
          await storage.writeAppSettings(
              language: data["language"], darkMode: data["darkMode"]);
        } else {
          final String defaultLocale = Platform.localeName;
          var liste = defaultLocale.split('_');
          var isSupported =
              AppLocalizations.delegate.isSupported(Locale(liste[0], ""));
          if (isSupported) {
            data["language"] = liste[0];
            await storage.writeAppSettings(
                language: data["language"], darkMode: data["darkMode"]);
          } else {
            data["language"] = "en";
            await storage.writeAppSettings(
                language: data["language"], darkMode: data["darkMode"]);
          }
        }
      }

      if (data["loggedIn"] == null) {
        data["loggedIn"] = false;
        data["userInfo"] = [];
        await storage.writeUserData(isLoggedIn: false, userInfo: []);
      }

      settings.changeDarkMode(data["darkMode"]);
      settings.changeLanguage(data["language"]);
      if (data["loggedIn"]) {
        settings.userLogin(data["userInfo"]);
      } else {
        settings.userLogout();
      }

      setState(() {
        loading = false;
      });

      if (data["loggedIn"]) {
        // ignore: use_build_context_synchronously
        GoRouter.of(context).replace("/news");
      } else {
        // ignore: use_build_context_synchronously
        GoRouter.of(context).replace("/welcome");
      }
    } catch (e) {
      null;
    }
  }

  @override
  void initState() {
    settings = context.read<SettingsCubit>();
    super.initState();
    loadApp();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : const Text('Loaded'),
      ),
    );
  }
}
