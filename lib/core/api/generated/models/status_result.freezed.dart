// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'status_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StatusResult {

/// İşlemin sonucu (ör. `deleted`, `claimed`, `unclaimed`, `updated`, `removed`).
 String get status;
/// Create a copy of StatusResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatusResultCopyWith<StatusResult> get copyWith => _$StatusResultCopyWithImpl<StatusResult>(this as StatusResult, _$identity);

  /// Serializes this StatusResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StatusResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatusResult&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StatusResult;
  return Object.hash(runtimeType,_this.status);
}

@override
String toString() {
  final _this = this as StatusResult;
  return 'StatusResult(status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $StatusResultCopyWith<$Res>  {
  factory $StatusResultCopyWith(StatusResult value, $Res Function(StatusResult) _then) = _$StatusResultCopyWithImpl;
@useResult
$Res call({
 String status
});




}
/// @nodoc
class _$StatusResultCopyWithImpl<$Res>
    implements $StatusResultCopyWith<$Res> {
  _$StatusResultCopyWithImpl(this._self, this._then);

  final StatusResult _self;
  final $Res Function(StatusResult) _then;

/// Create a copy of StatusResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,}) {
  return _then(StatusResult(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StatusResult].
extension StatusResultPatterns on StatusResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatusResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatusResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatusResult value)  $default,){
final _that = this;
switch (_that) {
case _StatusResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatusResult value)?  $default,){
final _that = this;
switch (_that) {
case _StatusResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatusResult() when $default != null:
return $default(_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status)  $default,) {final _that = this;
switch (_that) {
case _StatusResult():
return $default(_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status)?  $default,) {final _that = this;
switch (_that) {
case _StatusResult() when $default != null:
return $default(_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StatusResult implements StatusResult {
  const _StatusResult({required this.status});
  factory _StatusResult.fromJson(Map<String, dynamic> json) => _$StatusResultFromJson(json);

/// İşlemin sonucu (ör. `deleted`, `claimed`, `unclaimed`, `updated`, `removed`).
@override final  String status;

/// Create a copy of StatusResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatusResultCopyWith<_StatusResult> get copyWith => __$StatusResultCopyWithImpl<_StatusResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatusResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatusResult&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,status);
}

@override
String toString() {
    return 'StatusResult(status: $status)';
}


}

/// @nodoc
abstract mixin class _$StatusResultCopyWith<$Res> implements $StatusResultCopyWith<$Res> {
  factory _$StatusResultCopyWith(_StatusResult value, $Res Function(_StatusResult) _then) = __$StatusResultCopyWithImpl;
@override @useResult
$Res call({
 String status
});




}
/// @nodoc
class __$StatusResultCopyWithImpl<$Res>
    implements _$StatusResultCopyWith<$Res> {
  __$StatusResultCopyWithImpl(this._self, this._then);

  final _StatusResult _self;
  final $Res Function(_StatusResult) _then;

/// Create a copy of StatusResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,}) {
  return _then(_StatusResult(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
