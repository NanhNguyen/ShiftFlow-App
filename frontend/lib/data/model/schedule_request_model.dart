import 'package:freezed_annotation/freezed_annotation.dart';
import '../constant/enums.dart';

part 'schedule_request_model.freezed.dart';
part 'schedule_request_model.g.dart';

enum RequestStatus { PENDING, APPROVED, REJECTED }

enum RecurrenceFrequency { NONE, DAILY, WEEKLY, MONTHLY }

@freezed
class RecurrenceModel with _$RecurrenceModel {
  const factory RecurrenceModel({
    @Default(RecurrenceFrequency.NONE) RecurrenceFrequency frequency,
    @Default([]) List<int> daysOfWeek,
    DateTime? endDate,
  }) = _RecurrenceModel;

  factory RecurrenceModel.fromJson(Map<String, dynamic> json) =>
      _$$RecurrenceModelImplFromJson(json);
}

@freezed
class ScheduleRequestModel with _$ScheduleRequestModel {
  const factory ScheduleRequestModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'employee_id', readValue: _readEmployeeId)
    required String employeeId,
    @JsonKey(name: 'user_metadata', readValue: _readUserMetadata)
    Map<String, dynamic>? userMetadata,
    String? weekday,
    required String shift,
    @JsonKey(name: 'is_recurring') required bool isRecurring,
    @JsonKey(name: 'start_date', readValue: _readStartDate)
    required DateTime startDate,
    @JsonKey(name: 'end_date', readValue: _readEndDate)
    required DateTime endDate,
    required RequestStatus status,
    @JsonKey(name: 'created_at', readValue: _readCreatedAt)
    required DateTime createdAt,
    required RecurrenceModel recurrence,
    String? approvedBy,
    String? title,
    String? description,
    @Default(ScheduleType.WORK) ScheduleType type,
    String? groupId,
  }) = _ScheduleRequestModel;

  factory ScheduleRequestModel.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleRequestModelImplFromJson(json);
}

Object? _readEmployeeId(Map json, String key) {
  final val = json['employee_id'] ?? json['employeeId'];
  if (val is Map) return val['_id'];
  return val;
}

Object? _readUserMetadata(Map json, String key) {
  final val = json['employee_id'] ?? json['employeeId'];
  if (val is Map) {
    return {'name': val['name'], 'role': val['role'], '_id': val['_id']};
  }
  return json['userMetadata'];
}

Object? _readStartDate(Map json, String key) =>
    json['start_date'] ?? json['startDate'] ?? json['date'];
Object? _readEndDate(Map json, String key) =>
    json['end_date'] ?? json['endDate'] ?? json['date'];
Object? _readCreatedAt(Map json, String key) =>
    json['created_at'] ?? json['createdAt'];

extension ScheduleRequestListExtension on List<ScheduleRequestModel> {
  List<dynamic> groupByGroupId() {
    final grouped = <String, List<ScheduleRequestModel>>{};
    final individuals = <ScheduleRequestModel>[];

    for (var r in this) {
      if (r.groupId != null && r.groupId!.isNotEmpty) {
        grouped.putIfAbsent(r.groupId!, () => []).add(r);
      } else {
        individuals.add(r);
      }
    }

    return <dynamic>[...grouped.values, ...individuals];
  }
}
