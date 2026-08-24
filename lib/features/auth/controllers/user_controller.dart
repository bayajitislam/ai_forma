import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/core/failure/failure.dart';
import 'package:ai_forma/features/auth/models/login_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final DioClient _dio;
  UserController(this._dio);

  /// Reactive user model accessible anywhere in the app via `Get.find<UserController>().currentUser.value`
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  /// Load user profile from local storage on app initialization
  Future<void> _loadUserFromStorage() async {
    final user = await AuthStorage.getUser();
    currentUser.value = user;
  }

  /// Fetch updated user profile from GET /api/auth/me/
  Future<Either<Failure, UserModel>> fetchProfile() async {
    isLoading(true);
    errorMessage('');

    try {
      final token = await AuthStorage.getAccessToken();

      final response = await _dio.get(
        ApiEndpoint.me,
        options: Options(
          headers: {
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
        ),
      );

      Map<String, dynamic>? userMap;
      if (response.data is Map<String, dynamic>) {
        final map = response.data as Map<String, dynamic>;
        if (map['user'] is Map<String, dynamic>) {
          userMap = map['user'] as Map<String, dynamic>;
        } else {
          userMap = map;
        }
      }

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          userMap != null) {
        final updatedUser = UserModel.fromJson(userMap);

        // Update reactive state
        currentUser.value = updatedUser;

        // Persist to local storage
        await AuthStorage.saveUser(updatedUser);

        isLoading(false);
        return Right(updatedUser);
      }

      isLoading(false);
      return Left(ServerFailure());
    } on DioException catch (e) {
      isLoading(false);
      if (e.response?.data is Map<String, dynamic>) {
        final message = ApiFailure.parseMessage(
          e.response!.data as Map<String, dynamic>,
        );
        errorMessage(message);
        return Left(ApiFailure(message: message));
      }
      final failure = NetworkFailure();
      errorMessage(failure.message);
      return Left(failure);
    } catch (e) {
      isLoading(false);
      final failure = ServerFailure();
      errorMessage(failure.message);
      return Left(failure);
    }
  }

  /// Update user profile details via PATCH /api/auth/profile/
  Future<Either<Failure, UserModel>> updateProfile(Map<String, dynamic> updateData) async {
    isLoading(true);
    errorMessage('');

    try {
      final token = await AuthStorage.getAccessToken();

      final response = await _dio.patch(
        ApiEndpoint.profile,
        data: updateData,
        options: Options(
          headers: {
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
        ),
      );

      Map<String, dynamic>? userMap;
      if (response.data is Map<String, dynamic>) {
        final map = response.data as Map<String, dynamic>;
        if (map['user'] is Map<String, dynamic>) {
          userMap = map['user'] as Map<String, dynamic>;
        } else {
          userMap = map;
        }
      }

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          userMap != null) {
        final updatedUser = UserModel.fromJson(userMap);

        // Update reactive state
        currentUser.value = updatedUser;

        // Persist to local storage
        await AuthStorage.saveUser(updatedUser);

        isLoading(false);
        return Right(updatedUser);
      }

      isLoading(false);
      return Left(ServerFailure());
    } on DioException catch (e) {
      isLoading(false);
      if (e.response?.data is Map<String, dynamic>) {
        final message = ApiFailure.parseMessage(
          e.response!.data as Map<String, dynamic>,
        );
        errorMessage(message);
        return Left(ApiFailure(message: message));
      }
      final failure = NetworkFailure();
      errorMessage(failure.message);
      return Left(failure);
    } catch (e) {
      isLoading(false);
      final failure = ServerFailure();
      errorMessage(failure.message);
      return Left(failure);
    }
  }

  /// Update currentUser state and save to local storage
  Future<void> setUser(UserModel user) async {
    currentUser.value = user;
    await AuthStorage.saveUser(user);
  }

  /// Logout and clear user session
  Future<void> logout() async {
    currentUser.value = null;
    await AuthStorage.clearSession();
  }
}
