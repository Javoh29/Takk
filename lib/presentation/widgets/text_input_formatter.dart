import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      print(true);
      return newValue;
    }

    String str = newValue.text;

    if (str.length == 1) {
      double value = double.parse(newValue.text) / 100;
      str = value.toString();
    } else if (oldValue.text.length < newValue.text.length) {
      double value = double.parse(newValue.text) * 10;
      str = NumberFormat('0.00').format(value);
    } else {
      double value = double.parse(newValue.text) / 10;
      str = NumberFormat('0.00').format(value);
    }

    return newValue.copyWith(
        text: str, selection: TextSelection.collapsed(offset: str.length));
  }
}
