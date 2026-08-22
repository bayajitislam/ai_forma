import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/failure/failure.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/features/profile/models/bug_report_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class BugReportRepository {
  final DioClient _dio;
  BugReportRepository(this._dio);

  /// Send bug report to POST /api/bug-reports/
  Future<Either<Failure, BugReportResponseModel>> submitBugReport({
    required String title,
    required String description,
    String? imagePath,
  }) async {
    try {
      final formDataMap = <String, dynamic>{
        'title': title,
        'description': description,
      };

      if (imagePath != null && imagePath.isNotEmpty) {
        formDataMap['image'] = await MultipartFile.fromFile(imagePath);
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiEndpoint.bugReports,
        data: formData,
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data is Map<String, dynamic>) {
        return Right(
          BugReportResponseModel.fromJson(
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
