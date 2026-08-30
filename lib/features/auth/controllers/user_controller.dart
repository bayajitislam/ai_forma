import 'package:ai_forma/core/constants/api_endpoint.dart';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:ai_forma/core/storage/auth_storage.dart';
import 'package:ai_forma/core/failure/failure.dart';
import 'package:ai_forma/features/auth/models/login_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import 'package:ai_forma/core/services/push_notification_service.dart';

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
    if (user != null) {
      PushNotificationService.instance.registerCurrentToken();
    }
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
  Future<Either<Failure, UserModel>> updateProfile(
    Map<String, dynamic> updateData,
  ) async {
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

  /// Upload profile image via PATCH /api/auth/profile/ with multipart/form-data
  Future<Either<Failure, UserModel>> updateProfileImage(String filePath) async {
    isLoading(true);
    errorMessage('');

    try {
      final formData = FormData.fromMap({
        'profile_image': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });

      final response = await _dio.patch(
        ApiEndpoint.profile,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
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
        currentUser.value = updatedUser;
        await AuthStorage.saveUser(updatedUser);

        isLoading(false);
        return Right(updatedUser);
      }

      isLoading(false);
      return Left(ServerFailure(message: 'Failed to upload image.'));
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
      final failure = ServerFailure(message: 'Unexpected error: $e');
      errorMessage(failure.message);
      return Left(failure);
    }
  }

  /// Update currentUser state and save to local storage
  Future<void> setUser(UserModel user) async {
    currentUser.value = user;
    await AuthStorage.saveUser(user);
    PushNotificationService.instance.registerCurrentToken();
  }

  /// Logout and clear user session
  Future<void> logout() async {
    await PushNotificationService.instance.unregisterTokenFromBackend();
    currentUser.value = null;
    await AuthStorage.clearSession();
  }

  /// Permanently delete user account via DELETE /api/auth/delete-account/
  Future<Either<Failure, String>> deleteAccount() async {
    isLoading(true);
    errorMessage('');

    try {
      final response = await _dio.delete(ApiEndpoint.deleteAccount);

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Clear all local data
        currentUser.value = null;
        await AuthStorage.clearSession();

        isLoading(false);
        final detail = (response.data is Map<String, dynamic>)
            ? (response.data['detail']?.toString() ??
                  'Account deleted successfully.')
            : 'Account deleted successfully.';
        return Right(detail);
      }

      isLoading(false);
      return Left(ServerFailure(message: 'Failed to delete account.'));
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
      final failure = ServerFailure(message: 'Unexpected error: $e');
      errorMessage(failure.message);
      return Left(failure);
    }
  }
}
