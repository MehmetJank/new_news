import 'package:flutter/cupertino.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../../localizations/localizations.dart';

late final SettingsCubit settings;

void showActionSheet(BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      title:
          Text(AppLocalizations.of(context).getTranslate('language_selection')),
      message: Text(AppLocalizations.of(context)
          .getTranslate('language_selection_message')),
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            settings.changeLanguage("tr");
            Navigator.pop(context);
          },
          child: const Text('Turkce'),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            settings.changeLanguage("en");
            Navigator.pop(context);
          },
          child: const Text('English'),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            settings.changeLanguage("fr");
            Navigator.pop(context);
          },
          child: const Text('French'),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context).getTranslate('cancel')),
        ),
      ],
    ),
  );
}
