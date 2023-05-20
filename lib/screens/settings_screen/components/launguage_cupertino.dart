import 'package:flutter/cupertino.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../../localizations/localizations.dart';

late final SettingsCubit settings;

void showActionSheet(BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      title: Text(getTranslatedText(context, 'language_selection')),
      message: Text(getTranslatedText(context, 'language_selection_message')),
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            settings.changeLanguage("tr");
            Navigator.pop(context);
          },
          child: Text(getTranslatedText(context, 'language_tr')),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            settings.changeLanguage("en");
            Navigator.pop(context);
          },
          child: Text(getTranslatedText(context, 'language_en')),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            settings.changeLanguage("fr");
            Navigator.pop(context);
          },
          child: Text(getTranslatedText(context, 'language_fr')),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(getTranslatedText(context, 'cancel')),
        ),
      ],
    ),
  );
}
