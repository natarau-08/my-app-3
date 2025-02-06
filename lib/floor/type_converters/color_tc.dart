import 'dart:ui';

import 'package:floor/floor.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorTcN extends TypeConverter<Color?, String?>{
  @override
  Color? decode(String? databaseValue) {
    return databaseValue == null ? null : Color(int.parse(databaseValue, radix: 16));
  }

  @override
  String? encode(Color? value) {
    return value?.toHexString();
  }
}