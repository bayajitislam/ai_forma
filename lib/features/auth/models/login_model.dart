class LoginModel {
  final String email;
  final String password;

  LoginModel({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class UserModel {
  final int id;
  final String email;
  final String fullName;
  final String? gender;
  final bool isEmailVerified;
  final bool onboardingCompleted;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.gender,
    required this.isEmailVerified,
    required this.onboardingCompleted,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      gender: json['gender'],
      isEmailVerified: json['is_email_verified'] ?? false,
      onboardingCompleted: json['onboarding_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'full_name': fullName,
        'gender': gender,
        'is_email_verified': isEmailVerified,
        'onboarding_completed': onboardingCompleted,
      };
}

class TokenModel {
  final String access;
  final String refresh;

  TokenModel({required this.access, required this.refresh});

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      access: json['access'] ?? '',
      refresh: json['refresh'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'access': access,
        'refresh': refresh,
      };
}

class LoginResponseModel {
  final UserModel user;
  final TokenModel tokens;

  LoginResponseModel({required this.user, required this.tokens});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      user: UserModel.fromJson(json['user'] ?? {}),
      tokens: TokenModel.fromJson(json['tokens'] ?? {}),
    );
  }
}
