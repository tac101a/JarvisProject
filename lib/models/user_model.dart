class User {
  static late String id;
  static late String username;
  static late String email;
  static bool isSignedIn = false;

  static int remainingUsage = 0;
  static bool unlimited = false;

  static String accessToken = '';
  static String refreshToken = '';

  static String kbAccessToken = '';
  static String kbRefreshToken = '';

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
