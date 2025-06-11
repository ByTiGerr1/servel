class UserProfile {
  final int id;
  final String username;
  final String? email;
  final String? firstName;
  final String? lastName;

  UserProfile({
    required this.id,
    required this.username,
    this.email,
    this.firstName,
    this.lastName,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      username: json['username'] as String,
      email: json['email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
    );
  }
}
