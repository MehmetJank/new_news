import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../../localizations/localizations.dart';
import '../../settings_screen/components/profile_pic.dart';
import 'profile_menu.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({Key? key}) : super(key: key);

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

  String _formatDate(String date) {
    final dateTime = DateTime.parse(date);
    final formattedDate = DateFormat('dd.MM.yyyy').format(dateTime);
    return formattedDate;
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
            icon: "assets/icons/user.svg",
            info: settings.state.userInfo[1],
          ),
          ProfileMenu(
            title: getTranslatedText(context, "your_mail_address"),
            icon: "assets/icons/email.svg",
            info: settings.state.userInfo[2],
          ),
          ProfileMenu(
            title: getTranslatedText(context, "your_phone_number"),
            icon: "assets/icons/phone.svg",
            info: settings.state.userInfo[3],
          ),
          ProfileMenu(
            title: "Register Date",
            icon: "assets/icons/date.svg",
            info: _formatDate(settings.state.userInfo[5]),
          ),
        ],
      ),
    );
  }
}
