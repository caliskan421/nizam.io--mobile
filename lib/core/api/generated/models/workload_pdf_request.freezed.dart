// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workload_pdf_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkloadPdfRequest {

/// Boş ya da yoksa bütün üyeler.
@JsonKey(name: 'member_ids') List<String>? get memberIds;
/// Create a copy of WorkloadPdfRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkloadPdfRequestCopyWith<WorkloadPdfRequest> get copyWith => _$WorkloadPdfRequestCopyWithImpl<WorkloadPdfRequest>(this as WorkloadPdfRequest, _$identity);

  /// Serializes this WorkloadPdfRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkloadPdfRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkloadPdfRequest&&const DeepCollectionEquality().equals(other.memberIds, _this.memberIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkloadPdfRequest;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.memberIds));
}

@override
String toString() {
  final _this = this as WorkloadPdfRequest;
  return 'WorkloadPdfRequest(memberIds: ${_this.memberIds})';
}


}

/// @nodoc
abstract mixin class $WorkloadPdfRequestCopyWith<$Res>  {
  factory $WorkloadPdfRequestCopyWith(WorkloadPdfRequest value, $Res Function(WorkloadPdfRequest) _then) = _$WorkloadPdfRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'member_ids') List<String>? memberIds
});




}
/// @nodoc
class _$WorkloadPdfRequestCopyWithImpl<$Res>
    implements $WorkloadPdfRequestCopyWith<$Res> {
  _$WorkloadPdfRequestCopyWithImpl(this._self, this._then);

  final WorkloadPdfRequest _self;
  final $Res Function(WorkloadPdfRequest) _then;

/// Create a copy of WorkloadPdfRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memberIds = freezed,}) {
  return _then(WorkloadPdfRequest(
memberIds: freezed == memberIds ? _self.memberIds : memberIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkloadPdfRequest].
extension WorkloadPdfRequestPatterns on WorkloadPdfRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkloadPdfRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkloadPdfRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkloadPdfRequest value)  $default,){
final _that = this;
switch (_that) {
case _WorkloadPdfRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkloadPdfRequest value)?  $default,){
final _that = this;
switch (_that) {
case _WorkloadPdfRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'member_ids')  List<String>? memberIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkloadPdfRequest() when $default != null:
return $default(_that.memberIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'member_ids')  List<String>? memberIds)  $default,) {final _that = this;
switch (_that) {
case _WorkloadPdfRequest():
return $default(_that.memberIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'member_ids')  List<String>? memberIds)?  $default,) {final _that = this;
switch (_that) {
case _WorkloadPdfRequest() when $default != null:
return $default(_that.memberIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkloadPdfRequest implements WorkloadPdfRequest {
  const _WorkloadPdfRequest({@JsonKey(name: 'member_ids')  List<String>? memberIds}): _memberIds = memberIds;
  factory _WorkloadPdfRequest.fromJson(Map<String, dynamic> json) => _$WorkloadPdfRequestFromJson(json);

/// Boş ya da yoksa bütün üyeler.
 final  List<String>? _memberIds;
/// Boş ya da yoksa bütün üyeler.
@override@JsonKey(name: 'member_ids') List<String>? get memberIds {
  final value = _memberIds;
  if (value == null) return null;
  if (_memberIds is EqualUnmodifiableListView) return _memberIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of WorkloadPdfRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkloadPdfRequestCopyWith<_WorkloadPdfRequest> get copyWith => __$WorkloadPdfRequestCopyWithImpl<_WorkloadPdfRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkloadPdfRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkloadPdfRequest&&const DeepCollectionEquality().equals(other.memberIds, _memberIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_memberIds));
}

@override
String toString() {
    return 'WorkloadPdfRequest(memberIds: $memberIds)';
}


}

/// @nodoc
abstract mixin class _$WorkloadPdfRequestCopyWith<$Res> implements $WorkloadPdfRequestCopyWith<$Res> {
  factory _$WorkloadPdfRequestCopyWith(_WorkloadPdfRequest value, $Res Function(_WorkloadPdfRequest) _then) = __$WorkloadPdfRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'member_ids') List<String>? memberIds
});




}
/// @nodoc
class __$WorkloadPdfRequestCopyWithImpl<$Res>
    implements _$WorkloadPdfRequestCopyWith<$Res> {
  __$WorkloadPdfRequestCopyWithImpl(this._self, this._then);

  final _WorkloadPdfRequest _self;
  final $Res Function(_WorkloadPdfRequest) _then;

/// Create a copy of WorkloadPdfRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memberIds = freezed,}) {
  return _then(_WorkloadPdfRequest(
memberIds: freezed == memberIds ? _self._memberIds : memberIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
