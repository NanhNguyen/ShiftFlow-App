// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manager_requests_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ManagerRequestsState {
  BaseStatus get status => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  List<ScheduleRequestModel> get requests => throw _privateConstructorUsedError;
  String? get actionResult => throw _privateConstructorUsedError;

  /// Create a copy of ManagerRequestsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManagerRequestsStateCopyWith<ManagerRequestsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagerRequestsStateCopyWith<$Res> {
  factory $ManagerRequestsStateCopyWith(
    ManagerRequestsState value,
    $Res Function(ManagerRequestsState) then,
  ) = _$ManagerRequestsStateCopyWithImpl<$Res, ManagerRequestsState>;
  @useResult
  $Res call({
    BaseStatus status,
    String? errorMessage,
    List<ScheduleRequestModel> requests,
    String? actionResult,
  });
}

/// @nodoc
class _$ManagerRequestsStateCopyWithImpl<
  $Res,
  $Val extends ManagerRequestsState
>
    implements $ManagerRequestsStateCopyWith<$Res> {
  _$ManagerRequestsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManagerRequestsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? errorMessage = freezed,
    Object? requests = null,
    Object? actionResult = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BaseStatus,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            requests: null == requests
                ? _value.requests
                : requests // ignore: cast_nullable_to_non_nullable
                      as List<ScheduleRequestModel>,
            actionResult: freezed == actionResult
                ? _value.actionResult
                : actionResult // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ManagerRequestsStateImplCopyWith<$Res>
    implements $ManagerRequestsStateCopyWith<$Res> {
  factory _$$ManagerRequestsStateImplCopyWith(
    _$ManagerRequestsStateImpl value,
    $Res Function(_$ManagerRequestsStateImpl) then,
  ) = __$$ManagerRequestsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    BaseStatus status,
    String? errorMessage,
    List<ScheduleRequestModel> requests,
    String? actionResult,
  });
}

/// @nodoc
class __$$ManagerRequestsStateImplCopyWithImpl<$Res>
    extends _$ManagerRequestsStateCopyWithImpl<$Res, _$ManagerRequestsStateImpl>
    implements _$$ManagerRequestsStateImplCopyWith<$Res> {
  __$$ManagerRequestsStateImplCopyWithImpl(
    _$ManagerRequestsStateImpl _value,
    $Res Function(_$ManagerRequestsStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ManagerRequestsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? errorMessage = freezed,
    Object? requests = null,
    Object? actionResult = freezed,
  }) {
    return _then(
      _$ManagerRequestsStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BaseStatus,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        requests: null == requests
            ? _value._requests
            : requests // ignore: cast_nullable_to_non_nullable
                  as List<ScheduleRequestModel>,
        actionResult: freezed == actionResult
            ? _value.actionResult
            : actionResult // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ManagerRequestsStateImpl implements _ManagerRequestsState {
  const _$ManagerRequestsStateImpl({
    this.status = BaseStatus.initial,
    this.errorMessage,
    final List<ScheduleRequestModel> requests = const [],
    this.actionResult,
  }) : _requests = requests;

  @override
  @JsonKey()
  final BaseStatus status;
  @override
  final String? errorMessage;
  final List<ScheduleRequestModel> _requests;
  @override
  @JsonKey()
  List<ScheduleRequestModel> get requests {
    if (_requests is EqualUnmodifiableListView) return _requests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requests);
  }

  @override
  final String? actionResult;

  @override
  String toString() {
    return 'ManagerRequestsState(status: $status, errorMessage: $errorMessage, requests: $requests, actionResult: $actionResult)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagerRequestsStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality().equals(other._requests, _requests) &&
            (identical(other.actionResult, actionResult) ||
                other.actionResult == actionResult));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    errorMessage,
    const DeepCollectionEquality().hash(_requests),
    actionResult,
  );

  /// Create a copy of ManagerRequestsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagerRequestsStateImplCopyWith<_$ManagerRequestsStateImpl>
  get copyWith =>
      __$$ManagerRequestsStateImplCopyWithImpl<_$ManagerRequestsStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ManagerRequestsState implements ManagerRequestsState {
  const factory _ManagerRequestsState({
    final BaseStatus status,
    final String? errorMessage,
    final List<ScheduleRequestModel> requests,
    final String? actionResult,
  }) = _$ManagerRequestsStateImpl;

  @override
  BaseStatus get status;
  @override
  String? get errorMessage;
  @override
  List<ScheduleRequestModel> get requests;
  @override
  String? get actionResult;

  /// Create a copy of ManagerRequestsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManagerRequestsStateImplCopyWith<_$ManagerRequestsStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
