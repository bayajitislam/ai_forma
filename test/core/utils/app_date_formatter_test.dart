import 'package:ai_forma/core/utils/app_date_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppDateFormatter', () {
    test('formats DateTime correctly to short month "18 Jul 2026"', () {
      final dt = DateTime(2026, 7, 18);
      expect(AppDateFormatter.toDayMonthYear(dt), '18 Jul 2026');
      expect(AppDateFormatter.toDayMonthYear(dt, lowerCase: true), '18 jul 2026');
    });

    test('formats ISO-8601 string correctly to "18 Jul 2026"', () {
      expect(AppDateFormatter.toDayMonthYear('2026-07-18'), '18 Jul 2026');
      expect(AppDateFormatter.toDayMonthYear('2026-07-18T14:30:00.000Z'), '18 Jul 2026');
    });

    test('formats full month with toFullDayMonthYear', () {
      final dt = DateTime(2026, 7, 18);
      expect(AppDateFormatter.toFullDayMonthYear(dt), '18 July 2026');
      expect(AppDateFormatter.toFullDayMonthYear(dt, lowerCase: true), '18 july 2026');
    });

    test('formats using extensions on DateTime and String', () {
      final dt = DateTime(2026, 7, 18);
      expect(dt.toDayMonthYear(), '18 Jul 2026');
      expect(dt.toDayMonthYear(lowerCase: true), '18 jul 2026');

      const String dateStr = '2026-07-18';
      expect(dateStr.toDayMonthYear(), '18 Jul 2026');

      const String? nullStr = null;
      expect(nullStr.toDayMonthYear(fallback: 'N/A'), 'N/A');
    });

    test('handles invalid strings gracefully with fallback', () {
      expect(AppDateFormatter.toDayMonthYear('not-a-date', fallback: 'Default'), 'Default');
      expect(AppDateFormatter.toDayMonthYear(''), '');
      expect(AppDateFormatter.toDayMonthYear(null), '');
    });

    test('formats short day month year', () {
      final dt = DateTime(2026, 7, 18);
      expect(AppDateFormatter.toShortDayMonthYear(dt), '18 Jul 2026');
    });

    test('formats month year', () {
      final dt = DateTime(2026, 7, 18);
      expect(AppDateFormatter.toMonthYear(dt), 'Jul 2026');
    });
  });
}
