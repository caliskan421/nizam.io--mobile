// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_subtask_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateSubtaskRequest {

 String? get title;@JsonKey(name: 'assignee_account_id') String? get assigneeAccountId;@JsonKey(name: 'start_on') String? get startOn;@JsonKey(name: 'end_on') String? get endOn;/// true kapatır, false yeniden açar (tamamlanmış görevde 409 `work.item_completed`).
 bool? get done;
/// Create a copy of UpdateSubtaskRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateSubtaskRequestCopyWith<UpdateSubtaskRequest> get copyWith => _$UpdateSubtaskRequestCopyWithImpl<UpdateSubtaskRequest>(this as UpdateSubtaskRequest, _$identity);

  /// Serializes this UpdateSubtaskRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateSubtaskRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateSubtaskRequest&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.assigneeAccountId, _this.assigneeAccountId) || other.assigneeAccountId == _this.assigneeAccountId)&&(identical(other.startOn, _this.startOn) || other.startOn == _this.startOn)&&(identical(other.endOn, _this.endOn) || other.endOn == _this.endOn)&&(identical(other.done, _this.done) || other.done == _this.done));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateSubtaskRequest;
  return Object.hash(runtimeType,_this.title,_this.assigneeAccountId,_this.startOn,_this.endOn,_this.done);
}

@override
String toString() {
  final _this = this as UpdateSubtaskRequest;
  return 'UpdateSubtaskRequest(title: ${_this.title}, assigneeAccountId: ${_this.assigneeAccountId}, startOn: ${_this.startOn}, endOn: ${_this.endOn}, done: ${_this.done})';
}


}

/// @nodoc
abstract mixin class $UpdateSubtaskRequestCopyWith<$Res>  {
  factory $UpdateSubtaskRequestCopyWith(UpdateSubtaskRequest value, $Res Function(UpdateSubtaskRequest) _then) = _$UpdateSubtaskRequestCopyWithImpl;
@useResult
$Res call({
 String? title,@JsonKey(name: 'assignee_account_id') String? assigneeAccountId,@JsonKey(name: 'start_on') String? startOn,@JsonKey(name: 'end_on') String? endOn, bool? done
});




}
/// @nodoc
class _$UpdateSubtaskRequestCopyWithImpl<$Res>
    implements $UpdateSubtaskRequestCopyWith<$Res> {
  _$UpdateSubtaskRequestCopyWithImpl(this._self, this._then);

  final UpdateSubtaskRequest _self;
  final $Res Function(UpdateSubtaskRequest) _then;

/// Create a copy of UpdateSubtaskRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? assigneeAccountId = freezed,Object? startOn = freezed,Object? endOn = freezed,Object? done = freezed,}) {
  return _then(UpdateSubtaskRequest(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,assigneeAccountId: freezed == assigneeAccountId ? _self.assigneeAccountId : assigneeAccountId // ignore: cast_nullable_to_non_nullable
as String?,startOn: freezed == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as String?,endOn: freezed == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as String?,done: freezed == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateSubtaskRequest].
extension UpdateSubtaskRequestPatterns on UpdateSubtaskRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateSubtaskRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateSubtaskRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateSubtaskRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateSubtaskRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateSubtaskRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateSubtaskRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title, @JsonKey(name: 'assignee_account_id')  String? assigneeAccountId, @JsonKey(name: 'start_on')  String? startOn, @JsonKey(name: 'end_on')  String? endOn,  bool? done)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateSubtaskRequest() when $default != null:
return $default(_that.title,_that.assigneeAccountId,_that.startOn,_that.endOn,_that.done);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title, @JsonKey(name: 'assignee_account_id')  String? assigneeAccountId, @JsonKey(name: 'start_on')  String? startOn, @JsonKey(name: 'end_on')  String? endOn,  bool? done)  $default,) {final _that = this;
switch (_that) {
case _UpdateSubtaskRequest():
return $default(_that.title,_that.assigneeAccountId,_that.startOn,_that.endOn,_that.done);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title, @JsonKey(name: 'assignee_account_id')  String? assigneeAccountId, @JsonKey(name: 'start_on')  String? startOn, @JsonKey(name: 'end_on')  String? endOn,  bool? done)?  $default,) {final _that = this;
switch (_that) {
case _UpdateSubtaskRequest() when $default != null:
return $default(_that.title,_that.assigneeAccountId,_that.startOn,_that.endOn,_that.done);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateSubtaskRequest implements UpdateSubtaskRequest {
  const _UpdateSubtaskRequest({this.title, @JsonKey(name: 'assignee_account_id') this.assigneeAccountId, @JsonKey(name: 'start_on') this.startOn, @JsonKey(name: 'end_on') this.endOn, this.done});
  factory _UpdateSubtaskRequest.fromJson(Map<String, dynamic> json) => _$UpdateSubtaskRequestFromJson(json);

@override final  String? title;
@override@JsonKey(name: 'assignee_account_id') final  String? assigneeAccountId;
@override@JsonKey(name: 'start_on') final  String? startOn;
@override@JsonKey(name: 'end_on') final  String? endOn;
/// true kapatır, false yeniden açar (tamamlanmış görevde 409 `work.item_completed`).
@override final  bool? done;

/// Create a copy of UpdateSubtaskRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateSubtaskRequestCopyWith<_UpdateSubtaskRequest> get copyWith => __$UpdateSubtaskRequestCopyWithImpl<_UpdateSubtaskRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateSubtaskRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateSubtaskRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.assigneeAccountId, assigneeAccountId) || other.assigneeAccountId == assigneeAccountId)&&(identical(other.startOn, startOn) || other.startOn == startOn)&&(identical(other.endOn, endOn) || other.endOn == endOn)&&(identical(other.done, done) || other.done == done));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,assigneeAccountId,startOn,endOn,done);
}

@override
String toString() {
    return 'UpdateSubtaskRequest(title: $title, assigneeAccountId: $assigneeAccountId, startOn: $startOn, endOn: $endOn, done: $done)';
}


}

/// @nodoc
abstract mixin class _$UpdateSubtaskRequestCopyWith<$Res> implements $UpdateSubtaskRequestCopyWith<$Res> {
  factory _$UpdateSubtaskRequestCopyWith(_UpdateSubtaskRequest value, $Res Function(_UpdateSubtaskRequest) _then) = __$UpdateSubtaskRequestCopyWithImpl;
@override @useResult
$Res call({
 String? title,@JsonKey(name: 'assignee_account_id') String? assigneeAccountId,@JsonKey(name: 'start_on') String? startOn,@JsonKey(name: 'end_on') String? endOn, bool? done
});




}
/// @nodoc
class __$UpdateSubtaskRequestCopyWithImpl<$Res>
    implements _$UpdateSubtaskRequestCopyWith<$Res> {
  __$UpdateSubtaskRequestCopyWithImpl(this._self, this._then);

  final _UpdateSubtaskRequest _self;
  final $Res Function(_UpdateSubtaskRequest) _then;

/// Create a copy of UpdateSubtaskRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? assigneeAccountId = freezed,Object? startOn = freezed,Object? endOn = freezed,Object? done = freezed,}) {
  return _then(_UpdateSubtaskRequest(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,assigneeAccountId: freezed == assigneeAccountId ? _self.assigneeAccountId : assigneeAccountId // ignore: cast_nullable_to_non_nullable
as String?,startOn: freezed == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as String?,endOn: freezed == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as String?,done: freezed == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
