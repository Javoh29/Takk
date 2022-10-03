import 'package:project_blueprint/core/domain/entties/date_time_enum.dart';

extension DateTimeType on DateTime {
  DateTimeEnum getDateType() {
    if (hour >= 12 && hour < 18) {
      return DateTimeEnum.afternoon;
    } else if (hour >= 18) {
      return DateTimeEnum.evening;
    } else {
      return DateTimeEnum.morning;
    }
  }
}
