// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Meeting {

@JsonKey(name: 'meeting_id') String get meetingId;@JsonKey(name: 'program_id') String get programId;@JsonKey(name: 'owner_department_id') String get ownerDepartmentId; String get title;@JsonKey(name: 'meeting_date') DateTime get meetingDate;/// Toplantı yeri (düz metin, en çok 200 karakter); belirtilmemişse null (COLLABORATION-K76).
 String? get place;@JsonKey(name: 'members_included') bool get membersIncluded;/// Davet kipi (COLLABORATION-K73, K74). `coordinatorship`: bağlı departmanların koordinatörleri ve `members_included` ise üyeleri erişir. `person`: departman bağı erişim vermez; yönetici ve sahip departmanı hâlâ koordine eden oluşturan yönetir (koordinatörlüğü düşen oluşturan katılımcıysa üye düzeyindedir, değilse toplantıyı görmez). İki kipte de katılımcı üye düzeyinde görür. Kuruluşta seçilir, değişmez.
@JsonKey(name: 'invite_mode') MeetingInviteMode get inviteMode;@JsonKey(name: 'created_by_account_id') String get createdByAccountId;@JsonKey(name: 'created_by_role') MeetingCreatedByRole get createdByRole;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt; List<MeetingDepartment> get departments;@JsonKey(name: 'deleted_at') DateTime? get deletedAt;/// Yalnız silinenler listelerinde (`GET /v1/meetings/deleted`, `GET /v1/admin/deleted/meetings`) vardır ve orada her zaman bulunur: toplantıyı yumuşak silen hesap ve adı (COLLABORATION-K77). Silen bilinmiyorsa (alan eklenmeden önce silinmiş toplantı) null.
@JsonKey(name: 'deleted_by') MeetingDeletedBy? get deletedBy;/// Yalnız `GET /v1/meetings` satırlarında vardır ve orada her zaman doludur (COLLABORATION-K70); kuruluş, güncelleme, detay ve silinenler listesi taşımaz.
 MeetingSummary? get summary;
/// Create a copy of Meeting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingCopyWith<Meeting> get copyWith => _$MeetingCopyWithImpl<Meeting>(this as Meeting, _$identity);

  /// Serializes this Meeting to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Meeting;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Meeting&&(identical(other.meetingId, _this.meetingId) || other.meetingId == _this.meetingId)&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.ownerDepartmentId, _this.ownerDepartmentId) || other.ownerDepartmentId == _this.ownerDepartmentId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.meetingDate, _this.meetingDate) || other.meetingDate == _this.meetingDate)&&(identical(other.place, _this.place) || other.place == _this.place)&&(identical(other.membersIncluded, _this.membersIncluded) || other.membersIncluded == _this.membersIncluded)&&(identical(other.inviteMode, _this.inviteMode) || other.inviteMode == _this.inviteMode)&&(identical(other.createdByAccountId, _this.createdByAccountId) || other.createdByAccountId == _this.createdByAccountId)&&(identical(other.createdByRole, _this.createdByRole) || other.createdByRole == _this.createdByRole)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&const DeepCollectionEquality().equals(other.departments, _this.departments)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.deletedBy, _this.deletedBy) || other.deletedBy == _this.deletedBy)&&(identical(other.summary, _this.summary) || other.summary == _this.summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Meeting;
  return Object.hash(runtimeType,_this.meetingId,_this.programId,_this.ownerDepartmentId,_this.title,_this.meetingDate,_this.place,_this.membersIncluded,_this.inviteMode,_this.createdByAccountId,_this.createdByRole,_this.createdAt,_this.updatedAt,const DeepCollectionEquality().hash(_this.departments),_this.deletedAt,_this.deletedBy,_this.summary);
}

@override
String toString() {
  final _this = this as Meeting;
  return 'Meeting(meetingId: ${_this.meetingId}, programId: ${_this.programId}, ownerDepartmentId: ${_this.ownerDepartmentId}, title: ${_this.title}, meetingDate: ${_this.meetingDate}, place: ${_this.place}, membersIncluded: ${_this.membersIncluded}, inviteMode: ${_this.inviteMode}, createdByAccountId: ${_this.createdByAccountId}, createdByRole: ${_this.createdByRole}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, departments: ${_this.departments}, deletedAt: ${_this.deletedAt}, deletedBy: ${_this.deletedBy}, summary: ${_this.summary})';
}


}

/// @nodoc
abstract mixin class $MeetingCopyWith<$Res>  {
  factory $MeetingCopyWith(Meeting value, $Res Function(Meeting) _then) = _$MeetingCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'meeting_id') String meetingId,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'owner_department_id') String ownerDepartmentId, String title,@JsonKey(name: 'meeting_date') DateTime meetingDate, String? place,@JsonKey(name: 'members_included') bool membersIncluded,@JsonKey(name: 'invite_mode') MeetingInviteMode inviteMode,@JsonKey(name: 'created_by_account_id') String createdByAccountId,@JsonKey(name: 'created_by_role') MeetingCreatedByRole createdByRole,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt, List<MeetingDepartment> departments,@JsonKey(name: 'deleted_at') DateTime? deletedAt,@JsonKey(name: 'deleted_by') MeetingDeletedBy? deletedBy, MeetingSummary? summary
});


$MeetingDeletedByCopyWith<$Res>? get deletedBy;$MeetingSummaryCopyWith<$Res>? get summary;

}
/// @nodoc
class _$MeetingCopyWithImpl<$Res>
    implements $MeetingCopyWith<$Res> {
  _$MeetingCopyWithImpl(this._self, this._then);

  final Meeting _self;
  final $Res Function(Meeting) _then;

/// Create a copy of Meeting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meetingId = null,Object? programId = null,Object? ownerDepartmentId = null,Object? title = null,Object? meetingDate = null,Object? place = freezed,Object? membersIncluded = null,Object? inviteMode = null,Object? createdByAccountId = null,Object? createdByRole = null,Object? createdAt = null,Object? updatedAt = null,Object? departments = null,Object? deletedAt = freezed,Object? deletedBy = freezed,Object? summary = freezed,}) {
  return _then(Meeting(
meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,ownerDepartmentId: null == ownerDepartmentId ? _self.ownerDepartmentId : ownerDepartmentId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,meetingDate: null == meetingDate ? _self.meetingDate : meetingDate // ignore: cast_nullable_to_non_nullable
as DateTime,place: freezed == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String?,membersIncluded: null == membersIncluded ? _self.membersIncluded : membersIncluded // ignore: cast_nullable_to_non_nullable
as bool,inviteMode: null == inviteMode ? _self.inviteMode : inviteMode // ignore: cast_nullable_to_non_nullable
as MeetingInviteMode,createdByAccountId: null == createdByAccountId ? _self.createdByAccountId : createdByAccountId // ignore: cast_nullable_to_non_nullable
as String,createdByRole: null == createdByRole ? _self.createdByRole : createdByRole // ignore: cast_nullable_to_non_nullable
as MeetingCreatedByRole,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,departments: null == departments ? _self.departments : departments // ignore: cast_nullable_to_non_nullable
as List<MeetingDepartment>,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedBy: freezed == deletedBy ? _self.deletedBy : deletedBy // ignore: cast_nullable_to_non_nullable
as MeetingDeletedBy?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as MeetingSummary?,
  ));
}
/// Create a copy of Meeting
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingDeletedByCopyWith<$Res>? get deletedBy {
    if (_self.deletedBy == null) {
    return null;
  }

  return $MeetingDeletedByCopyWith<$Res>(_self.deletedBy!, (value) {
    return _then(_self.copyWith(deletedBy: value));
  });
}/// Create a copy of Meeting
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingSummaryCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $MeetingSummaryCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [Meeting].
extension MeetingPatterns on Meeting {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Meeting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Meeting() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Meeting value)  $default,){
final _that = this;
switch (_that) {
case _Meeting():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Meeting value)?  $default,){
final _that = this;
switch (_that) {
case _Meeting() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'meeting_id')  String meetingId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'owner_department_id')  String ownerDepartmentId,  String title, @JsonKey(name: 'meeting_date')  DateTime meetingDate,  String? place, @JsonKey(name: 'members_included')  bool membersIncluded, @JsonKey(name: 'invite_mode')  MeetingInviteMode inviteMode, @JsonKey(name: 'created_by_account_id')  String createdByAccountId, @JsonKey(name: 'created_by_role')  MeetingCreatedByRole createdByRole, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt,  List<MeetingDepartment> departments, @JsonKey(name: 'deleted_at')  DateTime? deletedAt, @JsonKey(name: 'deleted_by')  MeetingDeletedBy? deletedBy,  MeetingSummary? summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Meeting() when $default != null:
return $default(_that.meetingId,_that.programId,_that.ownerDepartmentId,_that.title,_that.meetingDate,_that.place,_that.membersIncluded,_that.inviteMode,_that.createdByAccountId,_that.createdByRole,_that.createdAt,_that.updatedAt,_that.departments,_that.deletedAt,_that.deletedBy,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'meeting_id')  String meetingId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'owner_department_id')  String ownerDepartmentId,  String title, @JsonKey(name: 'meeting_date')  DateTime meetingDate,  String? place, @JsonKey(name: 'members_included')  bool membersIncluded, @JsonKey(name: 'invite_mode')  MeetingInviteMode inviteMode, @JsonKey(name: 'created_by_account_id')  String createdByAccountId, @JsonKey(name: 'created_by_role')  MeetingCreatedByRole createdByRole, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt,  List<MeetingDepartment> departments, @JsonKey(name: 'deleted_at')  DateTime? deletedAt, @JsonKey(name: 'deleted_by')  MeetingDeletedBy? deletedBy,  MeetingSummary? summary)  $default,) {final _that = this;
switch (_that) {
case _Meeting():
return $default(_that.meetingId,_that.programId,_that.ownerDepartmentId,_that.title,_that.meetingDate,_that.place,_that.membersIncluded,_that.inviteMode,_that.createdByAccountId,_that.createdByRole,_that.createdAt,_that.updatedAt,_that.departments,_that.deletedAt,_that.deletedBy,_that.summary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'meeting_id')  String meetingId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'owner_department_id')  String ownerDepartmentId,  String title, @JsonKey(name: 'meeting_date')  DateTime meetingDate,  String? place, @JsonKey(name: 'members_included')  bool membersIncluded, @JsonKey(name: 'invite_mode')  MeetingInviteMode inviteMode, @JsonKey(name: 'created_by_account_id')  String createdByAccountId, @JsonKey(name: 'created_by_role')  MeetingCreatedByRole createdByRole, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt,  List<MeetingDepartment> departments, @JsonKey(name: 'deleted_at')  DateTime? deletedAt, @JsonKey(name: 'deleted_by')  MeetingDeletedBy? deletedBy,  MeetingSummary? summary)?  $default,) {final _that = this;
switch (_that) {
case _Meeting() when $default != null:
return $default(_that.meetingId,_that.programId,_that.ownerDepartmentId,_that.title,_that.meetingDate,_that.place,_that.membersIncluded,_that.inviteMode,_that.createdByAccountId,_that.createdByRole,_that.createdAt,_that.updatedAt,_that.departments,_that.deletedAt,_that.deletedBy,_that.summary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Meeting implements Meeting {
  const _Meeting({@JsonKey(name: 'meeting_id') required this.meetingId, @JsonKey(name: 'program_id') required this.programId, @JsonKey(name: 'owner_department_id') required this.ownerDepartmentId, required this.title, @JsonKey(name: 'meeting_date') required this.meetingDate, required this.place, @JsonKey(name: 'members_included') required this.membersIncluded, @JsonKey(name: 'invite_mode') required this.inviteMode, @JsonKey(name: 'created_by_account_id') required this.createdByAccountId, @JsonKey(name: 'created_by_role') required this.createdByRole, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, required  List<MeetingDepartment> departments, @JsonKey(name: 'deleted_at') this.deletedAt, @JsonKey(name: 'deleted_by') this.deletedBy, this.summary}): _departments = departments;
  factory _Meeting.fromJson(Map<String, dynamic> json) => _$MeetingFromJson(json);

@override@JsonKey(name: 'meeting_id') final  String meetingId;
@override@JsonKey(name: 'program_id') final  String programId;
@override@JsonKey(name: 'owner_department_id') final  String ownerDepartmentId;
@override final  String title;
@override@JsonKey(name: 'meeting_date') final  DateTime meetingDate;
/// Toplantı yeri (düz metin, en çok 200 karakter); belirtilmemişse null (COLLABORATION-K76).
@override final  String? place;
@override@JsonKey(name: 'members_included') final  bool membersIncluded;
/// Davet kipi (COLLABORATION-K73, K74). `coordinatorship`: bağlı departmanların koordinatörleri ve `members_included` ise üyeleri erişir. `person`: departman bağı erişim vermez; yönetici ve sahip departmanı hâlâ koordine eden oluşturan yönetir (koordinatörlüğü düşen oluşturan katılımcıysa üye düzeyindedir, değilse toplantıyı görmez). İki kipte de katılımcı üye düzeyinde görür. Kuruluşta seçilir, değişmez.
@override@JsonKey(name: 'invite_mode') final  MeetingInviteMode inviteMode;
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

@override@JsonKey(name: 'deleted_at') final  DateTime? deletedAt;
/// Yalnız silinenler listelerinde (`GET /v1/meetings/deleted`, `GET /v1/admin/deleted/meetings`) vardır ve orada her zaman bulunur: toplantıyı yumuşak silen hesap ve adı (COLLABORATION-K77). Silen bilinmiyorsa (alan eklenmeden önce silinmiş toplantı) null.
@override@JsonKey(name: 'deleted_by') final  MeetingDeletedBy? deletedBy;
/// Yalnız `GET /v1/meetings` satırlarında vardır ve orada her zaman doludur (COLLABORATION-K70); kuruluş, güncelleme, detay ve silinenler listesi taşımaz.
@override final  MeetingSummary? summary;

/// Create a copy of Meeting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingCopyWith<_Meeting> get copyWith => __$MeetingCopyWithImpl<_Meeting>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Meeting&&(identical(other.meetingId, meetingId) || other.meetingId == meetingId)&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.ownerDepartmentId, ownerDepartmentId) || other.ownerDepartmentId == ownerDepartmentId)&&(identical(other.title, title) || other.title == title)&&(identical(other.meetingDate, meetingDate) || other.meetingDate == meetingDate)&&(identical(other.place, place) || other.place == place)&&(identical(other.membersIncluded, membersIncluded) || other.membersIncluded == membersIncluded)&&(identical(other.inviteMode, inviteMode) || other.inviteMode == inviteMode)&&(identical(other.createdByAccountId, createdByAccountId) || other.createdByAccountId == createdByAccountId)&&(identical(other.createdByRole, createdByRole) || other.createdByRole == createdByRole)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.departments, _departments)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.deletedBy, deletedBy) || other.deletedBy == deletedBy)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,meetingId,programId,ownerDepartmentId,title,meetingDate,place,membersIncluded,inviteMode,createdByAccountId,createdByRole,createdAt,updatedAt,const DeepCollectionEquality().hash(_departments),deletedAt,deletedBy,summary);
}

@override
String toString() {
    return 'Meeting(meetingId: $meetingId, programId: $programId, ownerDepartmentId: $ownerDepartmentId, title: $title, meetingDate: $meetingDate, place: $place, membersIncluded: $membersIncluded, inviteMode: $inviteMode, createdByAccountId: $createdByAccountId, createdByRole: $createdByRole, createdAt: $createdAt, updatedAt: $updatedAt, departments: $departments, deletedAt: $deletedAt, deletedBy: $deletedBy, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$MeetingCopyWith<$Res> implements $MeetingCopyWith<$Res> {
  factory _$MeetingCopyWith(_Meeting value, $Res Function(_Meeting) _then) = __$MeetingCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'meeting_id') String meetingId,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'owner_department_id') String ownerDepartmentId, String title,@JsonKey(name: 'meeting_date') DateTime meetingDate, String? place,@JsonKey(name: 'members_included') bool membersIncluded,@JsonKey(name: 'invite_mode') MeetingInviteMode inviteMode,@JsonKey(name: 'created_by_account_id') String createdByAccountId,@JsonKey(name: 'created_by_role') MeetingCreatedByRole createdByRole,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt, List<MeetingDepartment> departments,@JsonKey(name: 'deleted_at') DateTime? deletedAt,@JsonKey(name: 'deleted_by') MeetingDeletedBy? deletedBy, MeetingSummary? summary
});


@override $MeetingDeletedByCopyWith<$Res>? get deletedBy;@override $MeetingSummaryCopyWith<$Res>? get summary;

}
/// @nodoc
class __$MeetingCopyWithImpl<$Res>
    implements _$MeetingCopyWith<$Res> {
  __$MeetingCopyWithImpl(this._self, this._then);

  final _Meeting _self;
  final $Res Function(_Meeting) _then;

/// Create a copy of Meeting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meetingId = null,Object? programId = null,Object? ownerDepartmentId = null,Object? title = null,Object? meetingDate = null,Object? place = freezed,Object? membersIncluded = null,Object? inviteMode = null,Object? createdByAccountId = null,Object? createdByRole = null,Object? createdAt = null,Object? updatedAt = null,Object? departments = null,Object? deletedAt = freezed,Object? deletedBy = freezed,Object? summary = freezed,}) {
  return _then(_Meeting(
meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,ownerDepartmentId: null == ownerDepartmentId ? _self.ownerDepartmentId : ownerDepartmentId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,meetingDate: null == meetingDate ? _self.meetingDate : meetingDate // ignore: cast_nullable_to_non_nullable
as DateTime,place: freezed == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String?,membersIncluded: null == membersIncluded ? _self.membersIncluded : membersIncluded // ignore: cast_nullable_to_non_nullable
as bool,inviteMode: null == inviteMode ? _self.inviteMode : inviteMode // ignore: cast_nullable_to_non_nullable
as MeetingInviteMode,createdByAccountId: null == createdByAccountId ? _self.createdByAccountId : createdByAccountId // ignore: cast_nullable_to_non_nullable
as String,createdByRole: null == createdByRole ? _self.createdByRole : createdByRole // ignore: cast_nullable_to_non_nullable
as MeetingCreatedByRole,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,departments: null == departments ? _self._departments : departments // ignore: cast_nullable_to_non_nullable
as List<MeetingDepartment>,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedBy: freezed == deletedBy ? _self.deletedBy : deletedBy // ignore: cast_nullable_to_non_nullable
as MeetingDeletedBy?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as MeetingSummary?,
  ));
}

/// Create a copy of Meeting
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingDeletedByCopyWith<$Res>? get deletedBy {
    if (_self.deletedBy == null) {
    return null;
  }

  return $MeetingDeletedByCopyWith<$Res>(_self.deletedBy!, (value) {
    return _then(_self.copyWith(deletedBy: value));
  });
}/// Create a copy of Meeting
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingSummaryCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $MeetingSummaryCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

// dart format on
