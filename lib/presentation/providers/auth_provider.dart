import 'package:auth0/data/repository/auth0_repository.dart';
import 'package:auth0/presentation/providers/auth_state.dart';
import 'package:riverpod/riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final auth0NotifierProvider = StateNotifierProvider<Auth0Controller, Auth0State>(
  (ref) => Auth0Controller(),
);

class Auth0Controller extends StateNotifier<Auth0State> {
  Auth0Controller() : super(const Auth0State());

  final repository = Auth0Repository();
  final storage =  const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  Future<void> initAction() async {
    state = state.copyWith(isBusy: true);
    try {
      final storedRefreshToken = await storage.read(key: 'refresh_token');

      if (storedRefreshToken == null) {
        state = state.copyWith(isBusy: false);
        return;
      }

      final data = await repository.initAction(storedRefreshToken);
      state = state.copyWith(isBusy: false, isLoggedIn: true, data: data);
    } on Exception catch (e, s) {
      debugPrint('login error: $e - stack: $s');
      logout();
    }
  }

  Future<void> login() async {
    state = state.copyWith(isBusy: true);
    try {
      final data = await repository.login();
      state = state.copyWith(isBusy: false, isLoggedIn: true, data: data);
    } on Exception catch (e, s) {
      debugPrint('login error: $e - stack: $s');
      state = state.copyWith(isBusy: false, isLoggedIn: false, errorMessage: e.toString());
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isBusy: true);
    await  storage.delete(key: 'refresh_token');
    state = state.copyWith(isBusy: false, isLoggedIn: false);
  }
}
