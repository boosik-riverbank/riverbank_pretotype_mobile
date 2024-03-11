class User {
  User({required this.id, required this.name, required this.profileImageUrl, required this.email, required this.provider});

  final String id;
  final String name;
  final String? profileImageUrl;
  final String email;
  final String provider;

  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      profileImageUrl: json['profile_image_url'],
      email: json['email'],
      provider: json['provider']
    );
  }

  @override
  String toString() {
    return {
      id: id,
      name: name,
      profileImageUrl: profileImageUrl,
      email: email,
      provider: provider,
    }.toString();
  }
}