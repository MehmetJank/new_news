import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../../localizations/localizations.dart';
import 'launguage_cupertino.dart';
import 'setting_menu.dart';
import 'profile_pic.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    try {
      settings = context.read<SettingsCubit>();
    } catch (e) {
      //pass
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = settings.state.darkMode;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const ProfilePic(),
          const SizedBox(height: 20),
          SettingMenu(
            text: getTranslatedText(context, 'my_account'),
            assetIcon: "assets/icons/user.svg",
            press: () => {
              GoRouter.of(context).push('/profile'),
            },
          ),
          SettingMenu(
            text: getTranslatedText(context, 'language'),
            assetIcon: "assets/icons/language.svg",
            press: () {
              showActionSheet(context);
            },
          ),
          SettingMenu(
            text: getTranslatedText(context, 'dark_mode'),
            assetIcon: isDarkMode
                ? "assets/icons/dark_mode.svg"
                : "assets/icons/light_mode.svg",
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
              settings.changeDarkMode(value);
            },
            isSwitched: isDarkMode,
          ),
          SettingMenu(
            text: getTranslatedText(context, 'help_center'),
            assetIcon: "assets/icons/support.svg",
            press: () {
              GoRouter.of(context).push('/ticket');
            },
          ),
          SettingMenu(
            text: getTranslatedText(context, 'logout'),
            assetIcon: "assets/icons/logout.svg",
            press: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(getTranslatedText(context, 'logout')),
                  content: Text(getTranslatedText(context, 'logout_message')),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        getTranslatedText(context, 'cancel'),
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        settings.userLogout();
                        GoRouter.of(context).go('/welcome');
                      },
                      child: Text(
                        getTranslatedText(context, 'logout'),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
