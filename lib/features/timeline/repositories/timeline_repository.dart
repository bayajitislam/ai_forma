import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/failure/failure.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/features/timeline/models/timeline_history_model.dart';
import 'package:ai_forma/features/timeline/models/timeline_overview_model.dart';
import 'package:ai_forma/features/timeline/models/timeline_scan_detail_model.dart';
import 'package:ai_forma/features/timeline/models/timeline_trends_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class TimelineRepository {
  final DioClient _dio;
  TimelineRepository(this._dio);

  /// GET /api/timeline/overview/?weeks=8
  Future<Either<Failure, TimelineOverviewResponseModel>> getOverview({int weeks = 8}) async {
    try {
      final response = await _dio.get(
        ApiEndpoint.timelineOverview,
        queryParameters: {'weeks': weeks},
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data is Map<String, dynamic>) {
        return Right(
          TimelineOverviewResponseModel.fromJson(
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

  /// GET /api/timeline/trends/?range=4w
  Future<Either<Failure, TimelineTrendsResponseModel>> getTrends({String range = '4w'}) async {
    try {
      final response = await _dio.get(
        ApiEndpoint.timelineTrends,
        queryParameters: {'range': range},
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data is Map<String, dynamic>) {
        return Right(
          TimelineTrendsResponseModel.fromJson(
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

  /// GET /api/timeline/history/?page=1
  Future<Either<Failure, TimelineHistoryResponseModel>> getHistory({int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiEndpoint.timelineHistory,
        queryParameters: {'page': page},
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data is Map<String, dynamic>) {
        return Right(
          TimelineHistoryResponseModel.fromJson(
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

  /// GET /api/timeline/scans/{id}/
  Future<Either<Failure, TimelineScanDetailResponseModel>> getScanDetail(String id) async {
    try {
      final response = await _dio.get(
        ApiEndpoint.timelineScanDetail(id),
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data is Map<String, dynamic>) {
        return Right(
          TimelineScanDetailResponseModel.fromJson(
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
