import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../news/presentation/screens/main_screen.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () {
        final message =
            l10n?.checkingAuthentication ?? 'Checking authentication...';

        return Scaffold(
          body: Center(
            child: Semantics(
              label: message,
              child: const CircularProgressIndicator(),
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        final title =
            l10n?.authenticationError ?? 'Authentication error';

        final message = l10n?.authenticationCheckFailed ??
            'Unable to check authentication status.';

        final retryLabel = l10n?.retry ?? 'Retry';

        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Semantics(
                    label: title,
                    child: const Icon(
                      Icons.error_outline,
                      size: 56,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Semantics(
                    button: true,
                    label: retryLabel,
                    child: FilledButton.icon(
                      onPressed: () {
                        ref.invalidate(authStateProvider);
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text(retryLabel),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }

        return const MainScreen();
      },
    );
  }
}