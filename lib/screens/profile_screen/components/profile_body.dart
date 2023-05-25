import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../../localizations/localizations.dart';
import '../../settings_screen/components/profile_pic.dart';
import 'profile_menu.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  late final SettingsCubit settings;

  @override
  void initState() {
    super.initState();
    try {
      settings = context.read<SettingsCubit>();
    } catch (e) {
      // pass
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const ProfilePic(),
          const SizedBox(height: 20),
          ProfileMenu(
            title: getTranslatedText(context, "your_name"),
            icon: "assets/icons/User Icon.svg",
            info: settings.state.userInfo[1],
          ),
          ProfileMenu(
            title: getTranslatedText(context, "your_mail_address"),
            icon: "assets/icons/User Icon.svg",
            info: settings.state.userInfo[2],
          ),
          ProfileMenu(
            title: getTranslatedText(context, "your_phone_number"),
            icon: "assets/icons/Phone.svg",
            info: settings.state.userInfo[3],
          ),
        ],
      ),
    );
  }
}
