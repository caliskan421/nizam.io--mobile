// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conference_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConferenceResult {

 Conference get conference;
/// Create a copy of ConferenceResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConferenceResultCopyWith<ConferenceResult> get copyWith => _$ConferenceResultCopyWithImpl<ConferenceResult>(this as ConferenceResult, _$identity);

  /// Serializes this ConferenceResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ConferenceResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConferenceResult&&(identical(other.conference, _this.conference) || other.conference == _this.conference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ConferenceResult;
  return Object.hash(runtimeType,_this.conference);
}

@override
String toString() {
  final _this = this as ConferenceResult;
  return 'ConferenceResult(conference: ${_this.conference})';
}


}

/// @nodoc
abstract mixin class $ConferenceResultCopyWith<$Res>  {
  factory $ConferenceResultCopyWith(ConferenceResult value, $Res Function(ConferenceResult) _then) = _$ConferenceResultCopyWithImpl;
@useResult
$Res call({
 Conference conference
});


$ConferenceCopyWith<$Res> get conference;

}
/// @nodoc
class _$ConferenceResultCopyWithImpl<$Res>
    implements $ConferenceResultCopyWith<$Res> {
  _$ConferenceResultCopyWithImpl(this._self, this._then);

  final ConferenceResult _self;
  final $Res Function(ConferenceResult) _then;

/// Create a copy of ConferenceResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conference = null,}) {
  return _then(ConferenceResult(
conference: null == conference ? _self.conference : conference // ignore: cast_nullable_to_non_nullable
as Conference,
  ));
}
/// Create a copy of ConferenceResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConferenceCopyWith<$Res> get conference {
  
  return $ConferenceCopyWith<$Res>(_self.conference, (value) {
    return _then(_self.copyWith(conference: value));
  });
}
}


/// Adds pattern-matching-related methods to [ConferenceResult].
extension ConferenceResultPatterns on ConferenceResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConferenceResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConferenceResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConferenceResult value)  $default,){
final _that = this;
switch (_that) {
case _ConferenceResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConferenceResult value)?  $default,){
final _that = this;
switch (_that) {
case _ConferenceResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Conference conference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConferenceResult() when $default != null:
return $default(_that.conference);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Conference conference)  $default,) {final _that = this;
switch (_that) {
case _ConferenceResult():
return $default(_that.conference);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Conference conference)?  $default,) {final _that = this;
switch (_that) {
case _ConferenceResult() when $default != null:
return $default(_that.conference);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConferenceResult implements ConferenceResult {
  const _ConferenceResult({required this.conference});
  factory _ConferenceResult.fromJson(Map<String, dynamic> json) => _$ConferenceResultFromJson(json);

@override final  Conference conference;

/// Create a copy of ConferenceResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConferenceResultCopyWith<_ConferenceResult> get copyWith => __$ConferenceResultCopyWithImpl<_ConferenceResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConferenceResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConferenceResult&&(identical(other.conference, conference) || other.conference == conference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,conference);
}

@override
String toString() {
    return 'ConferenceResult(conference: $conference)';
}


}

/// @nodoc
abstract mixin class _$ConferenceResultCopyWith<$Res> implements $ConferenceResultCopyWith<$Res> {
  factory _$ConferenceResultCopyWith(_ConferenceResult value, $Res Function(_ConferenceResult) _then) = __$ConferenceResultCopyWithImpl;
@override @useResult
$Res call({
 Conference conference
});


@override $ConferenceCopyWith<$Res> get conference;

}
/// @nodoc
class __$ConferenceResultCopyWithImpl<$Res>
    implements _$ConferenceResultCopyWith<$Res> {
  __$ConferenceResultCopyWithImpl(this._self, this._then);

  final _ConferenceResult _self;
  final $Res Function(_ConferenceResult) _then;

/// Create a copy of ConferenceResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conference = null,}) {
  return _then(_ConferenceResult(
conference: null == conference ? _self.conference : conference // ignore: cast_nullable_to_non_nullable
as Conference,
  ));
}

/// Create a copy of ConferenceResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConferenceCopyWith<$Res> get conference {
  
  return $ConferenceCopyWith<$Res>(_self.conference, (value) {
    return _then(_self.copyWith(conference: value));
  });
}
}

// dart format on
