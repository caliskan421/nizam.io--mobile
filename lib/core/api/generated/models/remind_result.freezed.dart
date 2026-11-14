// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remind_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RemindResult {

/// Bildirim kuyruğa alınan atanan sayısı (eylemi yapan hariç).
@JsonKey(name: 'recipient_count') int get recipientCount;
/// Create a copy of RemindResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemindResultCopyWith<RemindResult> get copyWith => _$RemindResultCopyWithImpl<RemindResult>(this as RemindResult, _$identity);

  /// Serializes this RemindResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RemindResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemindResult&&(identical(other.recipientCount, _this.recipientCount) || other.recipientCount == _this.recipientCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RemindResult;
  return Object.hash(runtimeType,_this.recipientCount);
}

@override
String toString() {
  final _this = this as RemindResult;
  return 'RemindResult(recipientCount: ${_this.recipientCount})';
}


}

/// @nodoc
abstract mixin class $RemindResultCopyWith<$Res>  {
  factory $RemindResultCopyWith(RemindResult value, $Res Function(RemindResult) _then) = _$RemindResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'recipient_count') int recipientCount
});




}
/// @nodoc
class _$RemindResultCopyWithImpl<$Res>
    implements $RemindResultCopyWith<$Res> {
  _$RemindResultCopyWithImpl(this._self, this._then);

  final RemindResult _self;
  final $Res Function(RemindResult) _then;

/// Create a copy of RemindResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recipientCount = null,}) {
  return _then(RemindResult(
recipientCount: null == recipientCount ? _self.recipientCount : recipientCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RemindResult].
extension RemindResultPatterns on RemindResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RemindResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RemindResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RemindResult value)  $default,){
final _that = this;
switch (_that) {
case _RemindResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RemindResult value)?  $default,){
final _that = this;
switch (_that) {
case _RemindResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'recipient_count')  int recipientCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RemindResult() when $default != null:
return $default(_that.recipientCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'recipient_count')  int recipientCount)  $default,) {final _that = this;
switch (_that) {
case _RemindResult():
return $default(_that.recipientCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'recipient_count')  int recipientCount)?  $default,) {final _that = this;
switch (_that) {
case _RemindResult() when $default != null:
return $default(_that.recipientCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RemindResult implements RemindResult {
  const _RemindResult({@JsonKey(name: 'recipient_count') required this.recipientCount});
  factory _RemindResult.fromJson(Map<String, dynamic> json) => _$RemindResultFromJson(json);

/// Bildirim kuyruğa alınan atanan sayısı (eylemi yapan hariç).
@override@JsonKey(name: 'recipient_count') final  int recipientCount;

/// Create a copy of RemindResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemindResultCopyWith<_RemindResult> get copyWith => __$RemindResultCopyWithImpl<_RemindResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RemindResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemindResult&&(identical(other.recipientCount, recipientCount) || other.recipientCount == recipientCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,recipientCount);
}

@override
String toString() {
    return 'RemindResult(recipientCount: $recipientCount)';
}


}

/// @nodoc
abstract mixin class _$RemindResultCopyWith<$Res> implements $RemindResultCopyWith<$Res> {
  factory _$RemindResultCopyWith(_RemindResult value, $Res Function(_RemindResult) _then) = __$RemindResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'recipient_count') int recipientCount
});




}
/// @nodoc
class __$RemindResultCopyWithImpl<$Res>
    implements _$RemindResultCopyWith<$Res> {
  __$RemindResultCopyWithImpl(this._self, this._then);

  final _RemindResult _self;
  final $Res Function(_RemindResult) _then;

/// Create a copy of RemindResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recipientCount = null,}) {
  return _then(_RemindResult(
recipientCount: null == recipientCount ? _self.recipientCount : recipientCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
