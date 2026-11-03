import 'package:ai_forma/core/services/push_notification_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PushNotificationService tests', () {
    test('singleton instance is persistent and not null', () {
      final instance1 = PushNotificationService.instance;
      final instance2 = PushNotificationService.instance;

      expect(instance1, isNotNull);
      expect(identical(instance1, instance2), isTrue);
    });

    test('initial state has no pending notification', () {
      final service = PushNotificationService.instance;
      expect(service.hasPendingNotification, isFalse);
      expect(service.pendingNotificationData, isNull);
    });
  });
}

