import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  //
  String capitalize() => "${this[0].toUpperCase()}${substring(1).toLowerCase()}";

//
  dynamic translateAndMakeItCompulsory({required final BuildContext context}) =>
      (AppLocalization.of(context)!.getTranslatedValues(this) ?? this).trim().makeItCompulsory();

  //
  String makeItCompulsory() => '$this *';

//
  Color toColor() {
    final String hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

//
  String convertToAgo({required final BuildContext context}) {
    final diff = DateTime.now().difference(DateTime.parse(this));

    if (diff.inDays >= 365) {
      return "${(diff.inDays / 365).toStringAsFixed(0)} ${"yearAgo".translate(context: context)}";
    } else if (diff.inDays >= 31) {
      return "${(diff.inDays / 31).toStringAsFixed(0)} ${"monthsAgo".translate(context: context)}";
    } else if (diff.inDays >= 1) {
      return "${diff.inDays} ${"daysAgo".translate(context: context)}";
    } else if (diff.inHours >= 1) {
      return "${diff.inHours} ${"hoursAgo".translate(context: context)}";
    } else if (diff.inMinutes >= 1) {
      return "${diff.inMinutes} ${"minutesAgo".translate(context: context)}";
    } else if (diff.inSeconds >= 1) {
      return "${diff.inSeconds} ${"secondsAgo".translate(context: context)}";
    }
    return "justNow".translate(context: context);
  }

  //
  String translate({required final BuildContext context}) =>
      (AppLocalization.of(context)!.getTranslatedValues(this) ?? this).trim();

  String convertTime() {
    final List<String> parts = split(':');

    // Extract hours, minutes, and seconds
    final int hours = int.parse(parts[0]);
    final int minutes = int.parse(parts[1]);
    final int seconds = int.parse(parts[2]);

    // Convert to the desired format
    final String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return formattedTime;
  }


  String formatDate() {
    return DateFormat("${dateAndTimeSetting["dateFormat"]}")
        .format(DateTime.parse("$this 00:00:00.000Z"));
  }

  String formatTime() {
    if (dateAndTimeSetting["use24HourFormat"]) return this;
    return DateFormat("hh:mm a").format(DateFormat('HH:mm').parse(this)).toString();
  }

  String formatDateAndTime() {
    //  input will be in dd-mm-yyyy hh:mm:ss format
    if (dateAndTimeSetting["use24HourFormat"]) {
      //format the date only return the time as it is
      final String date = split(" ").first;
      return "${date.formatDate()} ${split(" ")[1]}";
    }
    return DateFormat('${dateAndTimeSetting["dateFormat"]} hh:mm a').format(DateTime.parse(this));
  }

  String priceFormat() {
    final double newPrice = double.parse(replaceAll(",", ""));

    return NumberFormat.currency(
      locale: Platform.localeName,
      name: systemCurrencyCountryCode,
      symbol: systemCurrency,
      decimalDigits: int.parse(decimalPointsForPrice ?? "0"),
    ).format(newPrice);
  }

}
