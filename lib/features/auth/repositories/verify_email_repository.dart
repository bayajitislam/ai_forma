import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/failure/failure.dart';
import 'package:ai_forma/features/auth/models/verify_email_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class VerifyEmailRepository {
  final DioClient _dio;
  VerifyEmailRepository({required this._dio});

  Future<Either<Failure, bool>> verifyEmail(
    VerifyEmailModel verifyEmailModel,
  ) async {
    try {
      //call api
      final res = await _dio.post(
        ApiEndpoint.verifyEmail,
        data: verifyEmailModel.toJson(),
      );

      //Success: email verified
      if (res.statusCode == 200 &&
          res.data['user']['is_email_verified'] == true) {
        return const Right(true);
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

  Future<Either<Failure, String>> resendCode(String email) async {
    try {
      final res = await _dio.post(
        ApiEndpoint.resendOtp,
        data: {'email': email},
      );

      if (res.statusCode == 200) {
        final detail = res.data['detail']?.toString() ??
            'A new code has been sent if the account is eligible.';
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
