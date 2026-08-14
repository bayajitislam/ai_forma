class VerifyCodeResponseModel {
  final String detail;
  final String resetToken;
  final String email;

  VerifyCodeResponseModel({
    required this.detail,
    required this.resetToken,
    required this.email,
  });

  factory VerifyCodeResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyCodeResponseModel(
      detail: json['detail'] ?? '',
      resetToken: json['reset_token'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
