// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Counter _$CounterFromJson(Map<String, dynamic> json) => Counter(
      id: json['id'] as String?,
      name: json['name'] as String,
      seq: (json['seq'] as num).toInt(),
    );

Map<String, dynamic> _$CounterToJson(Counter instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'seq': instance.seq,
    };
