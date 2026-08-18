import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/failure/failure.dart';
import 'package:ai_forma/features/auth/models/login_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class LoginRepository {
  final DioClient _dio;
  LoginRepository(this._dio);

  Future<Either<Failure, LoginResponseModel>> login(LoginModel model) async {
    try {
      final response = await _dio.post(
        ApiEndpoint.login,
        data: model.toJson(),
      );

      if (response.statusCode == 200) {
        return Right(LoginResponseModel.fromJson(response.data));
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
