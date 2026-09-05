import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_text_styles.dart';
import 'package:ai_forma/core/widgets/app_bottom_sheet.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/check_in/models/checkin_status_model.dart';
import 'package:ai_forma/features/check_in/models/scan_validation_model.dart';
import 'package:ai_forma/features/check_in/repositories/check_in_repository.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_devlog/flutter_devlog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import 'package:ai_forma/features/auth/controllers/user_controller.dart';

/// Background isolate image processing helper to prevent main UI thread jank.
Uint8List? processCapturedImageBytes({
  required Uint8List rawBytes,
  required bool isFrontCamera,
  int quality = 90,
}) {
  try {
    final img.Image? decoded = img.decodeImage(rawBytes);
    if (decoded == null) return null;

    // 1. Bake EXIF orientation so image is 100% upright portrait mode (0° orientation)
    img.Image processed = img.bakeOrientation(decoded);

    // 2. Un-mirror front camera captures so final image matches true reality
    if (isFrontCamera) {
      processed = img.flipHorizontal(processed);
    }

    final encoded = img.encodeJpg(processed, quality: quality);
    return Uint8List.fromList(encoded);
  } catch (e) {
    return null;
  }
}

class CheckInController extends GetxController {
  final CheckInRepository repository;
  CheckInController({required this.repository});

  final ImagePicker _picker = ImagePicker();

  // Flag to force Weekly Check-In endpoint (POST /api/checkins/weekly/)
  final RxBool isWeeklyCheckIn = false.obs;

  // Check-In Day Preference
  final RxString selectedCheckDay = 'Sun'.obs;

  void setCheckDay(String day) {
    selectedCheckDay.value = day;
  }

  // Camera Controller State
  CameraController? cameraController;
  List<CameraDescription> availableCameraList = [];
  int selectedCameraIndex = 0;
  final RxBool isCameraInitialized = false.obs;
  final RxBool isCapturing = false.obs;

  // Scan Angle State: 'Front', 'Side', 'Back'
  final RxString currentAngle = 'Front'.obs;

  // Captured Image Files
  final Rx<File?> frontImage = Rx<File?>(null);
  final Rx<File?> sideImage = Rx<File?>(null);
  final Rx<File?> backImage = Rx<File?>(null);

  // Image Validation State
  final RxBool isValidating = false.obs;
  final Rx<ScanValidationResponseModel?> validationResult =
      Rx<ScanValidationResponseModel?>(null);
  final RxString errorMessage = ''.obs;

  // Check-In Status Data
  final Rx<CheckinStatusModel?> statusData = Rx<CheckinStatusModel?>(null);
  final RxBool isLoadingStatus = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStatusData();
  }

  /// Fetch Check-In Status from GET /api/checkins/status/
  Future<void> fetchStatusData({bool force = false}) async {
    if (!force && statusData.value != null && !isLoadingStatus.value) return;

    isLoadingStatus(true);
    try {
      final result = await repository.getCheckInStatus();
      result.fold(
        (failure) {
          DevLog.error('Failed to load checkin status: ${failure.message}');
        },
        (data) {
          statusData.value = data;
          selectedCheckDay.value = data.checkDay;
        },
      );
    } catch (e) {
      DevLog.error('Unexpected error fetching checkin status: $e');
    } finally {
      isLoadingStatus(false);
    }
  }

  /// Update weekly check-in day schedule at POST /api/checkins/schedule/
  Future<bool> updateCheckInDay(
    String newDay, {
    BuildContext? context,
  }) async {
    final result = await repository.updateScanSchedule(newDay);
    return result.fold(
      (failure) {
        errorMessage(failure.message);
        final activeContext = context ?? Get.context;
        if (activeContext != null) {
          showScheduleErrorPopup(activeContext, failure.message);
        } else {
          Get.snackbar(
            'Schedule Change Restricted',
            failure.message.isNotEmpty
                ? failure.message
                : 'Failed to update check-in day',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
          );
        }
        return false;
      },
      (data) {
        final confirmation = data['confirmation'] is Map<String, dynamic>
            ? data['confirmation'] as Map<String, dynamic>
            : null;

        final bool activeCycleExists = data['active_cycle_exists'] == true ||
            (confirmation?['has_bridge_days'] == true);
        final String? pendingScanDay = data['pending_scan_day']?.toString();
        final String? scanDay = data['scan_day']?.toString();

        final String popupTitle = confirmation?['title']?.toString() ??
            (activeCycleExists
                ? 'Scan Schedule Change Set'
                : 'Scan Schedule Updated');

        final String? nextScanLine = confirmation?['next_scan_line']?.toString();
        final List<dynamic>? bodyList = confirmation?['body'] as List<dynamic>?;
        final String bodyJoined = bodyList != null && bodyList.isNotEmpty
            ? bodyList.join('\n\n')
            : '';

        final String message = nextScanLine != null
            ? (bodyJoined.isNotEmpty ? '$nextScanLine\n\n$bodyJoined' : nextScanLine)
            : (data['message']?.toString() ?? 'Weekly scan day successfully updated.');

        if (scanDay != null && scanDay.isNotEmpty) {
          selectedCheckDay.value = scanDay;
        } else {
          selectedCheckDay.value = newDay;
        }

        fetchStatusData(force: true);

        final activeContext = context ?? Get.context;
        if (activeContext != null) {
          showScheduleSuccessPopup(
            activeContext,
            title: popupTitle,
            message: message,
            activeCycleExists: activeCycleExists,
            pendingScanDay: pendingScanDay,
          );
        } else {
          Get.snackbar(
            popupTitle,
            nextScanLine ?? message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.brandTeal,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
          );
        }
        return true;
      },
    );
  }

  /// Show popup confirmation dialog upon successful schedule change response
  void showScheduleSuccessPopup(
    BuildContext context, {
    String? title,
    required String message,
    bool activeCycleExists = false,
    String? pendingScanDay,
  }) {
    final displayTitle = title ??
        (activeCycleExists
            ? 'Scan Schedule Change Set'
            : 'Scan Schedule Updated');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.iconBackground,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.event_available_rounded,
                  size: 32,
                  color: AppColors.brandTeal,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              displayTitle,
              style: AppTextStyles.authSectionTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              onPressed: () => Navigator.of(ctx).pop(),
              label: 'GOT IT',
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// Show popup error dialog when schedule update fails (e.g. 7-day restriction)
  void showScheduleErrorPopup(BuildContext context, String message) {
    final cleanMsg = message.isNotEmpty
        ? message
        : 'You can only change your weekly check-in day once every 7 days.';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.calendar_month_rounded,
                  size: 32,
                  color: Colors.redAccent,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Schedule Change Restricted',
              style: AppTextStyles.authSectionTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              cleanMsg,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              onPressed: () => Navigator.of(ctx).pop(),
              label: 'GOT IT',
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }

  /// Safely dispose camera hardware when leaving camera screen
  Future<void> disposeCamera() async {
    final controllerToDispose = cameraController;
    cameraController = null;
    isCameraInitialized.value = false;
    await controllerToDispose?.dispose();
  }

  /// Initialize real device camera
  Future<void> initCamera() async {
    // If camera is already initialized and running, reuse it instantly without delay!
    if (cameraController != null && cameraController!.value.isInitialized) {
      isCameraInitialized(true);
      return;
    }

    try {
      if (availableCameraList.isEmpty) {
        availableCameraList = await availableCameras();
      }
      if (availableCameraList.isEmpty) {
        errorMessage('No camera found on this device.');
        return;
      }

      // Default to back camera if available
      selectedCameraIndex = availableCameraList.indexWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
      );
      if (selectedCameraIndex == -1) selectedCameraIndex = 0;

      await _initCameraController(availableCameraList[selectedCameraIndex]);
    } catch (e) {
      errorMessage('Failed to initialize camera: $e');
    }
  }

  Future<void> _initCameraController(CameraDescription camera) async {
    isCameraInitialized(false);
    await cameraController?.dispose();

    cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await cameraController!.initialize();
    isCameraInitialized(true);
  }

  /// Toggle between front and back cameras
  Future<void> toggleCamera() async {
    if (availableCameraList.length < 2) return;
    selectedCameraIndex =
        (selectedCameraIndex + 1) % availableCameraList.length;
    await _initCameraController(availableCameraList[selectedCameraIndex]);
  }

  /// Show Top Right "Tips" ⓘ Bottom Sheet Modal
  void showPhotoTips(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      title: 'Photo Tips',
      bulletPoints: const [
        'Use good, even lighting.',
        'Stand against a plain background.',
        'Keep your whole body inside the frame.',
        'Stand naturally and look straight ahead.',
        'Wear fitted clothing where possible.',
        'Avoid hats, bulky clothing and loose accessories.',
      ],
    );
  }

  /// Show Bottom Right "Guide" Bottom Sheet Modal for current pose
  void showPoseGuide(BuildContext context) {
    String title;
    List<String> points;

    switch (currentAngle.value) {
      case 'Side':
        title = 'Side Photo Guide';
        points = const [
          'Turn 90 degrees to face your left or right side.',
          'Stand straight with your posture natural.',
          'Keep your arms slightly away from your sides so your body outline is clear.',
          'Look straight ahead in the direction you are facing.',
          'Stay still until the photo is taken.',
        ];
        break;
      case 'Back':
        title = 'Back Photo Guide';
        points = const [
          'Turn around so your back faces the camera.',
          'Stand tall with your feet shoulder-width apart.',
          'Let your arms hang slightly away from your body.',
          'Keep your head level looking straight ahead.',
          'Stay still until the photo is taken.',
        ];
        break;
      case 'Front':
      default:
        title = 'Front Photo Guide';
        points = const [
          'Stand tall facing the camera.',
          'Keep your feet shoulder-width apart.',
          'Let your arms hang slightly away from your body.',
          'Keep your head level and look straight ahead.',
          'Stay still until the photo is taken.',
        ];
        break;
    }

    AppBottomSheet.show(context: context, title: title, bulletPoints: points);
  }

  /// Take photo for the active pose ('Front', 'Side', or 'Back')
  Future<File?> capturePhoto() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return null;
    }

    try {
      isCapturing(true);
      final xFile = await cameraController!.takePicture();
      final rawBytes = await xFile.readAsBytes();

      File file = File(xFile.path);

      final bool isFrontCamera = availableCameraList.isNotEmpty &&
          selectedCameraIndex < availableCameraList.length &&
          availableCameraList[selectedCameraIndex].lensDirection ==
              CameraLensDirection.front;

      // Offload orientation baking, un-mirroring, and JPEG re-encoding to a background isolate
      final processedBytes = await Isolate.run(() => processCapturedImageBytes(
            rawBytes: rawBytes,
            isFrontCamera: isFrontCamera,
            quality: 90,
          ));

      if (processedBytes != null) {
        await file.writeAsBytes(processedBytes);
      }

      if (currentAngle.value == 'Front') {
        frontImage.value = file;
      } else if (currentAngle.value == 'Side') {
        sideImage.value = file;
      } else if (currentAngle.value == 'Back') {
        backImage.value = file;
      }

      isCapturing(false);
      return file;
    } catch (e) {
      isCapturing(false);
      errorMessage('Error capturing photo: $e');
      return null;
    }
  }

  /// Pick image from gallery for testing / dev purposes
  Future<File?> pickFromGallery() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (picked != null) {
        final file = File(picked.path);
        if (currentAngle.value == 'Front') {
          frontImage.value = file;
        } else if (currentAngle.value == 'Side') {
          sideImage.value = file;
        } else if (currentAngle.value == 'Back') {
          backImage.value = file;
        }
        return file;
      }
    } catch (e) {
      DevLog.error('Error picking image from gallery: $e');
    }
    return null;
  }

  /// Reset all captured images to restart scan
  void resetScan() {
    frontImage.value = null;
    sideImage.value = null;
    backImage.value = null;
    currentAngle.value = 'Front';
    validationResult.value = null;
    errorMessage('');
  }

  /// Clear files for failed poses so user can retake them step-by-step
  void clearFailedImages() {
    final result = validationResult.value;
    if (result != null) {
      if (result.frontCheck?.isValid == false) frontImage.value = null;
      if (result.sideCheck?.isValid == false) sideImage.value = null;
      if (result.backCheck?.isValid == false) backImage.value = null;
    }
    validationResult.value = null;
  }

  /// Call POST /api/scans/validate-images/ with 3 captured files
  Future<bool> validateImages({bool force = false}) async {
    if (isValidating.value) return false;
    if (!force && validationResult.value != null && validationResult.value!.allValid) {
      return true;
    }
    if (frontImage.value == null ||
        sideImage.value == null ||
        backImage.value == null) {
      errorMessage(
        'Please capture front, side, and back photos before validating.',
      );
      return false;
    }

    isValidating(true);
    errorMessage('');

    final result = await repository.validateScanImages(
      frontImage: frontImage.value!,
      sideImage: sideImage.value!,
      backImage: backImage.value!,
    );

    return result.fold(
      (failure) {
        errorMessage(failure.message);
        isValidating(false);
        return false;
      },
      (ScanValidationResponseModel res) {
        validationResult.value = res;
        isValidating(false);
        return res.allValid;
      },
    );
  }

  // Scan Analysis Submission State
  final RxBool isSubmittingScan = false.obs;
  final Rx<Map<String, dynamic>?> scanResultData = Rx<Map<String, dynamic>?>(
    null,
  );

  /// Call POST /api/scans/ or POST /api/checkins/weekly/ with 3 captured files and timezone
  Future<bool> submitScan({String? timezone}) async {
    if (frontImage.value == null ||
        sideImage.value == null ||
        backImage.value == null) {
      errorMessage(
        'Please capture front, side, and back photos before submitting.',
      );
      return false;
    }

    isSubmittingScan(true);
    errorMessage('');

    final bool isWeekly =
        isWeeklyCheckIn.value ||
        (Get.isRegistered<UserController>() &&
            Get.find<UserController>()
                    .currentUser
                    .value
                    ?.initialScanCompleted ==
                true);

    final result = isWeekly
        ? await repository.createWeeklyCheckin(
            frontImage: frontImage.value!,
            sideImage: sideImage.value!,
            backImage: backImage.value!,
            timezone: timezone,
          )
        : await repository.createScan(
            frontImage: frontImage.value!,
            sideImage: sideImage.value!,
            backImage: backImage.value!,
            timezone: timezone,
          );

    return result.fold(
      (failure) async {
        // If there was a network drop or gateway timeout, verify if the backend
        // successfully processed the scan in the background before reporting failure.
        try {
          final statusResult = await repository.getCheckInStatus();
          final bool isScanSavedOnBackend = statusResult.fold(
            (_) => false,
            (status) {
              if (isWeekly) {
                return status.today?.alreadyAnswered == true ||
                    status.latestScan != null;
              } else {
                return status.phase != 'initial_checkin_required' ||
                    status.latestScan != null;
              }
            },
          );

          if (isScanSavedOnBackend) {
            statusData.value = statusResult.getOrElse(() => statusData.value!);
            isSubmittingScan(false);
            return true;
          }
        } catch (_) {}

        errorMessage(failure.message);
        isSubmittingScan(false);
        return false;
      },
      (data) async {
        scanResultData.value = data;
        await fetchStatusData(force: true);
        isSubmittingScan(false);
        return true;
      },
    );
  }
}
