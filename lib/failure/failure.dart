class Failure {
  final String message;

  Failure({required this.message});
}

class ServerFailure extends Failure {
  ServerFailure({
    super.message =
        'Server connection failed. Please check back in a few moments',
  });
}

class NetworkFailure extends Failure {
  NetworkFailure({
    super.message =
        'No internet connection detected. Please check your network and try again.',
  });
}

/// Used when the backend returns a 4xx with a validation/error body.
/// e.g. {"code": ["Invalid or expired verification code."]}
///      {"email": ["This email is already registered."]}
class ApiFailure extends Failure {
  ApiFailure({required super.message});

  /// Parses the backend error map and returns the first error string found.
  /// Works for any field name: "code", "email", "full_name", etc.
  static String parseMessage(Map<String, dynamic> data) {
    for (final value in data.values) {
      if (value is List && value.isNotEmpty) {
        return value.first.toString();
      }
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }
    return 'Something went wrong. Please try again.';
  }
}
