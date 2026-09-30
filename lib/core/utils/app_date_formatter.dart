import 'package:intl/intl.dart';

/// Centralized date formatting utility for AI Forma.
/// Formats dates in standard human-readable format: "18 Jul 2026" (d MMM yyyy).
class AppDateFormatter {
  AppDateFormatter._();

  static final DateFormat _dayMonthYearFormat = DateFormat('d MMM yyyy');
  static final DateFormat _fullFormat = DateFormat('d MMMM yyyy');
  static final DateFormat _shortFormat = DateFormat('d MMM yyyy');
  static final DateFormat _monthYearFormat = DateFormat('MMM yyyy');
  static final DateFormat _dayMonthFormat = DateFormat('d MMM');

  /// Safely parse dynamic input (String, DateTime, int epoch) into a DateTime?
  static DateTime? tryParse(dynamic input) {
    if (input == null) return null;
    if (input is DateTime) return input;
    if (input is int) {
      if (input > 100000000000) {
        return DateTime.fromMillisecondsSinceEpoch(input);
      } else {
        return DateTime.fromMillisecondsSinceEpoch(input * 1000);
      }
    }
    if (input is String) {
      final trimmed = input.trim();
      if (trimmed.isEmpty) return null;
      try {
        return DateTime.parse(trimmed);
      } catch (_) {
        try {
          return DateFormat('yyyy-MM-dd').parseLoose(trimmed);
        } catch (_) {
          try {
            return DateFormat('dd/MM/yyyy').parseLoose(trimmed);
          } catch (_) {
            return null;
          }
        }
      }
    }
    return null;
  }

  /// Converts any date/string input to "18 July 2026" (or "18 july 2026" if [lowerCase] is true).
  /// If input cannot be parsed and [fallback] is provided, returns [fallback];
  /// otherwise returns the original string or empty string.
  static String toDayMonthYear(
    dynamic input, {
    bool lowerCase = false,
    String? fallback,
  }) {
    if (input == null) return fallback ?? '';
    final dt = tryParse(input);
    if (dt == null) {
      if (fallback != null) return fallback;
      final str = input.toString().trim();
      return lowerCase ? str.toLowerCase() : str;
    }
    final formatted = _dayMonthYearFormat.format(dt);
    return lowerCase ? formatted.toLowerCase() : formatted;
  }

  /// Alias for [toDayMonthYear]
  static String format(
    dynamic input, {
    bool lowerCase = false,
    String? fallback,
  }) => toDayMonthYear(input, lowerCase: lowerCase, fallback: fallback);

  /// Converts any date to full format: "18 July 2026"
  static String toFullDayMonthYear(
    dynamic input, {
    bool lowerCase = false,
    String? fallback,
  }) {
    if (input == null) return fallback ?? '';
    final dt = tryParse(input);
    if (dt == null) return fallback ?? input.toString();
    final formatted = _fullFormat.format(dt);
    return lowerCase ? formatted.toLowerCase() : formatted;
  }

  /// Converts any date to short format: "18 Jul 2026"
  static String toShortDayMonthYear(dynamic input, {String? fallback}) {
    if (input == null) return fallback ?? '';
    final dt = tryParse(input);
    if (dt == null) return fallback ?? input.toString();
    return _shortFormat.format(dt);
  }

  /// Converts any date to month year: "July 2026"
  static String toMonthYear(dynamic input, {String? fallback}) {
    if (input == null) return fallback ?? '';
    final dt = tryParse(input);
    if (dt == null) return fallback ?? input.toString();
    return _monthYearFormat.format(dt);
  }

  /// Converts any date to day month: "18 July"
  static String toDayMonth(dynamic input, {String? fallback}) {
    if (input == null) return fallback ?? '';
    final dt = tryParse(input);
    if (dt == null) return fallback ?? input.toString();
    return _dayMonthFormat.format(dt);
  }
}

extension AppDateFormatterDateTimeX on DateTime {
  /// Returns date formatted as "18 July 2026"
  String toDayMonthYear({bool lowerCase = false}) =>
      AppDateFormatter.toDayMonthYear(this, lowerCase: lowerCase);
}

extension AppDateFormatterStringX on String? {
  /// Returns date formatted as "18 July 2026"
  String toDayMonthYear({bool lowerCase = false, String? fallback}) =>
      AppDateFormatter.toDayMonthYear(
        this,
        lowerCase: lowerCase,
        fallback: fallback,
      );
}
