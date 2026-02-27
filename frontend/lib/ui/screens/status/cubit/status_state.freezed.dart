// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'status_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$StatusState {
  BaseStatus get status => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  List<ScheduleRequestModel> get requests => throw _privateConstructorUsedError;

  /// Create a copy of StatusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatusStateCopyWith<StatusState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatusStateCopyWith<$Res> {
  factory $StatusStateCopyWith(
    StatusState value,
    $Res Function(StatusState) then,
  ) = _$StatusStateCopyWithImpl<$Res, StatusState>;
  @useResult
  $Res call({
    BaseStatus status,
    String? errorMessage,
    List<ScheduleRequestModel> requests,
  });
}

/// @nodoc
class _$StatusStateCopyWithImpl<$Res, $Val extends StatusState>
    implements $StatusStateCopyWith<$Res> {
  _$StatusStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StatusState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? errorMessage = freezed,
    Object? requests = null,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StatusStateImplCopyWith<$Res>
    implements $StatusStateCopyWith<$Res> {
  factory _$$StatusStateImplCopyWith(
    _$StatusStateImpl value,
    $Res Function(_$StatusStateImpl) then,
  ) = __$$StatusStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    BaseStatus status,
    String? errorMessage,
    List<ScheduleRequestModel> requests,
  });
}

/// @nodoc
class __$$StatusStateImplCopyWithImpl<$Res>
    extends _$StatusStateCopyWithImpl<$Res, _$StatusStateImpl>
    implements _$$StatusStateImplCopyWith<$Res> {
  __$$StatusStateImplCopyWithImpl(
    _$StatusStateImpl _value,
    $Res Function(_$StatusStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StatusState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? errorMessage = freezed,
    Object? requests = null,
  }) {
    return _then(
      _$StatusStateImpl(
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
      ),
    );
  }
}

/// @nodoc

class _$StatusStateImpl implements _StatusState {
  const _$StatusStateImpl({
    this.status = BaseStatus.initial,
    this.errorMessage,
    final List<ScheduleRequestModel> requests = const [],
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
  String toString() {
    return 'StatusState(status: $status, errorMessage: $errorMessage, requests: $requests)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatusStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality().equals(other._requests, _requests));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    errorMessage,
    const DeepCollectionEquality().hash(_requests),
  );

  /// Create a copy of StatusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatusStateImplCopyWith<_$StatusStateImpl> get copyWith =>
      __$$StatusStateImplCopyWithImpl<_$StatusStateImpl>(this, _$identity);
}

abstract class _StatusState implements StatusState {
  const factory _StatusState({
    final BaseStatus status,
    final String? errorMessage,
    final List<ScheduleRequestModel> requests,
  }) = _$StatusStateImpl;

  @override
  BaseStatus get status;
  @override
  String? get errorMessage;
  @override
  List<ScheduleRequestModel> get requests;

  /// Create a copy of StatusState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatusStateImplCopyWith<_$StatusStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
