import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'bloc/settings/settings_cubit.dart';
import 'bloc/settings/settings_state.dart';
import 'localizations/localizations.dart';
import 'routes/route.dart';
import 'themes/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(SettingsState()),
      child:
          BlocBuilder<SettingsCubit, SettingsState>(builder: (context, state) {
        return MaterialApp.router(
          title: 'Starter',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLanguages
              .map((e) => Locale(e, ""))
              .toList(),
          locale: Locale(state.language, ""),
          themeMode: state.darkMode ? ThemeMode.dark : ThemeMode.light,
          theme: Themes.lightTheme,
          darkTheme: Themes.darkTheme,
          routerConfig: routes,
        );
      }),
    );
  }
}
