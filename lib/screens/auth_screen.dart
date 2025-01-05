import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jarvis_project/components/error_modal.dart';
import 'package:jarvis_project/services/auth_service.dart';
import 'package:jarvis_project/style/styles.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // auth service
  final AuthService _authService = AuthService();

  // State
  bool _pwdVisibility = false;
  bool _cfPwdVisibility = false;
  bool _emailValid = true;
  bool _passwordValid = true;
  bool _cfPasswordValid = true;
  bool _isUsernameEmpty = false;
  bool _isSignInFailed = false;

  // TextField Controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLogin =
        GoRouter.of(context).routeInformationProvider.value.uri.toString() ==
            '/login';

    // check email valid
    bool isValidEmail(String email) {
      // Must have '@' and '.'
      if (!email.contains('@') || !email.contains('.')) return false;

      // Split string at '@'
      // Both left and right '@' must not empty
      final parts = email.split('@');
      if (parts.length != 2 || parts[0].isEmpty || parts[1].isEmpty) {
        return false;
      }

      // Right side of '@' must have '.'
      if (!parts[1].contains('.')) return false;

      return true;
    }

    // check password valid
    bool isValidPassword(String password) {
      if (password.length < 6 || password.length > 32) {
        return false; // 6 - 32 characters
      }
      bool hasUppercase =
          password.contains(RegExp(r'[A-Z]')); // uppercase letter
      bool hasLowercase =
          password.contains(RegExp(r'[a-z]')); // lowercase letter
      bool hasDigit = password.contains(RegExp(r'[0-9]')); // number

      return hasUppercase && hasLowercase && hasDigit;
    }

    // submit
    Future<void> submitData() async {
      // information
      var email = emailController.text;
      var password = passwordController.text;
      var cfPassword = confirmPasswordController.text;

      setState(() {
        _emailValid = isValidEmail(email); // check email valid
        _passwordValid = isValidPassword(password); // check password valid

        // if sign-up
        if (!isLogin) {
          _isUsernameEmpty = usernameController.text.isEmpty;
          _cfPasswordValid = password == cfPassword; // confirm password
        }
      });

      if (_emailValid && _passwordValid && _cfPasswordValid) {
        if (isLogin) {
          // sign-in
          try {
            final result = await _authService.signIn(email, password);

            // after successfully log in
            if (result) {
              if (context.mounted) {
                const snackBar = SnackBar(
                  content: Text('Sign-in successfully.'),
                );

                // show snackbar
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                // go to home page
                context.go('/');
              }
            } else {
              // email or password is invalid
              setState(() {
                _isSignInFailed = true;
              });
            }
          } catch (e) {
            showErrorModal(context, e.toString());
            print(e);
          }
        } else {
          // sign-up
          try {
            final result = await _authService.signUp(
                usernameController.text, email, password);

            var data = json.decode(result);
            print(data);

            if (context.mounted && data.containsKey('user')) {
              const snackBar = SnackBar(
                content: Text('Sign-up successfully.'),
              );

              // show snackbar
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              // go to login page
              context.go('/login');
            }
          } catch (e) {
            print(e);
          }
        }
      } else {
        return;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
            // Added SingleChildScrollView here
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
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
                      'Luna',
                      style: TextStyle(
                        fontSize: 45,
                        fontFamily: 'Mokoto',
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    // Registration fields for non-login state
                    if (!isLogin) ...[
                      TextField(
                        controller: usernameController,
                        decoration: usernameFieldDecoration,
                      ),
                      const SizedBox(height: 10),
                    ],
                    if (!isLogin && _isUsernameEmpty) ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '* Please enter username.',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ],
                    TextField(
                      controller: emailController,
                      decoration: emailFieldDecoration,
                    ),
                    if (!_emailValid) ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '* Please enter a valid email.',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ],
                    const SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      obscureText: !_pwdVisibility,
                      decoration: passwordFieldDecoration(
                          hintText: 'Enter your password',
                          obscureText: !_pwdVisibility,
                          onToggleVisibility: () {
                            setState(() {
                              _pwdVisibility = !_pwdVisibility;
                            });
                          }),
                    ),
                    if (_isSignInFailed) ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '* Invalid email or password.',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ],
                    if (!_passwordValid) ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '* Password must be 6-32 characters long and include '
                          'uppercase letters, lowercase letters, and numbers.',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ],
                    const SizedBox(height: 10),
                    if (!isLogin) ...[
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: !_cfPwdVisibility,
                        decoration: passwordFieldDecoration(
                            hintText: 'Confirm your password',
                            obscureText: !_cfPwdVisibility,
                            onToggleVisibility: () {
                              setState(() {
                                _cfPwdVisibility = !_cfPwdVisibility;
                              });
                            }),
                      ),
                      if (!isLogin && !_cfPasswordValid) ...[
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '* Confirm password is not correct.',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                      const SizedBox(height: 10),
                    ],
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
                  ],
                ),

                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        isLogin
                            ? context.go('/register')
                            : context.go('/login');
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
                    ),
                  ],
                )
                // Switch between Login and Register
              ],
            ),
          ),
        )),
      ),
    );
  }
}
