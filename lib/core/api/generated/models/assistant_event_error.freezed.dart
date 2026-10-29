// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant_event_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssistantEventError {

 AssistantEventErrorKod get kod;/// Kullanıcıya gösterilebilir Türkçe metin; iç ayrıntı taşımaz.
 String get mesaj;
/// Create a copy of AssistantEventError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssistantEventErrorCopyWith<AssistantEventError> get copyWith => _$AssistantEventErrorCopyWithImpl<AssistantEventError>(this as AssistantEventError, _$identity);

  /// Serializes this AssistantEventError to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AssistantEventError;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssistantEventError&&(identical(other.kod, _this.kod) || other.kod == _this.kod)&&(identical(other.mesaj, _this.mesaj) || other.mesaj == _this.mesaj));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AssistantEventError;
  return Object.hash(runtimeType,_this.kod,_this.mesaj);
}

@override
String toString() {
  final _this = this as AssistantEventError;
  return 'AssistantEventError(kod: ${_this.kod}, mesaj: ${_this.mesaj})';
}


}

/// @nodoc
abstract mixin class $AssistantEventErrorCopyWith<$Res>  {
  factory $AssistantEventErrorCopyWith(AssistantEventError value, $Res Function(AssistantEventError) _then) = _$AssistantEventErrorCopyWithImpl;
@useResult
$Res call({
 AssistantEventErrorKod kod, String mesaj
});




}
/// @nodoc
class _$AssistantEventErrorCopyWithImpl<$Res>
    implements $AssistantEventErrorCopyWith<$Res> {
  _$AssistantEventErrorCopyWithImpl(this._self, this._then);

  final AssistantEventError _self;
  final $Res Function(AssistantEventError) _then;

/// Create a copy of AssistantEventError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kod = null,Object? mesaj = null,}) {
  return _then(AssistantEventError(
kod: null == kod ? _self.kod : kod // ignore: cast_nullable_to_non_nullable
as AssistantEventErrorKod,mesaj: null == mesaj ? _self.mesaj : mesaj // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AssistantEventError].
extension AssistantEventErrorPatterns on AssistantEventError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssistantEventError value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssistantEventError() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssistantEventError value)  $default,){
final _that = this;
switch (_that) {
case _AssistantEventError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssistantEventError value)?  $default,){
final _that = this;
switch (_that) {
case _AssistantEventError() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AssistantEventErrorKod kod,  String mesaj)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssistantEventError() when $default != null:
return $default(_that.kod,_that.mesaj);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AssistantEventErrorKod kod,  String mesaj)  $default,) {final _that = this;
switch (_that) {
case _AssistantEventError():
return $default(_that.kod,_that.mesaj);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AssistantEventErrorKod kod,  String mesaj)?  $default,) {final _that = this;
switch (_that) {
case _AssistantEventError() when $default != null:
return $default(_that.kod,_that.mesaj);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssistantEventError implements AssistantEventError {
  const _AssistantEventError({required this.kod, required this.mesaj});
  factory _AssistantEventError.fromJson(Map<String, dynamic> json) => _$AssistantEventErrorFromJson(json);

@override final  AssistantEventErrorKod kod;
/// Kullanıcıya gösterilebilir Türkçe metin; iç ayrıntı taşımaz.
@override final  String mesaj;

/// Create a copy of AssistantEventError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssistantEventErrorCopyWith<_AssistantEventError> get copyWith => __$AssistantEventErrorCopyWithImpl<_AssistantEventError>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssistantEventErrorToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssistantEventError&&(identical(other.kod, kod) || other.kod == kod)&&(identical(other.mesaj, mesaj) || other.mesaj == mesaj));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kod,mesaj);
}

@override
String toString() {
    return 'AssistantEventError(kod: $kod, mesaj: $mesaj)';
}


}

/// @nodoc
abstract mixin class _$AssistantEventErrorCopyWith<$Res> implements $AssistantEventErrorCopyWith<$Res> {
  factory _$AssistantEventErrorCopyWith(_AssistantEventError value, $Res Function(_AssistantEventError) _then) = __$AssistantEventErrorCopyWithImpl;
@override @useResult
$Res call({
 AssistantEventErrorKod kod, String mesaj
});




}
/// @nodoc
class __$AssistantEventErrorCopyWithImpl<$Res>
    implements _$AssistantEventErrorCopyWith<$Res> {
  __$AssistantEventErrorCopyWithImpl(this._self, this._then);

  final _AssistantEventError _self;
  final $Res Function(_AssistantEventError) _then;

/// Create a copy of AssistantEventError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kod = null,Object? mesaj = null,}) {
  return _then(_AssistantEventError(
kod: null == kod ? _self.kod : kod // ignore: cast_nullable_to_non_nullable
as AssistantEventErrorKod,mesaj: null == mesaj ? _self.mesaj : mesaj // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
