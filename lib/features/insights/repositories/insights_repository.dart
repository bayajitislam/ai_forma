import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/failure/failure.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/features/insights/models/fat_loss_detail_model.dart';
import 'package:ai_forma/features/insights/models/muscle_growth_detail_model.dart';
import 'package:ai_forma/features/insights/models/posture_detail_model.dart';
import 'package:ai_forma/features/insights/models/scan_latest_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class InsightsRepository {
  final DioClient _dio;
  InsightsRepository(this._dio);

  /// Fetch latest scan insights from GET /api/scans/latest/
  Future<Either<Failure, ScanLatestResponseModel>> getLatestScan() async {
    try {
      final response = await _dio.get(ApiEndpoint.latestScan);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data is Map<String, dynamic>) {
        return Right(
          ScanLatestResponseModel.fromJson(
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

  /// Fetch muscle growth detail insight from GET /api/insights/muscle-growth/
  Future<Either<Failure, MuscleGrowthDetailResponseModel>>
      getMuscleGrowthDetail() async {
    try {
      final response = await _dio.get(ApiEndpoint.muscleGrowthInsight);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data is Map<String, dynamic>) {
        return Right(
          MuscleGrowthDetailResponseModel.fromJson(
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

  /// Fetch fat loss detail insight from GET /api/insights/fat-loss/
  Future<Either<Failure, FatLossDetailResponseModel>> getFatLossDetail() async {
    try {
      final response = await _dio.get(ApiEndpoint.fatLossInsight);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data is Map<String, dynamic>) {
        return Right(
          FatLossDetailResponseModel.fromJson(
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

  /// Fetch posture detail insight from GET /api/insights/posture/
  Future<Either<Failure, PostureDetailResponseModel>> getPostureDetail() async {
    try {
      final response = await _dio.get(ApiEndpoint.postureInsight);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data is Map<String, dynamic>) {
        return Right(
          PostureDetailResponseModel.fromJson(
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
}
