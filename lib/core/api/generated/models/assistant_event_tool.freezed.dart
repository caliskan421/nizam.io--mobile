// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant_event_tool.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssistantEventTool {

 AssistantEventToolArac get arac;/// Arayüzde gösterilecek kısa metin.
 String get etiket;
/// Create a copy of AssistantEventTool
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssistantEventToolCopyWith<AssistantEventTool> get copyWith => _$AssistantEventToolCopyWithImpl<AssistantEventTool>(this as AssistantEventTool, _$identity);

  /// Serializes this AssistantEventTool to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AssistantEventTool;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssistantEventTool&&(identical(other.arac, _this.arac) || other.arac == _this.arac)&&(identical(other.etiket, _this.etiket) || other.etiket == _this.etiket));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AssistantEventTool;
  return Object.hash(runtimeType,_this.arac,_this.etiket);
}

@override
String toString() {
  final _this = this as AssistantEventTool;
  return 'AssistantEventTool(arac: ${_this.arac}, etiket: ${_this.etiket})';
}


}

/// @nodoc
abstract mixin class $AssistantEventToolCopyWith<$Res>  {
  factory $AssistantEventToolCopyWith(AssistantEventTool value, $Res Function(AssistantEventTool) _then) = _$AssistantEventToolCopyWithImpl;
@useResult
$Res call({
 AssistantEventToolArac arac, String etiket
});




}
/// @nodoc
class _$AssistantEventToolCopyWithImpl<$Res>
    implements $AssistantEventToolCopyWith<$Res> {
  _$AssistantEventToolCopyWithImpl(this._self, this._then);

  final AssistantEventTool _self;
  final $Res Function(AssistantEventTool) _then;

/// Create a copy of AssistantEventTool
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? arac = null,Object? etiket = null,}) {
  return _then(AssistantEventTool(
arac: null == arac ? _self.arac : arac // ignore: cast_nullable_to_non_nullable
as AssistantEventToolArac,etiket: null == etiket ? _self.etiket : etiket // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AssistantEventTool].
extension AssistantEventToolPatterns on AssistantEventTool {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssistantEventTool value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssistantEventTool() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssistantEventTool value)  $default,){
final _that = this;
switch (_that) {
case _AssistantEventTool():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssistantEventTool value)?  $default,){
final _that = this;
switch (_that) {
case _AssistantEventTool() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AssistantEventToolArac arac,  String etiket)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssistantEventTool() when $default != null:
return $default(_that.arac,_that.etiket);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AssistantEventToolArac arac,  String etiket)  $default,) {final _that = this;
switch (_that) {
case _AssistantEventTool():
return $default(_that.arac,_that.etiket);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AssistantEventToolArac arac,  String etiket)?  $default,) {final _that = this;
switch (_that) {
case _AssistantEventTool() when $default != null:
return $default(_that.arac,_that.etiket);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssistantEventTool implements AssistantEventTool {
  const _AssistantEventTool({required this.arac, required this.etiket});
  factory _AssistantEventTool.fromJson(Map<String, dynamic> json) => _$AssistantEventToolFromJson(json);

@override final  AssistantEventToolArac arac;
/// Arayüzde gösterilecek kısa metin.
@override final  String etiket;

/// Create a copy of AssistantEventTool
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssistantEventToolCopyWith<_AssistantEventTool> get copyWith => __$AssistantEventToolCopyWithImpl<_AssistantEventTool>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssistantEventToolToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssistantEventTool&&(identical(other.arac, arac) || other.arac == arac)&&(identical(other.etiket, etiket) || other.etiket == etiket));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,arac,etiket);
}

@override
String toString() {
    return 'AssistantEventTool(arac: $arac, etiket: $etiket)';
}


}

/// @nodoc
abstract mixin class _$AssistantEventToolCopyWith<$Res> implements $AssistantEventToolCopyWith<$Res> {
  factory _$AssistantEventToolCopyWith(_AssistantEventTool value, $Res Function(_AssistantEventTool) _then) = __$AssistantEventToolCopyWithImpl;
@override @useResult
$Res call({
 AssistantEventToolArac arac, String etiket
});




}
/// @nodoc
class __$AssistantEventToolCopyWithImpl<$Res>
    implements _$AssistantEventToolCopyWith<$Res> {
  __$AssistantEventToolCopyWithImpl(this._self, this._then);

  final _AssistantEventTool _self;
  final $Res Function(_AssistantEventTool) _then;

/// Create a copy of AssistantEventTool
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? arac = null,Object? etiket = null,}) {
  return _then(_AssistantEventTool(
arac: null == arac ? _self.arac : arac // ignore: cast_nullable_to_non_nullable
as AssistantEventToolArac,etiket: null == etiket ? _self.etiket : etiket // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
