// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeetingDetail {

@JsonKey(name: 'meeting_id') String get meetingId;@JsonKey(name: 'program_id') String get programId;@JsonKey(name: 'owner_department_id') String get ownerDepartmentId; String get title;@JsonKey(name: 'meeting_date') DateTime get meetingDate;@JsonKey(name: 'members_included') bool get membersIncluded;@JsonKey(name: 'created_by_account_id') String get createdByAccountId;@JsonKey(name: 'created_by_role') MeetingCreatedByRole get createdByRole;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt; List<MeetingDepartment> get departments;/// Aktif ya da kapanmakta olan konferans; yoksa null. Dış oda adı taşınmaz.
 Conference? get conference;/// Bağlı video sağlayıcısı oda açabiliyor mu (`none` iken false). İstemci başlat düğmesini buna göre gösterir.
@JsonKey(name: 'conference_available') bool get conferenceAvailable;@JsonKey(name: 'viewer_role') MeetingDetailViewerRole get viewerRole; List<Participant> get participants; List<AgendaItem> get agenda; MeetingNoteList get notes;@JsonKey(name: 'deleted_at') DateTime? get deletedAt;
/// Create a copy of MeetingDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingDetailCopyWith<MeetingDetail> get copyWith => _$MeetingDetailCopyWithImpl<MeetingDetail>(this as MeetingDetail, _$identity);

  /// Serializes this MeetingDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeetingDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingDetail&&(identical(other.meetingId, _this.meetingId) || other.meetingId == _this.meetingId)&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.ownerDepartmentId, _this.ownerDepartmentId) || other.ownerDepartmentId == _this.ownerDepartmentId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.meetingDate, _this.meetingDate) || other.meetingDate == _this.meetingDate)&&(identical(other.membersIncluded, _this.membersIncluded) || other.membersIncluded == _this.membersIncluded)&&(identical(other.createdByAccountId, _this.createdByAccountId) || other.createdByAccountId == _this.createdByAccountId)&&(identical(other.createdByRole, _this.createdByRole) || other.createdByRole == _this.createdByRole)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&const DeepCollectionEquality().equals(other.departments, _this.departments)&&(identical(other.conference, _this.conference) || other.conference == _this.conference)&&(identical(other.conferenceAvailable, _this.conferenceAvailable) || other.conferenceAvailable == _this.conferenceAvailable)&&(identical(other.viewerRole, _this.viewerRole) || other.viewerRole == _this.viewerRole)&&const DeepCollectionEquality().equals(other.participants, _this.participants)&&const DeepCollectionEquality().equals(other.agenda, _this.agenda)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeetingDetail;
  return Object.hash(runtimeType,_this.meetingId,_this.programId,_this.ownerDepartmentId,_this.title,_this.meetingDate,_this.membersIncluded,_this.createdByAccountId,_this.createdByRole,_this.createdAt,_this.updatedAt,const DeepCollectionEquality().hash(_this.departments),_this.conference,_this.conferenceAvailable,_this.viewerRole,const DeepCollectionEquality().hash(_this.participants),const DeepCollectionEquality().hash(_this.agenda),_this.notes,_this.deletedAt);
}

@override
String toString() {
  final _this = this as MeetingDetail;
  return 'MeetingDetail(meetingId: ${_this.meetingId}, programId: ${_this.programId}, ownerDepartmentId: ${_this.ownerDepartmentId}, title: ${_this.title}, meetingDate: ${_this.meetingDate}, membersIncluded: ${_this.membersIncluded}, createdByAccountId: ${_this.createdByAccountId}, createdByRole: ${_this.createdByRole}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, departments: ${_this.departments}, conference: ${_this.conference}, conferenceAvailable: ${_this.conferenceAvailable}, viewerRole: ${_this.viewerRole}, participants: ${_this.participants}, agenda: ${_this.agenda}, notes: ${_this.notes}, deletedAt: ${_this.deletedAt})';
}


}

/// @nodoc
abstract mixin class $MeetingDetailCopyWith<$Res>  {
  factory $MeetingDetailCopyWith(MeetingDetail value, $Res Function(MeetingDetail) _then) = _$MeetingDetailCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'meeting_id') String meetingId,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'owner_department_id') String ownerDepartmentId, String title,@JsonKey(name: 'meeting_date') DateTime meetingDate,@JsonKey(name: 'members_included') bool membersIncluded,@JsonKey(name: 'created_by_account_id') String createdByAccountId,@JsonKey(name: 'created_by_role') MeetingCreatedByRole createdByRole,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt, List<MeetingDepartment> departments, Conference? conference,@JsonKey(name: 'conference_available') bool conferenceAvailable,@JsonKey(name: 'viewer_role') MeetingDetailViewerRole viewerRole, List<Participant> participants, List<AgendaItem> agenda, MeetingNoteList notes,@JsonKey(name: 'deleted_at') DateTime? deletedAt
});


$ConferenceCopyWith<$Res>? get conference;$MeetingNoteListCopyWith<$Res> get notes;

}
/// @nodoc
class _$MeetingDetailCopyWithImpl<$Res>
    implements $MeetingDetailCopyWith<$Res> {
  _$MeetingDetailCopyWithImpl(this._self, this._then);

  final MeetingDetail _self;
  final $Res Function(MeetingDetail) _then;

/// Create a copy of MeetingDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meetingId = null,Object? programId = null,Object? ownerDepartmentId = null,Object? title = null,Object? meetingDate = null,Object? membersIncluded = null,Object? createdByAccountId = null,Object? createdByRole = null,Object? createdAt = null,Object? updatedAt = null,Object? departments = null,Object? conference = freezed,Object? conferenceAvailable = null,Object? viewerRole = null,Object? participants = null,Object? agenda = null,Object? notes = null,Object? deletedAt = freezed,}) {
  return _then(MeetingDetail(
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
as List<MeetingDepartment>,conference: freezed == conference ? _self.conference : conference // ignore: cast_nullable_to_non_nullable
as Conference?,conferenceAvailable: null == conferenceAvailable ? _self.conferenceAvailable : conferenceAvailable // ignore: cast_nullable_to_non_nullable
as bool,viewerRole: null == viewerRole ? _self.viewerRole : viewerRole // ignore: cast_nullable_to_non_nullable
as MeetingDetailViewerRole,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<Participant>,agenda: null == agenda ? _self.agenda : agenda // ignore: cast_nullable_to_non_nullable
as List<AgendaItem>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as MeetingNoteList,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of MeetingDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConferenceCopyWith<$Res>? get conference {
    if (_self.conference == null) {
    return null;
  }

  return $ConferenceCopyWith<$Res>(_self.conference!, (value) {
    return _then(_self.copyWith(conference: value));
  });
}/// Create a copy of MeetingDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingNoteListCopyWith<$Res> get notes {
  
  return $MeetingNoteListCopyWith<$Res>(_self.notes, (value) {
    return _then(_self.copyWith(notes: value));
  });
}
}


/// Adds pattern-matching-related methods to [MeetingDetail].
extension MeetingDetailPatterns on MeetingDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetingDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetingDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetingDetail value)  $default,){
final _that = this;
switch (_that) {
case _MeetingDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetingDetail value)?  $default,){
final _that = this;
switch (_that) {
case _MeetingDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'meeting_id')  String meetingId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'owner_department_id')  String ownerDepartmentId,  String title, @JsonKey(name: 'meeting_date')  DateTime meetingDate, @JsonKey(name: 'members_included')  bool membersIncluded, @JsonKey(name: 'created_by_account_id')  String createdByAccountId, @JsonKey(name: 'created_by_role')  MeetingCreatedByRole createdByRole, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt,  List<MeetingDepartment> departments,  Conference? conference, @JsonKey(name: 'conference_available')  bool conferenceAvailable, @JsonKey(name: 'viewer_role')  MeetingDetailViewerRole viewerRole,  List<Participant> participants,  List<AgendaItem> agenda,  MeetingNoteList notes, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingDetail() when $default != null:
return $default(_that.meetingId,_that.programId,_that.ownerDepartmentId,_that.title,_that.meetingDate,_that.membersIncluded,_that.createdByAccountId,_that.createdByRole,_that.createdAt,_that.updatedAt,_that.departments,_that.conference,_that.conferenceAvailable,_that.viewerRole,_that.participants,_that.agenda,_that.notes,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'meeting_id')  String meetingId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'owner_department_id')  String ownerDepartmentId,  String title, @JsonKey(name: 'meeting_date')  DateTime meetingDate, @JsonKey(name: 'members_included')  bool membersIncluded, @JsonKey(name: 'created_by_account_id')  String createdByAccountId, @JsonKey(name: 'created_by_role')  MeetingCreatedByRole createdByRole, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt,  List<MeetingDepartment> departments,  Conference? conference, @JsonKey(name: 'conference_available')  bool conferenceAvailable, @JsonKey(name: 'viewer_role')  MeetingDetailViewerRole viewerRole,  List<Participant> participants,  List<AgendaItem> agenda,  MeetingNoteList notes, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _MeetingDetail():
return $default(_that.meetingId,_that.programId,_that.ownerDepartmentId,_that.title,_that.meetingDate,_that.membersIncluded,_that.createdByAccountId,_that.createdByRole,_that.createdAt,_that.updatedAt,_that.departments,_that.conference,_that.conferenceAvailable,_that.viewerRole,_that.participants,_that.agenda,_that.notes,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'meeting_id')  String meetingId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'owner_department_id')  String ownerDepartmentId,  String title, @JsonKey(name: 'meeting_date')  DateTime meetingDate, @JsonKey(name: 'members_included')  bool membersIncluded, @JsonKey(name: 'created_by_account_id')  String createdByAccountId, @JsonKey(name: 'created_by_role')  MeetingCreatedByRole createdByRole, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt,  List<MeetingDepartment> departments,  Conference? conference, @JsonKey(name: 'conference_available')  bool conferenceAvailable, @JsonKey(name: 'viewer_role')  MeetingDetailViewerRole viewerRole,  List<Participant> participants,  List<AgendaItem> agenda,  MeetingNoteList notes, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _MeetingDetail() when $default != null:
return $default(_that.meetingId,_that.programId,_that.ownerDepartmentId,_that.title,_that.meetingDate,_that.membersIncluded,_that.createdByAccountId,_that.createdByRole,_that.createdAt,_that.updatedAt,_that.departments,_that.conference,_that.conferenceAvailable,_that.viewerRole,_that.participants,_that.agenda,_that.notes,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetingDetail implements MeetingDetail {
  const _MeetingDetail({@JsonKey(name: 'meeting_id') required this.meetingId, @JsonKey(name: 'program_id') required this.programId, @JsonKey(name: 'owner_department_id') required this.ownerDepartmentId, required this.title, @JsonKey(name: 'meeting_date') required this.meetingDate, @JsonKey(name: 'members_included') required this.membersIncluded, @JsonKey(name: 'created_by_account_id') required this.createdByAccountId, @JsonKey(name: 'created_by_role') required this.createdByRole, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, required  List<MeetingDepartment> departments, required this.conference, @JsonKey(name: 'conference_available') required this.conferenceAvailable, @JsonKey(name: 'viewer_role') required this.viewerRole, required  List<Participant> participants, required  List<AgendaItem> agenda, required this.notes, @JsonKey(name: 'deleted_at') this.deletedAt}): _departments = departments,_participants = participants,_agenda = agenda;
  factory _MeetingDetail.fromJson(Map<String, dynamic> json) => _$MeetingDetailFromJson(json);

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

/// Aktif ya da kapanmakta olan konferans; yoksa null. Dış oda adı taşınmaz.
@override final  Conference? conference;
/// Bağlı video sağlayıcısı oda açabiliyor mu (`none` iken false). İstemci başlat düğmesini buna göre gösterir.
@override@JsonKey(name: 'conference_available') final  bool conferenceAvailable;
@override@JsonKey(name: 'viewer_role') final  MeetingDetailViewerRole viewerRole;
 final  List<Participant> _participants;
@override List<Participant> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

 final  List<AgendaItem> _agenda;
@override List<AgendaItem> get agenda {
  if (_agenda is EqualUnmodifiableListView) return _agenda;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_agenda);
}

@override final  MeetingNoteList notes;
@override@JsonKey(name: 'deleted_at') final  DateTime? deletedAt;

/// Create a copy of MeetingDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingDetailCopyWith<_MeetingDetail> get copyWith => __$MeetingDetailCopyWithImpl<_MeetingDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetingDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingDetail&&(identical(other.meetingId, meetingId) || other.meetingId == meetingId)&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.ownerDepartmentId, ownerDepartmentId) || other.ownerDepartmentId == ownerDepartmentId)&&(identical(other.title, title) || other.title == title)&&(identical(other.meetingDate, meetingDate) || other.meetingDate == meetingDate)&&(identical(other.membersIncluded, membersIncluded) || other.membersIncluded == membersIncluded)&&(identical(other.createdByAccountId, createdByAccountId) || other.createdByAccountId == createdByAccountId)&&(identical(other.createdByRole, createdByRole) || other.createdByRole == createdByRole)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.departments, _departments)&&(identical(other.conference, conference) || other.conference == conference)&&(identical(other.conferenceAvailable, conferenceAvailable) || other.conferenceAvailable == conferenceAvailable)&&(identical(other.viewerRole, viewerRole) || other.viewerRole == viewerRole)&&const DeepCollectionEquality().equals(other.participants, _participants)&&const DeepCollectionEquality().equals(other.agenda, _agenda)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,meetingId,programId,ownerDepartmentId,title,meetingDate,membersIncluded,createdByAccountId,createdByRole,createdAt,updatedAt,const DeepCollectionEquality().hash(_departments),conference,conferenceAvailable,viewerRole,const DeepCollectionEquality().hash(_participants),const DeepCollectionEquality().hash(_agenda),notes,deletedAt);
}

@override
String toString() {
    return 'MeetingDetail(meetingId: $meetingId, programId: $programId, ownerDepartmentId: $ownerDepartmentId, title: $title, meetingDate: $meetingDate, membersIncluded: $membersIncluded, createdByAccountId: $createdByAccountId, createdByRole: $createdByRole, createdAt: $createdAt, updatedAt: $updatedAt, departments: $departments, conference: $conference, conferenceAvailable: $conferenceAvailable, viewerRole: $viewerRole, participants: $participants, agenda: $agenda, notes: $notes, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$MeetingDetailCopyWith<$Res> implements $MeetingDetailCopyWith<$Res> {
  factory _$MeetingDetailCopyWith(_MeetingDetail value, $Res Function(_MeetingDetail) _then) = __$MeetingDetailCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'meeting_id') String meetingId,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'owner_department_id') String ownerDepartmentId, String title,@JsonKey(name: 'meeting_date') DateTime meetingDate,@JsonKey(name: 'members_included') bool membersIncluded,@JsonKey(name: 'created_by_account_id') String createdByAccountId,@JsonKey(name: 'created_by_role') MeetingCreatedByRole createdByRole,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt, List<MeetingDepartment> departments, Conference? conference,@JsonKey(name: 'conference_available') bool conferenceAvailable,@JsonKey(name: 'viewer_role') MeetingDetailViewerRole viewerRole, List<Participant> participants, List<AgendaItem> agenda, MeetingNoteList notes,@JsonKey(name: 'deleted_at') DateTime? deletedAt
});


@override $ConferenceCopyWith<$Res>? get conference;@override $MeetingNoteListCopyWith<$Res> get notes;

}
/// @nodoc
class __$MeetingDetailCopyWithImpl<$Res>
    implements _$MeetingDetailCopyWith<$Res> {
  __$MeetingDetailCopyWithImpl(this._self, this._then);

  final _MeetingDetail _self;
  final $Res Function(_MeetingDetail) _then;

/// Create a copy of MeetingDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meetingId = null,Object? programId = null,Object? ownerDepartmentId = null,Object? title = null,Object? meetingDate = null,Object? membersIncluded = null,Object? createdByAccountId = null,Object? createdByRole = null,Object? createdAt = null,Object? updatedAt = null,Object? departments = null,Object? conference = freezed,Object? conferenceAvailable = null,Object? viewerRole = null,Object? participants = null,Object? agenda = null,Object? notes = null,Object? deletedAt = freezed,}) {
  return _then(_MeetingDetail(
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
as List<MeetingDepartment>,conference: freezed == conference ? _self.conference : conference // ignore: cast_nullable_to_non_nullable
as Conference?,conferenceAvailable: null == conferenceAvailable ? _self.conferenceAvailable : conferenceAvailable // ignore: cast_nullable_to_non_nullable
as bool,viewerRole: null == viewerRole ? _self.viewerRole : viewerRole // ignore: cast_nullable_to_non_nullable
as MeetingDetailViewerRole,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<Participant>,agenda: null == agenda ? _self._agenda : agenda // ignore: cast_nullable_to_non_nullable
as List<AgendaItem>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as MeetingNoteList,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of MeetingDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConferenceCopyWith<$Res>? get conference {
    if (_self.conference == null) {
    return null;
  }

  return $ConferenceCopyWith<$Res>(_self.conference!, (value) {
    return _then(_self.copyWith(conference: value));
  });
}/// Create a copy of MeetingDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingNoteListCopyWith<$Res> get notes {
  
  return $MeetingNoteListCopyWith<$Res>(_self.notes, (value) {
    return _then(_self.copyWith(notes: value));
  });
}
}

// dart format on
