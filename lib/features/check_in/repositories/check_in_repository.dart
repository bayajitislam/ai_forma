import 'dart:io';

import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/failure/failure.dart';
import 'package:ai_forma/features/check_in/models/scan_validation_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class CheckInRepository {
  final DioClient _dio;
  CheckInRepository(this._dio);

  /// Get native device IANA timezone identifier (e.g. 'Australia/Sydney', 'Asia/Dhaka')
  static Future<String> _getDeviceIanaTimezone(String? customTz) async {
    if (customTz != null && customTz.isNotEmpty) {
      return customTz;
    }
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      final String deviceTz = tzInfo.identifier;
      if (deviceTz.isNotEmpty) return deviceTz;
    } catch (_) {}

    return 'UTC';
  }

  /// Validate front, side, and back images at POST /api/scans/validate-images/
  Future<Either<Failure, ScanValidationResponseModel>> validateScanImages({
    required File frontImage,
    required File sideImage,
    required File backImage,
  }) async {
    try {
      final formData = FormData.fromMap({
        'front_image': await MultipartFile.fromFile(
          frontImage.path,
          filename: 'front_image.jpg',
        ),
        'side_image': await MultipartFile.fromFile(
          sideImage.path,
          filename: 'side_image.jpg',
        ),
        'back_image': await MultipartFile.fromFile(
          backImage.path,
          filename: 'back_image.jpg',
        ),
      });

      final response = await _dio.post(
        ApiEndpoint.validateImages,
        data: formData,
      );

      if (response.statusCode == 200 && response.data != null) {
        return Right(
          ScanValidationResponseModel.fromJson(
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

  /// Create scan analysis with 3 images at POST /api/scans/
  Future<Either<Failure, Map<String, dynamic>>> createScan({
    required File frontImage,
    required File sideImage,
    required File backImage,
    String? timezone,
  }) async {
    try {
      final ianaTz = await _getDeviceIanaTimezone(timezone);

      final formDataMap = <String, dynamic>{
        'front_image': await MultipartFile.fromFile(
          frontImage.path,
          filename: 'front_image.jpg',
        ),
        'side_image': await MultipartFile.fromFile(
          sideImage.path,
          filename: 'side_image.jpg',
        ),
        'back_image': await MultipartFile.fromFile(
          backImage.path,
          filename: 'back_image.jpg',
        ),
        'timezone': ianaTz,
      };

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(ApiEndpoint.createScan, data: formData);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return Right(response.data as Map<String, dynamic>);
        }
        return const Right({});
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

  /// Weekly Check-in submission at POST /api/checkins/weekly/
  Future<Either<Failure, Map<String, dynamic>>> createWeeklyCheckin({
    required File frontImage,
    required File sideImage,
    required File backImage,
    String? timezone,
    double? weightKg,
  }) async {
    try {
      final ianaTz = await _getDeviceIanaTimezone(timezone);

      final formDataMap = <String, dynamic>{
        'front_image': await MultipartFile.fromFile(
          frontImage.path,
          filename: 'front_image.jpg',
        ),
        'side_image': await MultipartFile.fromFile(
          sideImage.path,
          filename: 'side_image.jpg',
        ),
        'back_image': await MultipartFile.fromFile(
          backImage.path,
          filename: 'back_image.jpg',
        ),
        'timezone': ianaTz,
      };

      if (weightKg != null) {
        formDataMap['weight_kg'] = weightKg;
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiEndpoint.weeklyCheckin,
        data: formData,
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return Right(response.data as Map<String, dynamic>);
        }
        return const Right({});
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
