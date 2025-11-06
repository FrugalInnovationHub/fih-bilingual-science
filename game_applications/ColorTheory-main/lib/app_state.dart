import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _enableSound = prefs.getBool('ff_enableSound') ?? _enableSound;
    });
    _safeInit(() {
      _soundVolumeBg = prefs.getDouble('ff_soundVolumeBg') ?? _soundVolumeBg;
    });
    _safeInit(() {
      _soundVolumeGame =
          prefs.getDouble('ff_soundVolumeGame') ?? _soundVolumeGame;
    });
    _safeInit(() {
      _pauseSound = prefs.getBool('ff_pauseSound') ?? _pauseSound;
    });
    _safeInit(() {
      _highScoreList = prefs
              .getStringList('ff_highScoreList')
              ?.map((x) {
                try {
                  return HighScoreInfoStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _highScoreList;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  dynamic _mainMenuAudioRef;
  dynamic get mainMenuAudioRef => _mainMenuAudioRef;
  set mainMenuAudioRef(dynamic value) {
    _mainMenuAudioRef = value;
  }

  bool _enableSound = false;
  bool get enableSound => _enableSound;
  set enableSound(bool value) {
    _enableSound = value;
    prefs.setBool('ff_enableSound', value);
  }

  double _soundVolumeBg = 0.4;
  double get soundVolumeBg => _soundVolumeBg;
  set soundVolumeBg(double value) {
    _soundVolumeBg = value;
    prefs.setDouble('ff_soundVolumeBg', value);
  }

  double _soundVolumeGame = 0.8;
  double get soundVolumeGame => _soundVolumeGame;
  set soundVolumeGame(double value) {
    _soundVolumeGame = value;
    prefs.setDouble('ff_soundVolumeGame', value);
  }

  dynamic _gameOverAudioRef;
  dynamic get gameOverAudioRef => _gameOverAudioRef;
  set gameOverAudioRef(dynamic value) {
    _gameOverAudioRef = value;
  }

  bool _pauseSound = false;
  bool get pauseSound => _pauseSound;
  set pauseSound(bool value) {
    _pauseSound = value;
    prefs.setBool('ff_pauseSound', value);
  }

  List<dynamic> _colorAudioEsRef = [];
  List<dynamic> get colorAudioEsRef => _colorAudioEsRef;
  set colorAudioEsRef(List<dynamic> value) {
    _colorAudioEsRef = value;
  }

  void addToColorAudioEsRef(dynamic value) {
    colorAudioEsRef.add(value);
  }

  void removeFromColorAudioEsRef(dynamic value) {
    colorAudioEsRef.remove(value);
  }

  void removeAtIndexFromColorAudioEsRef(int index) {
    colorAudioEsRef.removeAt(index);
  }

  void updateColorAudioEsRefAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    colorAudioEsRef[index] = updateFn(_colorAudioEsRef[index]);
  }

  void insertAtIndexInColorAudioEsRef(int index, dynamic value) {
    colorAudioEsRef.insert(index, value);
  }

  List<dynamic> _colorAudioEnRef = [];
  List<dynamic> get colorAudioEnRef => _colorAudioEnRef;
  set colorAudioEnRef(List<dynamic> value) {
    _colorAudioEnRef = value;
  }

  void addToColorAudioEnRef(dynamic value) {
    colorAudioEnRef.add(value);
  }

  void removeFromColorAudioEnRef(dynamic value) {
    colorAudioEnRef.remove(value);
  }

  void removeAtIndexFromColorAudioEnRef(int index) {
    colorAudioEnRef.removeAt(index);
  }

  void updateColorAudioEnRefAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    colorAudioEnRef[index] = updateFn(_colorAudioEnRef[index]);
  }

  void insertAtIndexInColorAudioEnRef(int index, dynamic value) {
    colorAudioEnRef.insert(index, value);
  }

  bool _audioInitialized = false;
  bool get audioInitialized => _audioInitialized;
  set audioInitialized(bool value) {
    _audioInitialized = value;
  }

  List<HighScoreInfoStruct> _highScoreList = [];
  List<HighScoreInfoStruct> get highScoreList => _highScoreList;
  set highScoreList(List<HighScoreInfoStruct> value) {
    _highScoreList = value;
    prefs.setStringList(
        'ff_highScoreList', value.map((x) => x.serialize()).toList());
  }

  void addToHighScoreList(HighScoreInfoStruct value) {
    highScoreList.add(value);
    prefs.setStringList(
        'ff_highScoreList', _highScoreList.map((x) => x.serialize()).toList());
  }

  void removeFromHighScoreList(HighScoreInfoStruct value) {
    highScoreList.remove(value);
    prefs.setStringList(
        'ff_highScoreList', _highScoreList.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromHighScoreList(int index) {
    highScoreList.removeAt(index);
    prefs.setStringList(
        'ff_highScoreList', _highScoreList.map((x) => x.serialize()).toList());
  }

  void updateHighScoreListAtIndex(
    int index,
    HighScoreInfoStruct Function(HighScoreInfoStruct) updateFn,
  ) {
    highScoreList[index] = updateFn(_highScoreList[index]);
    prefs.setStringList(
        'ff_highScoreList', _highScoreList.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInHighScoreList(int index, HighScoreInfoStruct value) {
    highScoreList.insert(index, value);
    prefs.setStringList(
        'ff_highScoreList', _highScoreList.map((x) => x.serialize()).toList());
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
