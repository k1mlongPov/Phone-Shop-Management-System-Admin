class UserModel {
  final String id;
  final String username;
  final String email;
  final String? phone;
  final bool verification;
  final bool phoneVerification;
  final String? profile;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.phone,
    required this.verification,
    required this.phoneVerification,
    this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      verification: json['verification'] as bool? ?? false,
      phoneVerification: json['phoneVerification'] as bool? ?? false,
      profile: json['profile'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'username': username,
        'email': email,
        'phone': phone,
        'verification': verification,
        'phoneVerification': phoneVerification,
        'profile': profile,
      };
}
