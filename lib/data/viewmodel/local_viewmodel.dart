import 'package:flutter_cache_manager/file.dart';
import 'package:jbaza/jbaza.dart';
import 'package:project_blueprint/core/domain/entties/date_time_enum.dart';

class LocalViewModel extends BaseViewModel {
  LocalViewModel({required super.context});

  DateTimeEnum dateTimeEnum = DateTimeEnum.morning;
  File? bgImage;

  @override
  callBackError(String text) {}
}
