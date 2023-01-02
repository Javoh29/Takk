import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  CurrencyInputFormatter({this.price});
  final double? price;
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (double.tryParse(newValue.text) != null) {
      if (newValue.selection.baseOffset == 0) {
        return newValue;
      }

      String str = newValue.text;
      double value;

      if (str.length == 1) {
        value = double.parse(newValue.text) / 100;
        str = value.toString();
      } else if (oldValue.text.length < newValue.text.length) {
        value = double.parse(newValue.text) * 10;
        str = NumberFormat('0.00').format(value);
      } else {
        value = double.parse(newValue.text) / 10;
        str = NumberFormat('0.00').format(value);
      }

      if (price != null && value > price!) {
        return oldValue;
      }

      return newValue.copyWith(text: str, selection: TextSelection.collapsed(offset: str.length));
    } else {
      return oldValue;
    }
  }
}
