import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String formatShortDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, h:mm a').format(date);
  }

  static String formatHeaderDate(DateTime date) {
    return DateFormat('EEEE, d MMMM').format(date);
  }

  static String formatDisplay(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today, ${formatTime(date)}';
    }
    return formatDateTime(date);
  }
}

class GstUtils {
  GstUtils._();

  /// Calculates CGST, SGST, IGST breakdown based on taxable amount & tax rate
  static Map<String, double> calculateTaxBreakdown({
    required double taxableAmount,
    required double gstRate,
    bool isInterState = false,
  }) {
    final totalTax = (taxableAmount * gstRate) / 100.0;
    if (isInterState) {
      return {
        'cgst': 0.0,
        'sgst': 0.0,
        'igst': totalTax,
        'totalTax': totalTax,
      };
    } else {
      final halfTax = totalTax / 2.0;
      return {
        'cgst': halfTax,
        'sgst': halfTax,
        'igst': 0.0,
        'totalTax': totalTax,
      };
    }
  }

  static bool isValidGstin(String gstin) {
    if (gstin.isEmpty) return true;
    final regExp = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
    return regExp.hasMatch(gstin.toUpperCase());
  }
}
