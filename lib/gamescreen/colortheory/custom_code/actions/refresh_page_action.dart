// Automatic FlutterFlow imports
import '../../backend/schema/structs/index.dart';
import '../../backend/schema/enums/enums.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<void> refreshPageAction(BuildContext context) async {
  // Navigator.popAndPushNamed(context, '/reloadPage');
  await context.pushNamed('ReloadPage');
  // context.go('/reloadPage');
}
