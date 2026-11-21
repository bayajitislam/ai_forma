import 'dart:io';
import 'dart:isolate';
import 'package:ai_forma/core/failure/failure.dart';
import 'package:ai_forma/core/widgets/app_bottom_sheet.dart';
import 'package:ai_forma/core/widgets/app_cached_image.dart';
import 'package:ai_forma/core/widgets/app_snackbar.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/check_in/constants/check_in_strings.dart';
import 'package:ai_forma/features/check_in/models/checkin_status_model.dart';
import 'package:ai_forma/features/check_in/models/scan_validation_model.dart';
import 'package:ai_forma/features/check_in/repositories/check_in_repository.dart';
import 'package:ai_forma/features/check_in/view/widgets/schedule_feedback_bottom_sheet.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_devlog/flutter_devlog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

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

    // 3. Guarantee portrait orientation for body scan photos (height >= width)
    // If the image is landscape, the hardware sensor captured in sensor orientation.
    // Rotating 90° clockwise ensures the uploaded image is strictly portrait format.
    if (processed.width > processed.height) {
      processed = img.copyRotate(processed, angle: 90);
    }

    final encoded = img.encodeJpg(processed, quality: quality);
    return Uint8List.fromList(encoded);
  } catch (e) {
    return null;
  }
}

/// True only when [current] is a different scan from [previous].
///
/// A timeout recovery must not treat an older `latest_scan` as the upload
/// that just failed. Identity is the scan id, then a newer scan timestamp
/// when the id is missing.
bool isNewlySavedScan({
  required LatestScanModel? previous,
  required LatestScanModel? current,
}) {
  if (current == null) return false;

  final currentId = _nonEmptyScanValue(current.publicId);
  final previousId = _nonEmptyScanValue(previous?.publicId);
  if (currentId != null) return currentId != previousId;

  final currentAt = _scanTimestamp(current.scanDate);
  if (currentAt == null) return false;
  if (previous == null) return true;

  final previousAt = _scanTimestamp(previous.scanDate);
  if (previousAt == null) return true;
  return currentAt.isAfter(previousAt);
}

String? _nonEmptyScanValue(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}

DateTime? _scanTimestamp(String? raw) {
  final value = _nonEmptyScanValue(raw);
  if (value == null) return null;
  return DateTime.tryParse(value);
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
  int _cameraGeneration = 0;
  final RxBool isCameraInitialized = false.obs;
  final RxBool isCapturing = false.obs;
  final RxBool isProcessingGalleryImage = false.obs;

  // Scan Angle State: 'Front', 'Side', 'Back'
  final RxString currentAngle = CheckInStrings.angleFront.obs;

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
          AppSnackbar.showError(
            failure.message.isNotEmpty
                ? failure.message
                : CheckInStrings.failedToUpdateCheckInDay,
            title: CheckInStrings.scheduleChangeRestricted,
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
                ? CheckInStrings.scanScheduleChangeSet
                : CheckInStrings.scanScheduleUpdated);

        final String? nextScanLine = confirmation?['next_scan_line']?.toString();
        final List<dynamic>? bodyList = confirmation?['body'] as List<dynamic>?;
        final String bodyJoined = bodyList != null && bodyList.isNotEmpty
            ? bodyList.join('\n\n')
            : '';

        final String message = nextScanLine != null
            ? (bodyJoined.isNotEmpty ? '$nextScanLine\n\n$bodyJoined' : nextScanLine)
            : (data['message']?.toString() ?? CheckInStrings.weeklyScanDayUpdated);

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
          AppSnackbar.showSuccess(
            nextScanLine ?? message,
            title: popupTitle,
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
    ScheduleFeedbackBottomSheet.showSuccess(
      context,
      title: title,
      message: message,
      activeCycleExists: activeCycleExists,
      pendingScanDay: pendingScanDay,
    );
  }

  /// Show popup error dialog when schedule update fails (e.g. 7-day restriction)
  void showScheduleErrorPopup(BuildContext context, String message) {
    ScheduleFeedbackBottomSheet.showError(
      context,
      message: message,
    );
  }

  @override
  void onClose() {
    disposeCamera();
    super.onClose();
  }

  /// Releases [controller] when it is still the active camera.
  ///
  /// The leaving route passes the instance it captured. Once a newer
  /// [CameraController] is active, this call leaves that newer camera running.
  Future<void> disposeCamera([CameraController? controller]) async {
    final requested = controller ?? cameraController;
    if (requested == null || !identical(cameraController, requested)) return;

    _cameraGeneration++;
    cameraController = null;
    isCameraInitialized.value = false;
    await requested.dispose();
  }

  /// Initialize real device camera
  Future<void> initCamera() async {
    // If camera is already initialized and running, reuse it instantly without delay
    if (cameraController != null && cameraController!.value.isInitialized) {
      isCameraInitialized(true);
      return;
    }

    try {
      if (availableCameraList.isEmpty) {
        availableCameraList = await availableCameras();
      }
      if (availableCameraList.isEmpty) {
        errorMessage(CheckInStrings.noCameraFound);
        return;
      }

      // Default to back camera if available
      selectedCameraIndex = availableCameraList.indexWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
      );
      if (selectedCameraIndex == -1) selectedCameraIndex = 0;

      await _initCameraController(availableCameraList[selectedCameraIndex]);
    } catch (e) {
      errorMessage('${CheckInStrings.failedToInitCamera}$e');
    }
  }

  Future<void> _initCameraController(CameraDescription camera) async {
    final generation = ++_cameraGeneration;
    isCameraInitialized(false);
    final previous = cameraController;
    cameraController = null;
    if (previous != null) {
      await previous.dispose();
    }
    if (generation != _cameraGeneration) return;

    final next = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    cameraController = next;

    try {
      await next.initialize();
      if (generation != _cameraGeneration || !identical(cameraController, next)) {
        return;
      }
      try {
        await next.lockCaptureOrientation(DeviceOrientation.portraitUp);
      } catch (_) {}
      if (generation != _cameraGeneration || !identical(cameraController, next)) {
        return;
      }
      isCameraInitialized(true);
    } catch (e) {
      if (identical(cameraController, next)) {
        cameraController = null;
        isCameraInitialized.value = false;
      }
      rethrow;
    }
  }

  /// Toggle between front and back cameras
  Future<void> toggleCamera() async {
    if (availableCameraList.length < 2) return;
    selectedCameraIndex =
        (selectedCameraIndex + 1) % availableCameraList.length;
    await _initCameraController(availableCameraList[selectedCameraIndex]);
  }

  /// Show Top Right "Tips" Bottom Sheet Modal
  void showPhotoTips(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      title: CheckInStrings.photoTipsTitle,
      bulletPoints: CheckInStrings.photoTipsBulletPoints,
    );
  }

  /// Show Bottom Right "Guide" Bottom Sheet Modal for current pose
  void showPoseGuide(BuildContext context) {
    String title;
    List<String> points;

    switch (currentAngle.value) {
      case CheckInStrings.angleSide:
        title = CheckInStrings.sidePhotoGuideTitle;
        points = CheckInStrings.sidePhotoGuidePoints;
        break;
      case CheckInStrings.angleBack:
        title = CheckInStrings.backPhotoGuideTitle;
        points = CheckInStrings.backPhotoGuidePoints;
        break;
      case CheckInStrings.angleFront:
      default:
        title = CheckInStrings.frontPhotoGuideTitle;
        points = CheckInStrings.frontPhotoGuidePoints;
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
      try {
        await cameraController!.lockCaptureOrientation(DeviceOrientation.portraitUp);
      } catch (_) {}
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

      if (currentAngle.value == CheckInStrings.angleFront) {
        frontImage.value = file;
      } else if (currentAngle.value == CheckInStrings.angleSide) {
        sideImage.value = file;
      } else if (currentAngle.value == CheckInStrings.angleBack) {
        backImage.value = file;
      }

      isCapturing(false);
      return file;
    } catch (e) {
      isCapturing(false);
      errorMessage('${CheckInStrings.errorCapturingPhoto}$e');
      return null;
    }
  }

  /// Pick image from gallery.
  ///
  /// The picker already returns an oriented JPEG when [imageQuality] and a
  /// max size are set, so this does not decode and re-encode the file again.
  Future<File?> pickFromGallery() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
        requestFullMetadata: false,
      );
      if (picked != null) {
        final file = File(picked.path);
        if (currentAngle.value == CheckInStrings.angleFront) {
          frontImage.value = file;
        } else if (currentAngle.value == CheckInStrings.angleSide) {
          sideImage.value = file;
        } else if (currentAngle.value == CheckInStrings.angleBack) {
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
    currentAngle.value = CheckInStrings.angleFront;
    validationResult.value = null;
    errorMessage('');
  }

  /// Drop the in-progress scan without disposing this controller.
  ///
  /// The check-in tab stays mounted and subscribed, so the controller has to
  /// keep its status data. Camera hardware and captured files are released.
  Future<void> releaseScanSession() async {
    await disposeCamera();
    resetScan();
    scanResultData.value = null;
    isWeeklyCheckIn.value = false;
    isSubmittingScan.value = false;
    isValidating.value = false;
    isProcessingGalleryImage.value = false;
    isCapturing.value = false;
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
      errorMessage(CheckInStrings.captureAllPhotosWarning);
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
      errorMessage(CheckInStrings.submitAllPhotosWarning);
      return false;
    }

    isSubmittingScan(true);
    errorMessage('');

    // Snapshot the scan that already exists so a dropped upload cannot be
    // confirmed from that older record.
    var baseline = statusData.value;
    if (baseline == null) {
      final refreshed = await repository.getCheckInStatus();
      refreshed.fold((_) {}, (status) {
        baseline = status;
        statusData.value = status;
      });
    }
    final previousScan = baseline?.latestScan;
    final bool canConfirmSavedScan = baseline != null;

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
        // A dropped connection or gateway timeout can still leave the scan
        // saved. Confirm that only when status now points at a new scan.
        final bool mayHaveSavedAnyway =
            failure is NetworkFailure || failure is ServerFailure;
        if (mayHaveSavedAnyway && canConfirmSavedScan) {
          try {
            final statusResult = await repository.getCheckInStatus();
            final CheckinStatusModel? recovered = statusResult.fold(
              (_) => null,
              (status) => isNewlySavedScan(
                    previous: previousScan,
                    current: status.latestScan,
                  )
                  ? status
                  : null,
            );

            if (recovered != null) {
              final oldThumbs = previousScan?.thumbs;
              if (oldThumbs != null) {
                await AppCachedNetworkImage.evict(oldThumbs.front);
                await AppCachedNetworkImage.evict(oldThumbs.side);
                await AppCachedNetworkImage.evict(oldThumbs.back);
              }
              statusData.value = recovered;
              isSubmittingScan(false);
              return true;
            }
          } catch (_) {}
        }

        errorMessage(failure.message);
        isSubmittingScan(false);
        return false;
      },
      (data) async {
        // Evict previous scan thumbnails so new scan images immediately render fresh
        final oldLatest = statusData.value?.latestScan?.thumbs;
        if (oldLatest != null) {
          await AppCachedNetworkImage.evict(oldLatest.front);
          await AppCachedNetworkImage.evict(oldLatest.side);
          await AppCachedNetworkImage.evict(oldLatest.back);
        }
        scanResultData.value = data;
        await fetchStatusData(force: true);
        isSubmittingScan(false);
        return true;
      },
    );
  }
}
