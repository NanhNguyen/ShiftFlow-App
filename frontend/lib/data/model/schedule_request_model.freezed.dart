// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RecurrenceModel _$RecurrenceModelFromJson(Map<String, dynamic> json) {
  return _RecurrenceModel.fromJson(json);
}

/// @nodoc
mixin _$RecurrenceModel {
  RecurrenceFrequency get frequency => throw _privateConstructorUsedError;
  List<int> get daysOfWeek => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;

  /// Serializes this RecurrenceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecurrenceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecurrenceModelCopyWith<RecurrenceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurrenceModelCopyWith<$Res> {
  factory $RecurrenceModelCopyWith(
    RecurrenceModel value,
    $Res Function(RecurrenceModel) then,
  ) = _$RecurrenceModelCopyWithImpl<$Res, RecurrenceModel>;
  @useResult
  $Res call({
    RecurrenceFrequency frequency,
    List<int> daysOfWeek,
    DateTime? endDate,
  });
}

/// @nodoc
class _$RecurrenceModelCopyWithImpl<$Res, $Val extends RecurrenceModel>
    implements $RecurrenceModelCopyWith<$Res> {
  _$RecurrenceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecurrenceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frequency = null,
    Object? daysOfWeek = null,
    Object? endDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            frequency: null == frequency
                ? _value.frequency
                : frequency // ignore: cast_nullable_to_non_nullable
                      as RecurrenceFrequency,
            daysOfWeek: null == daysOfWeek
                ? _value.daysOfWeek
                : daysOfWeek // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecurrenceModelImplCopyWith<$Res>
    implements $RecurrenceModelCopyWith<$Res> {
  factory _$$RecurrenceModelImplCopyWith(
    _$RecurrenceModelImpl value,
    $Res Function(_$RecurrenceModelImpl) then,
  ) = __$$RecurrenceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    RecurrenceFrequency frequency,
    List<int> daysOfWeek,
    DateTime? endDate,
  });
}

/// @nodoc
class __$$RecurrenceModelImplCopyWithImpl<$Res>
    extends _$RecurrenceModelCopyWithImpl<$Res, _$RecurrenceModelImpl>
    implements _$$RecurrenceModelImplCopyWith<$Res> {
  __$$RecurrenceModelImplCopyWithImpl(
    _$RecurrenceModelImpl _value,
    $Res Function(_$RecurrenceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecurrenceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frequency = null,
    Object? daysOfWeek = null,
    Object? endDate = freezed,
  }) {
    return _then(
      _$RecurrenceModelImpl(
        frequency: null == frequency
            ? _value.frequency
            : frequency // ignore: cast_nullable_to_non_nullable
                  as RecurrenceFrequency,
        daysOfWeek: null == daysOfWeek
            ? _value._daysOfWeek
            : daysOfWeek // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecurrenceModelImpl implements _RecurrenceModel {
  const _$RecurrenceModelImpl({
    this.frequency = RecurrenceFrequency.NONE,
    final List<int> daysOfWeek = const [],
    this.endDate,
  }) : _daysOfWeek = daysOfWeek;

  factory _$RecurrenceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecurrenceModelImplFromJson(json);

  @override
  @JsonKey()
  final RecurrenceFrequency frequency;
  final List<int> _daysOfWeek;
  @override
  @JsonKey()
  List<int> get daysOfWeek {
    if (_daysOfWeek is EqualUnmodifiableListView) return _daysOfWeek;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_daysOfWeek);
  }

  @override
  final DateTime? endDate;

  @override
  String toString() {
    return 'RecurrenceModel(frequency: $frequency, daysOfWeek: $daysOfWeek, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurrenceModelImpl &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            const DeepCollectionEquality().equals(
              other._daysOfWeek,
              _daysOfWeek,
            ) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    frequency,
    const DeepCollectionEquality().hash(_daysOfWeek),
    endDate,
  );

  /// Create a copy of RecurrenceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurrenceModelImplCopyWith<_$RecurrenceModelImpl> get copyWith =>
      __$$RecurrenceModelImplCopyWithImpl<_$RecurrenceModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurrenceModelImplToJson(this);
  }
}

abstract class _RecurrenceModel implements RecurrenceModel {
  const factory _RecurrenceModel({
    final RecurrenceFrequency frequency,
    final List<int> daysOfWeek,
    final DateTime? endDate,
  }) = _$RecurrenceModelImpl;

  factory _RecurrenceModel.fromJson(Map<String, dynamic> json) =
      _$RecurrenceModelImpl.fromJson;

  @override
  RecurrenceFrequency get frequency;
  @override
  List<int> get daysOfWeek;
  @override
  DateTime? get endDate;

  /// Create a copy of RecurrenceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecurrenceModelImplCopyWith<_$RecurrenceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScheduleRequestModel _$ScheduleRequestModelFromJson(Map<String, dynamic> json) {
  return _ScheduleRequestModel.fromJson(json);
}

/// @nodoc
mixin _$ScheduleRequestModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'employee_id', readValue: _readEmployeeId)
  String get employeeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_metadata', readValue: _readUserMetadata)
  Map<String, dynamic>? get userMetadata => throw _privateConstructorUsedError;
  String? get weekday => throw _privateConstructorUsedError;
  String get shift => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_recurring')
  bool get isRecurring => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date', readValue: _readStartDate)
  DateTime get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date', readValue: _readEndDate)
  DateTime get endDate => throw _privateConstructorUsedError;
  RequestStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', readValue: _readCreatedAt)
  DateTime get createdAt => throw _privateConstructorUsedError;
  RecurrenceModel get recurrence => throw _privateConstructorUsedError;
  String? get approvedBy => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  ScheduleType get type => throw _privateConstructorUsedError;
  String? get groupId => throw _privateConstructorUsedError;

  /// Serializes this ScheduleRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleRequestModelCopyWith<ScheduleRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleRequestModelCopyWith<$Res> {
  factory $ScheduleRequestModelCopyWith(
    ScheduleRequestModel value,
    $Res Function(ScheduleRequestModel) then,
  ) = _$ScheduleRequestModelCopyWithImpl<$Res, ScheduleRequestModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: 'employee_id', readValue: _readEmployeeId) String employeeId,
    @JsonKey(name: 'user_metadata', readValue: _readUserMetadata)
    Map<String, dynamic>? userMetadata,
    String? weekday,
    String shift,
    @JsonKey(name: 'is_recurring') bool isRecurring,
    @JsonKey(name: 'start_date', readValue: _readStartDate) DateTime startDate,
    @JsonKey(name: 'end_date', readValue: _readEndDate) DateTime endDate,
    RequestStatus status,
    @JsonKey(name: 'created_at', readValue: _readCreatedAt) DateTime createdAt,
    RecurrenceModel recurrence,
    String? approvedBy,
    String? title,
    String? description,
    ScheduleType type,
    String? groupId,
  });

  $RecurrenceModelCopyWith<$Res> get recurrence;
}

/// @nodoc
class _$ScheduleRequestModelCopyWithImpl<
  $Res,
  $Val extends ScheduleRequestModel
>
    implements $ScheduleRequestModelCopyWith<$Res> {
  _$ScheduleRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? userMetadata = freezed,
    Object? weekday = freezed,
    Object? shift = null,
    Object? isRecurring = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? status = null,
    Object? createdAt = null,
    Object? recurrence = null,
    Object? approvedBy = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? type = null,
    Object? groupId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            employeeId: null == employeeId
                ? _value.employeeId
                : employeeId // ignore: cast_nullable_to_non_nullable
                      as String,
            userMetadata: freezed == userMetadata
                ? _value.userMetadata
                : userMetadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            weekday: freezed == weekday
                ? _value.weekday
                : weekday // ignore: cast_nullable_to_non_nullable
                      as String?,
            shift: null == shift
                ? _value.shift
                : shift // ignore: cast_nullable_to_non_nullable
                      as String,
            isRecurring: null == isRecurring
                ? _value.isRecurring
                : isRecurring // ignore: cast_nullable_to_non_nullable
                      as bool,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as RequestStatus,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            recurrence: null == recurrence
                ? _value.recurrence
                : recurrence // ignore: cast_nullable_to_non_nullable
                      as RecurrenceModel,
            approvedBy: freezed == approvedBy
                ? _value.approvedBy
                : approvedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as ScheduleType,
            groupId: freezed == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of ScheduleRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecurrenceModelCopyWith<$Res> get recurrence {
    return $RecurrenceModelCopyWith<$Res>(_value.recurrence, (value) {
      return _then(_value.copyWith(recurrence: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ScheduleRequestModelImplCopyWith<$Res>
    implements $ScheduleRequestModelCopyWith<$Res> {
  factory _$$ScheduleRequestModelImplCopyWith(
    _$ScheduleRequestModelImpl value,
    $Res Function(_$ScheduleRequestModelImpl) then,
  ) = __$$ScheduleRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: 'employee_id', readValue: _readEmployeeId) String employeeId,
    @JsonKey(name: 'user_metadata', readValue: _readUserMetadata)
    Map<String, dynamic>? userMetadata,
    String? weekday,
    String shift,
    @JsonKey(name: 'is_recurring') bool isRecurring,
    @JsonKey(name: 'start_date', readValue: _readStartDate) DateTime startDate,
    @JsonKey(name: 'end_date', readValue: _readEndDate) DateTime endDate,
    RequestStatus status,
    @JsonKey(name: 'created_at', readValue: _readCreatedAt) DateTime createdAt,
    RecurrenceModel recurrence,
    String? approvedBy,
    String? title,
    String? description,
    ScheduleType type,
    String? groupId,
  });

  @override
  $RecurrenceModelCopyWith<$Res> get recurrence;
}

/// @nodoc
class __$$ScheduleRequestModelImplCopyWithImpl<$Res>
    extends _$ScheduleRequestModelCopyWithImpl<$Res, _$ScheduleRequestModelImpl>
    implements _$$ScheduleRequestModelImplCopyWith<$Res> {
  __$$ScheduleRequestModelImplCopyWithImpl(
    _$ScheduleRequestModelImpl _value,
    $Res Function(_$ScheduleRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScheduleRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? userMetadata = freezed,
    Object? weekday = freezed,
    Object? shift = null,
    Object? isRecurring = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? status = null,
    Object? createdAt = null,
    Object? recurrence = null,
    Object? approvedBy = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? type = null,
    Object? groupId = freezed,
  }) {
    return _then(
      _$ScheduleRequestModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        employeeId: null == employeeId
            ? _value.employeeId
            : employeeId // ignore: cast_nullable_to_non_nullable
                  as String,
        userMetadata: freezed == userMetadata
            ? _value._userMetadata
            : userMetadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        weekday: freezed == weekday
            ? _value.weekday
            : weekday // ignore: cast_nullable_to_non_nullable
                  as String?,
        shift: null == shift
            ? _value.shift
            : shift // ignore: cast_nullable_to_non_nullable
                  as String,
        isRecurring: null == isRecurring
            ? _value.isRecurring
            : isRecurring // ignore: cast_nullable_to_non_nullable
                  as bool,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as RequestStatus,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        recurrence: null == recurrence
            ? _value.recurrence
            : recurrence // ignore: cast_nullable_to_non_nullable
                  as RecurrenceModel,
        approvedBy: freezed == approvedBy
            ? _value.approvedBy
            : approvedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ScheduleType,
        groupId: freezed == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleRequestModelImpl implements _ScheduleRequestModel {
  const _$ScheduleRequestModelImpl({
    @JsonKey(name: '_id') required this.id,
    @JsonKey(name: 'employee_id', readValue: _readEmployeeId)
    required this.employeeId,
    @JsonKey(name: 'user_metadata', readValue: _readUserMetadata)
    final Map<String, dynamic>? userMetadata,
    this.weekday,
    required this.shift,
    @JsonKey(name: 'is_recurring') required this.isRecurring,
    @JsonKey(name: 'start_date', readValue: _readStartDate)
    required this.startDate,
    @JsonKey(name: 'end_date', readValue: _readEndDate) required this.endDate,
    required this.status,
    @JsonKey(name: 'created_at', readValue: _readCreatedAt)
    required this.createdAt,
    required this.recurrence,
    this.approvedBy,
    this.title,
    this.description,
    this.type = ScheduleType.WORK,
    this.groupId,
  }) : _userMetadata = userMetadata;

  factory _$ScheduleRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleRequestModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  @JsonKey(name: 'employee_id', readValue: _readEmployeeId)
  final String employeeId;
  final Map<String, dynamic>? _userMetadata;
  @override
  @JsonKey(name: 'user_metadata', readValue: _readUserMetadata)
  Map<String, dynamic>? get userMetadata {
    final value = _userMetadata;
    if (value == null) return null;
    if (_userMetadata is EqualUnmodifiableMapView) return _userMetadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? weekday;
  @override
  final String shift;
  @override
  @JsonKey(name: 'is_recurring')
  final bool isRecurring;
  @override
  @JsonKey(name: 'start_date', readValue: _readStartDate)
  final DateTime startDate;
  @override
  @JsonKey(name: 'end_date', readValue: _readEndDate)
  final DateTime endDate;
  @override
  final RequestStatus status;
  @override
  @JsonKey(name: 'created_at', readValue: _readCreatedAt)
  final DateTime createdAt;
  @override
  final RecurrenceModel recurrence;
  @override
  final String? approvedBy;
  @override
  final String? title;
  @override
  final String? description;
  @override
  @JsonKey()
  final ScheduleType type;
  @override
  final String? groupId;

  @override
  String toString() {
    return 'ScheduleRequestModel(id: $id, employeeId: $employeeId, userMetadata: $userMetadata, weekday: $weekday, shift: $shift, isRecurring: $isRecurring, startDate: $startDate, endDate: $endDate, status: $status, createdAt: $createdAt, recurrence: $recurrence, approvedBy: $approvedBy, title: $title, description: $description, type: $type, groupId: $groupId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            const DeepCollectionEquality().equals(
              other._userMetadata,
              _userMetadata,
            ) &&
            (identical(other.weekday, weekday) || other.weekday == weekday) &&
            (identical(other.shift, shift) || other.shift == shift) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.recurrence, recurrence) ||
                other.recurrence == recurrence) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.groupId, groupId) || other.groupId == groupId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    employeeId,
    const DeepCollectionEquality().hash(_userMetadata),
    weekday,
    shift,
    isRecurring,
    startDate,
    endDate,
    status,
    createdAt,
    recurrence,
    approvedBy,
    title,
    description,
    type,
    groupId,
  );

  /// Create a copy of ScheduleRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleRequestModelImplCopyWith<_$ScheduleRequestModelImpl>
  get copyWith =>
      __$$ScheduleRequestModelImplCopyWithImpl<_$ScheduleRequestModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleRequestModelImplToJson(this);
  }
}

abstract class _ScheduleRequestModel implements ScheduleRequestModel {
  const factory _ScheduleRequestModel({
    @JsonKey(name: '_id') required final String id,
    @JsonKey(name: 'employee_id', readValue: _readEmployeeId)
    required final String employeeId,
    @JsonKey(name: 'user_metadata', readValue: _readUserMetadata)
    final Map<String, dynamic>? userMetadata,
    final String? weekday,
    required final String shift,
    @JsonKey(name: 'is_recurring') required final bool isRecurring,
    @JsonKey(name: 'start_date', readValue: _readStartDate)
    required final DateTime startDate,
    @JsonKey(name: 'end_date', readValue: _readEndDate)
    required final DateTime endDate,
    required final RequestStatus status,
    @JsonKey(name: 'created_at', readValue: _readCreatedAt)
    required final DateTime createdAt,
    required final RecurrenceModel recurrence,
    final String? approvedBy,
    final String? title,
    final String? description,
    final ScheduleType type,
    final String? groupId,
  }) = _$ScheduleRequestModelImpl;

  factory _ScheduleRequestModel.fromJson(Map<String, dynamic> json) =
      _$ScheduleRequestModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  @JsonKey(name: 'employee_id', readValue: _readEmployeeId)
  String get employeeId;
  @override
  @JsonKey(name: 'user_metadata', readValue: _readUserMetadata)
  Map<String, dynamic>? get userMetadata;
  @override
  String? get weekday;
  @override
  String get shift;
  @override
  @JsonKey(name: 'is_recurring')
  bool get isRecurring;
  @override
  @JsonKey(name: 'start_date', readValue: _readStartDate)
  DateTime get startDate;
  @override
  @JsonKey(name: 'end_date', readValue: _readEndDate)
  DateTime get endDate;
  @override
  RequestStatus get status;
  @override
  @JsonKey(name: 'created_at', readValue: _readCreatedAt)
  DateTime get createdAt;
  @override
  RecurrenceModel get recurrence;
  @override
  String? get approvedBy;
  @override
  String? get title;
  @override
  String? get description;
  @override
  ScheduleType get type;
  @override
  String? get groupId;

  /// Create a copy of ScheduleRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleRequestModelImplCopyWith<_$ScheduleRequestModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
