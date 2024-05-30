
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateConverter {

  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss a').format(dateTime);
  }

  static String dateToTimeOnly(DateTime dateTime) {
    return DateFormat(_timeFormatter()).format(dateTime);
  }

  static String dateToDateAndTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  static String dateToDateAndTimeAm(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd ${_timeFormatter()}').format(dateTime);
  }

  static String dateTimeStringToDateTime(String dateTime) {
    return DateFormat('dd MMM yyyy  ${_timeFormatter()}').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }

  static String dateTimeStringToDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }

  static DateTime dateTimeStringToDate(String dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime,true).toLocal();
  }

  static String isoStringToLocalString(String dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(dateTime).toLocal());
  }

  static String isoStringToDateTimeString(String dateTime) {
    return DateFormat('dd MMM yyyy  ${_timeFormatter()}').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  }

  static String stringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(DateFormat('yyyy-MM-dd').parse(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime);
  }

  static String convertTimeToTime(String time) {
    return DateFormat(_timeFormatter()).format(DateFormat('HH:mm').parse(time));
  }

  static DateTime convertStringTimeToDate(String time) {
    return DateFormat('HH:mm').parse(time);
  }


  static String _timeFormatter() {
    return 'HH:mm a';
    // return Get.find<SplashController>().configModel.timeformat == '24' ? 'HH:mm' : 'hh:mm a';
  }

  static String convertFromMinute(int minMinute, int maxMinute) {
    int _firstValue = minMinute;
    int _secondValue = maxMinute;
    String _type = 'min';
    if(minMinute >= 525600) {
      _firstValue = (minMinute / 525600).floor();
      _secondValue = (maxMinute / 525600).floor();
      _type = 'year';
    }else if(minMinute >= 43200) {
      _firstValue = (minMinute / 43200).floor();
      _secondValue = (maxMinute / 43200).floor();
      _type = 'month';
    }else if(minMinute >= 10080) {
      _firstValue = (minMinute / 10080).floor();
      _secondValue = (maxMinute / 10080).floor();
      _type = 'week';
    }else if(minMinute >= 1440) {
      _firstValue = (minMinute / 1440).floor();
      _secondValue = (maxMinute / 1440).floor();
      _type = 'day';
    }else if(minMinute >= 60) {
      _firstValue = (minMinute / 60).floor();
      _secondValue = (maxMinute / 60).floor();
      _type = 'hour';
    }
    return '$_firstValue-$_secondValue ${_type.tr}';
  }

  static String localDateToIsoStringAMPM(DateTime dateTime) {
    return DateFormat('${_timeFormatter()} | d-MMM-yyyy ').format(dateTime.toLocal());
  }
  static String localToIsoString(DateTime dateTime) {
    return DateFormat('d MMMM, yyyy ').format(dateTime.toLocal());
  }


}