// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error_envelope.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ErrorEnvelope {

/// Kararlı makine kodu (`<alan>.<durum>`); katalog docs/api/error-codes.json.
 String get code; String get message;/// Sunucunun ürettiği istek kimliği (X-Request-Id ile aynı).
@JsonKey(name: 'request_id') String get requestId;@JsonKey(name: 'correlation_id') String? get correlationId; List<FieldError>? get fields; String? get details;
/// Create a copy of ErrorEnvelope
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorEnvelopeCopyWith<ErrorEnvelope> get copyWith => _$ErrorEnvelopeCopyWithImpl<ErrorEnvelope>(this as ErrorEnvelope, _$identity);

  /// Serializes this ErrorEnvelope to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ErrorEnvelope;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorEnvelope&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.requestId, _this.requestId) || other.requestId == _this.requestId)&&(identical(other.correlationId, _this.correlationId) || other.correlationId == _this.correlationId)&&const DeepCollectionEquality().equals(other.fields, _this.fields)&&(identical(other.details, _this.details) || other.details == _this.details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ErrorEnvelope;
  return Object.hash(runtimeType,_this.code,_this.message,_this.requestId,_this.correlationId,const DeepCollectionEquality().hash(_this.fields),_this.details);
}

@override
String toString() {
  final _this = this as ErrorEnvelope;
  return 'ErrorEnvelope(code: ${_this.code}, message: ${_this.message}, requestId: ${_this.requestId}, correlationId: ${_this.correlationId}, fields: ${_this.fields}, details: ${_this.details})';
}


}

/// @nodoc
abstract mixin class $ErrorEnvelopeCopyWith<$Res>  {
  factory $ErrorEnvelopeCopyWith(ErrorEnvelope value, $Res Function(ErrorEnvelope) _then) = _$ErrorEnvelopeCopyWithImpl;
@useResult
$Res call({
 String code, String message,@JsonKey(name: 'request_id') String requestId,@JsonKey(name: 'correlation_id') String? correlationId, List<FieldError>? fields, String? details
});




}
/// @nodoc
class _$ErrorEnvelopeCopyWithImpl<$Res>
    implements $ErrorEnvelopeCopyWith<$Res> {
  _$ErrorEnvelopeCopyWithImpl(this._self, this._then);

  final ErrorEnvelope _self;
  final $Res Function(ErrorEnvelope) _then;

/// Create a copy of ErrorEnvelope
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? requestId = null,Object? correlationId = freezed,Object? fields = freezed,Object? details = freezed,}) {
  return _then(ErrorEnvelope(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,correlationId: freezed == correlationId ? _self.correlationId : correlationId // ignore: cast_nullable_to_non_nullable
as String?,fields: freezed == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<FieldError>?,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ErrorEnvelope].
extension ErrorEnvelopePatterns on ErrorEnvelope {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ErrorEnvelope value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ErrorEnvelope() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ErrorEnvelope value)  $default,){
final _that = this;
switch (_that) {
case _ErrorEnvelope():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ErrorEnvelope value)?  $default,){
final _that = this;
switch (_that) {
case _ErrorEnvelope() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String message, @JsonKey(name: 'request_id')  String requestId, @JsonKey(name: 'correlation_id')  String? correlationId,  List<FieldError>? fields,  String? details)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ErrorEnvelope() when $default != null:
return $default(_that.code,_that.message,_that.requestId,_that.correlationId,_that.fields,_that.details);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String message, @JsonKey(name: 'request_id')  String requestId, @JsonKey(name: 'correlation_id')  String? correlationId,  List<FieldError>? fields,  String? details)  $default,) {final _that = this;
switch (_that) {
case _ErrorEnvelope():
return $default(_that.code,_that.message,_that.requestId,_that.correlationId,_that.fields,_that.details);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String message, @JsonKey(name: 'request_id')  String requestId, @JsonKey(name: 'correlation_id')  String? correlationId,  List<FieldError>? fields,  String? details)?  $default,) {final _that = this;
switch (_that) {
case _ErrorEnvelope() when $default != null:
return $default(_that.code,_that.message,_that.requestId,_that.correlationId,_that.fields,_that.details);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ErrorEnvelope implements ErrorEnvelope {
  const _ErrorEnvelope({required this.code, required this.message, @JsonKey(name: 'request_id') required this.requestId, @JsonKey(name: 'correlation_id') this.correlationId,  List<FieldError>? fields, this.details}): _fields = fields;
  factory _ErrorEnvelope.fromJson(Map<String, dynamic> json) => _$ErrorEnvelopeFromJson(json);

/// Kararlı makine kodu (`<alan>.<durum>`); katalog docs/api/error-codes.json.
@override final  String code;
@override final  String message;
/// Sunucunun ürettiği istek kimliği (X-Request-Id ile aynı).
@override@JsonKey(name: 'request_id') final  String requestId;
@override@JsonKey(name: 'correlation_id') final  String? correlationId;
 final  List<FieldError>? _fields;
@override List<FieldError>? get fields {
  final value = _fields;
  if (value == null) return null;
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? details;

/// Create a copy of ErrorEnvelope
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorEnvelopeCopyWith<_ErrorEnvelope> get copyWith => __$ErrorEnvelopeCopyWithImpl<_ErrorEnvelope>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ErrorEnvelopeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ErrorEnvelope&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.correlationId, correlationId) || other.correlationId == correlationId)&&const DeepCollectionEquality().equals(other.fields, _fields)&&(identical(other.details, details) || other.details == details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,message,requestId,correlationId,const DeepCollectionEquality().hash(_fields),details);
}

@override
String toString() {
    return 'ErrorEnvelope(code: $code, message: $message, requestId: $requestId, correlationId: $correlationId, fields: $fields, details: $details)';
}


}

/// @nodoc
abstract mixin class _$ErrorEnvelopeCopyWith<$Res> implements $ErrorEnvelopeCopyWith<$Res> {
  factory _$ErrorEnvelopeCopyWith(_ErrorEnvelope value, $Res Function(_ErrorEnvelope) _then) = __$ErrorEnvelopeCopyWithImpl;
@override @useResult
$Res call({
 String code, String message,@JsonKey(name: 'request_id') String requestId,@JsonKey(name: 'correlation_id') String? correlationId, List<FieldError>? fields, String? details
});




}
/// @nodoc
class __$ErrorEnvelopeCopyWithImpl<$Res>
    implements _$ErrorEnvelopeCopyWith<$Res> {
  __$ErrorEnvelopeCopyWithImpl(this._self, this._then);

  final _ErrorEnvelope _self;
  final $Res Function(_ErrorEnvelope) _then;

/// Create a copy of ErrorEnvelope
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? requestId = null,Object? correlationId = freezed,Object? fields = freezed,Object? details = freezed,}) {
  return _then(_ErrorEnvelope(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,correlationId: freezed == correlationId ? _self.correlationId : correlationId // ignore: cast_nullable_to_non_nullable
as String?,fields: freezed == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<FieldError>?,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
