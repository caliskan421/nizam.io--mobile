// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'department_lifecycle_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DepartmentLifecycleResult {

@JsonKey(name: 'department_id') String get departmentId; DepartmentLifecycleResultStatus get status;/// `restored`: departmanla birlikte silinmiş ve geri gelen görev sayısı (ADR-0043).
@JsonKey(name: 'work_items_restored') int? get workItemsRestored;/// `purged`: kalıcı silinen görev sayısı.
@JsonKey(name: 'work_items_deleted') int? get workItemsDeleted;/// `purged`: kalıcı silinen dosya sayısı.
@JsonKey(name: 'files_deleted') int? get filesDeleted;/// `purged`: kaldırılan program bağı sayısı.
@JsonKey(name: 'program_links_removed') int? get programLinksRemoved;/// `purged`: departmanla silinen ekip satırı sayısı (bağ kaldırmada silinenler hariç).
@JsonKey(name: 'memberships_deleted') int? get membershipsDeleted;
/// Create a copy of DepartmentLifecycleResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartmentLifecycleResultCopyWith<DepartmentLifecycleResult> get copyWith => _$DepartmentLifecycleResultCopyWithImpl<DepartmentLifecycleResult>(this as DepartmentLifecycleResult, _$identity);

  /// Serializes this DepartmentLifecycleResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DepartmentLifecycleResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentLifecycleResult&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.workItemsRestored, _this.workItemsRestored) || other.workItemsRestored == _this.workItemsRestored)&&(identical(other.workItemsDeleted, _this.workItemsDeleted) || other.workItemsDeleted == _this.workItemsDeleted)&&(identical(other.filesDeleted, _this.filesDeleted) || other.filesDeleted == _this.filesDeleted)&&(identical(other.programLinksRemoved, _this.programLinksRemoved) || other.programLinksRemoved == _this.programLinksRemoved)&&(identical(other.membershipsDeleted, _this.membershipsDeleted) || other.membershipsDeleted == _this.membershipsDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DepartmentLifecycleResult;
  return Object.hash(runtimeType,_this.departmentId,_this.status,_this.workItemsRestored,_this.workItemsDeleted,_this.filesDeleted,_this.programLinksRemoved,_this.membershipsDeleted);
}

@override
String toString() {
  final _this = this as DepartmentLifecycleResult;
  return 'DepartmentLifecycleResult(departmentId: ${_this.departmentId}, status: ${_this.status}, workItemsRestored: ${_this.workItemsRestored}, workItemsDeleted: ${_this.workItemsDeleted}, filesDeleted: ${_this.filesDeleted}, programLinksRemoved: ${_this.programLinksRemoved}, membershipsDeleted: ${_this.membershipsDeleted})';
}


}

/// @nodoc
abstract mixin class $DepartmentLifecycleResultCopyWith<$Res>  {
  factory $DepartmentLifecycleResultCopyWith(DepartmentLifecycleResult value, $Res Function(DepartmentLifecycleResult) _then) = _$DepartmentLifecycleResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId, DepartmentLifecycleResultStatus status,@JsonKey(name: 'work_items_restored') int? workItemsRestored,@JsonKey(name: 'work_items_deleted') int? workItemsDeleted,@JsonKey(name: 'files_deleted') int? filesDeleted,@JsonKey(name: 'program_links_removed') int? programLinksRemoved,@JsonKey(name: 'memberships_deleted') int? membershipsDeleted
});




}
/// @nodoc
class _$DepartmentLifecycleResultCopyWithImpl<$Res>
    implements $DepartmentLifecycleResultCopyWith<$Res> {
  _$DepartmentLifecycleResultCopyWithImpl(this._self, this._then);

  final DepartmentLifecycleResult _self;
  final $Res Function(DepartmentLifecycleResult) _then;

/// Create a copy of DepartmentLifecycleResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departmentId = null,Object? status = null,Object? workItemsRestored = freezed,Object? workItemsDeleted = freezed,Object? filesDeleted = freezed,Object? programLinksRemoved = freezed,Object? membershipsDeleted = freezed,}) {
  return _then(DepartmentLifecycleResult(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DepartmentLifecycleResultStatus,workItemsRestored: freezed == workItemsRestored ? _self.workItemsRestored : workItemsRestored // ignore: cast_nullable_to_non_nullable
as int?,workItemsDeleted: freezed == workItemsDeleted ? _self.workItemsDeleted : workItemsDeleted // ignore: cast_nullable_to_non_nullable
as int?,filesDeleted: freezed == filesDeleted ? _self.filesDeleted : filesDeleted // ignore: cast_nullable_to_non_nullable
as int?,programLinksRemoved: freezed == programLinksRemoved ? _self.programLinksRemoved : programLinksRemoved // ignore: cast_nullable_to_non_nullable
as int?,membershipsDeleted: freezed == membershipsDeleted ? _self.membershipsDeleted : membershipsDeleted // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DepartmentLifecycleResult].
extension DepartmentLifecycleResultPatterns on DepartmentLifecycleResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DepartmentLifecycleResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DepartmentLifecycleResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DepartmentLifecycleResult value)  $default,){
final _that = this;
switch (_that) {
case _DepartmentLifecycleResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DepartmentLifecycleResult value)?  $default,){
final _that = this;
switch (_that) {
case _DepartmentLifecycleResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId,  DepartmentLifecycleResultStatus status, @JsonKey(name: 'work_items_restored')  int? workItemsRestored, @JsonKey(name: 'work_items_deleted')  int? workItemsDeleted, @JsonKey(name: 'files_deleted')  int? filesDeleted, @JsonKey(name: 'program_links_removed')  int? programLinksRemoved, @JsonKey(name: 'memberships_deleted')  int? membershipsDeleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DepartmentLifecycleResult() when $default != null:
return $default(_that.departmentId,_that.status,_that.workItemsRestored,_that.workItemsDeleted,_that.filesDeleted,_that.programLinksRemoved,_that.membershipsDeleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId,  DepartmentLifecycleResultStatus status, @JsonKey(name: 'work_items_restored')  int? workItemsRestored, @JsonKey(name: 'work_items_deleted')  int? workItemsDeleted, @JsonKey(name: 'files_deleted')  int? filesDeleted, @JsonKey(name: 'program_links_removed')  int? programLinksRemoved, @JsonKey(name: 'memberships_deleted')  int? membershipsDeleted)  $default,) {final _that = this;
switch (_that) {
case _DepartmentLifecycleResult():
return $default(_that.departmentId,_that.status,_that.workItemsRestored,_that.workItemsDeleted,_that.filesDeleted,_that.programLinksRemoved,_that.membershipsDeleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'department_id')  String departmentId,  DepartmentLifecycleResultStatus status, @JsonKey(name: 'work_items_restored')  int? workItemsRestored, @JsonKey(name: 'work_items_deleted')  int? workItemsDeleted, @JsonKey(name: 'files_deleted')  int? filesDeleted, @JsonKey(name: 'program_links_removed')  int? programLinksRemoved, @JsonKey(name: 'memberships_deleted')  int? membershipsDeleted)?  $default,) {final _that = this;
switch (_that) {
case _DepartmentLifecycleResult() when $default != null:
return $default(_that.departmentId,_that.status,_that.workItemsRestored,_that.workItemsDeleted,_that.filesDeleted,_that.programLinksRemoved,_that.membershipsDeleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DepartmentLifecycleResult implements DepartmentLifecycleResult {
  const _DepartmentLifecycleResult({@JsonKey(name: 'department_id') required this.departmentId, required this.status, @JsonKey(name: 'work_items_restored') this.workItemsRestored, @JsonKey(name: 'work_items_deleted') this.workItemsDeleted, @JsonKey(name: 'files_deleted') this.filesDeleted, @JsonKey(name: 'program_links_removed') this.programLinksRemoved, @JsonKey(name: 'memberships_deleted') this.membershipsDeleted});
  factory _DepartmentLifecycleResult.fromJson(Map<String, dynamic> json) => _$DepartmentLifecycleResultFromJson(json);

@override@JsonKey(name: 'department_id') final  String departmentId;
@override final  DepartmentLifecycleResultStatus status;
/// `restored`: departmanla birlikte silinmiş ve geri gelen görev sayısı (ADR-0043).
@override@JsonKey(name: 'work_items_restored') final  int? workItemsRestored;
/// `purged`: kalıcı silinen görev sayısı.
@override@JsonKey(name: 'work_items_deleted') final  int? workItemsDeleted;
/// `purged`: kalıcı silinen dosya sayısı.
@override@JsonKey(name: 'files_deleted') final  int? filesDeleted;
/// `purged`: kaldırılan program bağı sayısı.
@override@JsonKey(name: 'program_links_removed') final  int? programLinksRemoved;
/// `purged`: departmanla silinen ekip satırı sayısı (bağ kaldırmada silinenler hariç).
@override@JsonKey(name: 'memberships_deleted') final  int? membershipsDeleted;

/// Create a copy of DepartmentLifecycleResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DepartmentLifecycleResultCopyWith<_DepartmentLifecycleResult> get copyWith => __$DepartmentLifecycleResultCopyWithImpl<_DepartmentLifecycleResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DepartmentLifecycleResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DepartmentLifecycleResult&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.status, status) || other.status == status)&&(identical(other.workItemsRestored, workItemsRestored) || other.workItemsRestored == workItemsRestored)&&(identical(other.workItemsDeleted, workItemsDeleted) || other.workItemsDeleted == workItemsDeleted)&&(identical(other.filesDeleted, filesDeleted) || other.filesDeleted == filesDeleted)&&(identical(other.programLinksRemoved, programLinksRemoved) || other.programLinksRemoved == programLinksRemoved)&&(identical(other.membershipsDeleted, membershipsDeleted) || other.membershipsDeleted == membershipsDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,departmentId,status,workItemsRestored,workItemsDeleted,filesDeleted,programLinksRemoved,membershipsDeleted);
}

@override
String toString() {
    return 'DepartmentLifecycleResult(departmentId: $departmentId, status: $status, workItemsRestored: $workItemsRestored, workItemsDeleted: $workItemsDeleted, filesDeleted: $filesDeleted, programLinksRemoved: $programLinksRemoved, membershipsDeleted: $membershipsDeleted)';
}


}

/// @nodoc
abstract mixin class _$DepartmentLifecycleResultCopyWith<$Res> implements $DepartmentLifecycleResultCopyWith<$Res> {
  factory _$DepartmentLifecycleResultCopyWith(_DepartmentLifecycleResult value, $Res Function(_DepartmentLifecycleResult) _then) = __$DepartmentLifecycleResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId, DepartmentLifecycleResultStatus status,@JsonKey(name: 'work_items_restored') int? workItemsRestored,@JsonKey(name: 'work_items_deleted') int? workItemsDeleted,@JsonKey(name: 'files_deleted') int? filesDeleted,@JsonKey(name: 'program_links_removed') int? programLinksRemoved,@JsonKey(name: 'memberships_deleted') int? membershipsDeleted
});




}
/// @nodoc
class __$DepartmentLifecycleResultCopyWithImpl<$Res>
    implements _$DepartmentLifecycleResultCopyWith<$Res> {
  __$DepartmentLifecycleResultCopyWithImpl(this._self, this._then);

  final _DepartmentLifecycleResult _self;
  final $Res Function(_DepartmentLifecycleResult) _then;

/// Create a copy of DepartmentLifecycleResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departmentId = null,Object? status = null,Object? workItemsRestored = freezed,Object? workItemsDeleted = freezed,Object? filesDeleted = freezed,Object? programLinksRemoved = freezed,Object? membershipsDeleted = freezed,}) {
  return _then(_DepartmentLifecycleResult(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DepartmentLifecycleResultStatus,workItemsRestored: freezed == workItemsRestored ? _self.workItemsRestored : workItemsRestored // ignore: cast_nullable_to_non_nullable
as int?,workItemsDeleted: freezed == workItemsDeleted ? _self.workItemsDeleted : workItemsDeleted // ignore: cast_nullable_to_non_nullable
as int?,filesDeleted: freezed == filesDeleted ? _self.filesDeleted : filesDeleted // ignore: cast_nullable_to_non_nullable
as int?,programLinksRemoved: freezed == programLinksRemoved ? _self.programLinksRemoved : programLinksRemoved // ignore: cast_nullable_to_non_nullable
as int?,membershipsDeleted: freezed == membershipsDeleted ? _self.membershipsDeleted : membershipsDeleted // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
