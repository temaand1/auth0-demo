import 'package:auth0/contants/auth_contants.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth0Repository {
  Future<Map<String, Object>> initAction(String storedRefreshToken) async {
    final response = await _tokenRequest(storedRefreshToken);

    final idToken = _parseIdToken(response?.idToken);
    final profile = await _getUserDetails(response?.accessToken);

    const FlutterSecureStorage()
        .write(key: 'refresh_token', value: response!.refreshToken);

    return {...idToken, ...profile};
  }

  Future<TokenResponse?> _tokenRequest(String? storedRefreshToken) async {
    return await const FlutterAppAuth().token(TokenRequest(
      AUTH0_CLIENT_ID,
      AUTH0_REDIRECT_URI,
      issuer: AUTH0_ISSUER,
      refreshToken: storedRefreshToken,
    ));
  }

  Future<Map<String, Object>> login() async {
    final AuthorizationTokenResponse? result = await _authorizeExchange();

    final Map<String, Object> idToken = _parseIdToken(result?.idToken);
    final Map<String, Object> profile =
        await _getUserDetails(result?.accessToken);

    await const FlutterSecureStorage()
        .write(key: 'refresh_token', value: result!.refreshToken);
    return {...idToken, ...profile};
  }

  Future<AuthorizationTokenResponse?> _authorizeExchange() async {
    return await const FlutterAppAuth().authorizeAndExchangeCode(
      AuthorizationTokenRequest(
          AUTH0_CLIENT_ID, AUTH0_REDIRECT_URI,
          issuer: AUTH0_DOMAIN,
          scopes: <String>['openid', 'profile', 'offline_access', 'email'],
          promptValues: ['login']),
    );
  }

  Map<String, Object> _parseIdToken(String? idToken) {
    final List<String> parts = idToken!.split('.');
    assert(parts.length == 3);

    return Map<String, Object>.from(jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])))));
  }

  Future<Map<String, Object>> _getUserDetails(String? accessToken) async {
    final http.Response response = await http.get(
      Uri.parse('$AUTH0_DOMAIN/userinfo'),
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return Map<String, Object>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get user details');
    }
  }
}