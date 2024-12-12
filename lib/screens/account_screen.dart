import 'package:flutter/material.dart';

import '../models/user_model.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person, size: 40),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    User.username,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Account'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Billing'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.card_giftcard),
              title: const Text('Reward'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Tutorial'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: 'Profile'),
            SettingsCard(
              title: 'AI Jarvis',
              subtitle: 'UID: ${User.id}',
              trailing:
                  TextButton(onPressed: () {}, child: const Text('Change')),
            ),
            SettingsCard(
              title: 'Email',
              subtitle: User.email,
              trailing:
                  TextButton(onPressed: () {}, child: const Text('Change')),
            ),
            SettingsCard(
              title: 'Password',
              subtitle: 'Set a password to enable password login',
              trailing: TextButton(
                  onPressed: () {}, child: const Text('Set Password')),
            ),
            const SectionTitle(title: 'Linked Account'),
            const SettingsCard(
              title: 'Google',
              subtitle: 'myjarvischat@gmail.com',
              trailing: Icon(Icons.link),
            ),
            const SectionTitle(title: 'Email Preferences'),
            SettingsCard(
              title: 'Notifications will be sent to this email',
              subtitle: 'myjarvischat@gmail.com',
              trailing:
                  TextButton(onPressed: () {}, child: const Text('Change')),
            ),
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
