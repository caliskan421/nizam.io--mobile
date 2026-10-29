// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant_event_usage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssistantEventUsage {

@JsonKey(name: 'giris_token') int get girisToken;@JsonKey(name: 'cikis_token') int get cikisToken;
/// Create a copy of AssistantEventUsage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssistantEventUsageCopyWith<AssistantEventUsage> get copyWith => _$AssistantEventUsageCopyWithImpl<AssistantEventUsage>(this as AssistantEventUsage, _$identity);

  /// Serializes this AssistantEventUsage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AssistantEventUsage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssistantEventUsage&&(identical(other.girisToken, _this.girisToken) || other.girisToken == _this.girisToken)&&(identical(other.cikisToken, _this.cikisToken) || other.cikisToken == _this.cikisToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AssistantEventUsage;
  return Object.hash(runtimeType,_this.girisToken,_this.cikisToken);
}

@override
String toString() {
  final _this = this as AssistantEventUsage;
  return 'AssistantEventUsage(girisToken: ${_this.girisToken}, cikisToken: ${_this.cikisToken})';
}


}

/// @nodoc
abstract mixin class $AssistantEventUsageCopyWith<$Res>  {
  factory $AssistantEventUsageCopyWith(AssistantEventUsage value, $Res Function(AssistantEventUsage) _then) = _$AssistantEventUsageCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'giris_token') int girisToken,@JsonKey(name: 'cikis_token') int cikisToken
});




}
/// @nodoc
class _$AssistantEventUsageCopyWithImpl<$Res>
    implements $AssistantEventUsageCopyWith<$Res> {
  _$AssistantEventUsageCopyWithImpl(this._self, this._then);

  final AssistantEventUsage _self;
  final $Res Function(AssistantEventUsage) _then;

/// Create a copy of AssistantEventUsage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? girisToken = null,Object? cikisToken = null,}) {
  return _then(AssistantEventUsage(
girisToken: null == girisToken ? _self.girisToken : girisToken // ignore: cast_nullable_to_non_nullable
as int,cikisToken: null == cikisToken ? _self.cikisToken : cikisToken // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AssistantEventUsage].
extension AssistantEventUsagePatterns on AssistantEventUsage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssistantEventUsage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssistantEventUsage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssistantEventUsage value)  $default,){
final _that = this;
switch (_that) {
case _AssistantEventUsage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssistantEventUsage value)?  $default,){
final _that = this;
switch (_that) {
case _AssistantEventUsage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'giris_token')  int girisToken, @JsonKey(name: 'cikis_token')  int cikisToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssistantEventUsage() when $default != null:
return $default(_that.girisToken,_that.cikisToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'giris_token')  int girisToken, @JsonKey(name: 'cikis_token')  int cikisToken)  $default,) {final _that = this;
switch (_that) {
case _AssistantEventUsage():
return $default(_that.girisToken,_that.cikisToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'giris_token')  int girisToken, @JsonKey(name: 'cikis_token')  int cikisToken)?  $default,) {final _that = this;
switch (_that) {
case _AssistantEventUsage() when $default != null:
return $default(_that.girisToken,_that.cikisToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssistantEventUsage implements AssistantEventUsage {
  const _AssistantEventUsage({@JsonKey(name: 'giris_token') required this.girisToken, @JsonKey(name: 'cikis_token') required this.cikisToken});
  factory _AssistantEventUsage.fromJson(Map<String, dynamic> json) => _$AssistantEventUsageFromJson(json);

@override@JsonKey(name: 'giris_token') final  int girisToken;
@override@JsonKey(name: 'cikis_token') final  int cikisToken;

/// Create a copy of AssistantEventUsage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssistantEventUsageCopyWith<_AssistantEventUsage> get copyWith => __$AssistantEventUsageCopyWithImpl<_AssistantEventUsage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssistantEventUsageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssistantEventUsage&&(identical(other.girisToken, girisToken) || other.girisToken == girisToken)&&(identical(other.cikisToken, cikisToken) || other.cikisToken == cikisToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,girisToken,cikisToken);
}

@override
String toString() {
    return 'AssistantEventUsage(girisToken: $girisToken, cikisToken: $cikisToken)';
}


}

/// @nodoc
abstract mixin class _$AssistantEventUsageCopyWith<$Res> implements $AssistantEventUsageCopyWith<$Res> {
  factory _$AssistantEventUsageCopyWith(_AssistantEventUsage value, $Res Function(_AssistantEventUsage) _then) = __$AssistantEventUsageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'giris_token') int girisToken,@JsonKey(name: 'cikis_token') int cikisToken
});




}
/// @nodoc
class __$AssistantEventUsageCopyWithImpl<$Res>
    implements _$AssistantEventUsageCopyWith<$Res> {
  __$AssistantEventUsageCopyWithImpl(this._self, this._then);

  final _AssistantEventUsage _self;
  final $Res Function(_AssistantEventUsage) _then;

/// Create a copy of AssistantEventUsage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? girisToken = null,Object? cikisToken = null,}) {
  return _then(_AssistantEventUsage(
girisToken: null == girisToken ? _self.girisToken : girisToken // ignore: cast_nullable_to_non_nullable
as int,cikisToken: null == cikisToken ? _self.cikisToken : cikisToken // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
