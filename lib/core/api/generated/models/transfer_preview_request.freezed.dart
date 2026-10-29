// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_preview_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransferPreviewRequest {

@JsonKey(name: 'source_program_id') String? get sourceProgramId;@JsonKey(name: 'target_program_id') String? get targetProgramId;@JsonKey(name: 'department_id') String? get departmentId;@JsonKey(name: 'work_item_ids') List<String>? get workItemIds;
/// Create a copy of TransferPreviewRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferPreviewRequestCopyWith<TransferPreviewRequest> get copyWith => _$TransferPreviewRequestCopyWithImpl<TransferPreviewRequest>(this as TransferPreviewRequest, _$identity);

  /// Serializes this TransferPreviewRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransferPreviewRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferPreviewRequest&&(identical(other.sourceProgramId, _this.sourceProgramId) || other.sourceProgramId == _this.sourceProgramId)&&(identical(other.targetProgramId, _this.targetProgramId) || other.targetProgramId == _this.targetProgramId)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&const DeepCollectionEquality().equals(other.workItemIds, _this.workItemIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransferPreviewRequest;
  return Object.hash(runtimeType,_this.sourceProgramId,_this.targetProgramId,_this.departmentId,const DeepCollectionEquality().hash(_this.workItemIds));
}

@override
String toString() {
  final _this = this as TransferPreviewRequest;
  return 'TransferPreviewRequest(sourceProgramId: ${_this.sourceProgramId}, targetProgramId: ${_this.targetProgramId}, departmentId: ${_this.departmentId}, workItemIds: ${_this.workItemIds})';
}


}

/// @nodoc
abstract mixin class $TransferPreviewRequestCopyWith<$Res>  {
  factory $TransferPreviewRequestCopyWith(TransferPreviewRequest value, $Res Function(TransferPreviewRequest) _then) = _$TransferPreviewRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'source_program_id') String? sourceProgramId,@JsonKey(name: 'target_program_id') String? targetProgramId,@JsonKey(name: 'department_id') String? departmentId,@JsonKey(name: 'work_item_ids') List<String>? workItemIds
});




}
/// @nodoc
class _$TransferPreviewRequestCopyWithImpl<$Res>
    implements $TransferPreviewRequestCopyWith<$Res> {
  _$TransferPreviewRequestCopyWithImpl(this._self, this._then);

  final TransferPreviewRequest _self;
  final $Res Function(TransferPreviewRequest) _then;

/// Create a copy of TransferPreviewRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceProgramId = freezed,Object? targetProgramId = freezed,Object? departmentId = freezed,Object? workItemIds = freezed,}) {
  return _then(TransferPreviewRequest(
sourceProgramId: freezed == sourceProgramId ? _self.sourceProgramId : sourceProgramId // ignore: cast_nullable_to_non_nullable
as String?,targetProgramId: freezed == targetProgramId ? _self.targetProgramId : targetProgramId // ignore: cast_nullable_to_non_nullable
as String?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,workItemIds: freezed == workItemIds ? _self.workItemIds : workItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferPreviewRequest].
extension TransferPreviewRequestPatterns on TransferPreviewRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferPreviewRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferPreviewRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferPreviewRequest value)  $default,){
final _that = this;
switch (_that) {
case _TransferPreviewRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferPreviewRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TransferPreviewRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'source_program_id')  String? sourceProgramId, @JsonKey(name: 'target_program_id')  String? targetProgramId, @JsonKey(name: 'department_id')  String? departmentId, @JsonKey(name: 'work_item_ids')  List<String>? workItemIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferPreviewRequest() when $default != null:
return $default(_that.sourceProgramId,_that.targetProgramId,_that.departmentId,_that.workItemIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'source_program_id')  String? sourceProgramId, @JsonKey(name: 'target_program_id')  String? targetProgramId, @JsonKey(name: 'department_id')  String? departmentId, @JsonKey(name: 'work_item_ids')  List<String>? workItemIds)  $default,) {final _that = this;
switch (_that) {
case _TransferPreviewRequest():
return $default(_that.sourceProgramId,_that.targetProgramId,_that.departmentId,_that.workItemIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'source_program_id')  String? sourceProgramId, @JsonKey(name: 'target_program_id')  String? targetProgramId, @JsonKey(name: 'department_id')  String? departmentId, @JsonKey(name: 'work_item_ids')  List<String>? workItemIds)?  $default,) {final _that = this;
switch (_that) {
case _TransferPreviewRequest() when $default != null:
return $default(_that.sourceProgramId,_that.targetProgramId,_that.departmentId,_that.workItemIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransferPreviewRequest implements TransferPreviewRequest {
  const _TransferPreviewRequest({@JsonKey(name: 'source_program_id') this.sourceProgramId, @JsonKey(name: 'target_program_id') this.targetProgramId, @JsonKey(name: 'department_id') this.departmentId, @JsonKey(name: 'work_item_ids')  List<String>? workItemIds}): _workItemIds = workItemIds;
  factory _TransferPreviewRequest.fromJson(Map<String, dynamic> json) => _$TransferPreviewRequestFromJson(json);

@override@JsonKey(name: 'source_program_id') final  String? sourceProgramId;
@override@JsonKey(name: 'target_program_id') final  String? targetProgramId;
@override@JsonKey(name: 'department_id') final  String? departmentId;
 final  List<String>? _workItemIds;
@override@JsonKey(name: 'work_item_ids') List<String>? get workItemIds {
  final value = _workItemIds;
  if (value == null) return null;
  if (_workItemIds is EqualUnmodifiableListView) return _workItemIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of TransferPreviewRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferPreviewRequestCopyWith<_TransferPreviewRequest> get copyWith => __$TransferPreviewRequestCopyWithImpl<_TransferPreviewRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferPreviewRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferPreviewRequest&&(identical(other.sourceProgramId, sourceProgramId) || other.sourceProgramId == sourceProgramId)&&(identical(other.targetProgramId, targetProgramId) || other.targetProgramId == targetProgramId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&const DeepCollectionEquality().equals(other.workItemIds, _workItemIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,sourceProgramId,targetProgramId,departmentId,const DeepCollectionEquality().hash(_workItemIds));
}

@override
String toString() {
    return 'TransferPreviewRequest(sourceProgramId: $sourceProgramId, targetProgramId: $targetProgramId, departmentId: $departmentId, workItemIds: $workItemIds)';
}


}

/// @nodoc
abstract mixin class _$TransferPreviewRequestCopyWith<$Res> implements $TransferPreviewRequestCopyWith<$Res> {
  factory _$TransferPreviewRequestCopyWith(_TransferPreviewRequest value, $Res Function(_TransferPreviewRequest) _then) = __$TransferPreviewRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'source_program_id') String? sourceProgramId,@JsonKey(name: 'target_program_id') String? targetProgramId,@JsonKey(name: 'department_id') String? departmentId,@JsonKey(name: 'work_item_ids') List<String>? workItemIds
});




}
/// @nodoc
class __$TransferPreviewRequestCopyWithImpl<$Res>
    implements _$TransferPreviewRequestCopyWith<$Res> {
  __$TransferPreviewRequestCopyWithImpl(this._self, this._then);

  final _TransferPreviewRequest _self;
  final $Res Function(_TransferPreviewRequest) _then;

/// Create a copy of TransferPreviewRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceProgramId = freezed,Object? targetProgramId = freezed,Object? departmentId = freezed,Object? workItemIds = freezed,}) {
  return _then(_TransferPreviewRequest(
sourceProgramId: freezed == sourceProgramId ? _self.sourceProgramId : sourceProgramId // ignore: cast_nullable_to_non_nullable
as String?,targetProgramId: freezed == targetProgramId ? _self.targetProgramId : targetProgramId // ignore: cast_nullable_to_non_nullable
as String?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,workItemIds: freezed == workItemIds ? _self._workItemIds : workItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
