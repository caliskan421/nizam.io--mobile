// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'department_delete_impact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DepartmentDeleteImpact {

@JsonKey(name: 'department_id') String get departmentId;/// Katalog adı.
 String get name;/// Departman şu an geri alınabilir silinmiş mi.
 bool get deleted;/// Görevi ya da bağı olan programlar (program kimliği sırası).
 List<DepartmentDeleteImpactProgram> get programs;/// Silinmemiş, tamamlanmamış görev toplamı.
@JsonKey(name: 'active_items') int get activeItems;/// Silinmemiş, tamamlanmış görev toplamı.
@JsonKey(name: 'completed_items') int get completedItems;/// Silinmiş görev toplamı (departmanla silinenler dahil).
@JsonKey(name: 'deleted_items') int get deletedItems;/// Departmanla birlikte silinmiş görev toplamı; geri yüklemede geri gelir.
@JsonKey(name: 'deleted_with_department') int get deletedWithDepartment;/// Departmanın dosya sayısı (silinmiş görevlerin ekleri dahil).
@JsonKey(name: 'file_count') int get fileCount;/// Ekip satırı bulunan farklı kişi sayısı (bütün programlar).
@JsonKey(name: 'member_count') int get memberCount;/// Departmanı taşıyan silinmemiş toplantı sayısı.
@JsonKey(name: 'meeting_count') int get meetingCount;@JsonKey(name: 'permanent_blockers') DepartmentPermanentBlockers get permanentBlockers;/// `true` ise kalıcı silme 409 `organization.department_in_use` alır.
@JsonKey(name: 'permanent_blocked') bool get permanentBlocked;
/// Create a copy of DepartmentDeleteImpact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartmentDeleteImpactCopyWith<DepartmentDeleteImpact> get copyWith => _$DepartmentDeleteImpactCopyWithImpl<DepartmentDeleteImpact>(this as DepartmentDeleteImpact, _$identity);

  /// Serializes this DepartmentDeleteImpact to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DepartmentDeleteImpact;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentDeleteImpact&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.deleted, _this.deleted) || other.deleted == _this.deleted)&&const DeepCollectionEquality().equals(other.programs, _this.programs)&&(identical(other.activeItems, _this.activeItems) || other.activeItems == _this.activeItems)&&(identical(other.completedItems, _this.completedItems) || other.completedItems == _this.completedItems)&&(identical(other.deletedItems, _this.deletedItems) || other.deletedItems == _this.deletedItems)&&(identical(other.deletedWithDepartment, _this.deletedWithDepartment) || other.deletedWithDepartment == _this.deletedWithDepartment)&&(identical(other.fileCount, _this.fileCount) || other.fileCount == _this.fileCount)&&(identical(other.memberCount, _this.memberCount) || other.memberCount == _this.memberCount)&&(identical(other.meetingCount, _this.meetingCount) || other.meetingCount == _this.meetingCount)&&(identical(other.permanentBlockers, _this.permanentBlockers) || other.permanentBlockers == _this.permanentBlockers)&&(identical(other.permanentBlocked, _this.permanentBlocked) || other.permanentBlocked == _this.permanentBlocked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DepartmentDeleteImpact;
  return Object.hash(runtimeType,_this.departmentId,_this.name,_this.deleted,const DeepCollectionEquality().hash(_this.programs),_this.activeItems,_this.completedItems,_this.deletedItems,_this.deletedWithDepartment,_this.fileCount,_this.memberCount,_this.meetingCount,_this.permanentBlockers,_this.permanentBlocked);
}

@override
String toString() {
  final _this = this as DepartmentDeleteImpact;
  return 'DepartmentDeleteImpact(departmentId: ${_this.departmentId}, name: ${_this.name}, deleted: ${_this.deleted}, programs: ${_this.programs}, activeItems: ${_this.activeItems}, completedItems: ${_this.completedItems}, deletedItems: ${_this.deletedItems}, deletedWithDepartment: ${_this.deletedWithDepartment}, fileCount: ${_this.fileCount}, memberCount: ${_this.memberCount}, meetingCount: ${_this.meetingCount}, permanentBlockers: ${_this.permanentBlockers}, permanentBlocked: ${_this.permanentBlocked})';
}


}

/// @nodoc
abstract mixin class $DepartmentDeleteImpactCopyWith<$Res>  {
  factory $DepartmentDeleteImpactCopyWith(DepartmentDeleteImpact value, $Res Function(DepartmentDeleteImpact) _then) = _$DepartmentDeleteImpactCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId, String name, bool deleted, List<DepartmentDeleteImpactProgram> programs,@JsonKey(name: 'active_items') int activeItems,@JsonKey(name: 'completed_items') int completedItems,@JsonKey(name: 'deleted_items') int deletedItems,@JsonKey(name: 'deleted_with_department') int deletedWithDepartment,@JsonKey(name: 'file_count') int fileCount,@JsonKey(name: 'member_count') int memberCount,@JsonKey(name: 'meeting_count') int meetingCount,@JsonKey(name: 'permanent_blockers') DepartmentPermanentBlockers permanentBlockers,@JsonKey(name: 'permanent_blocked') bool permanentBlocked
});


$DepartmentPermanentBlockersCopyWith<$Res> get permanentBlockers;

}
/// @nodoc
class _$DepartmentDeleteImpactCopyWithImpl<$Res>
    implements $DepartmentDeleteImpactCopyWith<$Res> {
  _$DepartmentDeleteImpactCopyWithImpl(this._self, this._then);

  final DepartmentDeleteImpact _self;
  final $Res Function(DepartmentDeleteImpact) _then;

/// Create a copy of DepartmentDeleteImpact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departmentId = null,Object? name = null,Object? deleted = null,Object? programs = null,Object? activeItems = null,Object? completedItems = null,Object? deletedItems = null,Object? deletedWithDepartment = null,Object? fileCount = null,Object? memberCount = null,Object? meetingCount = null,Object? permanentBlockers = null,Object? permanentBlocked = null,}) {
  return _then(DepartmentDeleteImpact(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,programs: null == programs ? _self.programs : programs // ignore: cast_nullable_to_non_nullable
as List<DepartmentDeleteImpactProgram>,activeItems: null == activeItems ? _self.activeItems : activeItems // ignore: cast_nullable_to_non_nullable
as int,completedItems: null == completedItems ? _self.completedItems : completedItems // ignore: cast_nullable_to_non_nullable
as int,deletedItems: null == deletedItems ? _self.deletedItems : deletedItems // ignore: cast_nullable_to_non_nullable
as int,deletedWithDepartment: null == deletedWithDepartment ? _self.deletedWithDepartment : deletedWithDepartment // ignore: cast_nullable_to_non_nullable
as int,fileCount: null == fileCount ? _self.fileCount : fileCount // ignore: cast_nullable_to_non_nullable
as int,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,meetingCount: null == meetingCount ? _self.meetingCount : meetingCount // ignore: cast_nullable_to_non_nullable
as int,permanentBlockers: null == permanentBlockers ? _self.permanentBlockers : permanentBlockers // ignore: cast_nullable_to_non_nullable
as DepartmentPermanentBlockers,permanentBlocked: null == permanentBlocked ? _self.permanentBlocked : permanentBlocked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of DepartmentDeleteImpact
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DepartmentPermanentBlockersCopyWith<$Res> get permanentBlockers {
  
  return $DepartmentPermanentBlockersCopyWith<$Res>(_self.permanentBlockers, (value) {
    return _then(_self.copyWith(permanentBlockers: value));
  });
}
}


/// Adds pattern-matching-related methods to [DepartmentDeleteImpact].
extension DepartmentDeleteImpactPatterns on DepartmentDeleteImpact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DepartmentDeleteImpact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DepartmentDeleteImpact() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DepartmentDeleteImpact value)  $default,){
final _that = this;
switch (_that) {
case _DepartmentDeleteImpact():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DepartmentDeleteImpact value)?  $default,){
final _that = this;
switch (_that) {
case _DepartmentDeleteImpact() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId,  String name,  bool deleted,  List<DepartmentDeleteImpactProgram> programs, @JsonKey(name: 'active_items')  int activeItems, @JsonKey(name: 'completed_items')  int completedItems, @JsonKey(name: 'deleted_items')  int deletedItems, @JsonKey(name: 'deleted_with_department')  int deletedWithDepartment, @JsonKey(name: 'file_count')  int fileCount, @JsonKey(name: 'member_count')  int memberCount, @JsonKey(name: 'meeting_count')  int meetingCount, @JsonKey(name: 'permanent_blockers')  DepartmentPermanentBlockers permanentBlockers, @JsonKey(name: 'permanent_blocked')  bool permanentBlocked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DepartmentDeleteImpact() when $default != null:
return $default(_that.departmentId,_that.name,_that.deleted,_that.programs,_that.activeItems,_that.completedItems,_that.deletedItems,_that.deletedWithDepartment,_that.fileCount,_that.memberCount,_that.meetingCount,_that.permanentBlockers,_that.permanentBlocked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId,  String name,  bool deleted,  List<DepartmentDeleteImpactProgram> programs, @JsonKey(name: 'active_items')  int activeItems, @JsonKey(name: 'completed_items')  int completedItems, @JsonKey(name: 'deleted_items')  int deletedItems, @JsonKey(name: 'deleted_with_department')  int deletedWithDepartment, @JsonKey(name: 'file_count')  int fileCount, @JsonKey(name: 'member_count')  int memberCount, @JsonKey(name: 'meeting_count')  int meetingCount, @JsonKey(name: 'permanent_blockers')  DepartmentPermanentBlockers permanentBlockers, @JsonKey(name: 'permanent_blocked')  bool permanentBlocked)  $default,) {final _that = this;
switch (_that) {
case _DepartmentDeleteImpact():
return $default(_that.departmentId,_that.name,_that.deleted,_that.programs,_that.activeItems,_that.completedItems,_that.deletedItems,_that.deletedWithDepartment,_that.fileCount,_that.memberCount,_that.meetingCount,_that.permanentBlockers,_that.permanentBlocked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'department_id')  String departmentId,  String name,  bool deleted,  List<DepartmentDeleteImpactProgram> programs, @JsonKey(name: 'active_items')  int activeItems, @JsonKey(name: 'completed_items')  int completedItems, @JsonKey(name: 'deleted_items')  int deletedItems, @JsonKey(name: 'deleted_with_department')  int deletedWithDepartment, @JsonKey(name: 'file_count')  int fileCount, @JsonKey(name: 'member_count')  int memberCount, @JsonKey(name: 'meeting_count')  int meetingCount, @JsonKey(name: 'permanent_blockers')  DepartmentPermanentBlockers permanentBlockers, @JsonKey(name: 'permanent_blocked')  bool permanentBlocked)?  $default,) {final _that = this;
switch (_that) {
case _DepartmentDeleteImpact() when $default != null:
return $default(_that.departmentId,_that.name,_that.deleted,_that.programs,_that.activeItems,_that.completedItems,_that.deletedItems,_that.deletedWithDepartment,_that.fileCount,_that.memberCount,_that.meetingCount,_that.permanentBlockers,_that.permanentBlocked);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DepartmentDeleteImpact implements DepartmentDeleteImpact {
  const _DepartmentDeleteImpact({@JsonKey(name: 'department_id') required this.departmentId, required this.name, required this.deleted, required  List<DepartmentDeleteImpactProgram> programs, @JsonKey(name: 'active_items') required this.activeItems, @JsonKey(name: 'completed_items') required this.completedItems, @JsonKey(name: 'deleted_items') required this.deletedItems, @JsonKey(name: 'deleted_with_department') required this.deletedWithDepartment, @JsonKey(name: 'file_count') required this.fileCount, @JsonKey(name: 'member_count') required this.memberCount, @JsonKey(name: 'meeting_count') required this.meetingCount, @JsonKey(name: 'permanent_blockers') required this.permanentBlockers, @JsonKey(name: 'permanent_blocked') required this.permanentBlocked}): _programs = programs;
  factory _DepartmentDeleteImpact.fromJson(Map<String, dynamic> json) => _$DepartmentDeleteImpactFromJson(json);

@override@JsonKey(name: 'department_id') final  String departmentId;
/// Katalog adı.
@override final  String name;
/// Departman şu an geri alınabilir silinmiş mi.
@override final  bool deleted;
/// Görevi ya da bağı olan programlar (program kimliği sırası).
 final  List<DepartmentDeleteImpactProgram> _programs;
/// Görevi ya da bağı olan programlar (program kimliği sırası).
@override List<DepartmentDeleteImpactProgram> get programs {
  if (_programs is EqualUnmodifiableListView) return _programs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_programs);
}

/// Silinmemiş, tamamlanmamış görev toplamı.
@override@JsonKey(name: 'active_items') final  int activeItems;
/// Silinmemiş, tamamlanmış görev toplamı.
@override@JsonKey(name: 'completed_items') final  int completedItems;
/// Silinmiş görev toplamı (departmanla silinenler dahil).
@override@JsonKey(name: 'deleted_items') final  int deletedItems;
/// Departmanla birlikte silinmiş görev toplamı; geri yüklemede geri gelir.
@override@JsonKey(name: 'deleted_with_department') final  int deletedWithDepartment;
/// Departmanın dosya sayısı (silinmiş görevlerin ekleri dahil).
@override@JsonKey(name: 'file_count') final  int fileCount;
/// Ekip satırı bulunan farklı kişi sayısı (bütün programlar).
@override@JsonKey(name: 'member_count') final  int memberCount;
/// Departmanı taşıyan silinmemiş toplantı sayısı.
@override@JsonKey(name: 'meeting_count') final  int meetingCount;
@override@JsonKey(name: 'permanent_blockers') final  DepartmentPermanentBlockers permanentBlockers;
/// `true` ise kalıcı silme 409 `organization.department_in_use` alır.
@override@JsonKey(name: 'permanent_blocked') final  bool permanentBlocked;

/// Create a copy of DepartmentDeleteImpact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DepartmentDeleteImpactCopyWith<_DepartmentDeleteImpact> get copyWith => __$DepartmentDeleteImpactCopyWithImpl<_DepartmentDeleteImpact>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DepartmentDeleteImpactToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DepartmentDeleteImpact&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.name, name) || other.name == name)&&(identical(other.deleted, deleted) || other.deleted == deleted)&&const DeepCollectionEquality().equals(other.programs, _programs)&&(identical(other.activeItems, activeItems) || other.activeItems == activeItems)&&(identical(other.completedItems, completedItems) || other.completedItems == completedItems)&&(identical(other.deletedItems, deletedItems) || other.deletedItems == deletedItems)&&(identical(other.deletedWithDepartment, deletedWithDepartment) || other.deletedWithDepartment == deletedWithDepartment)&&(identical(other.fileCount, fileCount) || other.fileCount == fileCount)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.meetingCount, meetingCount) || other.meetingCount == meetingCount)&&(identical(other.permanentBlockers, permanentBlockers) || other.permanentBlockers == permanentBlockers)&&(identical(other.permanentBlocked, permanentBlocked) || other.permanentBlocked == permanentBlocked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,departmentId,name,deleted,const DeepCollectionEquality().hash(_programs),activeItems,completedItems,deletedItems,deletedWithDepartment,fileCount,memberCount,meetingCount,permanentBlockers,permanentBlocked);
}

@override
String toString() {
    return 'DepartmentDeleteImpact(departmentId: $departmentId, name: $name, deleted: $deleted, programs: $programs, activeItems: $activeItems, completedItems: $completedItems, deletedItems: $deletedItems, deletedWithDepartment: $deletedWithDepartment, fileCount: $fileCount, memberCount: $memberCount, meetingCount: $meetingCount, permanentBlockers: $permanentBlockers, permanentBlocked: $permanentBlocked)';
}


}

/// @nodoc
abstract mixin class _$DepartmentDeleteImpactCopyWith<$Res> implements $DepartmentDeleteImpactCopyWith<$Res> {
  factory _$DepartmentDeleteImpactCopyWith(_DepartmentDeleteImpact value, $Res Function(_DepartmentDeleteImpact) _then) = __$DepartmentDeleteImpactCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId, String name, bool deleted, List<DepartmentDeleteImpactProgram> programs,@JsonKey(name: 'active_items') int activeItems,@JsonKey(name: 'completed_items') int completedItems,@JsonKey(name: 'deleted_items') int deletedItems,@JsonKey(name: 'deleted_with_department') int deletedWithDepartment,@JsonKey(name: 'file_count') int fileCount,@JsonKey(name: 'member_count') int memberCount,@JsonKey(name: 'meeting_count') int meetingCount,@JsonKey(name: 'permanent_blockers') DepartmentPermanentBlockers permanentBlockers,@JsonKey(name: 'permanent_blocked') bool permanentBlocked
});


@override $DepartmentPermanentBlockersCopyWith<$Res> get permanentBlockers;

}
/// @nodoc
class __$DepartmentDeleteImpactCopyWithImpl<$Res>
    implements _$DepartmentDeleteImpactCopyWith<$Res> {
  __$DepartmentDeleteImpactCopyWithImpl(this._self, this._then);

  final _DepartmentDeleteImpact _self;
  final $Res Function(_DepartmentDeleteImpact) _then;

/// Create a copy of DepartmentDeleteImpact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departmentId = null,Object? name = null,Object? deleted = null,Object? programs = null,Object? activeItems = null,Object? completedItems = null,Object? deletedItems = null,Object? deletedWithDepartment = null,Object? fileCount = null,Object? memberCount = null,Object? meetingCount = null,Object? permanentBlockers = null,Object? permanentBlocked = null,}) {
  return _then(_DepartmentDeleteImpact(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,programs: null == programs ? _self._programs : programs // ignore: cast_nullable_to_non_nullable
as List<DepartmentDeleteImpactProgram>,activeItems: null == activeItems ? _self.activeItems : activeItems // ignore: cast_nullable_to_non_nullable
as int,completedItems: null == completedItems ? _self.completedItems : completedItems // ignore: cast_nullable_to_non_nullable
as int,deletedItems: null == deletedItems ? _self.deletedItems : deletedItems // ignore: cast_nullable_to_non_nullable
as int,deletedWithDepartment: null == deletedWithDepartment ? _self.deletedWithDepartment : deletedWithDepartment // ignore: cast_nullable_to_non_nullable
as int,fileCount: null == fileCount ? _self.fileCount : fileCount // ignore: cast_nullable_to_non_nullable
as int,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,meetingCount: null == meetingCount ? _self.meetingCount : meetingCount // ignore: cast_nullable_to_non_nullable
as int,permanentBlockers: null == permanentBlockers ? _self.permanentBlockers : permanentBlockers // ignore: cast_nullable_to_non_nullable
as DepartmentPermanentBlockers,permanentBlocked: null == permanentBlocked ? _self.permanentBlocked : permanentBlocked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of DepartmentDeleteImpact
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DepartmentPermanentBlockersCopyWith<$Res> get permanentBlockers {
  
  return $DepartmentPermanentBlockersCopyWith<$Res>(_self.permanentBlockers, (value) {
    return _then(_self.copyWith(permanentBlockers: value));
  });
}
}

// dart format on
