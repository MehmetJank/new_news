import 'package:flutter/material.dart';

import '../../../../../bloc/settings/settings_cubit.dart';
import '../../../../../localizations/localizations.dart';

late final SettingsCubit settings;

void showLanguageDropdown(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(getTranslatedText(context, 'language_selection')),
            subtitle:
                Text(getTranslatedText(context, 'language_selection_message')),
          ),
          ListTile(
            title: Text(getTranslatedText(context, 'language_tr')),
            onTap: () {
              settings.changeLanguage("tr");
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(getTranslatedText(context, 'language_en')),
            onTap: () {
              settings.changeLanguage("en");
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(getTranslatedText(context, 'language_fr')),
            onTap: () {
              settings.changeLanguage("fr");
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(getTranslatedText(context, 'cancel')),
            onTap: () {
              Navigator.pop(context);
            },
            tileColor: Colors.red,
          ),
        ],
      );
    },
  );
}
