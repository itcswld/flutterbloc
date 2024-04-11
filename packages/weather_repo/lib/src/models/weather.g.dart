// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Weather',
      json,
      ($checkedConvert) {
        final val = Weather(
          location: $checkedConvert('location', (v) => v as String),
          temperature:
              $checkedConvert('temperature', (v) => (v as num).toDouble()),
          condition: $checkedConvert(
              'condition', (v) => $enumDecode(_$ConditionEnumMap, v)),
        );
        return val;
      },
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'location': instance.location,
      'temperature': instance.temperature,
      'condition': _$ConditionEnumMap[instance.condition]!,
    };

const _$ConditionEnumMap = {
  Condition.clear: 'clear',
  Condition.rainy: 'rainy',
  Condition.cloudy: 'cloudy',
  Condition.snowy: 'snowy',
  Condition.unknown: 'unknown',
};
