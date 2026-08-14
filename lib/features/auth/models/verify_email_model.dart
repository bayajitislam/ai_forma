class VerifyEmailModel {
  String email;
  String code;

  VerifyEmailModel({required this.email, required this.code});

  Map<String, dynamic> toJson() => {'email': email, 'code': code};

  factory VerifyEmailModel.fromJson(Map<String, dynamic> json) {
    return VerifyEmailModel(email: json['email'], code: json['code']);
  }
}