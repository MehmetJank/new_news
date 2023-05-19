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
            assetIcon: "assets/icons/User Icon.svg",
            press: () => {
              GoRouter.of(context).replace('/profile'),
            },
          ),
          SettingMenu(
            text: getTranslatedText(context, 'language'),
            icon: Icons.language,
            press: () {
              showActionSheet(context);
            },
          ),
          SettingMenu(
            text: getTranslatedText(context, 'dark_mode'),
            icon: Icons.dark_mode,
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
            assetIcon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          SettingMenu(
            text: getTranslatedText(context, 'logout'),
            assetIcon: "assets/icons/Log out.svg",
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
                      child: Text(getTranslatedText(context, 'cancel')),
                    ),
                    TextButton(
                      onPressed: () {
                        settings.userLogout();
                        GoRouter.of(context).go('/welcome');
                      },
                      child: Text(getTranslatedText(context, 'logout')),
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
