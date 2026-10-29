// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_revised.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeetingRevised {

@JsonKey(name: 'meeting_id') String get meetingId;@JsonKey(name: 'program_id') String get programId;@JsonKey(name: 'owner_department_id') String get ownerDepartmentId; String get title;@JsonKey(name: 'meeting_date') DateTime get meetingDate;@JsonKey(name: 'members_included') bool get membersIncluded;@JsonKey(name: 'created_by_account_id') String get createdByAccountId;@JsonKey(name: 'created_by_role') MeetingCreatedByRole get createdByRole;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt; List<MeetingDepartment> get departments;@JsonKey(name: 'side_effects') MeetingSideEffects get sideEffects;@JsonKey(name: 'deleted_at') DateTime? get deletedAt;
/// Create a copy of MeetingRevised
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingRevisedCopyWith<MeetingRevised> get copyWith => _$MeetingRevisedCopyWithImpl<MeetingRevised>(this as MeetingRevised, _$identity);

  /// Serializes this MeetingRevised to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeetingRevised;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingRevised&&(identical(other.meetingId, _this.meetingId) || other.meetingId == _this.meetingId)&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.ownerDepartmentId, _this.ownerDepartmentId) || other.ownerDepartmentId == _this.ownerDepartmentId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.meetingDate, _this.meetingDate) || other.meetingDate == _this.meetingDate)&&(identical(other.membersIncluded, _this.membersIncluded) || other.membersIncluded == _this.membersIncluded)&&(identical(other.createdByAccountId, _this.createdByAccountId) || other.createdByAccountId == _this.createdByAccountId)&&(identical(other.createdByRole, _this.createdByRole) || other.createdByRole == _this.createdByRole)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&const DeepCollectionEquality().equals(other.departments, _this.departments)&&(identical(other.sideEffects, _this.sideEffects) || other.sideEffects == _this.sideEffects)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeetingRevised;
  return Object.hash(runtimeType,_this.meetingId,_this.programId,_this.ownerDepartmentId,_this.title,_this.meetingDate,_this.membersIncluded,_this.createdByAccountId,_this.createdByRole,_this.createdAt,_this.updatedAt,const DeepCollectionEquality().hash(_this.departments),_this.sideEffects,_this.deletedAt);
}

@override
String toString() {
  final _this = this as MeetingRevised;
  return 'MeetingRevised(meetingId: ${_this.meetingId}, programId: ${_this.programId}, ownerDepartmentId: ${_this.ownerDepartmentId}, title: ${_this.title}, meetingDate: ${_this.meetingDate}, membersIncluded: ${_this.membersIncluded}, createdByAccountId: ${_this.createdByAccountId}, createdByRole: ${_this.createdByRole}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, departments: ${_this.departments}, sideEffects: ${_this.sideEffects}, deletedAt: ${_this.deletedAt})';
}


}

/// @nodoc
abstract mixin class $MeetingRevisedCopyWith<$Res>  {
  factory $MeetingRevisedCopyWith(MeetingRevised value, $Res Function(MeetingRevised) _then) = _$MeetingRevisedCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'meeting_id') String meetingId,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'owner_department_id') String ownerDepartmentId, String title,@JsonKey(name: 'meeting_date') DateTime meetingDate,@JsonKey(name: 'members_included') bool membersIncluded,@JsonKey(name: 'created_by_account_id') String createdByAccountId,@JsonKey(name: 'created_by_role') MeetingCreatedByRole createdByRole,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt, List<MeetingDepartment> departments,@JsonKey(name: 'side_effects') MeetingSideEffects sideEffects,@JsonKey(name: 'deleted_at') DateTime? deletedAt
});


$MeetingSideEffectsCopyWith<$Res> get sideEffects;

}
/// @nodoc
class _$MeetingRevisedCopyWithImpl<$Res>
    implements $MeetingRevisedCopyWith<$Res> {
  _$MeetingRevisedCopyWithImpl(this._self, this._then);

  final MeetingRevised _self;
  final $Res Function(MeetingRevised) _then;

/// Create a copy of MeetingRevised
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meetingId = null,Object? programId = null,Object? ownerDepartmentId = null,Object? title = null,Object? meetingDate = null,Object? membersIncluded = null,Object? createdByAccountId = null,Object? createdByRole = null,Object? createdAt = null,Object? updatedAt = null,Object? departments = null,Object? sideEffects = null,Object? deletedAt = freezed,}) {
  return _then(MeetingRevised(
meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,ownerDepartmentId: null == ownerDepartmentId ? _self.ownerDepartmentId : ownerDepartmentId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,meetingDate: null == meetingDate ? _self.meetingDate : meetingDate // ignore: cast_nullable_to_non_nullable
as DateTime,membersIncluded: null == membersIncluded ? _self.membersIncluded : membersIncluded // ignore: cast_nullable_to_non_nullable
as bool,createdByAccountId: null == createdByAccountId ? _self.createdByAccountId : createdByAccountId // ignore: cast_nullable_to_non_nullable
as String,createdByRole: null == createdByRole ? _self.createdByRole : createdByRole // ignore: cast_nullable_to_non_nullable
as MeetingCreatedByRole,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,departments: null == departments ? _self.departments : departments // ignore: cast_nullable_to_non_nullable
as List<MeetingDepartment>,sideEffects: null == sideEffects ? _self.sideEffects : sideEffects // ignore: cast_nullable_to_non_nullable
as MeetingSideEffects,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of MeetingRevised
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingSideEffectsCopyWith<$Res> get sideEffects {
  
  return $MeetingSideEffectsCopyWith<$Res>(_self.sideEffects, (value) {
    return _then(_self.copyWith(sideEffects: value));
  });
}
}


/// Adds pattern-matching-related methods to [MeetingRevised].
extension MeetingRevisedPatterns on MeetingRevised {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetingRevised value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetingRevised() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetingRevised value)  $default,){
final _that = this;
switch (_that) {
case _MeetingRevised():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetingRevised value)?  $default,){
final _that = this;
switch (_that) {
case _MeetingRevised() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'meeting_id')  String meetingId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'owner_department_id')  String ownerDepartmentId,  String title, @JsonKey(name: 'meeting_date')  DateTime meetingDate, @JsonKey(name: 'members_included')  bool membersIncluded, @JsonKey(name: 'created_by_account_id')  String createdByAccountId, @JsonKey(name: 'created_by_role')  MeetingCreatedByRole createdByRole, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt,  List<MeetingDepartment> departments, @JsonKey(name: 'side_effects')  MeetingSideEffects sideEffects, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingRevised() when $default != null:
return $default(_that.meetingId,_that.programId,_that.ownerDepartmentId,_that.title,_that.meetingDate,_that.membersIncluded,_that.createdByAccountId,_that.createdByRole,_that.createdAt,_that.updatedAt,_that.departments,_that.sideEffects,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'meeting_id')  String meetingId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'owner_department_id')  String ownerDepartmentId,  String title, @JsonKey(name: 'meeting_date')  DateTime meetingDate, @JsonKey(name: 'members_included')  bool membersIncluded, @JsonKey(name: 'created_by_account_id')  String createdByAccountId, @JsonKey(name: 'created_by_role')  MeetingCreatedByRole createdByRole, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt,  List<MeetingDepartment> departments, @JsonKey(name: 'side_effects')  MeetingSideEffects sideEffects, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _MeetingRevised():
return $default(_that.meetingId,_that.programId,_that.ownerDepartmentId,_that.title,_that.meetingDate,_that.membersIncluded,_that.createdByAccountId,_that.createdByRole,_that.createdAt,_that.updatedAt,_that.departments,_that.sideEffects,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'meeting_id')  String meetingId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'owner_department_id')  String ownerDepartmentId,  String title, @JsonKey(name: 'meeting_date')  DateTime meetingDate, @JsonKey(name: 'members_included')  bool membersIncluded, @JsonKey(name: 'created_by_account_id')  String createdByAccountId, @JsonKey(name: 'created_by_role')  MeetingCreatedByRole createdByRole, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt,  List<MeetingDepartment> departments, @JsonKey(name: 'side_effects')  MeetingSideEffects sideEffects, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _MeetingRevised() when $default != null:
return $default(_that.meetingId,_that.programId,_that.ownerDepartmentId,_that.title,_that.meetingDate,_that.membersIncluded,_that.createdByAccountId,_that.createdByRole,_that.createdAt,_that.updatedAt,_that.departments,_that.sideEffects,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetingRevised implements MeetingRevised {
  const _MeetingRevised({@JsonKey(name: 'meeting_id') required this.meetingId, @JsonKey(name: 'program_id') required this.programId, @JsonKey(name: 'owner_department_id') required this.ownerDepartmentId, required this.title, @JsonKey(name: 'meeting_date') required this.meetingDate, @JsonKey(name: 'members_included') required this.membersIncluded, @JsonKey(name: 'created_by_account_id') required this.createdByAccountId, @JsonKey(name: 'created_by_role') required this.createdByRole, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, required  List<MeetingDepartment> departments, @JsonKey(name: 'side_effects') required this.sideEffects, @JsonKey(name: 'deleted_at') this.deletedAt}): _departments = departments;
  factory _MeetingRevised.fromJson(Map<String, dynamic> json) => _$MeetingRevisedFromJson(json);

@override@JsonKey(name: 'meeting_id') final  String meetingId;
@override@JsonKey(name: 'program_id') final  String programId;
@override@JsonKey(name: 'owner_department_id') final  String ownerDepartmentId;
@override final  String title;
@override@JsonKey(name: 'meeting_date') final  DateTime meetingDate;
@override@JsonKey(name: 'members_included') final  bool membersIncluded;
@override@JsonKey(name: 'created_by_account_id') final  String createdByAccountId;
@override@JsonKey(name: 'created_by_role') final  MeetingCreatedByRole createdByRole;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;
 final  List<MeetingDepartment> _departments;
@override List<MeetingDepartment> get departments {
  if (_departments is EqualUnmodifiableListView) return _departments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_departments);
}

@override@JsonKey(name: 'side_effects') final  MeetingSideEffects sideEffects;
@override@JsonKey(name: 'deleted_at') final  DateTime? deletedAt;

/// Create a copy of MeetingRevised
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingRevisedCopyWith<_MeetingRevised> get copyWith => __$MeetingRevisedCopyWithImpl<_MeetingRevised>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetingRevisedToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingRevised&&(identical(other.meetingId, meetingId) || other.meetingId == meetingId)&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.ownerDepartmentId, ownerDepartmentId) || other.ownerDepartmentId == ownerDepartmentId)&&(identical(other.title, title) || other.title == title)&&(identical(other.meetingDate, meetingDate) || other.meetingDate == meetingDate)&&(identical(other.membersIncluded, membersIncluded) || other.membersIncluded == membersIncluded)&&(identical(other.createdByAccountId, createdByAccountId) || other.createdByAccountId == createdByAccountId)&&(identical(other.createdByRole, createdByRole) || other.createdByRole == createdByRole)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.departments, _departments)&&(identical(other.sideEffects, sideEffects) || other.sideEffects == sideEffects)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,meetingId,programId,ownerDepartmentId,title,meetingDate,membersIncluded,createdByAccountId,createdByRole,createdAt,updatedAt,const DeepCollectionEquality().hash(_departments),sideEffects,deletedAt);
}

@override
String toString() {
    return 'MeetingRevised(meetingId: $meetingId, programId: $programId, ownerDepartmentId: $ownerDepartmentId, title: $title, meetingDate: $meetingDate, membersIncluded: $membersIncluded, createdByAccountId: $createdByAccountId, createdByRole: $createdByRole, createdAt: $createdAt, updatedAt: $updatedAt, departments: $departments, sideEffects: $sideEffects, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$MeetingRevisedCopyWith<$Res> implements $MeetingRevisedCopyWith<$Res> {
  factory _$MeetingRevisedCopyWith(_MeetingRevised value, $Res Function(_MeetingRevised) _then) = __$MeetingRevisedCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'meeting_id') String meetingId,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'owner_department_id') String ownerDepartmentId, String title,@JsonKey(name: 'meeting_date') DateTime meetingDate,@JsonKey(name: 'members_included') bool membersIncluded,@JsonKey(name: 'created_by_account_id') String createdByAccountId,@JsonKey(name: 'created_by_role') MeetingCreatedByRole createdByRole,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt, List<MeetingDepartment> departments,@JsonKey(name: 'side_effects') MeetingSideEffects sideEffects,@JsonKey(name: 'deleted_at') DateTime? deletedAt
});


@override $MeetingSideEffectsCopyWith<$Res> get sideEffects;

}
/// @nodoc
class __$MeetingRevisedCopyWithImpl<$Res>
    implements _$MeetingRevisedCopyWith<$Res> {
  __$MeetingRevisedCopyWithImpl(this._self, this._then);

  final _MeetingRevised _self;
  final $Res Function(_MeetingRevised) _then;

/// Create a copy of MeetingRevised
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meetingId = null,Object? programId = null,Object? ownerDepartmentId = null,Object? title = null,Object? meetingDate = null,Object? membersIncluded = null,Object? createdByAccountId = null,Object? createdByRole = null,Object? createdAt = null,Object? updatedAt = null,Object? departments = null,Object? sideEffects = null,Object? deletedAt = freezed,}) {
  return _then(_MeetingRevised(
meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,ownerDepartmentId: null == ownerDepartmentId ? _self.ownerDepartmentId : ownerDepartmentId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,meetingDate: null == meetingDate ? _self.meetingDate : meetingDate // ignore: cast_nullable_to_non_nullable
as DateTime,membersIncluded: null == membersIncluded ? _self.membersIncluded : membersIncluded // ignore: cast_nullable_to_non_nullable
as bool,createdByAccountId: null == createdByAccountId ? _self.createdByAccountId : createdByAccountId // ignore: cast_nullable_to_non_nullable
as String,createdByRole: null == createdByRole ? _self.createdByRole : createdByRole // ignore: cast_nullable_to_non_nullable
as MeetingCreatedByRole,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,departments: null == departments ? _self._departments : departments // ignore: cast_nullable_to_non_nullable
as List<MeetingDepartment>,sideEffects: null == sideEffects ? _self.sideEffects : sideEffects // ignore: cast_nullable_to_non_nullable
as MeetingSideEffects,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of MeetingRevised
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingSideEffectsCopyWith<$Res> get sideEffects {
  
  return $MeetingSideEffectsCopyWith<$Res>(_self.sideEffects, (value) {
    return _then(_self.copyWith(sideEffects: value));
  });
}
}

// dart format on
