import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_model.freezed.dart';
part 'meal_model.g.dart';

enum MealShift { LUNCH }

enum MealWeekday { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY }

extension MealWeekdayExtension on MealWeekday {
  String get displayName {
    switch (this) {
      case MealWeekday.MONDAY:
        return 'Thứ 2';
      case MealWeekday.TUESDAY:
        return 'Thứ 3';
      case MealWeekday.WEDNESDAY:
        return 'Thứ 4';
      case MealWeekday.THURSDAY:
        return 'Thứ 5';
      case MealWeekday.FRIDAY:
        return 'Thứ 6';
    }
  }

  int get weekdayNumber {
    switch (this) {
      case MealWeekday.MONDAY:
        return 1;
      case MealWeekday.TUESDAY:
        return 2;
      case MealWeekday.WEDNESDAY:
        return 3;
      case MealWeekday.THURSDAY:
        return 4;
      case MealWeekday.FRIDAY:
        return 5;
    }
  }
}

extension MealShiftExtension on MealShift {
  String get displayName {
    switch (this) {
      case MealShift.LUNCH:
        return 'Bữa trưa';
    }
  }
}

@freezed
class MealModel with _$MealModel {
  const factory MealModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'userId', readValue: _readUserId) required String userId,
    @JsonKey(name: 'user_metadata', readValue: _readUserMetadata)
    Map<String, dynamic>? userMetadata,
    required MealShift shift,
    @Default(false) bool isRecurring,
    @Default([]) List<MealWeekday> weekdays,
    @JsonKey(name: 'startDate', readValue: _readDate)
    required DateTime startDate,
    @JsonKey(name: 'endDate', readValue: _readDate) DateTime? endDate,
    @Default([]) List<DateTime> specificDates,
    String? note,
    @JsonKey(name: 'createdAt', readValue: _readDate) DateTime? createdAt,
  }) = _MealModel;

  factory MealModel.fromJson(Map<String, dynamic> json) =>
      _$MealModelFromJson(json);
}

Object? _readUserId(Map json, String key) {
  final val = json['userId'];
  if (val is Map) return val['_id'];
  return val;
}

Object? _readUserMetadata(Map json, String key) {
  final val = json['userId'];
  if (val is Map) {
    return {'name': val['name'], 'role': val['role'], '_id': val['_id']};
  }
  return null;
}

Object? _readDate(Map json, String key) => json[key];
