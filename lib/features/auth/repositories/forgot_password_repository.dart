import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/failure/failure.dart';
import 'package:ai_forma/features/auth/models/forgot_password_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ForgotPasswordRepository {
  final DioClient _dio;
  ForgotPasswordRepository(this._dio);

  /// Send forgot password request to GET /api/auth/password/forgot/
  Future<Either<Failure, String>> forgotPassword(String email) async {
    try {
      final response = await _dio.post(
        ApiEndpoint.forgotPassword,
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        final detail = response.data['detail']?.toString() ??
            'Password reset code sent successfully.';
        return Right(detail);
      }

      return Left(ServerFailure());
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final message = ApiFailure.parseMessage(
          e.response!.data as Map<String, dynamic>,
        );
        return Left(ApiFailure(message: message));
      }
      return Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  /// Verify 6-digit reset code at POST /api/auth/password/verify-code/
  Future<Either<Failure, VerifyCodeResponseModel>> verifyResetCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoint.verifyResetCode,
        data: {
          'email': email,
          'code': code,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return Right(
          VerifyCodeResponseModel.fromJson(
            response.data as Map<String, dynamic>,
          ),
        );
      }

      return Left(ServerFailure());
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final message = ApiFailure.parseMessage(
          e.response!.data as Map<String, dynamic>,
        );
        return Left(ApiFailure(message: message));
      }
      return Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  /// Reset password at POST /api/auth/password/reset/
  Future<Either<Failure, String>> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoint.resetPassword,
        data: {
          'reset_token': resetToken,
          'password': newPassword,
        },
      );

      if (response.statusCode == 200) {
        final detail = response.data['detail']?.toString() ??
            'Password has been reset successfully.';
        return Right(detail);
      }

      return Left(ServerFailure());
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final message = ApiFailure.parseMessage(
          e.response!.data as Map<String, dynamic>,
        );
        return Left(ApiFailure(message: message));
      }
      return Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
