import 'package:intl/intl.dart';

String convertDateFormat(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd').format(dateTime);
}
