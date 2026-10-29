// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_public_key.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PushPublicKey {

@JsonKey(name: 'public_key') String get publicKey; bool get enabled;
/// Create a copy of PushPublicKey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PushPublicKeyCopyWith<PushPublicKey> get copyWith => _$PushPublicKeyCopyWithImpl<PushPublicKey>(this as PushPublicKey, _$identity);

  /// Serializes this PushPublicKey to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PushPublicKey;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PushPublicKey&&(identical(other.publicKey, _this.publicKey) || other.publicKey == _this.publicKey)&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PushPublicKey;
  return Object.hash(runtimeType,_this.publicKey,_this.enabled);
}

@override
String toString() {
  final _this = this as PushPublicKey;
  return 'PushPublicKey(publicKey: ${_this.publicKey}, enabled: ${_this.enabled})';
}


}

/// @nodoc
abstract mixin class $PushPublicKeyCopyWith<$Res>  {
  factory $PushPublicKeyCopyWith(PushPublicKey value, $Res Function(PushPublicKey) _then) = _$PushPublicKeyCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'public_key') String publicKey, bool enabled
});




}
/// @nodoc
class _$PushPublicKeyCopyWithImpl<$Res>
    implements $PushPublicKeyCopyWith<$Res> {
  _$PushPublicKeyCopyWithImpl(this._self, this._then);

  final PushPublicKey _self;
  final $Res Function(PushPublicKey) _then;

/// Create a copy of PushPublicKey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? publicKey = null,Object? enabled = null,}) {
  return _then(PushPublicKey(
publicKey: null == publicKey ? _self.publicKey : publicKey // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PushPublicKey].
extension PushPublicKeyPatterns on PushPublicKey {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PushPublicKey value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PushPublicKey() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PushPublicKey value)  $default,){
final _that = this;
switch (_that) {
case _PushPublicKey():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PushPublicKey value)?  $default,){
final _that = this;
switch (_that) {
case _PushPublicKey() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'public_key')  String publicKey,  bool enabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PushPublicKey() when $default != null:
return $default(_that.publicKey,_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'public_key')  String publicKey,  bool enabled)  $default,) {final _that = this;
switch (_that) {
case _PushPublicKey():
return $default(_that.publicKey,_that.enabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'public_key')  String publicKey,  bool enabled)?  $default,) {final _that = this;
switch (_that) {
case _PushPublicKey() when $default != null:
return $default(_that.publicKey,_that.enabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PushPublicKey implements PushPublicKey {
  const _PushPublicKey({@JsonKey(name: 'public_key') required this.publicKey, required this.enabled});
  factory _PushPublicKey.fromJson(Map<String, dynamic> json) => _$PushPublicKeyFromJson(json);

@override@JsonKey(name: 'public_key') final  String publicKey;
@override final  bool enabled;

/// Create a copy of PushPublicKey
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PushPublicKeyCopyWith<_PushPublicKey> get copyWith => __$PushPublicKeyCopyWithImpl<_PushPublicKey>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PushPublicKeyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PushPublicKey&&(identical(other.publicKey, publicKey) || other.publicKey == publicKey)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,publicKey,enabled);
}

@override
String toString() {
    return 'PushPublicKey(publicKey: $publicKey, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$PushPublicKeyCopyWith<$Res> implements $PushPublicKeyCopyWith<$Res> {
  factory _$PushPublicKeyCopyWith(_PushPublicKey value, $Res Function(_PushPublicKey) _then) = __$PushPublicKeyCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'public_key') String publicKey, bool enabled
});




}
/// @nodoc
class __$PushPublicKeyCopyWithImpl<$Res>
    implements _$PushPublicKeyCopyWith<$Res> {
  __$PushPublicKeyCopyWithImpl(this._self, this._then);

  final _PushPublicKey _self;
  final $Res Function(_PushPublicKey) _then;

/// Create a copy of PushPublicKey
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? publicKey = null,Object? enabled = null,}) {
  return _then(_PushPublicKey(
publicKey: null == publicKey ? _self.publicKey : publicKey // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
