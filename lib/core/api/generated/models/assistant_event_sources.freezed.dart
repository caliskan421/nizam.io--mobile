// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant_event_sources.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssistantEventSources {

/// Cevabın dayandığı araç adları.
 List<String> get kaynaklar;
/// Create a copy of AssistantEventSources
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssistantEventSourcesCopyWith<AssistantEventSources> get copyWith => _$AssistantEventSourcesCopyWithImpl<AssistantEventSources>(this as AssistantEventSources, _$identity);

  /// Serializes this AssistantEventSources to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AssistantEventSources;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssistantEventSources&&const DeepCollectionEquality().equals(other.kaynaklar, _this.kaynaklar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AssistantEventSources;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.kaynaklar));
}

@override
String toString() {
  final _this = this as AssistantEventSources;
  return 'AssistantEventSources(kaynaklar: ${_this.kaynaklar})';
}


}

/// @nodoc
abstract mixin class $AssistantEventSourcesCopyWith<$Res>  {
  factory $AssistantEventSourcesCopyWith(AssistantEventSources value, $Res Function(AssistantEventSources) _then) = _$AssistantEventSourcesCopyWithImpl;
@useResult
$Res call({
 List<String> kaynaklar
});




}
/// @nodoc
class _$AssistantEventSourcesCopyWithImpl<$Res>
    implements $AssistantEventSourcesCopyWith<$Res> {
  _$AssistantEventSourcesCopyWithImpl(this._self, this._then);

  final AssistantEventSources _self;
  final $Res Function(AssistantEventSources) _then;

/// Create a copy of AssistantEventSources
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kaynaklar = null,}) {
  return _then(AssistantEventSources(
kaynaklar: null == kaynaklar ? _self.kaynaklar : kaynaklar // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AssistantEventSources].
extension AssistantEventSourcesPatterns on AssistantEventSources {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssistantEventSources value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssistantEventSources() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssistantEventSources value)  $default,){
final _that = this;
switch (_that) {
case _AssistantEventSources():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssistantEventSources value)?  $default,){
final _that = this;
switch (_that) {
case _AssistantEventSources() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> kaynaklar)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssistantEventSources() when $default != null:
return $default(_that.kaynaklar);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> kaynaklar)  $default,) {final _that = this;
switch (_that) {
case _AssistantEventSources():
return $default(_that.kaynaklar);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> kaynaklar)?  $default,) {final _that = this;
switch (_that) {
case _AssistantEventSources() when $default != null:
return $default(_that.kaynaklar);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssistantEventSources implements AssistantEventSources {
  const _AssistantEventSources({required  List<String> kaynaklar}): _kaynaklar = kaynaklar;
  factory _AssistantEventSources.fromJson(Map<String, dynamic> json) => _$AssistantEventSourcesFromJson(json);

/// Cevabın dayandığı araç adları.
 final  List<String> _kaynaklar;
/// Cevabın dayandığı araç adları.
@override List<String> get kaynaklar {
  if (_kaynaklar is EqualUnmodifiableListView) return _kaynaklar;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_kaynaklar);
}


/// Create a copy of AssistantEventSources
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssistantEventSourcesCopyWith<_AssistantEventSources> get copyWith => __$AssistantEventSourcesCopyWithImpl<_AssistantEventSources>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssistantEventSourcesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssistantEventSources&&const DeepCollectionEquality().equals(other.kaynaklar, _kaynaklar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_kaynaklar));
}

@override
String toString() {
    return 'AssistantEventSources(kaynaklar: $kaynaklar)';
}


}

/// @nodoc
abstract mixin class _$AssistantEventSourcesCopyWith<$Res> implements $AssistantEventSourcesCopyWith<$Res> {
  factory _$AssistantEventSourcesCopyWith(_AssistantEventSources value, $Res Function(_AssistantEventSources) _then) = __$AssistantEventSourcesCopyWithImpl;
@override @useResult
$Res call({
 List<String> kaynaklar
});




}
/// @nodoc
class __$AssistantEventSourcesCopyWithImpl<$Res>
    implements _$AssistantEventSourcesCopyWith<$Res> {
  __$AssistantEventSourcesCopyWithImpl(this._self, this._then);

  final _AssistantEventSources _self;
  final $Res Function(_AssistantEventSources) _then;

/// Create a copy of AssistantEventSources
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kaynaklar = null,}) {
  return _then(_AssistantEventSources(
kaynaklar: null == kaynaklar ? _self._kaynaklar : kaynaklar // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
