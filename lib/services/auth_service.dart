import 'dart:convert';

import 'package:jarvis_project/models/user_model.dart';

import 'api_service.dart';
import '../util/storage.dart';

class AuthService {
  final Storage _secureStorageService = Storage();

  // sign-in
  Future<bool> signIn(String email, String password) async {
    try {
      final response =
          await apiService.signIn({'email': email, 'password': password});

      var data = json.decode(response.body);
      print(data);

      if (response.statusCode == 200) {
        // sign-in successfully
        String accessToken = data['token']['accessToken'];
        String refreshToken = data['token']['refreshToken'];

        // save token
        await _secureStorageService.saveToken('accessToken', accessToken);
        await _secureStorageService.saveToken('refreshToken', refreshToken);

        // get user info
        await getUser();

        return true;
      } else {
        // invalid email or password
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // sign-up
  Future<String> signUp(String username, String email, String password) async {
    try {
      final response = await apiService
          .signUp({'email': email, 'password': password, 'username': username});

      return response.body;
    } catch (e) {
      throw Exception(e);
    }
  }

  // sign-out and delete all token
  Future<void> signOut() async {
    try {
      final response = await apiService.signOut();

      if (response.statusCode == 200) {
        User.isSignedIn = false;
        await _secureStorageService.deleteAll();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // check if user has signed in or not
  Future<bool> isSignedIn() async {
    String? token = await _secureStorageService.getToken('accessToken');
    bool result = token != null && token.isNotEmpty;
    if (result) {
      User.accessToken = token;
      User.isSignedIn = result;
    }
    return result;
  }

  // kb sign in
  Future<bool> kbSignIn() async {
    try {
      var response = await apiService.kbSignIn();

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        User.kbAccessToken = data['token']['accessToken'];
        User.kbRefreshToken = data['token']['refreshToken'];
        print(data['token']);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // get user information
  Future<bool> getUser() async {
    try {
      if (await isSignedIn()) {
        String? token = await _secureStorageService.getToken('refreshToken');
        if (token != null && token.isNotEmpty) {
          User.refreshToken = token;
        }

        final response = await apiService.getUser();
        var userInf = json.decode(response.body);
        User.init(userInf['id'], userInf['username'], userInf['email']);

        await kbSignIn();
        return true;
      } else {
        return false;
      }

      // if (response.statusCode == 200) {
      //   // success
      //   return response.body;
      // } else {
      //   // Unauthorized
      //   // get new token
      //   final refreshToken =
      //       await _secureStorageService.getToken('refreshToken');
      //   final requestNewToken = await _apiService.refreshToken(refreshToken!);
      //   var newToken =
      //       json.decode(requestNewToken.body)['token']['accessToken'];
      // }
    } catch (e) {
      throw Exception(e);
    }
  }
}
