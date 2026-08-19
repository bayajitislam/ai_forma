import 'dart:io';

import 'package:ai_forma/core/widgets/app_bottom_sheet.dart';
import 'package:ai_forma/features/check_in/models/scan_validation_model.dart';
import 'package:ai_forma/features/check_in/repositories/check_in_repository.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_devlog/flutter_devlog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CheckInController extends GetxController {
  final CheckInRepository repository;
  CheckInController({required this.repository});

  final ImagePicker _picker = ImagePicker();

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

  @override
  void onInit() {
    super.onInit();
    initCamera();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
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
      final file = File(xFile.path);

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
  Future<bool> validateImages() async {
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

  /// Call POST /api/scans/ with 3 captured files and timezone
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

    final result = await repository.createScan(
      frontImage: frontImage.value!,
      sideImage: sideImage.value!,
      backImage: backImage.value!,
      timezone: timezone,
    );

    return result.fold(
      (failure) {
        errorMessage(failure.message);
        isSubmittingScan(false);
        return false;
      },
      (data) {
        scanResultData.value = data;
        isSubmittingScan(false);
        return true;
      },
    );
  }
}
