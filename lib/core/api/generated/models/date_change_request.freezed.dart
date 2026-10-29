// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'date_change_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DateChangeRequest {

@JsonKey(name: 'request_id') String get requestId;@JsonKey(name: 'work_item_id') String get workItemId; DateChangeRequestStatus get status;@JsonKey(name: 'old_start_on') DateTime get oldStartOn;@JsonKey(name: 'new_start_on') DateTime get newStartOn;@JsonKey(name: 'old_end_on') DateTime get oldEndOn;@JsonKey(name: 'new_end_on') DateTime get newEndOn; String? get reason;
/// Create a copy of DateChangeRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DateChangeRequestCopyWith<DateChangeRequest> get copyWith => _$DateChangeRequestCopyWithImpl<DateChangeRequest>(this as DateChangeRequest, _$identity);

  /// Serializes this DateChangeRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DateChangeRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DateChangeRequest&&(identical(other.requestId, _this.requestId) || other.requestId == _this.requestId)&&(identical(other.workItemId, _this.workItemId) || other.workItemId == _this.workItemId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.oldStartOn, _this.oldStartOn) || other.oldStartOn == _this.oldStartOn)&&(identical(other.newStartOn, _this.newStartOn) || other.newStartOn == _this.newStartOn)&&(identical(other.oldEndOn, _this.oldEndOn) || other.oldEndOn == _this.oldEndOn)&&(identical(other.newEndOn, _this.newEndOn) || other.newEndOn == _this.newEndOn)&&(identical(other.reason, _this.reason) || other.reason == _this.reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DateChangeRequest;
  return Object.hash(runtimeType,_this.requestId,_this.workItemId,_this.status,_this.oldStartOn,_this.newStartOn,_this.oldEndOn,_this.newEndOn,_this.reason);
}

@override
String toString() {
  final _this = this as DateChangeRequest;
  return 'DateChangeRequest(requestId: ${_this.requestId}, workItemId: ${_this.workItemId}, status: ${_this.status}, oldStartOn: ${_this.oldStartOn}, newStartOn: ${_this.newStartOn}, oldEndOn: ${_this.oldEndOn}, newEndOn: ${_this.newEndOn}, reason: ${_this.reason})';
}


}

/// @nodoc
abstract mixin class $DateChangeRequestCopyWith<$Res>  {
  factory $DateChangeRequestCopyWith(DateChangeRequest value, $Res Function(DateChangeRequest) _then) = _$DateChangeRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'request_id') String requestId,@JsonKey(name: 'work_item_id') String workItemId, DateChangeRequestStatus status,@JsonKey(name: 'old_start_on') DateTime oldStartOn,@JsonKey(name: 'new_start_on') DateTime newStartOn,@JsonKey(name: 'old_end_on') DateTime oldEndOn,@JsonKey(name: 'new_end_on') DateTime newEndOn, String? reason
});




}
/// @nodoc
class _$DateChangeRequestCopyWithImpl<$Res>
    implements $DateChangeRequestCopyWith<$Res> {
  _$DateChangeRequestCopyWithImpl(this._self, this._then);

  final DateChangeRequest _self;
  final $Res Function(DateChangeRequest) _then;

/// Create a copy of DateChangeRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? workItemId = null,Object? status = null,Object? oldStartOn = null,Object? newStartOn = null,Object? oldEndOn = null,Object? newEndOn = null,Object? reason = freezed,}) {
  return _then(DateChangeRequest(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DateChangeRequestStatus,oldStartOn: null == oldStartOn ? _self.oldStartOn : oldStartOn // ignore: cast_nullable_to_non_nullable
as DateTime,newStartOn: null == newStartOn ? _self.newStartOn : newStartOn // ignore: cast_nullable_to_non_nullable
as DateTime,oldEndOn: null == oldEndOn ? _self.oldEndOn : oldEndOn // ignore: cast_nullable_to_non_nullable
as DateTime,newEndOn: null == newEndOn ? _self.newEndOn : newEndOn // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DateChangeRequest].
extension DateChangeRequestPatterns on DateChangeRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DateChangeRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DateChangeRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DateChangeRequest value)  $default,){
final _that = this;
switch (_that) {
case _DateChangeRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DateChangeRequest value)?  $default,){
final _that = this;
switch (_that) {
case _DateChangeRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'request_id')  String requestId, @JsonKey(name: 'work_item_id')  String workItemId,  DateChangeRequestStatus status, @JsonKey(name: 'old_start_on')  DateTime oldStartOn, @JsonKey(name: 'new_start_on')  DateTime newStartOn, @JsonKey(name: 'old_end_on')  DateTime oldEndOn, @JsonKey(name: 'new_end_on')  DateTime newEndOn,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DateChangeRequest() when $default != null:
return $default(_that.requestId,_that.workItemId,_that.status,_that.oldStartOn,_that.newStartOn,_that.oldEndOn,_that.newEndOn,_that.reason);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'request_id')  String requestId, @JsonKey(name: 'work_item_id')  String workItemId,  DateChangeRequestStatus status, @JsonKey(name: 'old_start_on')  DateTime oldStartOn, @JsonKey(name: 'new_start_on')  DateTime newStartOn, @JsonKey(name: 'old_end_on')  DateTime oldEndOn, @JsonKey(name: 'new_end_on')  DateTime newEndOn,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _DateChangeRequest():
return $default(_that.requestId,_that.workItemId,_that.status,_that.oldStartOn,_that.newStartOn,_that.oldEndOn,_that.newEndOn,_that.reason);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'request_id')  String requestId, @JsonKey(name: 'work_item_id')  String workItemId,  DateChangeRequestStatus status, @JsonKey(name: 'old_start_on')  DateTime oldStartOn, @JsonKey(name: 'new_start_on')  DateTime newStartOn, @JsonKey(name: 'old_end_on')  DateTime oldEndOn, @JsonKey(name: 'new_end_on')  DateTime newEndOn,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _DateChangeRequest() when $default != null:
return $default(_that.requestId,_that.workItemId,_that.status,_that.oldStartOn,_that.newStartOn,_that.oldEndOn,_that.newEndOn,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DateChangeRequest implements DateChangeRequest {
  const _DateChangeRequest({@JsonKey(name: 'request_id') required this.requestId, @JsonKey(name: 'work_item_id') required this.workItemId, required this.status, @JsonKey(name: 'old_start_on') required this.oldStartOn, @JsonKey(name: 'new_start_on') required this.newStartOn, @JsonKey(name: 'old_end_on') required this.oldEndOn, @JsonKey(name: 'new_end_on') required this.newEndOn, this.reason});
  factory _DateChangeRequest.fromJson(Map<String, dynamic> json) => _$DateChangeRequestFromJson(json);

@override@JsonKey(name: 'request_id') final  String requestId;
@override@JsonKey(name: 'work_item_id') final  String workItemId;
@override final  DateChangeRequestStatus status;
@override@JsonKey(name: 'old_start_on') final  DateTime oldStartOn;
@override@JsonKey(name: 'new_start_on') final  DateTime newStartOn;
@override@JsonKey(name: 'old_end_on') final  DateTime oldEndOn;
@override@JsonKey(name: 'new_end_on') final  DateTime newEndOn;
@override final  String? reason;

/// Create a copy of DateChangeRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DateChangeRequestCopyWith<_DateChangeRequest> get copyWith => __$DateChangeRequestCopyWithImpl<_DateChangeRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DateChangeRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DateChangeRequest&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.workItemId, workItemId) || other.workItemId == workItemId)&&(identical(other.status, status) || other.status == status)&&(identical(other.oldStartOn, oldStartOn) || other.oldStartOn == oldStartOn)&&(identical(other.newStartOn, newStartOn) || other.newStartOn == newStartOn)&&(identical(other.oldEndOn, oldEndOn) || other.oldEndOn == oldEndOn)&&(identical(other.newEndOn, newEndOn) || other.newEndOn == newEndOn)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,requestId,workItemId,status,oldStartOn,newStartOn,oldEndOn,newEndOn,reason);
}

@override
String toString() {
    return 'DateChangeRequest(requestId: $requestId, workItemId: $workItemId, status: $status, oldStartOn: $oldStartOn, newStartOn: $newStartOn, oldEndOn: $oldEndOn, newEndOn: $newEndOn, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$DateChangeRequestCopyWith<$Res> implements $DateChangeRequestCopyWith<$Res> {
  factory _$DateChangeRequestCopyWith(_DateChangeRequest value, $Res Function(_DateChangeRequest) _then) = __$DateChangeRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'request_id') String requestId,@JsonKey(name: 'work_item_id') String workItemId, DateChangeRequestStatus status,@JsonKey(name: 'old_start_on') DateTime oldStartOn,@JsonKey(name: 'new_start_on') DateTime newStartOn,@JsonKey(name: 'old_end_on') DateTime oldEndOn,@JsonKey(name: 'new_end_on') DateTime newEndOn, String? reason
});




}
/// @nodoc
class __$DateChangeRequestCopyWithImpl<$Res>
    implements _$DateChangeRequestCopyWith<$Res> {
  __$DateChangeRequestCopyWithImpl(this._self, this._then);

  final _DateChangeRequest _self;
  final $Res Function(_DateChangeRequest) _then;

/// Create a copy of DateChangeRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? workItemId = null,Object? status = null,Object? oldStartOn = null,Object? newStartOn = null,Object? oldEndOn = null,Object? newEndOn = null,Object? reason = freezed,}) {
  return _then(_DateChangeRequest(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DateChangeRequestStatus,oldStartOn: null == oldStartOn ? _self.oldStartOn : oldStartOn // ignore: cast_nullable_to_non_nullable
as DateTime,newStartOn: null == newStartOn ? _self.newStartOn : newStartOn // ignore: cast_nullable_to_non_nullable
as DateTime,oldEndOn: null == oldEndOn ? _self.oldEndOn : oldEndOn // ignore: cast_nullable_to_non_nullable
as DateTime,newEndOn: null == newEndOn ? _self.newEndOn : newEndOn // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
