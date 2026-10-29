// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'keys.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Keys {

 String get p256dh; String get auth;
/// Create a copy of Keys
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeysCopyWith<Keys> get copyWith => _$KeysCopyWithImpl<Keys>(this as Keys, _$identity);

  /// Serializes this Keys to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Keys;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Keys&&(identical(other.p256dh, _this.p256dh) || other.p256dh == _this.p256dh)&&(identical(other.auth, _this.auth) || other.auth == _this.auth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Keys;
  return Object.hash(runtimeType,_this.p256dh,_this.auth);
}

@override
String toString() {
  final _this = this as Keys;
  return 'Keys(p256dh: ${_this.p256dh}, auth: ${_this.auth})';
}


}

/// @nodoc
abstract mixin class $KeysCopyWith<$Res>  {
  factory $KeysCopyWith(Keys value, $Res Function(Keys) _then) = _$KeysCopyWithImpl;
@useResult
$Res call({
 String p256dh, String auth
});




}
/// @nodoc
class _$KeysCopyWithImpl<$Res>
    implements $KeysCopyWith<$Res> {
  _$KeysCopyWithImpl(this._self, this._then);

  final Keys _self;
  final $Res Function(Keys) _then;

/// Create a copy of Keys
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? p256dh = null,Object? auth = null,}) {
  return _then(Keys(
p256dh: null == p256dh ? _self.p256dh : p256dh // ignore: cast_nullable_to_non_nullable
as String,auth: null == auth ? _self.auth : auth // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Keys].
extension KeysPatterns on Keys {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Keys value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Keys() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Keys value)  $default,){
final _that = this;
switch (_that) {
case _Keys():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Keys value)?  $default,){
final _that = this;
switch (_that) {
case _Keys() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String p256dh,  String auth)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Keys() when $default != null:
return $default(_that.p256dh,_that.auth);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String p256dh,  String auth)  $default,) {final _that = this;
switch (_that) {
case _Keys():
return $default(_that.p256dh,_that.auth);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String p256dh,  String auth)?  $default,) {final _that = this;
switch (_that) {
case _Keys() when $default != null:
return $default(_that.p256dh,_that.auth);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Keys implements Keys {
  const _Keys({required this.p256dh, required this.auth});
  factory _Keys.fromJson(Map<String, dynamic> json) => _$KeysFromJson(json);

@override final  String p256dh;
@override final  String auth;

/// Create a copy of Keys
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeysCopyWith<_Keys> get copyWith => __$KeysCopyWithImpl<_Keys>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KeysToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Keys&&(identical(other.p256dh, p256dh) || other.p256dh == p256dh)&&(identical(other.auth, auth) || other.auth == auth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,p256dh,auth);
}

@override
String toString() {
    return 'Keys(p256dh: $p256dh, auth: $auth)';
}


}

/// @nodoc
abstract mixin class _$KeysCopyWith<$Res> implements $KeysCopyWith<$Res> {
  factory _$KeysCopyWith(_Keys value, $Res Function(_Keys) _then) = __$KeysCopyWithImpl;
@override @useResult
$Res call({
 String p256dh, String auth
});




}
/// @nodoc
class __$KeysCopyWithImpl<$Res>
    implements _$KeysCopyWith<$Res> {
  __$KeysCopyWithImpl(this._self, this._then);

  final _Keys _self;
  final $Res Function(_Keys) _then;

/// Create a copy of Keys
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? p256dh = null,Object? auth = null,}) {
  return _then(_Keys(
p256dh: null == p256dh ? _self.p256dh : p256dh // ignore: cast_nullable_to_non_nullable
as String,auth: null == auth ? _self.auth : auth // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
