import 'package:auth0/presentation/pages/login_page.dart';
import 'package:auth0/presentation/pages/profile_page.dart';
import 'package:auth0/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthApp extends HookConsumerWidget {
  const AuthApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth0State = ref.watch(auth0NotifierProvider);
    useEffect(() {
      Future.microtask(() async {
        ref.watch(auth0NotifierProvider.notifier).initAction();
      });
      return;
    }, const []);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Auth0',
          ),
        ),
        body: auth0State.isBusy
            ? const Center(child: CircularProgressIndicator())
            : auth0State.isLoggedIn
                ? const ProfilePage()
                : const LoginPage(),
      ),
    );
  }
}
