// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransferRequest {

@JsonKey(name: 'source_program_id') String? get sourceProgramId;@JsonKey(name: 'target_program_id') String? get targetProgramId;@JsonKey(name: 'department_id') String? get departmentId;@JsonKey(name: 'work_item_ids') List<String>? get workItemIds;@JsonKey(name: 'preview_fingerprint') String? get previewFingerprint;/// Doluysa istek o aktarımın tersidir.
@JsonKey(name: 'reverses_transfer_id') String? get reversesTransferId;@JsonKey(name: 'add_missing_access') bool? get addMissingAccess;
/// Create a copy of TransferRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferRequestCopyWith<TransferRequest> get copyWith => _$TransferRequestCopyWithImpl<TransferRequest>(this as TransferRequest, _$identity);

  /// Serializes this TransferRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransferRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferRequest&&(identical(other.sourceProgramId, _this.sourceProgramId) || other.sourceProgramId == _this.sourceProgramId)&&(identical(other.targetProgramId, _this.targetProgramId) || other.targetProgramId == _this.targetProgramId)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&const DeepCollectionEquality().equals(other.workItemIds, _this.workItemIds)&&(identical(other.previewFingerprint, _this.previewFingerprint) || other.previewFingerprint == _this.previewFingerprint)&&(identical(other.reversesTransferId, _this.reversesTransferId) || other.reversesTransferId == _this.reversesTransferId)&&(identical(other.addMissingAccess, _this.addMissingAccess) || other.addMissingAccess == _this.addMissingAccess));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransferRequest;
  return Object.hash(runtimeType,_this.sourceProgramId,_this.targetProgramId,_this.departmentId,const DeepCollectionEquality().hash(_this.workItemIds),_this.previewFingerprint,_this.reversesTransferId,_this.addMissingAccess);
}

@override
String toString() {
  final _this = this as TransferRequest;
  return 'TransferRequest(sourceProgramId: ${_this.sourceProgramId}, targetProgramId: ${_this.targetProgramId}, departmentId: ${_this.departmentId}, workItemIds: ${_this.workItemIds}, previewFingerprint: ${_this.previewFingerprint}, reversesTransferId: ${_this.reversesTransferId}, addMissingAccess: ${_this.addMissingAccess})';
}


}

/// @nodoc
abstract mixin class $TransferRequestCopyWith<$Res>  {
  factory $TransferRequestCopyWith(TransferRequest value, $Res Function(TransferRequest) _then) = _$TransferRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'source_program_id') String? sourceProgramId,@JsonKey(name: 'target_program_id') String? targetProgramId,@JsonKey(name: 'department_id') String? departmentId,@JsonKey(name: 'work_item_ids') List<String>? workItemIds,@JsonKey(name: 'preview_fingerprint') String? previewFingerprint,@JsonKey(name: 'reverses_transfer_id') String? reversesTransferId,@JsonKey(name: 'add_missing_access') bool? addMissingAccess
});




}
/// @nodoc
class _$TransferRequestCopyWithImpl<$Res>
    implements $TransferRequestCopyWith<$Res> {
  _$TransferRequestCopyWithImpl(this._self, this._then);

  final TransferRequest _self;
  final $Res Function(TransferRequest) _then;

/// Create a copy of TransferRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceProgramId = freezed,Object? targetProgramId = freezed,Object? departmentId = freezed,Object? workItemIds = freezed,Object? previewFingerprint = freezed,Object? reversesTransferId = freezed,Object? addMissingAccess = freezed,}) {
  return _then(TransferRequest(
sourceProgramId: freezed == sourceProgramId ? _self.sourceProgramId : sourceProgramId // ignore: cast_nullable_to_non_nullable
as String?,targetProgramId: freezed == targetProgramId ? _self.targetProgramId : targetProgramId // ignore: cast_nullable_to_non_nullable
as String?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,workItemIds: freezed == workItemIds ? _self.workItemIds : workItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,previewFingerprint: freezed == previewFingerprint ? _self.previewFingerprint : previewFingerprint // ignore: cast_nullable_to_non_nullable
as String?,reversesTransferId: freezed == reversesTransferId ? _self.reversesTransferId : reversesTransferId // ignore: cast_nullable_to_non_nullable
as String?,addMissingAccess: freezed == addMissingAccess ? _self.addMissingAccess : addMissingAccess // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferRequest].
extension TransferRequestPatterns on TransferRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferRequest value)  $default,){
final _that = this;
switch (_that) {
case _TransferRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TransferRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'source_program_id')  String? sourceProgramId, @JsonKey(name: 'target_program_id')  String? targetProgramId, @JsonKey(name: 'department_id')  String? departmentId, @JsonKey(name: 'work_item_ids')  List<String>? workItemIds, @JsonKey(name: 'preview_fingerprint')  String? previewFingerprint, @JsonKey(name: 'reverses_transfer_id')  String? reversesTransferId, @JsonKey(name: 'add_missing_access')  bool? addMissingAccess)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferRequest() when $default != null:
return $default(_that.sourceProgramId,_that.targetProgramId,_that.departmentId,_that.workItemIds,_that.previewFingerprint,_that.reversesTransferId,_that.addMissingAccess);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'source_program_id')  String? sourceProgramId, @JsonKey(name: 'target_program_id')  String? targetProgramId, @JsonKey(name: 'department_id')  String? departmentId, @JsonKey(name: 'work_item_ids')  List<String>? workItemIds, @JsonKey(name: 'preview_fingerprint')  String? previewFingerprint, @JsonKey(name: 'reverses_transfer_id')  String? reversesTransferId, @JsonKey(name: 'add_missing_access')  bool? addMissingAccess)  $default,) {final _that = this;
switch (_that) {
case _TransferRequest():
return $default(_that.sourceProgramId,_that.targetProgramId,_that.departmentId,_that.workItemIds,_that.previewFingerprint,_that.reversesTransferId,_that.addMissingAccess);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'source_program_id')  String? sourceProgramId, @JsonKey(name: 'target_program_id')  String? targetProgramId, @JsonKey(name: 'department_id')  String? departmentId, @JsonKey(name: 'work_item_ids')  List<String>? workItemIds, @JsonKey(name: 'preview_fingerprint')  String? previewFingerprint, @JsonKey(name: 'reverses_transfer_id')  String? reversesTransferId, @JsonKey(name: 'add_missing_access')  bool? addMissingAccess)?  $default,) {final _that = this;
switch (_that) {
case _TransferRequest() when $default != null:
return $default(_that.sourceProgramId,_that.targetProgramId,_that.departmentId,_that.workItemIds,_that.previewFingerprint,_that.reversesTransferId,_that.addMissingAccess);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransferRequest implements TransferRequest {
  const _TransferRequest({@JsonKey(name: 'source_program_id') this.sourceProgramId, @JsonKey(name: 'target_program_id') this.targetProgramId, @JsonKey(name: 'department_id') this.departmentId, @JsonKey(name: 'work_item_ids')  List<String>? workItemIds, @JsonKey(name: 'preview_fingerprint') this.previewFingerprint, @JsonKey(name: 'reverses_transfer_id') this.reversesTransferId, @JsonKey(name: 'add_missing_access') this.addMissingAccess}): _workItemIds = workItemIds;
  factory _TransferRequest.fromJson(Map<String, dynamic> json) => _$TransferRequestFromJson(json);

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

@override@JsonKey(name: 'preview_fingerprint') final  String? previewFingerprint;
/// Doluysa istek o aktarımın tersidir.
@override@JsonKey(name: 'reverses_transfer_id') final  String? reversesTransferId;
@override@JsonKey(name: 'add_missing_access') final  bool? addMissingAccess;

/// Create a copy of TransferRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferRequestCopyWith<_TransferRequest> get copyWith => __$TransferRequestCopyWithImpl<_TransferRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferRequest&&(identical(other.sourceProgramId, sourceProgramId) || other.sourceProgramId == sourceProgramId)&&(identical(other.targetProgramId, targetProgramId) || other.targetProgramId == targetProgramId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&const DeepCollectionEquality().equals(other.workItemIds, _workItemIds)&&(identical(other.previewFingerprint, previewFingerprint) || other.previewFingerprint == previewFingerprint)&&(identical(other.reversesTransferId, reversesTransferId) || other.reversesTransferId == reversesTransferId)&&(identical(other.addMissingAccess, addMissingAccess) || other.addMissingAccess == addMissingAccess));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,sourceProgramId,targetProgramId,departmentId,const DeepCollectionEquality().hash(_workItemIds),previewFingerprint,reversesTransferId,addMissingAccess);
}

@override
String toString() {
    return 'TransferRequest(sourceProgramId: $sourceProgramId, targetProgramId: $targetProgramId, departmentId: $departmentId, workItemIds: $workItemIds, previewFingerprint: $previewFingerprint, reversesTransferId: $reversesTransferId, addMissingAccess: $addMissingAccess)';
}


}

/// @nodoc
abstract mixin class _$TransferRequestCopyWith<$Res> implements $TransferRequestCopyWith<$Res> {
  factory _$TransferRequestCopyWith(_TransferRequest value, $Res Function(_TransferRequest) _then) = __$TransferRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'source_program_id') String? sourceProgramId,@JsonKey(name: 'target_program_id') String? targetProgramId,@JsonKey(name: 'department_id') String? departmentId,@JsonKey(name: 'work_item_ids') List<String>? workItemIds,@JsonKey(name: 'preview_fingerprint') String? previewFingerprint,@JsonKey(name: 'reverses_transfer_id') String? reversesTransferId,@JsonKey(name: 'add_missing_access') bool? addMissingAccess
});




}
/// @nodoc
class __$TransferRequestCopyWithImpl<$Res>
    implements _$TransferRequestCopyWith<$Res> {
  __$TransferRequestCopyWithImpl(this._self, this._then);

  final _TransferRequest _self;
  final $Res Function(_TransferRequest) _then;

/// Create a copy of TransferRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceProgramId = freezed,Object? targetProgramId = freezed,Object? departmentId = freezed,Object? workItemIds = freezed,Object? previewFingerprint = freezed,Object? reversesTransferId = freezed,Object? addMissingAccess = freezed,}) {
  return _then(_TransferRequest(
sourceProgramId: freezed == sourceProgramId ? _self.sourceProgramId : sourceProgramId // ignore: cast_nullable_to_non_nullable
as String?,targetProgramId: freezed == targetProgramId ? _self.targetProgramId : targetProgramId // ignore: cast_nullable_to_non_nullable
as String?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,workItemIds: freezed == workItemIds ? _self._workItemIds : workItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,previewFingerprint: freezed == previewFingerprint ? _self.previewFingerprint : previewFingerprint // ignore: cast_nullable_to_non_nullable
as String?,reversesTransferId: freezed == reversesTransferId ? _self.reversesTransferId : reversesTransferId // ignore: cast_nullable_to_non_nullable
as String?,addMissingAccess: freezed == addMissingAccess ? _self.addMissingAccess : addMissingAccess // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
