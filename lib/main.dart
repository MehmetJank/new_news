import 'package:connectivity_plus/connectivity_plus.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final SettingsCubit settings;
  //ignore: unused_field
  late ConnectivityResult _connectivityResult;
  late bool _isConnected;

  @override
  void initState() {
    super.initState();
    _isConnected = true;
    try {
      settings = context.read<SettingsCubit>();
    } catch (e) {
      // pass
    }
    _checkConnectivity();

    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _connectivityResult = result;
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = result;
      _isConnected = result != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(SettingsState()),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'New News',
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
            builder: (context, router) {
              return WillPopScope(
                onWillPop: () async => !_isConnected,
                child: AbsorbPointer(
                  absorbing: !_isConnected,
                  child: Stack(
                    children: [
                      router!,
                      if (!_isConnected)
                        AlertDialog(
                          title: Text(
                              getTranslatedText(context, "connection_alert")),
                          content: Text(getTranslatedText(
                              context, "connection_alert_message")),
                          actions: [
                            TextButton(
                              child: Text(getTranslatedText(context, "close")),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
