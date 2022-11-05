import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

var numFormat = NumberFormat('###,###.00', 'en_US');

const headerContent = {'Content-Type': 'application/json'};

const MethodChannel channel = MethodChannel('com.range.takk/callIntent');
