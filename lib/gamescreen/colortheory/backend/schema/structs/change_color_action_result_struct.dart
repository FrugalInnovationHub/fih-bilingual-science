// ignore_for_file: unnecessary_getters_setters

import '../util/schema_util.dart';
import 'index.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/nav/serialization_util.dart';

class ChangeColorActionResultStruct extends BaseStruct {
  ChangeColorActionResultStruct({
    String? currentColor,
    ColorStruct? greenState,
    ColorStruct? yellowState,
    ColorStruct? redState,
    ColorStruct? purpleState,
    ColorStruct? orangeState,
    ColorStruct? brownState,
    ColorStruct? blueState,
    ColorStruct? pinkState,
    String? leftButtonVal,
    String? midButtonVal,
    String? rightButtonVal,
  })  : _currentColor = currentColor,
        _greenState = greenState,
        _yellowState = yellowState,
        _redState = redState,
        _purpleState = purpleState,
        _orangeState = orangeState,
        _brownState = brownState,
        _blueState = blueState,
        _pinkState = pinkState,
        _leftButtonVal = leftButtonVal,
        _midButtonVal = midButtonVal,
        _rightButtonVal = rightButtonVal;

  // "currentColor" field.
  String? _currentColor;
  String get currentColor => _currentColor ?? '';
  set currentColor(String? val) => _currentColor = val;

  bool hasCurrentColor() => _currentColor != null;

  // "greenState" field.
  ColorStruct? _greenState;
  ColorStruct get greenState => _greenState ?? ColorStruct();
  set greenState(ColorStruct? val) => _greenState = val;

  void updateGreenState(Function(ColorStruct) updateFn) {
    updateFn(_greenState ??= ColorStruct());
  }

  bool hasGreenState() => _greenState != null;

  // "yellowState" field.
  ColorStruct? _yellowState;
  ColorStruct get yellowState => _yellowState ?? ColorStruct();
  set yellowState(ColorStruct? val) => _yellowState = val;

  void updateYellowState(Function(ColorStruct) updateFn) {
    updateFn(_yellowState ??= ColorStruct());
  }

  bool hasYellowState() => _yellowState != null;

  // "redState" field.
  ColorStruct? _redState;
  ColorStruct get redState => _redState ?? ColorStruct();
  set redState(ColorStruct? val) => _redState = val;

  void updateRedState(Function(ColorStruct) updateFn) {
    updateFn(_redState ??= ColorStruct());
  }

  bool hasRedState() => _redState != null;

  // "purpleState" field.
  ColorStruct? _purpleState;
  ColorStruct get purpleState => _purpleState ?? ColorStruct();
  set purpleState(ColorStruct? val) => _purpleState = val;

  void updatePurpleState(Function(ColorStruct) updateFn) {
    updateFn(_purpleState ??= ColorStruct());
  }

  bool hasPurpleState() => _purpleState != null;

  // "orangeState" field.
  ColorStruct? _orangeState;
  ColorStruct get orangeState => _orangeState ?? ColorStruct();
  set orangeState(ColorStruct? val) => _orangeState = val;

  void updateOrangeState(Function(ColorStruct) updateFn) {
    updateFn(_orangeState ??= ColorStruct());
  }

  bool hasOrangeState() => _orangeState != null;

  // "brownState" field.
  ColorStruct? _brownState;
  ColorStruct get brownState => _brownState ?? ColorStruct();
  set brownState(ColorStruct? val) => _brownState = val;

  void updateBrownState(Function(ColorStruct) updateFn) {
    updateFn(_brownState ??= ColorStruct());
  }

  bool hasBrownState() => _brownState != null;

  // "blueState" field.
  ColorStruct? _blueState;
  ColorStruct get blueState => _blueState ?? ColorStruct();
  set blueState(ColorStruct? val) => _blueState = val;

  void updateBlueState(Function(ColorStruct) updateFn) {
    updateFn(_blueState ??= ColorStruct());
  }

  bool hasBlueState() => _blueState != null;

  // "pinkState" field.
  ColorStruct? _pinkState;
  ColorStruct get pinkState => _pinkState ?? ColorStruct();
  set pinkState(ColorStruct? val) => _pinkState = val;

  void updatePinkState(Function(ColorStruct) updateFn) {
    updateFn(_pinkState ??= ColorStruct());
  }

  bool hasPinkState() => _pinkState != null;

  // "leftButtonVal" field.
  String? _leftButtonVal;
  String get leftButtonVal => _leftButtonVal ?? '';
  set leftButtonVal(String? val) => _leftButtonVal = val;

  bool hasLeftButtonVal() => _leftButtonVal != null;

  // "midButtonVal" field.
  String? _midButtonVal;
  String get midButtonVal => _midButtonVal ?? '';
  set midButtonVal(String? val) => _midButtonVal = val;

  bool hasMidButtonVal() => _midButtonVal != null;

  // "rightButtonVal" field.
  String? _rightButtonVal;
  String get rightButtonVal => _rightButtonVal ?? '';
  set rightButtonVal(String? val) => _rightButtonVal = val;

  bool hasRightButtonVal() => _rightButtonVal != null;

  static ChangeColorActionResultStruct fromMap(Map<String, dynamic> data) =>
      ChangeColorActionResultStruct(
        currentColor: data['currentColor'] as String?,
        greenState: data['greenState'] is ColorStruct
            ? data['greenState']
            : ColorStruct.maybeFromMap(data['greenState']),
        yellowState: data['yellowState'] is ColorStruct
            ? data['yellowState']
            : ColorStruct.maybeFromMap(data['yellowState']),
        redState: data['redState'] is ColorStruct
            ? data['redState']
            : ColorStruct.maybeFromMap(data['redState']),
        purpleState: data['purpleState'] is ColorStruct
            ? data['purpleState']
            : ColorStruct.maybeFromMap(data['purpleState']),
        orangeState: data['orangeState'] is ColorStruct
            ? data['orangeState']
            : ColorStruct.maybeFromMap(data['orangeState']),
        brownState: data['brownState'] is ColorStruct
            ? data['brownState']
            : ColorStruct.maybeFromMap(data['brownState']),
        blueState: data['blueState'] is ColorStruct
            ? data['blueState']
            : ColorStruct.maybeFromMap(data['blueState']),
        pinkState: data['pinkState'] is ColorStruct
            ? data['pinkState']
            : ColorStruct.maybeFromMap(data['pinkState']),
        leftButtonVal: data['leftButtonVal'] as String?,
        midButtonVal: data['midButtonVal'] as String?,
        rightButtonVal: data['rightButtonVal'] as String?,
      );

  static ChangeColorActionResultStruct? maybeFromMap(dynamic data) =>
      data is Map
          ? ChangeColorActionResultStruct.fromMap(data.cast<String, dynamic>())
          : null;

  Map<String, dynamic> toMap() => {
        'currentColor': _currentColor,
        'greenState': _greenState?.toMap(),
        'yellowState': _yellowState?.toMap(),
        'redState': _redState?.toMap(),
        'purpleState': _purpleState?.toMap(),
        'orangeState': _orangeState?.toMap(),
        'brownState': _brownState?.toMap(),
        'blueState': _blueState?.toMap(),
        'pinkState': _pinkState?.toMap(),
        'leftButtonVal': _leftButtonVal,
        'midButtonVal': _midButtonVal,
        'rightButtonVal': _rightButtonVal,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'currentColor': serializeParam(
          _currentColor,
          ParamType.String,
        ),
        'greenState': serializeParam(
          _greenState,
          ParamType.DataStruct,
        ),
        'yellowState': serializeParam(
          _yellowState,
          ParamType.DataStruct,
        ),
        'redState': serializeParam(
          _redState,
          ParamType.DataStruct,
        ),
        'purpleState': serializeParam(
          _purpleState,
          ParamType.DataStruct,
        ),
        'orangeState': serializeParam(
          _orangeState,
          ParamType.DataStruct,
        ),
        'brownState': serializeParam(
          _brownState,
          ParamType.DataStruct,
        ),
        'blueState': serializeParam(
          _blueState,
          ParamType.DataStruct,
        ),
        'pinkState': serializeParam(
          _pinkState,
          ParamType.DataStruct,
        ),
        'leftButtonVal': serializeParam(
          _leftButtonVal,
          ParamType.String,
        ),
        'midButtonVal': serializeParam(
          _midButtonVal,
          ParamType.String,
        ),
        'rightButtonVal': serializeParam(
          _rightButtonVal,
          ParamType.String,
        ),
      }.withoutNulls;

  static ChangeColorActionResultStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      ChangeColorActionResultStruct(
        currentColor: deserializeParam(
          data['currentColor'],
          ParamType.String,
          false,
        ),
        greenState: deserializeStructParam(
          data['greenState'],
          ParamType.DataStruct,
          false,
          structBuilder: ColorStruct.fromSerializableMap,
        ),
        yellowState: deserializeStructParam(
          data['yellowState'],
          ParamType.DataStruct,
          false,
          structBuilder: ColorStruct.fromSerializableMap,
        ),
        redState: deserializeStructParam(
          data['redState'],
          ParamType.DataStruct,
          false,
          structBuilder: ColorStruct.fromSerializableMap,
        ),
        purpleState: deserializeStructParam(
          data['purpleState'],
          ParamType.DataStruct,
          false,
          structBuilder: ColorStruct.fromSerializableMap,
        ),
        orangeState: deserializeStructParam(
          data['orangeState'],
          ParamType.DataStruct,
          false,
          structBuilder: ColorStruct.fromSerializableMap,
        ),
        brownState: deserializeStructParam(
          data['brownState'],
          ParamType.DataStruct,
          false,
          structBuilder: ColorStruct.fromSerializableMap,
        ),
        blueState: deserializeStructParam(
          data['blueState'],
          ParamType.DataStruct,
          false,
          structBuilder: ColorStruct.fromSerializableMap,
        ),
        pinkState: deserializeStructParam(
          data['pinkState'],
          ParamType.DataStruct,
          false,
          structBuilder: ColorStruct.fromSerializableMap,
        ),
        leftButtonVal: deserializeParam(
          data['leftButtonVal'],
          ParamType.String,
          false,
        ),
        midButtonVal: deserializeParam(
          data['midButtonVal'],
          ParamType.String,
          false,
        ),
        rightButtonVal: deserializeParam(
          data['rightButtonVal'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ChangeColorActionResultStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ChangeColorActionResultStruct &&
        currentColor == other.currentColor &&
        greenState == other.greenState &&
        yellowState == other.yellowState &&
        redState == other.redState &&
        purpleState == other.purpleState &&
        orangeState == other.orangeState &&
        brownState == other.brownState &&
        blueState == other.blueState &&
        pinkState == other.pinkState &&
        leftButtonVal == other.leftButtonVal &&
        midButtonVal == other.midButtonVal &&
        rightButtonVal == other.rightButtonVal;
  }

  @override
  int get hashCode => const ListEquality().hash([
        currentColor,
        greenState,
        yellowState,
        redState,
        purpleState,
        orangeState,
        brownState,
        blueState,
        pinkState,
        leftButtonVal,
        midButtonVal,
        rightButtonVal
      ]);
}

ChangeColorActionResultStruct createChangeColorActionResultStruct({
  String? currentColor,
  ColorStruct? greenState,
  ColorStruct? yellowState,
  ColorStruct? redState,
  ColorStruct? purpleState,
  ColorStruct? orangeState,
  ColorStruct? brownState,
  ColorStruct? blueState,
  ColorStruct? pinkState,
  String? leftButtonVal,
  String? midButtonVal,
  String? rightButtonVal,
}) =>
    ChangeColorActionResultStruct(
      currentColor: currentColor,
      greenState: greenState ?? ColorStruct(),
      yellowState: yellowState ?? ColorStruct(),
      redState: redState ?? ColorStruct(),
      purpleState: purpleState ?? ColorStruct(),
      orangeState: orangeState ?? ColorStruct(),
      brownState: brownState ?? ColorStruct(),
      blueState: blueState ?? ColorStruct(),
      pinkState: pinkState ?? ColorStruct(),
      leftButtonVal: leftButtonVal,
      midButtonVal: midButtonVal,
      rightButtonVal: rightButtonVal,
    );
