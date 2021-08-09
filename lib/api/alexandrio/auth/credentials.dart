class Credentials {
  final String username;
  final String email;
  final String password;
  final String authToken;
  final String refreshToken;

  Credentials({
    required this.username,
    required this.email,
    required this.password,
    required this.authToken,
    required this.refreshToken,
  });
}
