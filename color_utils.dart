import 'package:base/utils/logging_utils.dart';
import 'package:base/utils/string_utils.dart';
import 'package:flutter/material.dart';

Color hexToColor(String code, {Color fallBackColor}) {
  //log("hexToColor: input=$code");
  if (isEmpty(code)) {
    //log("hexToColor: output=transparent");
    return fallBackColor ?? Colors.transparent;
  }
  String trimmed = code.trim();
  String tmp = trimmed.startsWith("#") ? trimmed.substring(1) : trimmed;
  int length = tmp.length;
  if (length != 3 && length != 6 && length != 8) {
    //log("hexToColor: output=transparent");
    return fallBackColor ?? Colors.transparent;
  }
  int a = hexToA(tmp);
  int r = hexToR(tmp);
  int g = hexToG(tmp);
  int b = hexToB(tmp);
  //log("hexToColor: output=ARGB[$a,$r,$g,$b]");
  Color c = Color.fromARGB(a, r, g, b);
  return c;
}
int hexToA(String code) {
  try {
    int length = code.length;
    if (length < 8) return 255;
    return int.parse(code.substring(0, 2), radix: 16);
  } catch (e) {
    log("hexToA: $e");
    return 0;
  }
}

int hexToR(String code) {
  try {
    int length = code.length;
    if (length == 3) {
      var s = code.substring(0, 1);
      s += s;
      return int.parse(s, radix: 16);
    } else if (length == 6)
      return int.parse(code.substring(0, 2), radix: 16);
    else
      return int.parse(code.substring(2, 4), radix: 16);
  } catch (e) {
    log("hexToR: $e");
    return 0;
  }
}

int hexToG(String code) {
  try {
    int length = code.length;
    if (length == 3) {
      var s = code.substring(1, 2);
      s += s;
      return int.parse(s, radix: 16);
    } else if (length == 6)
      return int.parse(code.substring(2, 4), radix: 16);
    else
      return int.parse(code.substring(4, 6), radix: 16);
  } catch (e) {
    log("hexToG: $e");
    return 0;
  }
}

int hexToB(String code) {
  try {
    int length = code.length;
    if (length == 3) {
      var s = code.substring(2, 3);
      s += s;
      return int.parse(s, radix: 16);
    } else if (length == 6)
      return int.parse(code.substring(4, 6), radix: 16);
    else
      return int.parse(code.substring(6), radix: 16);
  } catch (e) {
    log("hexToB: $e");
    return 0;
  }
}
