import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../api/user_api.dart';
import '../widget/background_widget.dart';
import '../widget/custom_app_bar.dart';
import '../widget/custom_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();
  bool _isEmailValid = false;
  late Color _passwordMismatchColor = Colors.white;

  final ApiClient _apiClient = ApiClient();

  Future<void> _register() async {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String passwordAgain = _passwordAgainController.text;

    List<String> errors = [];

    if (name.isEmpty) {
      errors.add('Lütfen adınızı giriniz');
    }

    if (email.isEmpty) {
      errors.add('Lütfen e-posta adresinizi giriniz');
    } else if (!_isEmailValid) {
      errors.add('Lütfen geçerli bir e-posta adresi giriniz');
    }
    // To do: control regex
    if (password.length < 6) {
      errors.add('Lütfen en az 6 karakterden oluşan bir şifre giriniz');
    }

    if (password != passwordAgain) {
      errors.add('Şifreler eşleşmiyor');
      _passwordMismatchColor = Colors.red;
    } else {
      _passwordMismatchColor = Colors.green;
    }

    if (errors.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: errors.map((error) => Text(error)).toList(),
          ),
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
      final response =
          await _apiClient.register(name, email, password, passwordAgain);
      print(response.data);

      final bool success = response.data['success'] ?? false;
      if (success) {
        GoRouter.of(context).go('/profile');
      } else {
        final String errorMessage =
            response.data['message'] ?? 'Register failed';
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
      print('Register request failed: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Register request failed'),
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
        body: Center(
          child: Stack(
            children: [
              const CustomBackground(
                  assetImage: 'assets/images/background.jpg'),
              const CustomAppBar(title: 'Kayıt Ol'),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Lütfen Bilgilerinizi Eksiksiz Giriniz",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.transparent.withOpacity(0.4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextFormField(
                            controller: _nameController,
                            borderSideColor: _nameController.text.isEmpty
                                ? Colors.white
                                : Colors.green,
                            keyboardType: TextInputType.text,
                            hintText: 'Adınızı giriniz',
                          ),
                          CustomTextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              hintText: 'Mail adresinizi giriniz',
                              onChanged: (value) {
                                final emailRegex = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                                setState(() {
                                  _isEmailValid = emailRegex.hasMatch(value);
                                });
                              },
                              borderSideColor: _emailController.text.isEmpty
                                  ? Colors.white
                                  : _isEmailValid
                                      ? Colors.green
                                      : Colors.red),
                          CustomTextFormField(
                            controller: _passwordController,
                            borderSideColor: _passwordMismatchColor,
                            keyboardType: TextInputType.visiblePassword,
                            hintText: 'Şifrenizi giriniz',
                            onChanged: (value) {
                              setState(() {
                                _passwordAgainController.text != value
                                    ? _passwordMismatchColor = Colors.red
                                    : _passwordMismatchColor = Colors.green;
                              });
                            },
                          ),
                          CustomTextFormField(
                            controller: _passwordAgainController,
                            borderSideColor: _passwordMismatchColor,
                            keyboardType: TextInputType.visiblePassword,
                            hintText: 'Şifrenizi tekrar giriniz',
                            onChanged: (value) {
                              setState(
                                () {
                                  _passwordController.text != value
                                      ? _passwordMismatchColor = Colors.red
                                      : _passwordMismatchColor = Colors.green;
                                },
                              );
                            },
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _register();
                              },
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
                                'Kayıt Ol',
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
