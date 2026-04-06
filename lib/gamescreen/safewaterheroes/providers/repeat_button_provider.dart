import 'package:flutter_riverpod/flutter_riverpod.dart';

// Controls if the repeat button is visible (logic managed by AudioController)
final repeatButtonVisibleProvider = StateProvider<bool>((ref) => false);