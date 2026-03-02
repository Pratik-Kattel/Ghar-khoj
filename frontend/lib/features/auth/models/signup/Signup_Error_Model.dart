class SignupErrorModel {
  final String message;
  final List<FieldErrors> errors;

  SignupErrorModel({required this.message, required this.errors});

  factory SignupErrorModel.fromJson(Map<String, dynamic> json) {
    return SignupErrorModel(
      message: json['message'] ?? '',
      errors:
          (json['errors'] as List<dynamic>?)
              ?.map((e) => FieldErrors.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class FieldErrors {
  final String code;
  final String message;
  final List<String> path;

  FieldErrors({required this.code, required this.message, required this.path});

  factory FieldErrors.fromJson(Map<String, dynamic> json) {
    return FieldErrors(
      code: json['code'],
      message: json['message'],
      path: List<String>.from(json['path'] ?? ''),
    );
  }
}
