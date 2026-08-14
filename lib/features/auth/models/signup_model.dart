class SignupModel {
  String fullName;
  String email;
  String password;

  SignupModel({
    required this.fullName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "email": email,
    "password": password,
  };

  factory SignupModel.fromJson(Map<String, dynamic> json) => SignupModel(
    fullName: json['full_name'],
    email: json['email'],
    password: json['password'],
  );
}

//Server Response Model
class SignupResponseModel {
  String? details;
  String? email;

  SignupResponseModel({this.details, this.email});

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) =>
      SignupResponseModel(details: json['details'], email: json['email']);
}
