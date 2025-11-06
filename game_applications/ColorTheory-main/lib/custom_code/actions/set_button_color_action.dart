// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<SetButtonColorActionResultStruct> setButtonColorAction(
  List<String> colorOrder,
  List<Color> colorCodeOrder,
  String currentButtonVal,
  Color defaultColor,
) async {
  final index = colorOrder.indexOf(currentButtonVal);
  final validIndex = (index != -1 && index < colorCodeOrder.length) ? index : 0;

  final color = (index != -1 && index < colorCodeOrder.length)
      ? colorCodeOrder[index]
      : defaultColor;

  return SetButtonColorActionResultStruct(
    colorIndex: validIndex,
    colorCode: color,
  );
}
