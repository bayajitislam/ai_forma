import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/failure/failure.dart';
import 'package:ai_forma/features/auth/models/signup_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class SignupRepository {
  final DioClient _dio;
  SignupRepository({required this._dio});

  //Signup
  Future<Either<Failure, SignupResponseModel>> signUp(SignupModel model) async {
    try {
      //API call
      final response = await _dio.post(
        ApiEndpoint.register,
        data: model.toJson(),
      );
      //Success
      return Right(SignupResponseModel.fromJson(response.data));
    } on DioException catch (e) {
      // e.response != null → backend replied with 4xx/5xx + a body
      // e.response == null → real network issue (no internet, timeout)
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
