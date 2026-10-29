// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant_event_names.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssistantEventNames {

/// Bu soruda görülen takma ad (`Üye-N`) → görünen ad. E-posta ve hesap kimliği taşımaz.
 Map<String, String> get adlar;
/// Create a copy of AssistantEventNames
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssistantEventNamesCopyWith<AssistantEventNames> get copyWith => _$AssistantEventNamesCopyWithImpl<AssistantEventNames>(this as AssistantEventNames, _$identity);

  /// Serializes this AssistantEventNames to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AssistantEventNames;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssistantEventNames&&const DeepCollectionEquality().equals(other.adlar, _this.adlar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AssistantEventNames;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.adlar));
}

@override
String toString() {
  final _this = this as AssistantEventNames;
  return 'AssistantEventNames(adlar: ${_this.adlar})';
}


}

/// @nodoc
abstract mixin class $AssistantEventNamesCopyWith<$Res>  {
  factory $AssistantEventNamesCopyWith(AssistantEventNames value, $Res Function(AssistantEventNames) _then) = _$AssistantEventNamesCopyWithImpl;
@useResult
$Res call({
 Map<String, String> adlar
});




}
/// @nodoc
class _$AssistantEventNamesCopyWithImpl<$Res>
    implements $AssistantEventNamesCopyWith<$Res> {
  _$AssistantEventNamesCopyWithImpl(this._self, this._then);

  final AssistantEventNames _self;
  final $Res Function(AssistantEventNames) _then;

/// Create a copy of AssistantEventNames
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? adlar = null,}) {
  return _then(AssistantEventNames(
adlar: null == adlar ? _self.adlar : adlar // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AssistantEventNames].
extension AssistantEventNamesPatterns on AssistantEventNames {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssistantEventNames value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssistantEventNames() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssistantEventNames value)  $default,){
final _that = this;
switch (_that) {
case _AssistantEventNames():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssistantEventNames value)?  $default,){
final _that = this;
switch (_that) {
case _AssistantEventNames() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, String> adlar)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssistantEventNames() when $default != null:
return $default(_that.adlar);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, String> adlar)  $default,) {final _that = this;
switch (_that) {
case _AssistantEventNames():
return $default(_that.adlar);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, String> adlar)?  $default,) {final _that = this;
switch (_that) {
case _AssistantEventNames() when $default != null:
return $default(_that.adlar);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssistantEventNames implements AssistantEventNames {
  const _AssistantEventNames({required  Map<String, String> adlar}): _adlar = adlar;
  factory _AssistantEventNames.fromJson(Map<String, dynamic> json) => _$AssistantEventNamesFromJson(json);

/// Bu soruda görülen takma ad (`Üye-N`) → görünen ad. E-posta ve hesap kimliği taşımaz.
 final  Map<String, String> _adlar;
/// Bu soruda görülen takma ad (`Üye-N`) → görünen ad. E-posta ve hesap kimliği taşımaz.
@override Map<String, String> get adlar {
  if (_adlar is EqualUnmodifiableMapView) return _adlar;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_adlar);
}


/// Create a copy of AssistantEventNames
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssistantEventNamesCopyWith<_AssistantEventNames> get copyWith => __$AssistantEventNamesCopyWithImpl<_AssistantEventNames>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssistantEventNamesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssistantEventNames&&const DeepCollectionEquality().equals(other.adlar, _adlar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_adlar));
}

@override
String toString() {
    return 'AssistantEventNames(adlar: $adlar)';
}


}

/// @nodoc
abstract mixin class _$AssistantEventNamesCopyWith<$Res> implements $AssistantEventNamesCopyWith<$Res> {
  factory _$AssistantEventNamesCopyWith(_AssistantEventNames value, $Res Function(_AssistantEventNames) _then) = __$AssistantEventNamesCopyWithImpl;
@override @useResult
$Res call({
 Map<String, String> adlar
});




}
/// @nodoc
class __$AssistantEventNamesCopyWithImpl<$Res>
    implements _$AssistantEventNamesCopyWith<$Res> {
  __$AssistantEventNamesCopyWithImpl(this._self, this._then);

  final _AssistantEventNames _self;
  final $Res Function(_AssistantEventNames) _then;

/// Create a copy of AssistantEventNames
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? adlar = null,}) {
  return _then(_AssistantEventNames(
adlar: null == adlar ? _self._adlar : adlar // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
