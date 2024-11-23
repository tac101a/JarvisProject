import 'package:flutter/material.dart';
import 'package:jarvis_project/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    bool isLogin =
        GoRouter.of(context).routeInformationProvider.value.uri.toString() ==
            '/login';

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();

    Future<void> submitData() async {
      final url = isLogin
          ? 'https://api.dev.jarvis.cx/api/v1/auth/sign-in' // Đổi thành URL đăng nhập
          : 'https://api.dev.jarvis.cx/api/v1/auth/sign-up'; // Đổi thành URL đăng ký

      final body = isLogin
          ? jsonEncode(<String, String>{
              'email': emailController.text,
              'password': passwordController.text,
            })
          : jsonEncode(<String, String>{
              'email': emailController.text,
              'password': passwordController.text,
              'username': usernameController.text
            });

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        // Xử lý phản hồi thành công
        final data = jsonDecode(response.body);
        print("Success: ${data}");
      } else {
        // Xử lý lỗi
        print("Error: ${response.statusCode}");
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // Added SingleChildScrollView here
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      iconSize: 35.0,
                      onPressed: () {
                        context.go('/');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 80),

                // Logo and Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/assets/logo.png',
                      height: 50,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Jarvis',
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80),

                // Sign in with Google Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.login),
                    label: const Text(
                      'Sign in with Google',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color.fromARGB(255, 245, 244, 250),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Divider with "or" text
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'or',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Registration fields for non-login state
                if (!isLogin) ...[
                  TextField(
                    controller: usernameController,
                    decoration: usernameFieldDecoration,
                  ),
                  const SizedBox(height: 10),
                ],
                TextField(
                  controller: emailController,
                  decoration: emailFieldDecoration,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: passwordFieldDecoration,
                ),
                const SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: submitData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      isLogin ? 'Login' : 'Register',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Switch between Login and Register
                TextButton(
                  onPressed: () {
                    isLogin ? context.go('/register') : context.go('/login');
                  },
                  child: Text(isLogin
                      ? "Don't have an account? Register"
                      : "Already have an account? Login"),
                ),
                const SizedBox(height: 20),

                // Privacy Policy Text
                const Text(
                  'By continuing, you agree to our Privacy policy',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
