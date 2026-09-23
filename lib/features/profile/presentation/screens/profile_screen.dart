import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: user == null
          ? Center(child: Text(l10n.noUserConnected))
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const CircleAvatar(
                  radius: 48,
                  child: Icon(Icons.person, size: 52),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.myAccount,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  user.email ?? l10n.emailNotAvailable,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: Text(l10n.emailAddress),
                    subtitle: Text(user.email ?? l10n.notAvailable),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.verified_user_outlined),
                    title: Text(l10n.status),
                    subtitle: Text(l10n.accountConnected),
                  ),
                ),
                const SizedBox(height: 32),
                Semantics(
                  button: true,
                  label: l10n.logout,
                  child: FilledButton.icon(
                    onPressed: () async {
                      await ref.read(authControllerProvider.notifier).logout();
                    },
                    icon: const Icon(Icons.logout),
                    label: Text(l10n.logout),
                  ),
                ),
              ],
            ),
    );
  }
}
