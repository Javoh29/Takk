import 'package:http/http.dart';

extension HttpIsSuccess on Response {
  bool get isSuccessful => statusCode >= 200 && statusCode < 300;
}
