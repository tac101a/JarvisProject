import 'package:go_router/go_router.dart';
import 'package:jarvis_project/screens/account_screen.dart';
import 'package:jarvis_project/screens/splash_screen.dart';
import 'package:jarvis_project/util/home.dart';
import 'package:jarvis_project/screens/auth_screen.dart';
import 'package:jarvis_project/screens/pricing_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/loading',
  routes: [
    // Home Route
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    // Login Route
    GoRoute(
      path: '/login',
      builder: (context, state) => const AuthScreen(),
    ),
    // Register Route
    GoRoute(
      path: '/register',
      builder: (context, state) => const AuthScreen(),
    ),

    GoRoute(
      path: '/pricing',
      builder: (context, state) => const PricingScreen(),
    ),

    GoRoute(
      path: '/account',
      builder: (context, state) => const AccountPage(),
    ),

    GoRoute(
      path: '/loading',
      builder: (context, state) => SplashScreen(),
    ),
  ],
);
