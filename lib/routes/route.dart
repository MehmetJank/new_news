import 'package:go_router/go_router.dart';

import '../initialize.dart';
import '../screens/authentication_screens/login_screen.dart';
import '../screens/news_screen/news_screen.dart';
import '../screens/profile_screen/profile_screen.dart';
import '../screens/settings_screen/settings_screen.dart';
import '../screens/authentication_screens/register_screen.dart';
import '../screens/welcome_screen.dart';

final routes = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const InitialScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LogInScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingScreen(),
    ),
    GoRoute(
      path: '/news',
      builder: (context, state) => const NewsScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
