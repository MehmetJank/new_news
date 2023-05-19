import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/settings/settings_cubit.dart';
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
      print("lennn");
      print(settings.state.userInfo.length);
      print(settings.state.userInfo[0]);
      print(settings.state.userInfo[1]);
      print(settings.state.userInfo[2]);
      print(settings.state.userInfo[3]);
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
            title: "Your Name",
            icon: "assets/icons/User Icon.svg",
            info: settings.state.userInfo[0],
          ),
          ProfileMenu(
            title: "Your email",
            icon: "assets/icons/User Icon.svg",
            info: settings.state.userInfo[1],
          ),
          ProfileMenu(
            title: "Your phone number",
            icon: "assets/icons/Phone.svg",
            info: settings.state.userInfo[2],
          ),
        ],
      ),
    );
  }
}
