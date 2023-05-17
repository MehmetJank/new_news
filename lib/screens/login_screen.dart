import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../api/user_api.dart';
import '../localizations/localizations.dart';
import '../widgets/background_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_text_form_field.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ApiClient _apiClient = ApiClient();

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    List<String> errors = [];

    if (email.isEmpty) {
      errors.add(getTranslatedText(context, 'mail_address_error'));
    }

    if (password.isEmpty) {
      errors.add(getTranslatedText(context, 'password_error'));
    }

    if (errors.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(getTranslatedText(context, 'error')),
          content: Text(errors.join('\n')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(getTranslatedText(context, 'ok')),
            ),
          ],
        ),
      );
      return;
    }

    try {
      final dynamic response = await _apiClient.login(email, password);

      if (response != null && response["success"]) {
        GoRouter.of(context).go('/settings');
      } else {
        final String errorMessage =
            response != null ? response["message"] : 'Login failed';
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(getTranslatedText(context, 'error')),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(getTranslatedText(context, 'ok')),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(getTranslatedText(context, 'error')),
          content: Text(getTranslatedText(context, 'login_error')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(getTranslatedText(context, 'ok')),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              const CustomBackground(
                  assetImage: 'assets/images/background.jpg'),
              CustomAppBar(title: getTranslatedText(context, 'login')),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.transparent.withOpacity(0.4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextFormField(
                            controller: _emailController,
                            borderSideColor: _emailController.text.isEmpty
                                ? Colors.white
                                : Colors.green,
                            keyboardType: TextInputType.emailAddress,
                            hintText: getTranslatedText(
                                context, 'mail_address_input'),
                          ),
                          CustomTextFormField(
                            controller: _passwordController,
                            borderSideColor: _passwordController.text.isEmpty
                                ? Colors.white
                                : Colors.green,
                            keyboardType: TextInputType.visiblePassword,
                            hintText:
                                getTranslatedText(context, 'password_input'),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 50,
                                ),
                              ),
                              child: Text(
                                getTranslatedText(context, 'login'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
