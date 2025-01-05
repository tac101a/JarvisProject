import 'package:go_router/go_router.dart';
import 'package:jarvis_project/screens/account_screen.dart';
import 'package:jarvis_project/screens/splash_screen.dart';
import 'package:jarvis_project/util/home.dart';
import 'package:jarvis_project/screens/auth_screen.dart';
import 'package:jarvis_project/screens/pricing_screen.dart';

import '../models/user_model.dart';

final GoRouter router = GoRouter(
  initialLocation: '/loading',
  redirect: (context, state) {
    final isLoggingIn = state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    if (!User.isSignedIn && !isLoggingIn) {
      // have not signed in yet, go to sign in page
      return '/loading';
    }

    if (User.isSignedIn && isLoggingIn) {
      // if signed in already, go to home page
      return '/';
    }

    return null;
  },
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
      builder: (context, state) => AccountPage(),
    ),

    GoRoute(
      path: '/loading',
      builder: (context, state) => SplashScreen(),
    ),
  ],
);
