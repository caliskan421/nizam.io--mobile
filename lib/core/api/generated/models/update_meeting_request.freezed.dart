// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_meeting_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateMeetingRequest {

 String? get title;/// Verilirse kuruluştaki kuralla aynı: geçmiş gün olamaz.
@JsonKey(name: 'meeting_date') String? get meetingDate;@JsonKey(name: 'department_ids') List<String>? get departmentIds;@JsonKey(name: 'members_included') bool? get membersIncluded;
/// Create a copy of UpdateMeetingRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateMeetingRequestCopyWith<UpdateMeetingRequest> get copyWith => _$UpdateMeetingRequestCopyWithImpl<UpdateMeetingRequest>(this as UpdateMeetingRequest, _$identity);

  /// Serializes this UpdateMeetingRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateMeetingRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateMeetingRequest&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.meetingDate, _this.meetingDate) || other.meetingDate == _this.meetingDate)&&const DeepCollectionEquality().equals(other.departmentIds, _this.departmentIds)&&(identical(other.membersIncluded, _this.membersIncluded) || other.membersIncluded == _this.membersIncluded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateMeetingRequest;
  return Object.hash(runtimeType,_this.title,_this.meetingDate,const DeepCollectionEquality().hash(_this.departmentIds),_this.membersIncluded);
}

@override
String toString() {
  final _this = this as UpdateMeetingRequest;
  return 'UpdateMeetingRequest(title: ${_this.title}, meetingDate: ${_this.meetingDate}, departmentIds: ${_this.departmentIds}, membersIncluded: ${_this.membersIncluded})';
}


}

/// @nodoc
abstract mixin class $UpdateMeetingRequestCopyWith<$Res>  {
  factory $UpdateMeetingRequestCopyWith(UpdateMeetingRequest value, $Res Function(UpdateMeetingRequest) _then) = _$UpdateMeetingRequestCopyWithImpl;
@useResult
$Res call({
 String? title,@JsonKey(name: 'meeting_date') String? meetingDate,@JsonKey(name: 'department_ids') List<String>? departmentIds,@JsonKey(name: 'members_included') bool? membersIncluded
});




}
/// @nodoc
class _$UpdateMeetingRequestCopyWithImpl<$Res>
    implements $UpdateMeetingRequestCopyWith<$Res> {
  _$UpdateMeetingRequestCopyWithImpl(this._self, this._then);

  final UpdateMeetingRequest _self;
  final $Res Function(UpdateMeetingRequest) _then;

/// Create a copy of UpdateMeetingRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? meetingDate = freezed,Object? departmentIds = freezed,Object? membersIncluded = freezed,}) {
  return _then(UpdateMeetingRequest(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,meetingDate: freezed == meetingDate ? _self.meetingDate : meetingDate // ignore: cast_nullable_to_non_nullable
as String?,departmentIds: freezed == departmentIds ? _self.departmentIds : departmentIds // ignore: cast_nullable_to_non_nullable
as List<String>?,membersIncluded: freezed == membersIncluded ? _self.membersIncluded : membersIncluded // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateMeetingRequest].
extension UpdateMeetingRequestPatterns on UpdateMeetingRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateMeetingRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateMeetingRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateMeetingRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateMeetingRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateMeetingRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateMeetingRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title, @JsonKey(name: 'meeting_date')  String? meetingDate, @JsonKey(name: 'department_ids')  List<String>? departmentIds, @JsonKey(name: 'members_included')  bool? membersIncluded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateMeetingRequest() when $default != null:
return $default(_that.title,_that.meetingDate,_that.departmentIds,_that.membersIncluded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title, @JsonKey(name: 'meeting_date')  String? meetingDate, @JsonKey(name: 'department_ids')  List<String>? departmentIds, @JsonKey(name: 'members_included')  bool? membersIncluded)  $default,) {final _that = this;
switch (_that) {
case _UpdateMeetingRequest():
return $default(_that.title,_that.meetingDate,_that.departmentIds,_that.membersIncluded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title, @JsonKey(name: 'meeting_date')  String? meetingDate, @JsonKey(name: 'department_ids')  List<String>? departmentIds, @JsonKey(name: 'members_included')  bool? membersIncluded)?  $default,) {final _that = this;
switch (_that) {
case _UpdateMeetingRequest() when $default != null:
return $default(_that.title,_that.meetingDate,_that.departmentIds,_that.membersIncluded);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateMeetingRequest implements UpdateMeetingRequest {
  const _UpdateMeetingRequest({this.title, @JsonKey(name: 'meeting_date') this.meetingDate, @JsonKey(name: 'department_ids')  List<String>? departmentIds, @JsonKey(name: 'members_included') this.membersIncluded}): _departmentIds = departmentIds;
  factory _UpdateMeetingRequest.fromJson(Map<String, dynamic> json) => _$UpdateMeetingRequestFromJson(json);

@override final  String? title;
/// Verilirse kuruluştaki kuralla aynı: geçmiş gün olamaz.
@override@JsonKey(name: 'meeting_date') final  String? meetingDate;
 final  List<String>? _departmentIds;
@override@JsonKey(name: 'department_ids') List<String>? get departmentIds {
  final value = _departmentIds;
  if (value == null) return null;
  if (_departmentIds is EqualUnmodifiableListView) return _departmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'members_included') final  bool? membersIncluded;

/// Create a copy of UpdateMeetingRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateMeetingRequestCopyWith<_UpdateMeetingRequest> get copyWith => __$UpdateMeetingRequestCopyWithImpl<_UpdateMeetingRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateMeetingRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateMeetingRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.meetingDate, meetingDate) || other.meetingDate == meetingDate)&&const DeepCollectionEquality().equals(other.departmentIds, _departmentIds)&&(identical(other.membersIncluded, membersIncluded) || other.membersIncluded == membersIncluded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,meetingDate,const DeepCollectionEquality().hash(_departmentIds),membersIncluded);
}

@override
String toString() {
    return 'UpdateMeetingRequest(title: $title, meetingDate: $meetingDate, departmentIds: $departmentIds, membersIncluded: $membersIncluded)';
}


}

/// @nodoc
abstract mixin class _$UpdateMeetingRequestCopyWith<$Res> implements $UpdateMeetingRequestCopyWith<$Res> {
  factory _$UpdateMeetingRequestCopyWith(_UpdateMeetingRequest value, $Res Function(_UpdateMeetingRequest) _then) = __$UpdateMeetingRequestCopyWithImpl;
@override @useResult
$Res call({
 String? title,@JsonKey(name: 'meeting_date') String? meetingDate,@JsonKey(name: 'department_ids') List<String>? departmentIds,@JsonKey(name: 'members_included') bool? membersIncluded
});




}
/// @nodoc
class __$UpdateMeetingRequestCopyWithImpl<$Res>
    implements _$UpdateMeetingRequestCopyWith<$Res> {
  __$UpdateMeetingRequestCopyWithImpl(this._self, this._then);

  final _UpdateMeetingRequest _self;
  final $Res Function(_UpdateMeetingRequest) _then;

/// Create a copy of UpdateMeetingRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? meetingDate = freezed,Object? departmentIds = freezed,Object? membersIncluded = freezed,}) {
  return _then(_UpdateMeetingRequest(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,meetingDate: freezed == meetingDate ? _self.meetingDate : meetingDate // ignore: cast_nullable_to_non_nullable
as String?,departmentIds: freezed == departmentIds ? _self._departmentIds : departmentIds // ignore: cast_nullable_to_non_nullable
as List<String>?,membersIncluded: freezed == membersIncluded ? _self.membersIncluded : membersIncluded // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
