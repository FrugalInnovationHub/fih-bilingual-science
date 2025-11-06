// ignore_for_file: unnecessary_getters_setters

import '../util/schema_util.dart';

import 'index.dart';
import '../../../flutter_flow/flutter_flow_util.dart';

class ColorStruct extends BaseStruct {
  ColorStruct({
    String? name,
    bool? isVisible,
  })  : _name = name,
        _isVisible = isVisible;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "isVisible" field.
  bool? _isVisible;
  bool get isVisible => _isVisible ?? false;
  set isVisible(bool? val) => _isVisible = val;

  bool hasIsVisible() => _isVisible != null;

  static ColorStruct fromMap(Map<String, dynamic> data) => ColorStruct(
        name: data['name'] as String?,
        isVisible: data['isVisible'] as bool?,
      );

  static ColorStruct? maybeFromMap(dynamic data) =>
      data is Map ? ColorStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'isVisible': _isVisible,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'isVisible': serializeParam(
          _isVisible,
          ParamType.bool,
        ),
      }.withoutNulls;

  static ColorStruct fromSerializableMap(Map<String, dynamic> data) =>
      ColorStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        isVisible: deserializeParam(
          data['isVisible'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'ColorStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ColorStruct &&
        name == other.name &&
        isVisible == other.isVisible;
  }

  @override
  int get hashCode => const ListEquality().hash([name, isVisible]);
}

ColorStruct createColorStruct({
  String? name,
  bool? isVisible,
}) =>
    ColorStruct(
      name: name,
      isVisible: isVisible,
    );
