// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecurrenceModelImpl _$$RecurrenceModelImplFromJson(
  Map<String, dynamic> json,
) => _$RecurrenceModelImpl(
  frequency:
      $enumDecodeNullable(_$RecurrenceFrequencyEnumMap, json['frequency']) ??
      RecurrenceFrequency.NONE,
  daysOfWeek:
      (json['daysOfWeek'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
);

Map<String, dynamic> _$$RecurrenceModelImplToJson(
  _$RecurrenceModelImpl instance,
) => <String, dynamic>{
  'frequency': _$RecurrenceFrequencyEnumMap[instance.frequency]!,
  'daysOfWeek': instance.daysOfWeek,
  'endDate': instance.endDate?.toIso8601String(),
};

const _$RecurrenceFrequencyEnumMap = {
  RecurrenceFrequency.NONE: 'NONE',
  RecurrenceFrequency.DAILY: 'DAILY',
  RecurrenceFrequency.WEEKLY: 'WEEKLY',
  RecurrenceFrequency.MONTHLY: 'MONTHLY',
};

_$ScheduleRequestModelImpl _$$ScheduleRequestModelImplFromJson(
  Map<String, dynamic> json,
) => _$ScheduleRequestModelImpl(
  id: json['_id'] as String,
  employeeId: _readEmployeeId(json, 'employee_id') as String,
  userMetadata:
      _readUserMetadata(json, 'user_metadata') as Map<String, dynamic>?,
  weekday: json['weekday'] as String?,
  shift: json['shift'] as String,
  isRecurring: json['is_recurring'] as bool,
  startDate: DateTime.parse(_readStartDate(json, 'start_date') as String),
  endDate: DateTime.parse(_readEndDate(json, 'end_date') as String),
  status: $enumDecode(_$RequestStatusEnumMap, json['status']),
  createdAt: DateTime.parse(_readCreatedAt(json, 'created_at') as String),
  recurrence: RecurrenceModel.fromJson(
    json['recurrence'] as Map<String, dynamic>,
  ),
  approvedBy: json['approvedBy'] as String?,
  title: json['title'] as String?,
  description: json['description'] as String?,
  type:
      $enumDecodeNullable(_$ScheduleTypeEnumMap, json['type']) ??
      ScheduleType.WORK,
  groupId: json['groupId'] as String?,
);

Map<String, dynamic> _$$ScheduleRequestModelImplToJson(
  _$ScheduleRequestModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'employee_id': instance.employeeId,
  'user_metadata': instance.userMetadata,
  'weekday': instance.weekday,
  'shift': instance.shift,
  'is_recurring': instance.isRecurring,
  'start_date': instance.startDate.toIso8601String(),
  'end_date': instance.endDate.toIso8601String(),
  'status': _$RequestStatusEnumMap[instance.status]!,
  'created_at': instance.createdAt.toIso8601String(),
  'recurrence': instance.recurrence,
  'approvedBy': instance.approvedBy,
  'title': instance.title,
  'description': instance.description,
  'type': _$ScheduleTypeEnumMap[instance.type]!,
  'groupId': instance.groupId,
};

const _$RequestStatusEnumMap = {
  RequestStatus.PENDING: 'PENDING',
  RequestStatus.APPROVED: 'APPROVED',
  RequestStatus.REJECTED: 'REJECTED',
};

const _$ScheduleTypeEnumMap = {
  ScheduleType.WORK: 'WORK',
  ScheduleType.LEAVE: 'LEAVE',
};
