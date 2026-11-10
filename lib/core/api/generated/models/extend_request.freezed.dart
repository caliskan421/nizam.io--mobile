// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extend_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExtendRequest {

/// Ek gün sayısı, 1–90 (aksi 422 `work.input_invalid`).
 int get days;/// İsteğe bağlı: istemcinin gördüğü tarih sürümü (`dates_revision`; WORK-K89). Verilirse kilit altındaki güncel sürümle karşılaştırılır; farklıysa 409 `work.edit_conflict` (`fields[0].field = expected_dates_revision`), uzatma uygulanmaz. Pozitif değilse 422 `work.input_invalid` (alan kodu `work.revision_invalid`). Uzatma göreli olduğundan ADR-0027'nin "istenen değer zaten güncelse 200" kuralı yoktur.
@JsonKey(name: 'expected_dates_revision') int? get expectedDatesRevision;
/// Create a copy of ExtendRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtendRequestCopyWith<ExtendRequest> get copyWith => _$ExtendRequestCopyWithImpl<ExtendRequest>(this as ExtendRequest, _$identity);

  /// Serializes this ExtendRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExtendRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtendRequest&&(identical(other.days, _this.days) || other.days == _this.days)&&(identical(other.expectedDatesRevision, _this.expectedDatesRevision) || other.expectedDatesRevision == _this.expectedDatesRevision));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExtendRequest;
  return Object.hash(runtimeType,_this.days,_this.expectedDatesRevision);
}

@override
String toString() {
  final _this = this as ExtendRequest;
  return 'ExtendRequest(days: ${_this.days}, expectedDatesRevision: ${_this.expectedDatesRevision})';
}


}

/// @nodoc
abstract mixin class $ExtendRequestCopyWith<$Res>  {
  factory $ExtendRequestCopyWith(ExtendRequest value, $Res Function(ExtendRequest) _then) = _$ExtendRequestCopyWithImpl;
@useResult
$Res call({
 int days,@JsonKey(name: 'expected_dates_revision') int? expectedDatesRevision
});




}
/// @nodoc
class _$ExtendRequestCopyWithImpl<$Res>
    implements $ExtendRequestCopyWith<$Res> {
  _$ExtendRequestCopyWithImpl(this._self, this._then);

  final ExtendRequest _self;
  final $Res Function(ExtendRequest) _then;

/// Create a copy of ExtendRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? days = null,Object? expectedDatesRevision = freezed,}) {
  return _then(ExtendRequest(
days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,expectedDatesRevision: freezed == expectedDatesRevision ? _self.expectedDatesRevision : expectedDatesRevision // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExtendRequest].
extension ExtendRequestPatterns on ExtendRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExtendRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExtendRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExtendRequest value)  $default,){
final _that = this;
switch (_that) {
case _ExtendRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExtendRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ExtendRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int days, @JsonKey(name: 'expected_dates_revision')  int? expectedDatesRevision)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExtendRequest() when $default != null:
return $default(_that.days,_that.expectedDatesRevision);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int days, @JsonKey(name: 'expected_dates_revision')  int? expectedDatesRevision)  $default,) {final _that = this;
switch (_that) {
case _ExtendRequest():
return $default(_that.days,_that.expectedDatesRevision);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int days, @JsonKey(name: 'expected_dates_revision')  int? expectedDatesRevision)?  $default,) {final _that = this;
switch (_that) {
case _ExtendRequest() when $default != null:
return $default(_that.days,_that.expectedDatesRevision);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExtendRequest implements ExtendRequest {
  const _ExtendRequest({required this.days, @JsonKey(name: 'expected_dates_revision') this.expectedDatesRevision});
  factory _ExtendRequest.fromJson(Map<String, dynamic> json) => _$ExtendRequestFromJson(json);

/// Ek gün sayısı, 1–90 (aksi 422 `work.input_invalid`).
@override final  int days;
/// İsteğe bağlı: istemcinin gördüğü tarih sürümü (`dates_revision`; WORK-K89). Verilirse kilit altındaki güncel sürümle karşılaştırılır; farklıysa 409 `work.edit_conflict` (`fields[0].field = expected_dates_revision`), uzatma uygulanmaz. Pozitif değilse 422 `work.input_invalid` (alan kodu `work.revision_invalid`). Uzatma göreli olduğundan ADR-0027'nin "istenen değer zaten güncelse 200" kuralı yoktur.
@override@JsonKey(name: 'expected_dates_revision') final  int? expectedDatesRevision;

/// Create a copy of ExtendRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtendRequestCopyWith<_ExtendRequest> get copyWith => __$ExtendRequestCopyWithImpl<_ExtendRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExtendRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtendRequest&&(identical(other.days, days) || other.days == days)&&(identical(other.expectedDatesRevision, expectedDatesRevision) || other.expectedDatesRevision == expectedDatesRevision));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,days,expectedDatesRevision);
}

@override
String toString() {
    return 'ExtendRequest(days: $days, expectedDatesRevision: $expectedDatesRevision)';
}


}

/// @nodoc
abstract mixin class _$ExtendRequestCopyWith<$Res> implements $ExtendRequestCopyWith<$Res> {
  factory _$ExtendRequestCopyWith(_ExtendRequest value, $Res Function(_ExtendRequest) _then) = __$ExtendRequestCopyWithImpl;
@override @useResult
$Res call({
 int days,@JsonKey(name: 'expected_dates_revision') int? expectedDatesRevision
});




}
/// @nodoc
class __$ExtendRequestCopyWithImpl<$Res>
    implements _$ExtendRequestCopyWith<$Res> {
  __$ExtendRequestCopyWithImpl(this._self, this._then);

  final _ExtendRequest _self;
  final $Res Function(_ExtendRequest) _then;

/// Create a copy of ExtendRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? days = null,Object? expectedDatesRevision = freezed,}) {
  return _then(_ExtendRequest(
days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,expectedDatesRevision: freezed == expectedDatesRevision ? _self.expectedDatesRevision : expectedDatesRevision // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
