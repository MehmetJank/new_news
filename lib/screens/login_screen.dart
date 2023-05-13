import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../api/user_api.dart';
import '../widget/background_widget.dart';
import '../widget/custom_app_bar.dart';
import '../widget/custom_text_form_field.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

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
      errors.add('Lütfen e-posta adresinizi giriniz');
    }

    if (password.isEmpty) {
      errors.add('Lütfen şifrenizi giriniz');
    }

    if (errors.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(errors.join('\n')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      final response = await _apiClient.login(email, password);
      print(response.data);

      final bool success = response.data['success'] ?? false;
      if (success) {
        GoRouter.of(context).go('/profile');
      } else {
        final String errorMessage = response.data['message'] ?? 'Login failed';
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Login request failed: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Login request failed'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
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
              const CustomAppBar(title: 'Giriş Yap'),
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
                            hintText: 'Mail adresinizi giriniz',
                          ),
                          CustomTextFormField(
                            controller: _passwordController,
                            borderSideColor: _passwordController.text.isEmpty
                                ? Colors.white
                                : Colors.green,
                            keyboardType: TextInputType.visiblePassword,
                            hintText: 'Şifrenizi giriniz',
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
                              child: const Text(
                                'Giriş Yap',
                                style: TextStyle(
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
