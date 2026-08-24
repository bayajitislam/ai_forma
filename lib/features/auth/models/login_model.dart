class LoginModel {
  final String email;
  final String password;

  LoginModel({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class UserProfileModel {
  final String? dateOfBirth;
  final int? age;
  final String? heightCm;
  final String? heightFt;
  final String? weightKg;
  final String? weightLbs;
  final String? goal;
  final String? experience;
  final String? sleepQuality;
  final String? activityLevel;
  final String? healthNotes;
  final String? menstrualCycle;
  final List<String>? supplements;
  final String? timezone;

  UserProfileModel({
    this.dateOfBirth,
    this.age,
    this.heightCm,
    this.heightFt,
    this.weightKg,
    this.weightLbs,
    this.goal,
    this.experience,
    this.sleepQuality,
    this.activityLevel,
    this.healthNotes,
    this.menstrualCycle,
    this.supplements,
    this.timezone,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      dateOfBirth: json['date_of_birth']?.toString(),
      age: (json['age'] as num?)?.toInt(),
      heightCm: json['height_cm']?.toString(),
      heightFt: json['height_ft']?.toString(),
      weightKg: json['weight_kg']?.toString(),
      weightLbs: json['weight_lbs']?.toString(),
      goal: json['goal']?.toString(),
      experience: json['experience']?.toString(),
      sleepQuality: json['sleep_quality']?.toString(),
      activityLevel: json['activity_level']?.toString(),
      healthNotes: json['health_notes']?.toString(),
      menstrualCycle: json['menstrual_cycle']?.toString(),
      supplements: json['supplements'] != null
          ? List<String>.from(json['supplements'].map((x) => x.toString()))
          : null,
      timezone: json['timezone']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'date_of_birth': dateOfBirth,
        'age': age,
        'height_cm': heightCm,
        'height_ft': heightFt,
        'weight_kg': weightKg,
        'weight_lbs': weightLbs,
        'goal': goal,
        'experience': experience,
        'sleep_quality': sleepQuality,
        'activity_level': activityLevel,
        'health_notes': healthNotes,
        'menstrual_cycle': menstrualCycle,
        'supplements': supplements,
        'timezone': timezone,
      };
}

class UserModel {
  final int id;
  final String email;
  final String fullName;
  final String? gender;
  final bool isEmailVerified;
  final bool onboardingCompleted;
  final bool initialScanCompleted;
  final String? nextStep;
  final UserProfileModel? profile;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.gender,
    required this.isEmailVerified,
    required this.onboardingCompleted,
    required this.initialScanCompleted,
    this.nextStep,
    this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      gender: json['gender'],
      isEmailVerified: json['is_email_verified'] ?? false,
      onboardingCompleted: json['onboarding_completed'] ?? false,
      initialScanCompleted: json['initial_scan_completed'] ?? false,
      nextStep: json['next_step']?.toString(),
      profile: json['profile'] != null && json['profile'] is Map<String, dynamic>
          ? UserProfileModel.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'full_name': fullName,
        'gender': gender,
        'is_email_verified': isEmailVerified,
        'onboarding_completed': onboardingCompleted,
        'initial_scan_completed': initialScanCompleted,
        'next_step': nextStep,
        'profile': profile?.toJson(),
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
