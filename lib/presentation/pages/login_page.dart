import 'package:auth0/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton(
        child: const Text('Login'),
        onPressed: () {
          ref.read(auth0NotifierProvider.notifier).login();
        },
      ),
    );
  }
}

