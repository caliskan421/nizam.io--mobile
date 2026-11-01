// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_item_assignee.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkItemAssignee {

@JsonKey(name: 'account_id') String get accountId;/// Görünen ad. Hesabın satırı yoksa `null` (boş dize değil); ad okuması o an başarısızsa da geçici olarak `null` (yanıt yine başarılıdır). İstemci nötr etiket gösterir. Silinmiş (geri yüklenebilir) hesabın adı döner.
@JsonKey(name: 'full_name') String? get fullName;
/// Create a copy of WorkItemAssignee
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkItemAssigneeCopyWith<WorkItemAssignee> get copyWith => _$WorkItemAssigneeCopyWithImpl<WorkItemAssignee>(this as WorkItemAssignee, _$identity);

  /// Serializes this WorkItemAssignee to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkItemAssignee;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkItemAssignee&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkItemAssignee;
  return Object.hash(runtimeType,_this.accountId,_this.fullName);
}

@override
String toString() {
  final _this = this as WorkItemAssignee;
  return 'WorkItemAssignee(accountId: ${_this.accountId}, fullName: ${_this.fullName})';
}


}

/// @nodoc
abstract mixin class $WorkItemAssigneeCopyWith<$Res>  {
  factory $WorkItemAssigneeCopyWith(WorkItemAssignee value, $Res Function(WorkItemAssignee) _then) = _$WorkItemAssigneeCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String? fullName
});




}
/// @nodoc
class _$WorkItemAssigneeCopyWithImpl<$Res>
    implements $WorkItemAssigneeCopyWith<$Res> {
  _$WorkItemAssigneeCopyWithImpl(this._self, this._then);

  final WorkItemAssignee _self;
  final $Res Function(WorkItemAssignee) _then;

/// Create a copy of WorkItemAssignee
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? fullName = freezed,}) {
  return _then(WorkItemAssignee(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkItemAssignee].
extension WorkItemAssigneePatterns on WorkItemAssignee {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkItemAssignee value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkItemAssignee() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkItemAssignee value)  $default,){
final _that = this;
switch (_that) {
case _WorkItemAssignee():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkItemAssignee value)?  $default,){
final _that = this;
switch (_that) {
case _WorkItemAssignee() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String? fullName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkItemAssignee() when $default != null:
return $default(_that.accountId,_that.fullName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String? fullName)  $default,) {final _that = this;
switch (_that) {
case _WorkItemAssignee():
return $default(_that.accountId,_that.fullName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String? fullName)?  $default,) {final _that = this;
switch (_that) {
case _WorkItemAssignee() when $default != null:
return $default(_that.accountId,_that.fullName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkItemAssignee implements WorkItemAssignee {
  const _WorkItemAssignee({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'full_name') required this.fullName});
  factory _WorkItemAssignee.fromJson(Map<String, dynamic> json) => _$WorkItemAssigneeFromJson(json);

@override@JsonKey(name: 'account_id') final  String accountId;
/// Görünen ad. Hesabın satırı yoksa `null` (boş dize değil); ad okuması o an başarısızsa da geçici olarak `null` (yanıt yine başarılıdır). İstemci nötr etiket gösterir. Silinmiş (geri yüklenebilir) hesabın adı döner.
@override@JsonKey(name: 'full_name') final  String? fullName;

/// Create a copy of WorkItemAssignee
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkItemAssigneeCopyWith<_WorkItemAssignee> get copyWith => __$WorkItemAssigneeCopyWithImpl<_WorkItemAssignee>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkItemAssigneeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkItemAssignee&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.fullName, fullName) || other.fullName == fullName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountId,fullName);
}

@override
String toString() {
    return 'WorkItemAssignee(accountId: $accountId, fullName: $fullName)';
}


}

/// @nodoc
abstract mixin class _$WorkItemAssigneeCopyWith<$Res> implements $WorkItemAssigneeCopyWith<$Res> {
  factory _$WorkItemAssigneeCopyWith(_WorkItemAssignee value, $Res Function(_WorkItemAssignee) _then) = __$WorkItemAssigneeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String? fullName
});




}
/// @nodoc
class __$WorkItemAssigneeCopyWithImpl<$Res>
    implements _$WorkItemAssigneeCopyWith<$Res> {
  __$WorkItemAssigneeCopyWithImpl(this._self, this._then);

  final _WorkItemAssignee _self;
  final $Res Function(_WorkItemAssignee) _then;

/// Create a copy of WorkItemAssignee
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? fullName = freezed,}) {
  return _then(_WorkItemAssignee(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
