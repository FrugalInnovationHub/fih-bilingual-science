// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math';

Future<ChangeColorActionResultStruct> changeColorAction(
    String currentColor,
    ColorStruct greenState,
    ColorStruct yellowState,
    ColorStruct redState,
    ColorStruct purpleState,
    ColorStruct orangeState,
    ColorStruct brownState,
    ColorStruct blueState,
    ColorStruct pinkState,
    String currentLang) async {
  final random = Random();

  // Step 1–4
  final correctButtonIdx = random.nextInt(3);
  late final colorOrder;
  if (currentLang == 'en') {
    colorOrder = FFAppConstants.ColorOrder;
  } else {
    colorOrder = FFAppConstants.ColorOrderEs;
  }

  final numColors = colorOrder.length;
  final correctColorIdx = random.nextInt(numColors);
  final newCurrentColor = colorOrder[correctColorIdx];

  // Step 5 – Update visibility
  ColorStruct toggleVisibility(ColorStruct colorState) {
    if (colorState.name == newCurrentColor) {
      if (!colorState.isVisible) {
        return ColorStruct(
          name: colorState.name,
          isVisible: true,
        );
      }
    } else if (colorState.isVisible) {
      return ColorStruct(
        name: colorState.name,
        isVisible: false,
      );
    }
    return colorState;
  }

  final newGreenState = toggleVisibility(greenState);
  final newYellowState = toggleVisibility(yellowState);
  final newRedState = toggleVisibility(redState);
  final newPurpleState = toggleVisibility(purpleState);
  final newOrangeState = toggleVisibility(orangeState);
  final newBrownState = toggleVisibility(brownState);
  final newBlueState = toggleVisibility(blueState);
  final newPinkState = toggleVisibility(pinkState);

  // Step 6–8 – Assign button values
  List<String> distractors = List.from(colorOrder);
  distractors.removeAt(correctColorIdx);
  distractors.shuffle();
  final distractor1 = distractors[0];
  final distractor2 = distractors[1];

  String left, mid, right;
  if (correctButtonIdx == 0) {
    left = newCurrentColor;
    mid = distractor1;
    right = distractor2;
  } else if (correctButtonIdx == 1) {
    mid = newCurrentColor;
    left = distractor1;
    right = distractor2;
  } else {
    right = newCurrentColor;
    mid = distractor1;
    left = distractor2;
  }

  return ChangeColorActionResultStruct(
      currentColor: newCurrentColor,
      greenState: newGreenState,
      yellowState: newYellowState,
      redState: newRedState,
      purpleState: newPurpleState,
      orangeState: newOrangeState,
      brownState: newBrownState,
      blueState: newBlueState,
      pinkState: newPinkState,
      leftButtonVal: left,
      midButtonVal: mid,
      rightButtonVal: right);
}
