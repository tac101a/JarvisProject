class User {
  static late String id;
  static late String username;
  static late String email;
  static bool isSignedIn = false;

  static String accessToken = '';
  static String refreshToken = '';

  static void init(String id, String username, String email) {
    User.id = id;
    User.username = username;
    User.email = email;
  }

  static void setToken(String accessToken, String refreshToken) {
    User.accessToken = accessToken;
    User.refreshToken = refreshToken;
  }
}
