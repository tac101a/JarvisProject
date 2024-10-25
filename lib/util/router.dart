import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jarvis_project/util/home.dart';
import 'package:jarvis_project/ui/auth_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
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
  ],
);