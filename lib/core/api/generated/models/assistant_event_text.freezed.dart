// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant_event_text.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssistantEventText {

/// Cevap metninin bir parçası.
 String get metin;
/// Create a copy of AssistantEventText
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssistantEventTextCopyWith<AssistantEventText> get copyWith => _$AssistantEventTextCopyWithImpl<AssistantEventText>(this as AssistantEventText, _$identity);

  /// Serializes this AssistantEventText to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AssistantEventText;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssistantEventText&&(identical(other.metin, _this.metin) || other.metin == _this.metin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AssistantEventText;
  return Object.hash(runtimeType,_this.metin);
}

@override
String toString() {
  final _this = this as AssistantEventText;
  return 'AssistantEventText(metin: ${_this.metin})';
}


}

/// @nodoc
abstract mixin class $AssistantEventTextCopyWith<$Res>  {
  factory $AssistantEventTextCopyWith(AssistantEventText value, $Res Function(AssistantEventText) _then) = _$AssistantEventTextCopyWithImpl;
@useResult
$Res call({
 String metin
});




}
/// @nodoc
class _$AssistantEventTextCopyWithImpl<$Res>
    implements $AssistantEventTextCopyWith<$Res> {
  _$AssistantEventTextCopyWithImpl(this._self, this._then);

  final AssistantEventText _self;
  final $Res Function(AssistantEventText) _then;

/// Create a copy of AssistantEventText
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? metin = null,}) {
  return _then(AssistantEventText(
metin: null == metin ? _self.metin : metin // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AssistantEventText].
extension AssistantEventTextPatterns on AssistantEventText {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssistantEventText value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssistantEventText() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssistantEventText value)  $default,){
final _that = this;
switch (_that) {
case _AssistantEventText():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssistantEventText value)?  $default,){
final _that = this;
switch (_that) {
case _AssistantEventText() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String metin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssistantEventText() when $default != null:
return $default(_that.metin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String metin)  $default,) {final _that = this;
switch (_that) {
case _AssistantEventText():
return $default(_that.metin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String metin)?  $default,) {final _that = this;
switch (_that) {
case _AssistantEventText() when $default != null:
return $default(_that.metin);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssistantEventText implements AssistantEventText {
  const _AssistantEventText({required this.metin});
  factory _AssistantEventText.fromJson(Map<String, dynamic> json) => _$AssistantEventTextFromJson(json);

/// Cevap metninin bir parçası.
@override final  String metin;

/// Create a copy of AssistantEventText
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssistantEventTextCopyWith<_AssistantEventText> get copyWith => __$AssistantEventTextCopyWithImpl<_AssistantEventText>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssistantEventTextToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssistantEventText&&(identical(other.metin, metin) || other.metin == metin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,metin);
}

@override
String toString() {
    return 'AssistantEventText(metin: $metin)';
}


}

/// @nodoc
abstract mixin class _$AssistantEventTextCopyWith<$Res> implements $AssistantEventTextCopyWith<$Res> {
  factory _$AssistantEventTextCopyWith(_AssistantEventText value, $Res Function(_AssistantEventText) _then) = __$AssistantEventTextCopyWithImpl;
@override @useResult
$Res call({
 String metin
});




}
/// @nodoc
class __$AssistantEventTextCopyWithImpl<$Res>
    implements _$AssistantEventTextCopyWith<$Res> {
  __$AssistantEventTextCopyWithImpl(this._self, this._then);

  final _AssistantEventText _self;
  final $Res Function(_AssistantEventText) _then;

/// Create a copy of AssistantEventText
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? metin = null,}) {
  return _then(_AssistantEventText(
metin: null == metin ? _self.metin : metin // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
