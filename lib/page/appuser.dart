class AppUser {
  final String uid;
  final String email;
  final String avatarUrl;
  final bool onlineStatus;

  AppUser({
    required this.uid,
    required this.email,
    required this.avatarUrl,
    required this.onlineStatus, // Ensure onlineStatus is provided
  });
}
