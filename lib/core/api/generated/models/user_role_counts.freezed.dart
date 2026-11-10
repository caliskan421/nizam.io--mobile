// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_role_counts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserRoleCounts {

 int get all;@JsonKey(name: 'company_admin') int get companyAdmin; int get koordinator; int get uye;
/// Create a copy of UserRoleCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserRoleCountsCopyWith<UserRoleCounts> get copyWith => _$UserRoleCountsCopyWithImpl<UserRoleCounts>(this as UserRoleCounts, _$identity);

  /// Serializes this UserRoleCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserRoleCounts;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserRoleCounts&&(identical(other.all, _this.all) || other.all == _this.all)&&(identical(other.companyAdmin, _this.companyAdmin) || other.companyAdmin == _this.companyAdmin)&&(identical(other.koordinator, _this.koordinator) || other.koordinator == _this.koordinator)&&(identical(other.uye, _this.uye) || other.uye == _this.uye));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserRoleCounts;
  return Object.hash(runtimeType,_this.all,_this.companyAdmin,_this.koordinator,_this.uye);
}

@override
String toString() {
  final _this = this as UserRoleCounts;
  return 'UserRoleCounts(all: ${_this.all}, companyAdmin: ${_this.companyAdmin}, koordinator: ${_this.koordinator}, uye: ${_this.uye})';
}


}

/// @nodoc
abstract mixin class $UserRoleCountsCopyWith<$Res>  {
  factory $UserRoleCountsCopyWith(UserRoleCounts value, $Res Function(UserRoleCounts) _then) = _$UserRoleCountsCopyWithImpl;
@useResult
$Res call({
 int all,@JsonKey(name: 'company_admin') int companyAdmin, int koordinator, int uye
});




}
/// @nodoc
class _$UserRoleCountsCopyWithImpl<$Res>
    implements $UserRoleCountsCopyWith<$Res> {
  _$UserRoleCountsCopyWithImpl(this._self, this._then);

  final UserRoleCounts _self;
  final $Res Function(UserRoleCounts) _then;

/// Create a copy of UserRoleCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? all = null,Object? companyAdmin = null,Object? koordinator = null,Object? uye = null,}) {
  return _then(UserRoleCounts(
all: null == all ? _self.all : all // ignore: cast_nullable_to_non_nullable
as int,companyAdmin: null == companyAdmin ? _self.companyAdmin : companyAdmin // ignore: cast_nullable_to_non_nullable
as int,koordinator: null == koordinator ? _self.koordinator : koordinator // ignore: cast_nullable_to_non_nullable
as int,uye: null == uye ? _self.uye : uye // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserRoleCounts].
extension UserRoleCountsPatterns on UserRoleCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserRoleCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserRoleCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserRoleCounts value)  $default,){
final _that = this;
switch (_that) {
case _UserRoleCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserRoleCounts value)?  $default,){
final _that = this;
switch (_that) {
case _UserRoleCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int all, @JsonKey(name: 'company_admin')  int companyAdmin,  int koordinator,  int uye)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserRoleCounts() when $default != null:
return $default(_that.all,_that.companyAdmin,_that.koordinator,_that.uye);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int all, @JsonKey(name: 'company_admin')  int companyAdmin,  int koordinator,  int uye)  $default,) {final _that = this;
switch (_that) {
case _UserRoleCounts():
return $default(_that.all,_that.companyAdmin,_that.koordinator,_that.uye);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int all, @JsonKey(name: 'company_admin')  int companyAdmin,  int koordinator,  int uye)?  $default,) {final _that = this;
switch (_that) {
case _UserRoleCounts() when $default != null:
return $default(_that.all,_that.companyAdmin,_that.koordinator,_that.uye);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserRoleCounts implements UserRoleCounts {
  const _UserRoleCounts({required this.all, @JsonKey(name: 'company_admin') required this.companyAdmin, required this.koordinator, required this.uye});
  factory _UserRoleCounts.fromJson(Map<String, dynamic> json) => _$UserRoleCountsFromJson(json);

@override final  int all;
@override@JsonKey(name: 'company_admin') final  int companyAdmin;
@override final  int koordinator;
@override final  int uye;

/// Create a copy of UserRoleCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserRoleCountsCopyWith<_UserRoleCounts> get copyWith => __$UserRoleCountsCopyWithImpl<_UserRoleCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserRoleCountsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserRoleCounts&&(identical(other.all, all) || other.all == all)&&(identical(other.companyAdmin, companyAdmin) || other.companyAdmin == companyAdmin)&&(identical(other.koordinator, koordinator) || other.koordinator == koordinator)&&(identical(other.uye, uye) || other.uye == uye));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,all,companyAdmin,koordinator,uye);
}

@override
String toString() {
    return 'UserRoleCounts(all: $all, companyAdmin: $companyAdmin, koordinator: $koordinator, uye: $uye)';
}


}

/// @nodoc
abstract mixin class _$UserRoleCountsCopyWith<$Res> implements $UserRoleCountsCopyWith<$Res> {
  factory _$UserRoleCountsCopyWith(_UserRoleCounts value, $Res Function(_UserRoleCounts) _then) = __$UserRoleCountsCopyWithImpl;
@override @useResult
$Res call({
 int all,@JsonKey(name: 'company_admin') int companyAdmin, int koordinator, int uye
});




}
/// @nodoc
class __$UserRoleCountsCopyWithImpl<$Res>
    implements _$UserRoleCountsCopyWith<$Res> {
  __$UserRoleCountsCopyWithImpl(this._self, this._then);

  final _UserRoleCounts _self;
  final $Res Function(_UserRoleCounts) _then;

/// Create a copy of UserRoleCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? all = null,Object? companyAdmin = null,Object? koordinator = null,Object? uye = null,}) {
  return _then(_UserRoleCounts(
all: null == all ? _self.all : all // ignore: cast_nullable_to_non_nullable
as int,companyAdmin: null == companyAdmin ? _self.companyAdmin : companyAdmin // ignore: cast_nullable_to_non_nullable
as int,koordinator: null == koordinator ? _self.koordinator : koordinator // ignore: cast_nullable_to_non_nullable
as int,uye: null == uye ? _self.uye : uye // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
