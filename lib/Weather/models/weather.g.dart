// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Temperature _$TemperatureFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Temperature',
      json,
      ($checkedConvert) {
        final val = Temperature(
          value: $checkedConvert('value', (v) => (v as num).toDouble()),
        );
        return val;
      },
    );

Map<String, dynamic> _$TemperatureToJson(Temperature instance) =>
    <String, dynamic>{
      'value': instance.value,
    };

Weather _$WeatherFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Weather',
      json,
      ($checkedConvert) {
        final val = Weather(
          lastUpd:
              $checkedConvert('last_upd', (v) => DateTime.parse(v as String)),
          condition: $checkedConvert(
              'condition', (v) => $enumDecode(_$ConditionEnumMap, v)),
          loc: $checkedConvert('loc', (v) => v as String),
          temperature: $checkedConvert('temperature',
              (v) => Temperature.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {'lastUpd': 'last_upd'},
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'last_upd': instance.lastUpd.toIso8601String(),
      'condition': _$ConditionEnumMap[instance.condition]!,
      'loc': instance.loc,
      'temperature': instance.temperature.toJson(),
    };

const _$ConditionEnumMap = {
  Condition.clear: 'clear',
  Condition.rainy: 'rainy',
  Condition.cloudy: 'cloudy',
  Condition.snowy: 'snowy',
  Condition.unknown: 'unknown',
};
