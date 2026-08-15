import 'package:intl/intl.dart';

/// Locale-aware currency/date formatting (docs/UI_UX_REQUIREMENTS.md §4).
/// Never format money/dates manually in widgets — use these helpers so
/// formatting stays consistent and centrally correctable.
class AppFormatters {
  AppFormatters._();

  static String currency(num amount,
      {String currencyCode = 'AED', String localeCode = 'en'}) {
    final format = NumberFormat.currency(
      locale: localeCode == 'ar' ? 'ar' : 'en_US',
      symbol: currencyCode == 'AED' ? 'AED ' : '$currencyCode ',
      decimalDigits: 2,
    );
    return format.format(amount);
  }

  static String date(DateTime date, {String localeCode = 'en'}) {
    final format =
        DateFormat.yMMMd(localeCode == 'ar' ? 'ar' : 'en_US');
    return format.format(date);
  }

  static String shortDate(DateTime date, {String localeCode = 'en'}) {
    final format = DateFormat.MMMd(localeCode == 'ar' ? 'ar' : 'en_US');
    return format.format(date);
  }

  static String percent(double value) {
    return '${(value * 100).clamp(0, 999).toStringAsFixed(0)}%';
  }
}
