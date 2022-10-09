import 'dart:convert';

extension DetailParse on String {
  String parseError() {
    if (jsonDecode(this)['detail'] != null) {
      return jsonDecode(this)['detail'].toString();
    }
    return this;
  }
}
