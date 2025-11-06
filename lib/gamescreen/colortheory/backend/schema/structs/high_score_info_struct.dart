// ignore_for_file: unnecessary_getters_setters

import '../util/schema_util.dart';

import 'index.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/nav/serialization_util.dart';

class HighScoreInfoStruct extends BaseStruct {
  HighScoreInfoStruct({
    int? score,
    String? datetime,
  })  : _score = score,
        _datetime = datetime;

  // "score" field.
  int? _score;
  int get score => _score ?? 0;
  set score(int? val) => _score = val;

  void incrementScore(int amount) => score = score + amount;

  bool hasScore() => _score != null;

  // "datetime" field.
  String? _datetime;
  String get datetime => _datetime ?? '';
  set datetime(String? val) => _datetime = val;

  bool hasDatetime() => _datetime != null;

  static HighScoreInfoStruct fromMap(Map<String, dynamic> data) =>
      HighScoreInfoStruct(
        score: castToType<int>(data['score']),
        datetime: data['datetime'] as String?,
      );

  static HighScoreInfoStruct? maybeFromMap(dynamic data) => data is Map
      ? HighScoreInfoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'score': _score,
        'datetime': _datetime,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'score': serializeParam(
          _score,
          ParamType.int,
        ),
        'datetime': serializeParam(
          _datetime,
          ParamType.String,
        ),
      }.withoutNulls;

  static HighScoreInfoStruct fromSerializableMap(Map<String, dynamic> data) =>
      HighScoreInfoStruct(
        score: deserializeParam(
          data['score'],
          ParamType.int,
          false,
        ),
        datetime: deserializeParam(
          data['datetime'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'HighScoreInfoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is HighScoreInfoStruct &&
        score == other.score &&
        datetime == other.datetime;
  }

  @override
  int get hashCode => const ListEquality().hash([score, datetime]);
}

HighScoreInfoStruct createHighScoreInfoStruct({
  int? score,
  String? datetime,
}) =>
    HighScoreInfoStruct(
      score: score,
      datetime: datetime,
    );
