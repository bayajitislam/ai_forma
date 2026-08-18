import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/failure/failure.dart';
import 'package:ai_forma/features/onboarding_assessment/models/onboarding_schema_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AssessmentRepository {
  final DioClient _dio;
  AssessmentRepository(this._dio);

  /// Fetch onboarding schema steps from GET /api/onboarding/schema/
  Future<Either<Failure, OnboardingSchemaModel>> getSchema() async {
    try {
      final response = await _dio.get(ApiEndpoint.onboardingSchema);

      if (response.statusCode == 200 && response.data != null) {
        final schema = OnboardingSchemaModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        return Right(schema);
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

  /// Submit collected onboarding answers to POST /api/onboarding/complete/
  Future<Either<Failure, bool>> completeOnboarding(
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await _dio.post(
        ApiEndpoint.onboardingComplete,
        data: payload,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
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
}
