// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_program_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateProgramRequest {

 String? get name; int? get year; String? get description;
/// Create a copy of UpdateProgramRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProgramRequestCopyWith<UpdateProgramRequest> get copyWith => _$UpdateProgramRequestCopyWithImpl<UpdateProgramRequest>(this as UpdateProgramRequest, _$identity);

  /// Serializes this UpdateProgramRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateProgramRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProgramRequest&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.description, _this.description) || other.description == _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateProgramRequest;
  return Object.hash(runtimeType,_this.name,_this.year,_this.description);
}

@override
String toString() {
  final _this = this as UpdateProgramRequest;
  return 'UpdateProgramRequest(name: ${_this.name}, year: ${_this.year}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $UpdateProgramRequestCopyWith<$Res>  {
  factory $UpdateProgramRequestCopyWith(UpdateProgramRequest value, $Res Function(UpdateProgramRequest) _then) = _$UpdateProgramRequestCopyWithImpl;
@useResult
$Res call({
 String? name, int? year, String? description
});




}
/// @nodoc
class _$UpdateProgramRequestCopyWithImpl<$Res>
    implements $UpdateProgramRequestCopyWith<$Res> {
  _$UpdateProgramRequestCopyWithImpl(this._self, this._then);

  final UpdateProgramRequest _self;
  final $Res Function(UpdateProgramRequest) _then;

/// Create a copy of UpdateProgramRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? year = freezed,Object? description = freezed,}) {
  return _then(UpdateProgramRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateProgramRequest].
extension UpdateProgramRequestPatterns on UpdateProgramRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateProgramRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateProgramRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateProgramRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateProgramRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateProgramRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateProgramRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  int? year,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateProgramRequest() when $default != null:
return $default(_that.name,_that.year,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  int? year,  String? description)  $default,) {final _that = this;
switch (_that) {
case _UpdateProgramRequest():
return $default(_that.name,_that.year,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  int? year,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _UpdateProgramRequest() when $default != null:
return $default(_that.name,_that.year,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateProgramRequest implements UpdateProgramRequest {
  const _UpdateProgramRequest({this.name, this.year, this.description});
  factory _UpdateProgramRequest.fromJson(Map<String, dynamic> json) => _$UpdateProgramRequestFromJson(json);

@override final  String? name;
@override final  int? year;
@override final  String? description;

/// Create a copy of UpdateProgramRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateProgramRequestCopyWith<_UpdateProgramRequest> get copyWith => __$UpdateProgramRequestCopyWithImpl<_UpdateProgramRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateProgramRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateProgramRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.year, year) || other.year == year)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,year,description);
}

@override
String toString() {
    return 'UpdateProgramRequest(name: $name, year: $year, description: $description)';
}


}

/// @nodoc
abstract mixin class _$UpdateProgramRequestCopyWith<$Res> implements $UpdateProgramRequestCopyWith<$Res> {
  factory _$UpdateProgramRequestCopyWith(_UpdateProgramRequest value, $Res Function(_UpdateProgramRequest) _then) = __$UpdateProgramRequestCopyWithImpl;
@override @useResult
$Res call({
 String? name, int? year, String? description
});




}
/// @nodoc
class __$UpdateProgramRequestCopyWithImpl<$Res>
    implements _$UpdateProgramRequestCopyWith<$Res> {
  __$UpdateProgramRequestCopyWithImpl(this._self, this._then);

  final _UpdateProgramRequest _self;
  final $Res Function(_UpdateProgramRequest) _then;

/// Create a copy of UpdateProgramRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? year = freezed,Object? description = freezed,}) {
  return _then(_UpdateProgramRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
