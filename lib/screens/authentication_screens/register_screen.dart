import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../api/user_api.dart';
import '../../bloc/settings/settings_cubit.dart';
import '../../localizations/localizations.dart';
import '../../widgets/background_widget.dart';
import 'components/custom_app_bar.dart';
import 'components/custom_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final SettingsCubit settings;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();

  bool _isEmailValid = false;
  bool _passwordVisible = false;
  bool _passwordAgainVisible = false;

  late Color _passwordMismatchColor = Colors.white;

  final ApiClient _apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    try {
      settings = context.read<SettingsCubit>();
    } catch (e) {
      //pass
    }
    _passwordVisible = false;
    _passwordAgainVisible = false;
  }

  Future<void> _register() async {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String phoneNumber = _phoneController.text;
    final String password = _passwordController.text;
    final String passwordAgain = _passwordAgainController.text;

    List<String> errors = [];
    List<String> userData = [];

    if (name.isEmpty) {
      errors.add(getTranslatedText(context, 'input_name_error'));
    }

    if (email.isEmpty) {
      errors.add(getTranslatedText(context, 'input_mail_address'));
    } else if (!_isEmailValid) {
      errors.add(getTranslatedText(context, 'input_mail_address_error'));
    }

    if (phoneNumber.isEmpty) {
      errors.add(getTranslatedText(context, 'input_phone_number_error'));
    }

    if (password.length < 6) {
      errors.add(getTranslatedText(context, 'input_password_error'));
    }

    if (password != passwordAgain) {
      errors.add(getTranslatedText(context, 'password_is_different'));
      _passwordMismatchColor = Colors.red;
    } else {
      _passwordMismatchColor = Colors.green;
    }

    if (errors.isNotEmpty) {
      _showErrorDialog(errors.join('\n'));
      return;
    }

    try {
      final dynamic response = await _apiClient.register(
          name, email, phoneNumber, password, passwordAgain);

      if (response != null && response["success"]) {
        userData.add(response["token"].toString());
        userData.add(response["name"].toString());
        userData.add(response["email"].toString());
        userData.add(response["phone"].toString());
        userData.add(response["profile_image"].toString());
        userData.add(response["created_at"].toString());
        settings.userLogin(userData);
        _navigateToNewsScreen();
      } else {
        final String errorMessage =
            response != null ? response["message"] : 'Register failed';
        _showErrorDialog(errorMessage);
      }
    } catch (e) {
      _showErrorDialog(getTranslatedText(context, 'login_error'));
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(getTranslatedText(context, 'error')),
        content: Text(message),
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

  void _navigateToNewsScreen() {
    GoRouter.of(context).go('/news');
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
              CustomAppBar(title: getTranslatedText(context, 'register')),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getTranslatedText(context, 'input_all_fields'),
                      style: const TextStyle(
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
                            hintText: getTranslatedText(context, 'input_name'),
                          ),
                          CustomTextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              hintText: getTranslatedText(
                                  context, 'input_mail_address'),
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
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            hintText: getTranslatedText(
                                context, 'input_phone_number'),
                            borderSideColor: _phoneController.text.isEmpty
                                ? Colors.white
                                : Colors.green,
                          ),
                          CustomTextFormField(
                            controller: _passwordController,
                            borderSideColor: _passwordMismatchColor,
                            obscureText: !_passwordVisible,
                            keyboardType: TextInputType.text,
                            hintText:
                                getTranslatedText(context, 'input_password'),
                            onChanged: (value) {
                              setState(() {
                                _passwordAgainController.text != value
                                    ? _passwordMismatchColor = Colors.red
                                    : _passwordMismatchColor = Colors.green;
                              });
                            },
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          CustomTextFormField(
                              controller: _passwordAgainController,
                              borderSideColor: _passwordMismatchColor,
                              obscureText: !_passwordAgainVisible,
                              keyboardType: TextInputType.visiblePassword,
                              hintText: getTranslatedText(
                                  context, 'input_password_again'),
                              onChanged: (value) {
                                setState(
                                  () {
                                    _passwordController.text != value
                                        ? _passwordMismatchColor = Colors.red
                                        : _passwordMismatchColor = Colors.green;
                                  },
                                );
                              },
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _passwordAgainVisible =
                                          !_passwordAgainVisible;
                                    });
                                  },
                                  icon: Icon(
                                    _passwordAgainVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
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
                              child: Text(
                                getTranslatedText(context, 'register'),
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
