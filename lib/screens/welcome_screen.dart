import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widget/background_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
                            GoRouter.of(context).go('/login');
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
                          child: const Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              'Giriş Yap',
                              style: TextStyle(
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
                            GoRouter.of(context).go('/register');
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
                          child: const Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              'Kayıt Ol',
                              style: TextStyle(
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
