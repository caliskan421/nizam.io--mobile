// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'date_change_request_create.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DateChangeRequestCreate {

@JsonKey(name: 'work_item_id') String get workItemId;@JsonKey(name: 'new_start_on') DateTime get newStartOn;@JsonKey(name: 'new_end_on') DateTime get newEndOn; String? get reason;
/// Create a copy of DateChangeRequestCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DateChangeRequestCreateCopyWith<DateChangeRequestCreate> get copyWith => _$DateChangeRequestCreateCopyWithImpl<DateChangeRequestCreate>(this as DateChangeRequestCreate, _$identity);

  /// Serializes this DateChangeRequestCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DateChangeRequestCreate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DateChangeRequestCreate&&(identical(other.workItemId, _this.workItemId) || other.workItemId == _this.workItemId)&&(identical(other.newStartOn, _this.newStartOn) || other.newStartOn == _this.newStartOn)&&(identical(other.newEndOn, _this.newEndOn) || other.newEndOn == _this.newEndOn)&&(identical(other.reason, _this.reason) || other.reason == _this.reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DateChangeRequestCreate;
  return Object.hash(runtimeType,_this.workItemId,_this.newStartOn,_this.newEndOn,_this.reason);
}

@override
String toString() {
  final _this = this as DateChangeRequestCreate;
  return 'DateChangeRequestCreate(workItemId: ${_this.workItemId}, newStartOn: ${_this.newStartOn}, newEndOn: ${_this.newEndOn}, reason: ${_this.reason})';
}


}

/// @nodoc
abstract mixin class $DateChangeRequestCreateCopyWith<$Res>  {
  factory $DateChangeRequestCreateCopyWith(DateChangeRequestCreate value, $Res Function(DateChangeRequestCreate) _then) = _$DateChangeRequestCreateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId,@JsonKey(name: 'new_start_on') DateTime newStartOn,@JsonKey(name: 'new_end_on') DateTime newEndOn, String? reason
});




}
/// @nodoc
class _$DateChangeRequestCreateCopyWithImpl<$Res>
    implements $DateChangeRequestCreateCopyWith<$Res> {
  _$DateChangeRequestCreateCopyWithImpl(this._self, this._then);

  final DateChangeRequestCreate _self;
  final $Res Function(DateChangeRequestCreate) _then;

/// Create a copy of DateChangeRequestCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workItemId = null,Object? newStartOn = null,Object? newEndOn = null,Object? reason = freezed,}) {
  return _then(DateChangeRequestCreate(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,newStartOn: null == newStartOn ? _self.newStartOn : newStartOn // ignore: cast_nullable_to_non_nullable
as DateTime,newEndOn: null == newEndOn ? _self.newEndOn : newEndOn // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DateChangeRequestCreate].
extension DateChangeRequestCreatePatterns on DateChangeRequestCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DateChangeRequestCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DateChangeRequestCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DateChangeRequestCreate value)  $default,){
final _that = this;
switch (_that) {
case _DateChangeRequestCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DateChangeRequestCreate value)?  $default,){
final _that = this;
switch (_that) {
case _DateChangeRequestCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId, @JsonKey(name: 'new_start_on')  DateTime newStartOn, @JsonKey(name: 'new_end_on')  DateTime newEndOn,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DateChangeRequestCreate() when $default != null:
return $default(_that.workItemId,_that.newStartOn,_that.newEndOn,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId, @JsonKey(name: 'new_start_on')  DateTime newStartOn, @JsonKey(name: 'new_end_on')  DateTime newEndOn,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _DateChangeRequestCreate():
return $default(_that.workItemId,_that.newStartOn,_that.newEndOn,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'work_item_id')  String workItemId, @JsonKey(name: 'new_start_on')  DateTime newStartOn, @JsonKey(name: 'new_end_on')  DateTime newEndOn,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _DateChangeRequestCreate() when $default != null:
return $default(_that.workItemId,_that.newStartOn,_that.newEndOn,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DateChangeRequestCreate implements DateChangeRequestCreate {
  const _DateChangeRequestCreate({@JsonKey(name: 'work_item_id') required this.workItemId, @JsonKey(name: 'new_start_on') required this.newStartOn, @JsonKey(name: 'new_end_on') required this.newEndOn, this.reason});
  factory _DateChangeRequestCreate.fromJson(Map<String, dynamic> json) => _$DateChangeRequestCreateFromJson(json);

@override@JsonKey(name: 'work_item_id') final  String workItemId;
@override@JsonKey(name: 'new_start_on') final  DateTime newStartOn;
@override@JsonKey(name: 'new_end_on') final  DateTime newEndOn;
@override final  String? reason;

/// Create a copy of DateChangeRequestCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DateChangeRequestCreateCopyWith<_DateChangeRequestCreate> get copyWith => __$DateChangeRequestCreateCopyWithImpl<_DateChangeRequestCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DateChangeRequestCreateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DateChangeRequestCreate&&(identical(other.workItemId, workItemId) || other.workItemId == workItemId)&&(identical(other.newStartOn, newStartOn) || other.newStartOn == newStartOn)&&(identical(other.newEndOn, newEndOn) || other.newEndOn == newEndOn)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,workItemId,newStartOn,newEndOn,reason);
}

@override
String toString() {
    return 'DateChangeRequestCreate(workItemId: $workItemId, newStartOn: $newStartOn, newEndOn: $newEndOn, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$DateChangeRequestCreateCopyWith<$Res> implements $DateChangeRequestCreateCopyWith<$Res> {
  factory _$DateChangeRequestCreateCopyWith(_DateChangeRequestCreate value, $Res Function(_DateChangeRequestCreate) _then) = __$DateChangeRequestCreateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId,@JsonKey(name: 'new_start_on') DateTime newStartOn,@JsonKey(name: 'new_end_on') DateTime newEndOn, String? reason
});




}
/// @nodoc
class __$DateChangeRequestCreateCopyWithImpl<$Res>
    implements _$DateChangeRequestCreateCopyWith<$Res> {
  __$DateChangeRequestCreateCopyWithImpl(this._self, this._then);

  final _DateChangeRequestCreate _self;
  final $Res Function(_DateChangeRequestCreate) _then;

/// Create a copy of DateChangeRequestCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workItemId = null,Object? newStartOn = null,Object? newEndOn = null,Object? reason = freezed,}) {
  return _then(_DateChangeRequestCreate(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,newStartOn: null == newStartOn ? _self.newStartOn : newStartOn // ignore: cast_nullable_to_non_nullable
as DateTime,newEndOn: null == newEndOn ? _self.newEndOn : newEndOn // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
