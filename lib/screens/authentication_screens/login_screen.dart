import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:new_news/screens/profile_screen/components/launguage_cupertino.dart';

import '../../api/user_api.dart';
import '../../bloc/settings/settings_cubit.dart';
import '../../localizations/localizations.dart';
import '../../widgets/background_widget.dart';
import 'components/custom_app_bar.dart';
import 'components/custom_text_form_field.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ApiClient _apiClient = ApiClient();
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    try {
      settings = context.read<SettingsCubit>();
    } catch (e) {
      //pass
    }
    _passwordVisible = false;
  }

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    List<String> errors = [];
    List<String> userData = [];

    if (email.isEmpty) {
      errors.add(getTranslatedText(context, 'mail_address_error'));
    }

    if (password.isEmpty) {
      errors.add(getTranslatedText(context, 'password_error'));
    }

    if (errors.isNotEmpty) {
      _showErrorDialog(errors.join('\n'));
      return;
    }

    try {
      final dynamic response = await _apiClient.login(email, password);

      if (response != null && response["success"]) {
        userData.add(response["user"].toString());
        userData.add(response["token"].toString());
        settings.userLogin(userData);
        _navigateToNewsScreen();
      } else {
        final String errorMessage =
            response != null ? response["message"] : 'Login failed';
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
    GoRouter.of(context).pushReplacement('/news');
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
                            obscureText: !_passwordVisible,
                            hintText:
                                getTranslatedText(context, 'password_input'),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                onPressed: () {
                                  setState(
                                    () {
                                      _passwordVisible = !_passwordVisible;
                                    },
                                  );
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
