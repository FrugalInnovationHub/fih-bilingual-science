// Automatic FlutterFlow imports
import '../../backend/schema/structs/index.dart';
import '../../backend/schema/enums/enums.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<HighScoreInfoStruct>> addNewHighScore(
  List<HighScoreInfoStruct> highScoreList,
  int currentHighScore,
) async {
  // Format current date as MM/DD/YYYY HH/MM/SS
  final now = DateTime.now();
  String two(int n) => n.toString().padLeft(2, '0');
  final month = two(now.month);
  final day = two(now.day);
  final year = now.year.toString();

  final formattedDateTime = '$month/$day/$year';

  // Make a copy so we don't mutate the input list
  final updated = List<HighScoreInfoStruct>.from(highScoreList);

  // Add the new high score entry
  updated.add(
    HighScoreInfoStruct(
      score: currentHighScore,
      datetime: formattedDateTime,
    ),
  );

  // Sort by score descending
  updated.sort((a, b) => b.score.compareTo(a.score));

  // Return top 10
  return updated.length > 10 ? updated.sublist(0, 10) : updated;
}
