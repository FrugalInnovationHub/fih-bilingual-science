// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SetButtonColorActionResultStruct extends BaseStruct {
  SetButtonColorActionResultStruct({
    int? colorIndex,
    Color? colorCode,
  })  : _colorIndex = colorIndex,
        _colorCode = colorCode;

  // "colorIndex" field.
  int? _colorIndex;
  int get colorIndex => _colorIndex ?? 0;
  set colorIndex(int? val) => _colorIndex = val;

  void incrementColorIndex(int amount) => colorIndex = colorIndex + amount;

  bool hasColorIndex() => _colorIndex != null;

  // "colorCode" field.
  Color? _colorCode;
  Color? get colorCode => _colorCode;
  set colorCode(Color? val) => _colorCode = val;

  bool hasColorCode() => _colorCode != null;

  static SetButtonColorActionResultStruct fromMap(Map<String, dynamic> data) =>
      SetButtonColorActionResultStruct(
        colorIndex: castToType<int>(data['colorIndex']),
        colorCode: getSchemaColor(data['colorCode']),
      );

  static SetButtonColorActionResultStruct? maybeFromMap(dynamic data) => data
          is Map
      ? SetButtonColorActionResultStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'colorIndex': _colorIndex,
        'colorCode': _colorCode,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'colorIndex': serializeParam(
          _colorIndex,
          ParamType.int,
        ),
        'colorCode': serializeParam(
          _colorCode,
          ParamType.Color,
        ),
      }.withoutNulls;

  static SetButtonColorActionResultStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      SetButtonColorActionResultStruct(
        colorIndex: deserializeParam(
          data['colorIndex'],
          ParamType.int,
          false,
        ),
        colorCode: deserializeParam(
          data['colorCode'],
          ParamType.Color,
          false,
        ),
      );

  @override
  String toString() => 'SetButtonColorActionResultStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SetButtonColorActionResultStruct &&
        colorIndex == other.colorIndex &&
        colorCode == other.colorCode;
  }

  @override
  int get hashCode => const ListEquality().hash([colorIndex, colorCode]);
}

SetButtonColorActionResultStruct createSetButtonColorActionResultStruct({
  int? colorIndex,
  Color? colorCode,
}) =>
    SetButtonColorActionResultStruct(
      colorIndex: colorIndex,
      colorCode: colorCode,
    );
