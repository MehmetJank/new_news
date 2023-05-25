import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/settings/settings_cubit.dart';
import '../../localizations/localizations.dart';
import '../../widgets/background_widget.dart';
import 'components/language_drop_down_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            const CustomBackground(assetImage: 'assets/images/background.jpg'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Column(
                children: [
                  Row(
                    // To do change the language functionality
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.language),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                        ),
                        color: Colors.white,
                        onPressed: () {
                          showLanguageDropdown(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                    scale: 1.6,
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            GoRouter.of(context).push('/login');
                          },
                          style: ButtonStyle(
                            // foregroundColor: MaterialStateProperty.all<
                            //         Color>(
                            //     AppColors.primaryWhite.withOpacity(0.6)),
                            // backgroundColor:
                            //     MaterialStateProperty.all<Color>(
                            //   AppColors.secondaryBlack.withOpacity(0.8),
                            // ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              getTranslatedText(context, 'login'),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            //Router login screen
                            GoRouter.of(context).push('/register');
                          },
                          style: ButtonStyle(
                            // foregroundColor:
                            // MaterialStateProperty.all<Color>(
                            // AppColors.secondaryBlack),
                            // backgroundColor: MaterialStateProperty.all<
                            //         Color>(
                            //     AppColors.primaryWhite.withOpacity(0.5)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              getTranslatedText(context, 'register'),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
