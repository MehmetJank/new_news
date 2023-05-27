import 'package:go_router/go_router.dart';

import '../initialize.dart';
import '../screens/authentication_screens/login_screen.dart';
import '../screens/news_screen/category_news_screen.dart';
import '../screens/news_screen/news_screen.dart';
import '../screens/profile_screen/profile_screen.dart';
import '../screens/settings_screen/settings_screen.dart';
import '../screens/authentication_screens/register_screen.dart';
import '../screens/ticket_screens/create_ticket_screen.dart';
import '../screens/ticket_screens/ticket_detail_screen.dart';
import '../screens/ticket_screens/ticket_list_screen.dart';
import '../screens/ticket_screens/ticket_screen.dart';
import '../screens/welcome_screen/welcome_screen.dart';

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
      path: '/news/:category',
      builder: (context, state) {
        final category = state.pathParameters['category']!;
        return CategoryNews(newsCategory: category);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/ticket',
      builder: (context, state) => const TicketScreen(),
    ),
    GoRoute(
      path: '/create_ticket',
      builder: (context, state) => const CreateTicketScreen(),
    ),
    GoRoute(
      path: '/ticket_list',
      builder: (context, state) => const TicketListScreen(),
    ),
    GoRoute(
      path: '/ticket/:id',
      builder: (context, state) {
        final ticketId = int.tryParse(state.pathParameters['id']!)!;
        return TicketDetailsScreen(ticketId: ticketId);
      },
    ),
  ],
);
