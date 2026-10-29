// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_person.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportPerson {

@JsonKey(name: 'account_id') String get accountId;@JsonKey(name: 'full_name') String get fullName;
/// Create a copy of ReportPerson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportPersonCopyWith<ReportPerson> get copyWith => _$ReportPersonCopyWithImpl<ReportPerson>(this as ReportPerson, _$identity);

  /// Serializes this ReportPerson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportPerson;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportPerson&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportPerson;
  return Object.hash(runtimeType,_this.accountId,_this.fullName);
}

@override
String toString() {
  final _this = this as ReportPerson;
  return 'ReportPerson(accountId: ${_this.accountId}, fullName: ${_this.fullName})';
}


}

/// @nodoc
abstract mixin class $ReportPersonCopyWith<$Res>  {
  factory $ReportPersonCopyWith(ReportPerson value, $Res Function(ReportPerson) _then) = _$ReportPersonCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName
});




}
/// @nodoc
class _$ReportPersonCopyWithImpl<$Res>
    implements $ReportPersonCopyWith<$Res> {
  _$ReportPersonCopyWithImpl(this._self, this._then);

  final ReportPerson _self;
  final $Res Function(ReportPerson) _then;

/// Create a copy of ReportPerson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? fullName = null,}) {
  return _then(ReportPerson(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportPerson].
extension ReportPersonPatterns on ReportPerson {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportPerson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportPerson() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportPerson value)  $default,){
final _that = this;
switch (_that) {
case _ReportPerson():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportPerson value)?  $default,){
final _that = this;
switch (_that) {
case _ReportPerson() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportPerson() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName)  $default,) {final _that = this;
switch (_that) {
case _ReportPerson():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName)?  $default,) {final _that = this;
switch (_that) {
case _ReportPerson() when $default != null:
return $default(_that.accountId,_that.fullName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportPerson implements ReportPerson {
  const _ReportPerson({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'full_name') required this.fullName});
  factory _ReportPerson.fromJson(Map<String, dynamic> json) => _$ReportPersonFromJson(json);

@override@JsonKey(name: 'account_id') final  String accountId;
@override@JsonKey(name: 'full_name') final  String fullName;

/// Create a copy of ReportPerson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportPersonCopyWith<_ReportPerson> get copyWith => __$ReportPersonCopyWithImpl<_ReportPerson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportPersonToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportPerson&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.fullName, fullName) || other.fullName == fullName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountId,fullName);
}

@override
String toString() {
    return 'ReportPerson(accountId: $accountId, fullName: $fullName)';
}


}

/// @nodoc
abstract mixin class _$ReportPersonCopyWith<$Res> implements $ReportPersonCopyWith<$Res> {
  factory _$ReportPersonCopyWith(_ReportPerson value, $Res Function(_ReportPerson) _then) = __$ReportPersonCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName
});




}
/// @nodoc
class __$ReportPersonCopyWithImpl<$Res>
    implements _$ReportPersonCopyWith<$Res> {
  __$ReportPersonCopyWithImpl(this._self, this._then);

  final _ReportPerson _self;
  final $Res Function(_ReportPerson) _then;

/// Create a copy of ReportPerson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? fullName = null,}) {
  return _then(_ReportPerson(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
