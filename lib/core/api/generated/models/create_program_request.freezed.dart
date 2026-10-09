// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_program_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateProgramRequest {

 String get name; int? get year; String? get description;
/// Create a copy of CreateProgramRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateProgramRequestCopyWith<CreateProgramRequest> get copyWith => _$CreateProgramRequestCopyWithImpl<CreateProgramRequest>(this as CreateProgramRequest, _$identity);

  /// Serializes this CreateProgramRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateProgramRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateProgramRequest&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.description, _this.description) || other.description == _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateProgramRequest;
  return Object.hash(runtimeType,_this.name,_this.year,_this.description);
}

@override
String toString() {
  final _this = this as CreateProgramRequest;
  return 'CreateProgramRequest(name: ${_this.name}, year: ${_this.year}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $CreateProgramRequestCopyWith<$Res>  {
  factory $CreateProgramRequestCopyWith(CreateProgramRequest value, $Res Function(CreateProgramRequest) _then) = _$CreateProgramRequestCopyWithImpl;
@useResult
$Res call({
 String name, int? year, String? description
});




}
/// @nodoc
class _$CreateProgramRequestCopyWithImpl<$Res>
    implements $CreateProgramRequestCopyWith<$Res> {
  _$CreateProgramRequestCopyWithImpl(this._self, this._then);

  final CreateProgramRequest _self;
  final $Res Function(CreateProgramRequest) _then;

/// Create a copy of CreateProgramRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? year = freezed,Object? description = freezed,}) {
  return _then(CreateProgramRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateProgramRequest].
extension CreateProgramRequestPatterns on CreateProgramRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateProgramRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateProgramRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateProgramRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateProgramRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateProgramRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateProgramRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int? year,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateProgramRequest() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int? year,  String? description)  $default,) {final _that = this;
switch (_that) {
case _CreateProgramRequest():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int? year,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _CreateProgramRequest() when $default != null:
return $default(_that.name,_that.year,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateProgramRequest implements CreateProgramRequest {
  const _CreateProgramRequest({required this.name, this.year, this.description});
  factory _CreateProgramRequest.fromJson(Map<String, dynamic> json) => _$CreateProgramRequestFromJson(json);

@override final  String name;
@override final  int? year;
@override final  String? description;

/// Create a copy of CreateProgramRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateProgramRequestCopyWith<_CreateProgramRequest> get copyWith => __$CreateProgramRequestCopyWithImpl<_CreateProgramRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateProgramRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateProgramRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.year, year) || other.year == year)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,year,description);
}

@override
String toString() {
    return 'CreateProgramRequest(name: $name, year: $year, description: $description)';
}


}

/// @nodoc
abstract mixin class _$CreateProgramRequestCopyWith<$Res> implements $CreateProgramRequestCopyWith<$Res> {
  factory _$CreateProgramRequestCopyWith(_CreateProgramRequest value, $Res Function(_CreateProgramRequest) _then) = __$CreateProgramRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, int? year, String? description
});




}
/// @nodoc
class __$CreateProgramRequestCopyWithImpl<$Res>
    implements _$CreateProgramRequestCopyWith<$Res> {
  __$CreateProgramRequestCopyWithImpl(this._self, this._then);

  final _CreateProgramRequest _self;
  final $Res Function(_CreateProgramRequest) _then;

/// Create a copy of CreateProgramRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? year = freezed,Object? description = freezed,}) {
  return _then(_CreateProgramRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
