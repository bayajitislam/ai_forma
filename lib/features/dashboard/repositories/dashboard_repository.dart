import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/failure/failure.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/features/dashboard/models/home_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class DashboardRepository {
  final DioClient _dio;
  DashboardRepository(this._dio);

  /// Fetch Home tab data from GET /api/home/
  Future<Either<Failure, HomeResponseModel>> getHomeData() async {
    try {
      final response = await _dio.get(ApiEndpoint.homeData);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data is Map<String, dynamic>) {
        return Right(
          HomeResponseModel.fromJson(
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
      final statusCode = e.response?.statusCode;
      final rawData = e.response?.data?.toString();
      if (statusCode != null) {
        final detail =
            (rawData != null && rawData.isNotEmpty && rawData.length < 200)
                ? rawData
                : e.response?.statusMessage ?? 'Server error';
        return Left(
          ServerFailure(message: 'Server error ($statusCode): $detail'),
        );
      }
      return Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  /// Submit Daily Brief Answer to POST (new) or PATCH (update) /api/checkins/daily/
  Future<Either<Failure, Map<String, dynamic>>> submitDailyAnswer({
    required String questionKey,
    required String selectedOption,
    double? weightKg,
    bool alreadyAnswered = false,
  }) async {
    try {
      final payload = <String, dynamic>{
        'question_key': questionKey,
        'selected_option': selectedOption,
      };
      if (weightKg != null) {
        payload['weight_kg'] = weightKg;
      }

      late Response response;
      if (alreadyAnswered) {
        try {
          response = await _dio.patch(
            ApiEndpoint.dailyCheckIn,
            data: payload,
          );
        } on DioException catch (e) {
          if (e.response?.statusCode == 404) {
            response = await _dio.post(
              ApiEndpoint.dailyCheckIn,
              data: payload,
            );
          } else {
            rethrow;
          }
        }
      } else {
        try {
          response = await _dio.post(
            ApiEndpoint.dailyCheckIn,
            data: payload,
          );
        } on DioException catch (e) {
          if (e.response?.statusCode == 400 || e.response?.statusCode == 409) {
            response = await _dio.patch(
              ApiEndpoint.dailyCheckIn,
              data: payload,
            );
          } else {
            rethrow;
          }
        }
      }

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data is Map<String, dynamic>) {
        return Right(response.data as Map<String, dynamic>);
      }

      return Left(ServerFailure());
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final message = ApiFailure.parseMessage(
          e.response!.data as Map<String, dynamic>,
        );
        return Left(ApiFailure(message: message));
      }
      final statusCode = e.response?.statusCode;
      final rawData = e.response?.data?.toString();
      if (statusCode != null) {
        final detail =
            (rawData != null && rawData.isNotEmpty && rawData.length < 200)
                ? rawData
                : e.response?.statusMessage ?? 'Server error';
        return Left(
          ServerFailure(message: 'Server error ($statusCode): $detail'),
        );
      }
      return Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  /// Submit Scan Day Weight to POST /api/checkins/cycle-weight/
  Future<Either<Failure, Map<String, dynamic>>> submitScanDayWeight({
    required double weightKg,
    int? cycleId,
  }) async {
    try {
      final payload = <String, dynamic>{
        'weight_kg': weightKg,
      };
      if (cycleId != null) {
        payload['cycle_id'] = cycleId;
      }

      final response = await _dio.post(
        ApiEndpoint.scanDayWeight,
        data: payload,
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data is Map<String, dynamic>) {
        return Right(response.data as Map<String, dynamic>);
      }

      return Left(ServerFailure());
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final message = ApiFailure.parseMessage(
          e.response!.data as Map<String, dynamic>,
        );
        return Left(ApiFailure(message: message));
      }
      return Left(ServerFailure(message: 'Failed to record weight'));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }
}
