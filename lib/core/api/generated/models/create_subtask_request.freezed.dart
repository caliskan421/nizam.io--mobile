// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_subtask_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateSubtaskRequest {

/// 1–300 karakter (kırpılarak), kontrol karakteri yok.
 String get title;/// Opsiyonel; yalnız ana göreve atanmış hesap (aksi 422 `work.subtask_assignee_not_assigned`).
@JsonKey(name: 'assignee_account_id') String? get assigneeAccountId;/// Opsiyonel; `end_on` ile birlikte verilir. Yalnız bilgidir (Gantt, bağımlılık ve gecikmeye girmez).
@DateOnlyConverter()@JsonKey(name: 'start_on') DateTime? get startOn;@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime? get endOn;
/// Create a copy of CreateSubtaskRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateSubtaskRequestCopyWith<CreateSubtaskRequest> get copyWith => _$CreateSubtaskRequestCopyWithImpl<CreateSubtaskRequest>(this as CreateSubtaskRequest, _$identity);

  /// Serializes this CreateSubtaskRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateSubtaskRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateSubtaskRequest&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.assigneeAccountId, _this.assigneeAccountId) || other.assigneeAccountId == _this.assigneeAccountId)&&(identical(other.startOn, _this.startOn) || other.startOn == _this.startOn)&&(identical(other.endOn, _this.endOn) || other.endOn == _this.endOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateSubtaskRequest;
  return Object.hash(runtimeType,_this.title,_this.assigneeAccountId,_this.startOn,_this.endOn);
}

@override
String toString() {
  final _this = this as CreateSubtaskRequest;
  return 'CreateSubtaskRequest(title: ${_this.title}, assigneeAccountId: ${_this.assigneeAccountId}, startOn: ${_this.startOn}, endOn: ${_this.endOn})';
}


}

/// @nodoc
abstract mixin class $CreateSubtaskRequestCopyWith<$Res>  {
  factory $CreateSubtaskRequestCopyWith(CreateSubtaskRequest value, $Res Function(CreateSubtaskRequest) _then) = _$CreateSubtaskRequestCopyWithImpl;
@useResult
$Res call({
 String title,@JsonKey(name: 'assignee_account_id') String? assigneeAccountId,@DateOnlyConverter()@JsonKey(name: 'start_on') DateTime? startOn,@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime? endOn
});




}
/// @nodoc
class _$CreateSubtaskRequestCopyWithImpl<$Res>
    implements $CreateSubtaskRequestCopyWith<$Res> {
  _$CreateSubtaskRequestCopyWithImpl(this._self, this._then);

  final CreateSubtaskRequest _self;
  final $Res Function(CreateSubtaskRequest) _then;

/// Create a copy of CreateSubtaskRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? assigneeAccountId = freezed,Object? startOn = freezed,Object? endOn = freezed,}) {
  return _then(CreateSubtaskRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,assigneeAccountId: freezed == assigneeAccountId ? _self.assigneeAccountId : assigneeAccountId // ignore: cast_nullable_to_non_nullable
as String?,startOn: freezed == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as DateTime?,endOn: freezed == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateSubtaskRequest].
extension CreateSubtaskRequestPatterns on CreateSubtaskRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateSubtaskRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateSubtaskRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateSubtaskRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateSubtaskRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateSubtaskRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateSubtaskRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title, @JsonKey(name: 'assignee_account_id')  String? assigneeAccountId, @DateOnlyConverter()@JsonKey(name: 'start_on')  DateTime? startOn, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime? endOn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateSubtaskRequest() when $default != null:
return $default(_that.title,_that.assigneeAccountId,_that.startOn,_that.endOn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title, @JsonKey(name: 'assignee_account_id')  String? assigneeAccountId, @DateOnlyConverter()@JsonKey(name: 'start_on')  DateTime? startOn, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime? endOn)  $default,) {final _that = this;
switch (_that) {
case _CreateSubtaskRequest():
return $default(_that.title,_that.assigneeAccountId,_that.startOn,_that.endOn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title, @JsonKey(name: 'assignee_account_id')  String? assigneeAccountId, @DateOnlyConverter()@JsonKey(name: 'start_on')  DateTime? startOn, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime? endOn)?  $default,) {final _that = this;
switch (_that) {
case _CreateSubtaskRequest() when $default != null:
return $default(_that.title,_that.assigneeAccountId,_that.startOn,_that.endOn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateSubtaskRequest implements CreateSubtaskRequest {
  const _CreateSubtaskRequest({required this.title, @JsonKey(name: 'assignee_account_id') this.assigneeAccountId, @DateOnlyConverter()@JsonKey(name: 'start_on') this.startOn, @DateOnlyConverter()@JsonKey(name: 'end_on') this.endOn});
  factory _CreateSubtaskRequest.fromJson(Map<String, dynamic> json) => _$CreateSubtaskRequestFromJson(json);

/// 1–300 karakter (kırpılarak), kontrol karakteri yok.
@override final  String title;
/// Opsiyonel; yalnız ana göreve atanmış hesap (aksi 422 `work.subtask_assignee_not_assigned`).
@override@JsonKey(name: 'assignee_account_id') final  String? assigneeAccountId;
/// Opsiyonel; `end_on` ile birlikte verilir. Yalnız bilgidir (Gantt, bağımlılık ve gecikmeye girmez).
@override@DateOnlyConverter()@JsonKey(name: 'start_on') final  DateTime? startOn;
@override@DateOnlyConverter()@JsonKey(name: 'end_on') final  DateTime? endOn;

/// Create a copy of CreateSubtaskRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateSubtaskRequestCopyWith<_CreateSubtaskRequest> get copyWith => __$CreateSubtaskRequestCopyWithImpl<_CreateSubtaskRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateSubtaskRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateSubtaskRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.assigneeAccountId, assigneeAccountId) || other.assigneeAccountId == assigneeAccountId)&&(identical(other.startOn, startOn) || other.startOn == startOn)&&(identical(other.endOn, endOn) || other.endOn == endOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,assigneeAccountId,startOn,endOn);
}

@override
String toString() {
    return 'CreateSubtaskRequest(title: $title, assigneeAccountId: $assigneeAccountId, startOn: $startOn, endOn: $endOn)';
}


}

/// @nodoc
abstract mixin class _$CreateSubtaskRequestCopyWith<$Res> implements $CreateSubtaskRequestCopyWith<$Res> {
  factory _$CreateSubtaskRequestCopyWith(_CreateSubtaskRequest value, $Res Function(_CreateSubtaskRequest) _then) = __$CreateSubtaskRequestCopyWithImpl;
@override @useResult
$Res call({
 String title,@JsonKey(name: 'assignee_account_id') String? assigneeAccountId,@DateOnlyConverter()@JsonKey(name: 'start_on') DateTime? startOn,@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime? endOn
});




}
/// @nodoc
class __$CreateSubtaskRequestCopyWithImpl<$Res>
    implements _$CreateSubtaskRequestCopyWith<$Res> {
  __$CreateSubtaskRequestCopyWithImpl(this._self, this._then);

  final _CreateSubtaskRequest _self;
  final $Res Function(_CreateSubtaskRequest) _then;

/// Create a copy of CreateSubtaskRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? assigneeAccountId = freezed,Object? startOn = freezed,Object? endOn = freezed,}) {
  return _then(_CreateSubtaskRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,assigneeAccountId: freezed == assigneeAccountId ? _self.assigneeAccountId : assigneeAccountId // ignore: cast_nullable_to_non_nullable
as String?,startOn: freezed == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as DateTime?,endOn: freezed == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
