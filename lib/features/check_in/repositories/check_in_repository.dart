import 'dart:io';

import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/failure/failure.dart';
import 'package:ai_forma/features/check_in/models/scan_validation_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class CheckInRepository {
  final DioClient _dio;
  CheckInRepository(this._dio);

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
        final detail = (rawData != null && rawData.isNotEmpty && rawData.length < 200)
            ? rawData
            : e.response?.statusMessage ?? 'Server error';
        return Left(ServerFailure(message: 'Server error ($statusCode): $detail'));
      }
      return Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }
}
