import 'dart:io';
import 'dart:typed_data';
import 'package:ai_forma/core/network/dio_client.dart';
import 'package:camera/camera.dart';
import 'package:ai_forma/features/check_in/controllers/check_in_controller.dart';
import 'package:ai_forma/features/check_in/models/checkin_status_model.dart';
import 'package:ai_forma/features/check_in/models/scan_validation_model.dart';
import 'package:ai_forma/features/check_in/repositories/check_in_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CheckIn Image Processing & Validation Tests', () {
    test('processCapturedImageBytes processes back camera image correctly', () {
      final image = img.Image(width: 50, height: 50);
      img.fill(image, color: img.ColorRgb8(255, 0, 0));
      final rawBytes = Uint8List.fromList(img.encodeJpg(image));

      final processed = processCapturedImageBytes(
        rawBytes: rawBytes,
        isFrontCamera: false,
        quality: 85,
      );

      expect(processed, isNotNull);
      final decoded = img.decodeImage(processed!);
      expect(decoded, isNotNull);
      expect(decoded!.width, 50);
      expect(decoded.height, 50);
    });

    test('processCapturedImageBytes handles front camera horizontal flip', () {
      final image = img.Image(width: 2, height: 1);
      image.setPixelRgb(0, 0, 255, 0, 0); // left pixel red
      image.setPixelRgb(1, 0, 0, 255, 0); // right pixel green
      final rawBytes = Uint8List.fromList(img.encodeJpg(image));

      final processed = processCapturedImageBytes(
        rawBytes: rawBytes,
        isFrontCamera: true,
        quality: 90,
      );

      expect(processed, isNotNull);
    });

    test('processCapturedImageBytes returns null gracefully on corrupt bytes', () {
      final corruptBytes = Uint8List.fromList([0, 1, 2, 3, 4, 5]);

      final processed = processCapturedImageBytes(
        rawBytes: corruptBytes,
        isFrontCamera: false,
        quality: 90,
      );

      expect(processed, isNull);
    });

    test('ScanValidationResponseModel correctly exposes failed check reasons', () {
      final model = ScanValidationResponseModel.fromJson({
        'status': 'success',
        'all_valid': false,
        'checks': {
          'front': {
            'status': 'passed',
            'is_human': true,
            'matches_expected_view': true,
            'detected_view': 'front',
            'sex_matches': true,
          },
          'side': {
            'status': 'failed',
            'is_human': true,
            'matches_expected_view': false,
            'detected_view': 'front',
            'sex_matches': true,
            'reason': 'Pose mismatch (detected: front)',
          },
        },
      });

      expect(model.allValid, isFalse);
      expect(model.frontCheck?.isValid, isTrue);
      expect(model.sideCheck?.isValid, isFalse);
      expect(model.sideCheck?.displayReason, 'Pose mismatch (detected: front)');
    });

    test('DioClient.uploadOptions sets extended 120-second sendTimeout and receiveTimeout', () {
      final options = DioClient.uploadOptions();
      expect(options.sendTimeout, const Duration(seconds: 120));
      expect(options.receiveTimeout, const Duration(seconds: 120));
    });

    test('CheckInController maintains front, side, and back image state', () {
      final controller = CheckInController(repository: CheckInRepository(DioClient()));
      expect(controller.frontImage.value, isNull);
      expect(controller.sideImage.value, isNull);
      expect(controller.backImage.value, isNull);
      expect(controller.currentAngle.value, 'Front');

      controller.resetScan();
      expect(controller.currentAngle.value, 'Front');
    });

    test('isNewlySavedScan rejects an existing latest scan after a dropped upload', () {
      final existing = LatestScanModel(
        publicId: 'scan-1',
        scanDate: '2026-11-01T10:00:00Z',
      );

      expect(
        isNewlySavedScan(previous: existing, current: existing),
        isFalse,
      );
      expect(
        isNewlySavedScan(
          previous: existing,
          current: LatestScanModel(
            publicId: 'scan-1',
            scanDate: '2026-11-12T10:00:00Z',
          ),
        ),
        isFalse,
      );
      expect(isNewlySavedScan(previous: null, current: null), isFalse);
    });

    test('isNewlySavedScan accepts a new scan id or a newer timestamp', () {
      final existing = LatestScanModel(
        publicId: 'scan-1',
        scanDate: '2026-11-01T10:00:00Z',
      );

      expect(
        isNewlySavedScan(
          previous: existing,
          current: LatestScanModel(
            publicId: 'scan-2',
            scanDate: '2026-11-12T10:00:00Z',
          ),
        ),
        isTrue,
      );
      expect(
        isNewlySavedScan(
          previous: LatestScanModel(scanDate: '2026-11-01'),
          current: LatestScanModel(scanDate: '2026-11-12T08:00:00Z'),
        ),
        isTrue,
      );
      expect(
        isNewlySavedScan(
          previous: null,
          current: LatestScanModel(publicId: 'scan-1'),
        ),
        isTrue,
      );
    });

    test('disposeCamera ignores a stale controller after a newer one is active', () async {
      final controller = CheckInController(repository: CheckInRepository(DioClient()));
      const description = CameraDescription(
        name: '0',
        lensDirection: CameraLensDirection.back,
        sensorOrientation: 90,
      );
      final previous = CameraController(description, ResolutionPreset.low);
      final current = CameraController(description, ResolutionPreset.low);
      controller.cameraController = current;

      await controller.disposeCamera(previous);

      expect(controller.cameraController, same(current));
      expect(controller.isCameraInitialized.value, isFalse);

      await controller.disposeCamera(current);
      expect(controller.cameraController, isNull);
      await previous.dispose();
    });

    test('releaseScanSession clears captured photos and keeps check-in status', () async {
      final controller = CheckInController(repository: CheckInRepository(DioClient()));
      final status = CheckinStatusModel(
        phase: 'weekly',
        checkinNumber: 2,
        totalCheckins: 2,
        streakWeeks: 1,
        personalBestWeeks: 1,
        streakHistory: [],
        onTimePercent: 80,
        checkDay: 'Sun',
        currentWeightKg: '80',
        currentWeightLbs: '176',
        weightChangeKg: '0',
        weightChangeLbs: '0',
        weightChangeLabel: '',
      );
      controller.statusData.value = status;
      controller.frontImage.value = File('front.jpg');
      controller.sideImage.value = File('side.jpg');
      controller.backImage.value = File('back.jpg');
      controller.scanResultData.value = {'public_id': 'scan-2'};
      controller.isWeeklyCheckIn.value = true;

      await controller.releaseScanSession();

      expect(controller.frontImage.value, isNull);
      expect(controller.sideImage.value, isNull);
      expect(controller.backImage.value, isNull);
      expect(controller.scanResultData.value, isNull);
      expect(controller.isWeeklyCheckIn.value, isFalse);
      expect(controller.statusData.value, same(status));
    });

    test('CheckInController validateImages sets error message on missing files', () async {
      final controller = CheckInController(repository: CheckInRepository(DioClient()));
      final result = await controller.validateImages();
      expect(result, isFalse);
      expect(controller.errorMessage.value, contains('Please capture front, side, and back photos'));
    });
  });
}
