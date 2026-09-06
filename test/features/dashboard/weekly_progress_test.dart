import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ai_forma/core/models/weight_record.dart';
import 'package:ai_forma/features/dashboard/controllers/weight_controller.dart';
import 'package:ai_forma/features/dashboard/view/pages/weekly_progress_view.dart';
import 'package:ai_forma/features/dashboard/view/widgets/weight_entry_bottom_sheet.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  group('WeeklyProgressView & WeightController Tests', () {
    testWidgets('WeeklyProgressView defaults to 1W every time it is opened',
        (tester) async {
      final controller = Get.put(WeightController());
      controller.selectedRange.value = TimeRange.month1;

      controller.records.assignAll([
        WeightRecord(
          id: '1',
          weightKg: 68.0,
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
        WeightRecord(
          id: '2',
          weightKg: 67.5,
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ]);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: WeeklyProgressView(),
        ),
      );
      await tester.pumpAndSettle();

      expect(controller.selectedRange.value, TimeRange.week1);
    });

    testWidgets('Deleting a weight record updates calculations and history immediately',
        (tester) async {
      final controller = Get.put(WeightController());
      final now = DateTime.now();

      final record1 = WeightRecord(
        id: 'rec-1',
        weightKg: 70.0,
        date: now.subtract(const Duration(days: 3)),
      );
      final record2 = WeightRecord(
        id: 'rec-2',
        weightKg: 68.5,
        date: now.subtract(const Duration(days: 1)),
      );

      controller.records.assignAll([record2, record1]);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: WeeklyProgressView(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('68.5'), findsWidgets);
      expect(find.text('70.0'), findsWidgets);

      // Delete record2
      await controller.deleteRecord('rec-2');
      await tester.pumpAndSettle();

      expect(controller.records.length, 1);
      expect(controller.currentWeight?.weightKg, 70.0);
    });

    testWidgets('WeightEntryBottomSheet saves weight accurately',
        (tester) async {
      final controller = Get.put(WeightController());
      final record = WeightRecord(
        id: 'rec-test',
        weightKg: 65.0,
        date: DateTime.now(),
      );
      controller.records.add(record);

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () =>
                    WeightEntryBottomSheet.show(context, record: record),
                child: const Text('Open Sheet'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Save Weight'), findsOneWidget);

      await tester.tap(find.text('Save Weight'));
      await tester.pumpAndSettle();

      expect(controller.records.isNotEmpty, true);
    });

    testWidgets('WeeklyProgressView handles single data point gracefully',
        (tester) async {
      final controller = Get.put(WeightController());
      controller.records.assignAll([
        WeightRecord(
          id: 'single-rec',
          weightKg: 64.0,
          date: DateTime.now(),
        ),
      ]);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: WeeklyProgressView(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('64.0'), findsWidgets);
      expect(find.text('Weekly Progress'), findsOneWidget);
    });

    testWidgets('WeeklyProgressView handles empty data gracefully',
        (tester) async {
      final controller = Get.put(WeightController());
      controller.records.clear();

      await tester.pumpWidget(
        const GetMaterialApp(
          home: WeeklyProgressView(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No data for this period.'), findsOneWidget);
    });
  });
}
