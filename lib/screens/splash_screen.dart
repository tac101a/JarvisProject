import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jarvis_project/services/auth_service.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _authService.getUser(),
      builder: (context, snapshot) {
        // display loading during check sign in status
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // redirect
        if (snapshot.hasData && snapshot.data == true) {
          // if signed in, move to home page
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/');
          });
        } else {
          // if not, move to log in page
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/login');
          });
        }

        return const SizedBox(); // showing nothing while waiting
      },
    );
  }
}
