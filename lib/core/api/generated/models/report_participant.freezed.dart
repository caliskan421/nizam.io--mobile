// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_participant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportParticipant {

@JsonKey(name: 'account_id') String get accountId;@JsonKey(name: 'full_name') String get fullName; String get role;
/// Create a copy of ReportParticipant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportParticipantCopyWith<ReportParticipant> get copyWith => _$ReportParticipantCopyWithImpl<ReportParticipant>(this as ReportParticipant, _$identity);

  /// Serializes this ReportParticipant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportParticipant;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportParticipant&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.role, _this.role) || other.role == _this.role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportParticipant;
  return Object.hash(runtimeType,_this.accountId,_this.fullName,_this.role);
}

@override
String toString() {
  final _this = this as ReportParticipant;
  return 'ReportParticipant(accountId: ${_this.accountId}, fullName: ${_this.fullName}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $ReportParticipantCopyWith<$Res>  {
  factory $ReportParticipantCopyWith(ReportParticipant value, $Res Function(ReportParticipant) _then) = _$ReportParticipantCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName, String role
});




}
/// @nodoc
class _$ReportParticipantCopyWithImpl<$Res>
    implements $ReportParticipantCopyWith<$Res> {
  _$ReportParticipantCopyWithImpl(this._self, this._then);

  final ReportParticipant _self;
  final $Res Function(ReportParticipant) _then;

/// Create a copy of ReportParticipant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? fullName = null,Object? role = null,}) {
  return _then(ReportParticipant(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportParticipant].
extension ReportParticipantPatterns on ReportParticipant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportParticipant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportParticipant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportParticipant value)  $default,){
final _that = this;
switch (_that) {
case _ReportParticipant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportParticipant value)?  $default,){
final _that = this;
switch (_that) {
case _ReportParticipant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  String role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportParticipant() when $default != null:
return $default(_that.accountId,_that.fullName,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  String role)  $default,) {final _that = this;
switch (_that) {
case _ReportParticipant():
return $default(_that.accountId,_that.fullName,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  String role)?  $default,) {final _that = this;
switch (_that) {
case _ReportParticipant() when $default != null:
return $default(_that.accountId,_that.fullName,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportParticipant implements ReportParticipant {
  const _ReportParticipant({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'full_name') required this.fullName, required this.role});
  factory _ReportParticipant.fromJson(Map<String, dynamic> json) => _$ReportParticipantFromJson(json);

@override@JsonKey(name: 'account_id') final  String accountId;
@override@JsonKey(name: 'full_name') final  String fullName;
@override final  String role;

/// Create a copy of ReportParticipant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportParticipantCopyWith<_ReportParticipant> get copyWith => __$ReportParticipantCopyWithImpl<_ReportParticipant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportParticipantToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportParticipant&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountId,fullName,role);
}

@override
String toString() {
    return 'ReportParticipant(accountId: $accountId, fullName: $fullName, role: $role)';
}


}

/// @nodoc
abstract mixin class _$ReportParticipantCopyWith<$Res> implements $ReportParticipantCopyWith<$Res> {
  factory _$ReportParticipantCopyWith(_ReportParticipant value, $Res Function(_ReportParticipant) _then) = __$ReportParticipantCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName, String role
});




}
/// @nodoc
class __$ReportParticipantCopyWithImpl<$Res>
    implements _$ReportParticipantCopyWith<$Res> {
  __$ReportParticipantCopyWithImpl(this._self, this._then);

  final _ReportParticipant _self;
  final $Res Function(_ReportParticipant) _then;

/// Create a copy of ReportParticipant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? fullName = null,Object? role = null,}) {
  return _then(_ReportParticipant(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
