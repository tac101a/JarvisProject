import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:jarvis_project/components/error_modal.dart';
import 'package:jarvis_project/screens/auth_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AccountPage extends StatelessWidget {
  AccountPage({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: 'Profile'),
            SettingsCard(
                title: 'Username',
                subtitle: User.username,
                trailing: Container()),
            SettingsCard(
              title: 'UID',
              subtitle: User.id,
              trailing: TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: User.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard!')),
                    );
                  },
                  child: const Text('Copy')),
            ),
            SettingsCard(
              title: 'Email',
              subtitle: User.email,
              trailing: TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: User.email));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard!')),
                    );
                  },
                  child: const Text('Copy')),
            ),
            // Center(
            //   child: Container(
            //     margin: const EdgeInsets.symmetric(vertical: 8),
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 60, vertical: 24),
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(12),
            //         gradient: LinearGradient(colors: [
            //           Colors.purple.shade100,
            //           Colors.blue.shade100,
            //           Colors.purple.shade100
            //         ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
            //     child: Column(
            //       children: [
            //         const Text('Become Premium User'),
            //         const SizedBox(
            //           height: 8,
            //         ),
            //         ElevatedButton(
            //             onPressed: () {
            //               try {
            //                 final url = Uri.parse(
            //                     'https://admin.dev.jarvis.cx/pricing/overview');
            //
            //                 launchUrl(url,
            //                     mode: LaunchMode.externalApplication);
            //               } catch (e) {
            //                 showErrorModal(context, e.toString());
            //               }
            //             },
            //             child: const Text('Subscribe here'))
            //       ],
            //     ),
            //   ),
            // ),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ListTile(
                onTap: () async {
                  await _authService.signOut();

                  if (!User.isSignedIn && context.mounted) {
                    context.go('/loading');
                  }
                },
                title: const Row(
                  children: [
                    Text(
                      'Sign Out',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;

  const SettingsCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey),
                  softWrap: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          trailing,
        ],
      ),
    );
  }
}
