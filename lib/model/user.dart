class User {
  final String username;
  final String avatarUrl;
  final String bio;
  final int followers;
  final int following;

  User({
    required this.username,
    required this.avatarUrl,
    required this.bio,
    required this.followers,
    required this.following,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['login'],
      avatarUrl: json['avatar_url'],
      bio: json['bio'] ?? '',
      followers: json['followers'],
      following: json['following'],
    );
  }
}
