import 'package:json_annotation/json_annotation.dart';
part 'counter_model.g.dart';

@JsonSerializable()
class Counter {
  final String? id;
  final String name;
  final int seq;

  Counter({this.id, required this.name, required this.seq});

  factory Counter.fromJson(Map<String, dynamic> json) =>
      _$CounterFromJson(json);
  Map<String, dynamic> toJson() => _$CounterToJson(this);
}
