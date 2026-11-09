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

@JsonKey(name: 'meeting_id') String get meetingId;@JsonKey(name: 'program_id') String get programId;@JsonKey(name: 'owner_department_id') String get ownerDepartmentId; String get title;@JsonKey(name: 'meeting_date') DateTime get meetingDate;/// Toplantı yeri (düz metin, en çok 200 karakter); belirtilmemişse null (COLLABORATION-K76).
 String? get place;@JsonKey(name: 'members_included') bool get membersIncluded;/// Davet kipi (COLLABORATION-K73, K74). `coordinatorship`: bağlı departmanların koordinatörleri ve `members_included` ise üyeleri erişir. `person`: departman bağı erişim vermez; yönetici ve sahip departmanı hâlâ koordine eden oluşturan yönetir (koordinatörlüğü düşen oluşturan katılımcıysa üye düzeyindedir, değilse toplantıyı görmez). İki kipte de katılımcı üye düzeyinde görür. Kuruluşta seçilir, değişmez.
@JsonKey(name: 'invite_mode') MeetingInviteMode get inviteMode;@JsonKey(name: 'created_by_account_id') String get createdByAccountId;@JsonKey(name: 'created_by_role') MeetingCreatedByRole get createdByRole;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt; List<MeetingDepartment> get departments;/// Aktif ya da kapanmakta olan konferans; yoksa null. Dış oda adı taşınmaz.
 Conference? get conference;/// En yeni biten konferans (COLLABORATION-K70); yoksa null. `conference` ile ikisi de null ise toplantıda hiç konferans açılmamıştır. Süreyi istemci `ended_at − started_at` olarak hesaplar; boş oda 5 dk sonra kapandığından sistem kapanışında (`provider_finished`, `reconciled_missing`) süre bu payı içerir.
@JsonKey(name: 'last_conference') LastConference? get lastConference;/// Bağlı video sağlayıcısı oda açabiliyor mu (`none` iken false). İstemci başlat düğmesini buna göre gösterir.
@JsonKey(name: 'conference_available') bool get conferenceAvailable;/// Çağıranın erişimi (COLLABORATION-K74): `coordinator` yönetimdir (`person` kipinde sahip departmanı hâlâ koordine eden oluşturan); `member` salt okuma ve not (katılımcı ve koordinatörlüğü düşmüş katılımcı oluşturan dahil).
@JsonKey(name: 'viewer_role') MeetingDetailViewerRole get viewerRole; List<Participant> get participants; List<AgendaItem> get agenda; MeetingNoteList get notes;@JsonKey(name: 'deleted_at') DateTime? get deletedAt;/// Yalnız silinenler listelerinde (`GET /v1/meetings/deleted`, `GET /v1/admin/deleted/meetings`) vardır ve orada her zaman bulunur: toplantıyı yumuşak silen hesap ve adı (COLLABORATION-K77). Silen bilinmiyorsa (alan eklenmeden önce silinmiş toplantı) null.
@JsonKey(name: 'deleted_by') MeetingDeletedBy? get deletedBy;/// Yalnız `GET /v1/meetings` satırlarında vardır ve orada her zaman doludur (COLLABORATION-K70); kuruluş, güncelleme, detay ve silinenler listesi taşımaz.
 MeetingSummary? get summary;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingDetail&&(identical(other.meetingId, _this.meetingId) || other.meetingId == _this.meetingId)&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.ownerDepartmentId, _this.ownerDepartmentId) || other.ownerDepartmentId == _this.ownerDepartmentId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.meetingDate, _this.meetingDate) || other.meetingDate == _this.meetingDate)&&(identical(other.place, _this.place) || other.place == _this.place)&&(identical(other.membersIncluded, _this.membersIncluded) || other.membersIncluded == _this.membersIncluded)&&(identical(other.inviteMode, _this.inviteMode) || other.inviteMode == _this.inviteMode)&&(identical(other.createdByAccountId, _this.createdByAccountId) || other.createdByAccountId == _this.createdByAccountId)&&(identical(other.createdByRole, _this.createdByRole) || other.createdByRole == _this.createdByRole)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&const DeepCollectionEquality().equals(other.departments, _this.departments)&&(identical(other.conference, _this.conference) || other.conference == _this.conference)&&(identical(other.lastConference, _this.lastConference) || other.lastConference == _this.lastConference)&&(identical(other.conferenceAvailable, _this.conferenceAvailable) || other.conferenceAvailable == _this.conferenceAvailable)&&(identical(other.viewerRole, _this.viewerRole) || other.viewerRole == _this.viewerRole)&&const DeepCollectionEquality().equals(other.participants, _this.participants)&&const DeepCollectionEquality().equals(other.agenda, _this.agenda)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.deletedBy, _this.deletedBy) || other.deletedBy == _this.deletedBy)&&(identical(other.summary, _this.summary) || other.summary == _this.summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeetingDetail;
  return Object.hashAll([runtimeType,_this.meetingId,_this.programId,_this.ownerDepartmentId,_this.title,_this.meetingDate,_this.place,_this.membersIncluded,_this.inviteMode,_this.createdByAccountId,_this.createdByRole,_this.createdAt,_this.updatedAt,const DeepCollectionEquality().hash(_this.departments),_this.conference,_this.lastConference,_this.conferenceAvailable,_this.viewerRole,const DeepCollectionEquality().hash(_this.participants),const DeepCollectionEquality().hash(_this.agenda),_this.notes,_this.deletedAt,_this.deletedBy,_this.summary]);
}

@override
String toString() {
  final _this = this as MeetingDetail;
  return 'MeetingDetail(meetingId: ${_this.meetingId}, programId: ${_this.programId}, ownerDepartmentId: ${_this.ownerDepartmentId}, title: ${_this.title}, meetingDate: ${_this.meetingDate}, place: ${_this.place}, membersIncluded: ${_this.membersIncluded}, inviteMode: ${_this.inviteMode}, createdByAccountId: ${_this.createdByAccountId}, createdByRole: ${_this.createdByRole}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, departments: ${_this.departments}, conference: ${_this.conference}, lastConference: ${_this.lastConference}, conferenceAvailable: ${_this.conferenceAvailable}, viewerRole: ${_this.viewerRole}, participants: ${_this.participants}, agenda: ${_this.agenda}, notes: ${_this.notes}, deletedAt: ${_this.deletedAt}, deletedBy: ${_this.deletedBy}, summary: ${_this.summary})';
}


}

/// @nodoc
abstract mixin class $MeetingDetailCopyWith<$Res>  {
  factory $MeetingDetailCopyWith(MeetingDetail value, $Res Function(MeetingDetail) _then) = _$MeetingDetailCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'meeting_id') String meetingId,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'owner_department_id') String ownerDepartmentId, String title,@JsonKey(name: 'meeting_date') DateTime meetingDate, String? place,@JsonKey(name: 'members_included') bool membersIncluded,@JsonKey(name: 'invite_mode') MeetingInviteMode inviteMode,@JsonKey(name: 'created_by_account_id') String createdByAccountId,@JsonKey(name: 'created_by_role') MeetingCreatedByRole createdByRole,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt, List<MeetingDepartment> departments, Conference? conference,@JsonKey(name: 'last_conference') LastConference? lastConference,@JsonKey(name: 'conference_available') bool conferenceAvailable,@JsonKey(name: 'viewer_role') MeetingDetailViewerRole viewerRole, List<Participant> participants, List<AgendaItem> agenda, MeetingNoteList notes,@JsonKey(name: 'deleted_at') DateTime? deletedAt,@JsonKey(name: 'deleted_by') MeetingDeletedBy? deletedBy, MeetingSummary? summary
});


$ConferenceCopyWith<$Res>? get conference;$LastConferenceCopyWith<$Res>? get lastConference;$MeetingNoteListCopyWith<$Res> get notes;$MeetingDeletedByCopyWith<$Res>? get deletedBy;$MeetingSummaryCopyWith<$Res>? get summary;

}
/// @nodoc
class _$MeetingDetailCopyWithImpl<$Res>
    implements $MeetingDetailCopyWith<$Res> {
  _$MeetingDetailCopyWithImpl(this._self, this._then);

  final MeetingDetail _self;
  final $Res Function(MeetingDetail) _then;

/// Create a copy of MeetingDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meetingId = null,Object? programId = null,Object? ownerDepartmentId = null,Object? title = null,Object? meetingDate = null,Object? place = freezed,Object? membersIncluded = null,Object? inviteMode = null,Object? createdByAccountId = null,Object? createdByRole = null,Object? createdAt = null,Object? updatedAt = null,Object? departments = null,Object? conference = freezed,Object? lastConference = freezed,Object? conferenceAvailable = null,Object? viewerRole = null,Object? participants = null,Object? agenda = null,Object? notes = null,Object? deletedAt = freezed,Object? deletedBy = freezed,Object? summary = freezed,}) {
  return _then(MeetingDetail(
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
as List<MeetingDepartment>,conference: freezed == conference ? _self.conference : conference // ignore: cast_nullable_to_non_nullable
as Conference?,lastConference: freezed == lastConference ? _self.lastConference : lastConference // ignore: cast_nullable_to_non_nullable
as LastConference?,conferenceAvailable: null == conferenceAvailable ? _self.conferenceAvailable : conferenceAvailable // ignore: cast_nullable_to_non_nullable
as bool,viewerRole: null == viewerRole ? _self.viewerRole : viewerRole // ignore: cast_nullable_to_non_nullable
as MeetingDetailViewerRole,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<Participant>,agenda: null == agenda ? _self.agenda : agenda // ignore: cast_nullable_to_non_nullable
as List<AgendaItem>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as MeetingNoteList,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedBy: freezed == deletedBy ? _self.deletedBy : deletedBy // ignore: cast_nullable_to_non_nullable
as MeetingDeletedBy?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as MeetingSummary?,
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
$LastConferenceCopyWith<$Res>? get lastConference {
    if (_self.lastConference == null) {
    return null;
  }

  return $LastConferenceCopyWith<$Res>(_self.lastConference!, (value) {
    return _then(_self.copyWith(lastConference: value));
  });
}/// Create a copy of MeetingDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingNoteListCopyWith<$Res> get notes {
  
  return $MeetingNoteListCopyWith<$Res>(_self.notes, (value) {
    return _then(_self.copyWith(notes: value));
  });
}/// Create a copy of MeetingDetail
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
}/// Create a copy of MeetingDetail
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'meeting_id')  String meetingId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'owner_department_id')  String ownerDepartmentId,  String title, @JsonKey(name: 'meeting_date')  DateTime meetingDate,  String? place, @JsonKey(name: 'members_included')  bool membersIncluded, @JsonKey(name: 'invite_mode')  MeetingInviteMode inviteMode, @JsonKey(name: 'created_by_account_id')  String createdByAccountId, @JsonKey(name: 'created_by_role')  MeetingCreatedByRole createdByRole, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt,  List<MeetingDepartment> departments,  Conference? conference, @JsonKey(name: 'last_conference')  LastConference? lastConference, @JsonKey(name: 'conference_available')  bool conferenceAvailable, @JsonKey(name: 'viewer_role')  MeetingDetailViewerRole viewerRole,  List<Participant> participants,  List<AgendaItem> agenda,  MeetingNoteList notes, @JsonKey(name: 'deleted_at')  DateTime? deletedAt, @JsonKey(name: 'deleted_by')  MeetingDeletedBy? deletedBy,  MeetingSummary? summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingDetail() when $default != null:
return $default(_that.meetingId,_that.programId,_that.ownerDepartmentId,_that.title,_that.meetingDate,_that.place,_that.membersIncluded,_that.inviteMode,_that.createdByAccountId,_that.createdByRole,_that.createdAt,_that.updatedAt,_that.departments,_that.conference,_that.lastConference,_that.conferenceAvailable,_that.viewerRole,_that.participants,_that.agenda,_that.notes,_that.deletedAt,_that.deletedBy,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'meeting_id')  String meetingId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'owner_department_id')  String ownerDepartmentId,  String title, @JsonKey(name: 'meeting_date')  DateTime meetingDate,  String? place, @JsonKey(name: 'members_included')  bool membersIncluded, @JsonKey(name: 'invite_mode')  MeetingInviteMode inviteMode, @JsonKey(name: 'created_by_account_id')  String createdByAccountId, @JsonKey(name: 'created_by_role')  MeetingCreatedByRole createdByRole, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt,  List<MeetingDepartment> departments,  Conference? conference, @JsonKey(name: 'last_conference')  LastConference? lastConference, @JsonKey(name: 'conference_available')  bool conferenceAvailable, @JsonKey(name: 'viewer_role')  MeetingDetailViewerRole viewerRole,  List<Participant> participants,  List<AgendaItem> agenda,  MeetingNoteList notes, @JsonKey(name: 'deleted_at')  DateTime? deletedAt, @JsonKey(name: 'deleted_by')  MeetingDeletedBy? deletedBy,  MeetingSummary? summary)  $default,) {final _that = this;
switch (_that) {
case _MeetingDetail():
return $default(_that.meetingId,_that.programId,_that.ownerDepartmentId,_that.title,_that.meetingDate,_that.place,_that.membersIncluded,_that.inviteMode,_that.createdByAccountId,_that.createdByRole,_that.createdAt,_that.updatedAt,_that.departments,_that.conference,_that.lastConference,_that.conferenceAvailable,_that.viewerRole,_that.participants,_that.agenda,_that.notes,_that.deletedAt,_that.deletedBy,_that.summary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'meeting_id')  String meetingId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'owner_department_id')  String ownerDepartmentId,  String title, @JsonKey(name: 'meeting_date')  DateTime meetingDate,  String? place, @JsonKey(name: 'members_included')  bool membersIncluded, @JsonKey(name: 'invite_mode')  MeetingInviteMode inviteMode, @JsonKey(name: 'created_by_account_id')  String createdByAccountId, @JsonKey(name: 'created_by_role')  MeetingCreatedByRole createdByRole, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt,  List<MeetingDepartment> departments,  Conference? conference, @JsonKey(name: 'last_conference')  LastConference? lastConference, @JsonKey(name: 'conference_available')  bool conferenceAvailable, @JsonKey(name: 'viewer_role')  MeetingDetailViewerRole viewerRole,  List<Participant> participants,  List<AgendaItem> agenda,  MeetingNoteList notes, @JsonKey(name: 'deleted_at')  DateTime? deletedAt, @JsonKey(name: 'deleted_by')  MeetingDeletedBy? deletedBy,  MeetingSummary? summary)?  $default,) {final _that = this;
switch (_that) {
case _MeetingDetail() when $default != null:
return $default(_that.meetingId,_that.programId,_that.ownerDepartmentId,_that.title,_that.meetingDate,_that.place,_that.membersIncluded,_that.inviteMode,_that.createdByAccountId,_that.createdByRole,_that.createdAt,_that.updatedAt,_that.departments,_that.conference,_that.lastConference,_that.conferenceAvailable,_that.viewerRole,_that.participants,_that.agenda,_that.notes,_that.deletedAt,_that.deletedBy,_that.summary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetingDetail implements MeetingDetail {
  const _MeetingDetail({@JsonKey(name: 'meeting_id') required this.meetingId, @JsonKey(name: 'program_id') required this.programId, @JsonKey(name: 'owner_department_id') required this.ownerDepartmentId, required this.title, @JsonKey(name: 'meeting_date') required this.meetingDate, required this.place, @JsonKey(name: 'members_included') required this.membersIncluded, @JsonKey(name: 'invite_mode') required this.inviteMode, @JsonKey(name: 'created_by_account_id') required this.createdByAccountId, @JsonKey(name: 'created_by_role') required this.createdByRole, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, required  List<MeetingDepartment> departments, required this.conference, @JsonKey(name: 'last_conference') required this.lastConference, @JsonKey(name: 'conference_available') required this.conferenceAvailable, @JsonKey(name: 'viewer_role') required this.viewerRole, required  List<Participant> participants, required  List<AgendaItem> agenda, required this.notes, @JsonKey(name: 'deleted_at') this.deletedAt, @JsonKey(name: 'deleted_by') this.deletedBy, this.summary}): _departments = departments,_participants = participants,_agenda = agenda;
  factory _MeetingDetail.fromJson(Map<String, dynamic> json) => _$MeetingDetailFromJson(json);

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

/// Aktif ya da kapanmakta olan konferans; yoksa null. Dış oda adı taşınmaz.
@override final  Conference? conference;
/// En yeni biten konferans (COLLABORATION-K70); yoksa null. `conference` ile ikisi de null ise toplantıda hiç konferans açılmamıştır. Süreyi istemci `ended_at − started_at` olarak hesaplar; boş oda 5 dk sonra kapandığından sistem kapanışında (`provider_finished`, `reconciled_missing`) süre bu payı içerir.
@override@JsonKey(name: 'last_conference') final  LastConference? lastConference;
/// Bağlı video sağlayıcısı oda açabiliyor mu (`none` iken false). İstemci başlat düğmesini buna göre gösterir.
@override@JsonKey(name: 'conference_available') final  bool conferenceAvailable;
/// Çağıranın erişimi (COLLABORATION-K74): `coordinator` yönetimdir (`person` kipinde sahip departmanı hâlâ koordine eden oluşturan); `member` salt okuma ve not (katılımcı ve koordinatörlüğü düşmüş katılımcı oluşturan dahil).
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
/// Yalnız silinenler listelerinde (`GET /v1/meetings/deleted`, `GET /v1/admin/deleted/meetings`) vardır ve orada her zaman bulunur: toplantıyı yumuşak silen hesap ve adı (COLLABORATION-K77). Silen bilinmiyorsa (alan eklenmeden önce silinmiş toplantı) null.
@override@JsonKey(name: 'deleted_by') final  MeetingDeletedBy? deletedBy;
/// Yalnız `GET /v1/meetings` satırlarında vardır ve orada her zaman doludur (COLLABORATION-K70); kuruluş, güncelleme, detay ve silinenler listesi taşımaz.
@override final  MeetingSummary? summary;

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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingDetail&&(identical(other.meetingId, meetingId) || other.meetingId == meetingId)&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.ownerDepartmentId, ownerDepartmentId) || other.ownerDepartmentId == ownerDepartmentId)&&(identical(other.title, title) || other.title == title)&&(identical(other.meetingDate, meetingDate) || other.meetingDate == meetingDate)&&(identical(other.place, place) || other.place == place)&&(identical(other.membersIncluded, membersIncluded) || other.membersIncluded == membersIncluded)&&(identical(other.inviteMode, inviteMode) || other.inviteMode == inviteMode)&&(identical(other.createdByAccountId, createdByAccountId) || other.createdByAccountId == createdByAccountId)&&(identical(other.createdByRole, createdByRole) || other.createdByRole == createdByRole)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.departments, _departments)&&(identical(other.conference, conference) || other.conference == conference)&&(identical(other.lastConference, lastConference) || other.lastConference == lastConference)&&(identical(other.conferenceAvailable, conferenceAvailable) || other.conferenceAvailable == conferenceAvailable)&&(identical(other.viewerRole, viewerRole) || other.viewerRole == viewerRole)&&const DeepCollectionEquality().equals(other.participants, _participants)&&const DeepCollectionEquality().equals(other.agenda, _agenda)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.deletedBy, deletedBy) || other.deletedBy == deletedBy)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,meetingId,programId,ownerDepartmentId,title,meetingDate,place,membersIncluded,inviteMode,createdByAccountId,createdByRole,createdAt,updatedAt,const DeepCollectionEquality().hash(_departments),conference,lastConference,conferenceAvailable,viewerRole,const DeepCollectionEquality().hash(_participants),const DeepCollectionEquality().hash(_agenda),notes,deletedAt,deletedBy,summary]);
}

@override
String toString() {
    return 'MeetingDetail(meetingId: $meetingId, programId: $programId, ownerDepartmentId: $ownerDepartmentId, title: $title, meetingDate: $meetingDate, place: $place, membersIncluded: $membersIncluded, inviteMode: $inviteMode, createdByAccountId: $createdByAccountId, createdByRole: $createdByRole, createdAt: $createdAt, updatedAt: $updatedAt, departments: $departments, conference: $conference, lastConference: $lastConference, conferenceAvailable: $conferenceAvailable, viewerRole: $viewerRole, participants: $participants, agenda: $agenda, notes: $notes, deletedAt: $deletedAt, deletedBy: $deletedBy, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$MeetingDetailCopyWith<$Res> implements $MeetingDetailCopyWith<$Res> {
  factory _$MeetingDetailCopyWith(_MeetingDetail value, $Res Function(_MeetingDetail) _then) = __$MeetingDetailCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'meeting_id') String meetingId,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'owner_department_id') String ownerDepartmentId, String title,@JsonKey(name: 'meeting_date') DateTime meetingDate, String? place,@JsonKey(name: 'members_included') bool membersIncluded,@JsonKey(name: 'invite_mode') MeetingInviteMode inviteMode,@JsonKey(name: 'created_by_account_id') String createdByAccountId,@JsonKey(name: 'created_by_role') MeetingCreatedByRole createdByRole,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt, List<MeetingDepartment> departments, Conference? conference,@JsonKey(name: 'last_conference') LastConference? lastConference,@JsonKey(name: 'conference_available') bool conferenceAvailable,@JsonKey(name: 'viewer_role') MeetingDetailViewerRole viewerRole, List<Participant> participants, List<AgendaItem> agenda, MeetingNoteList notes,@JsonKey(name: 'deleted_at') DateTime? deletedAt,@JsonKey(name: 'deleted_by') MeetingDeletedBy? deletedBy, MeetingSummary? summary
});


@override $ConferenceCopyWith<$Res>? get conference;@override $LastConferenceCopyWith<$Res>? get lastConference;@override $MeetingNoteListCopyWith<$Res> get notes;@override $MeetingDeletedByCopyWith<$Res>? get deletedBy;@override $MeetingSummaryCopyWith<$Res>? get summary;

}
/// @nodoc
class __$MeetingDetailCopyWithImpl<$Res>
    implements _$MeetingDetailCopyWith<$Res> {
  __$MeetingDetailCopyWithImpl(this._self, this._then);

  final _MeetingDetail _self;
  final $Res Function(_MeetingDetail) _then;

/// Create a copy of MeetingDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meetingId = null,Object? programId = null,Object? ownerDepartmentId = null,Object? title = null,Object? meetingDate = null,Object? place = freezed,Object? membersIncluded = null,Object? inviteMode = null,Object? createdByAccountId = null,Object? createdByRole = null,Object? createdAt = null,Object? updatedAt = null,Object? departments = null,Object? conference = freezed,Object? lastConference = freezed,Object? conferenceAvailable = null,Object? viewerRole = null,Object? participants = null,Object? agenda = null,Object? notes = null,Object? deletedAt = freezed,Object? deletedBy = freezed,Object? summary = freezed,}) {
  return _then(_MeetingDetail(
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
as List<MeetingDepartment>,conference: freezed == conference ? _self.conference : conference // ignore: cast_nullable_to_non_nullable
as Conference?,lastConference: freezed == lastConference ? _self.lastConference : lastConference // ignore: cast_nullable_to_non_nullable
as LastConference?,conferenceAvailable: null == conferenceAvailable ? _self.conferenceAvailable : conferenceAvailable // ignore: cast_nullable_to_non_nullable
as bool,viewerRole: null == viewerRole ? _self.viewerRole : viewerRole // ignore: cast_nullable_to_non_nullable
as MeetingDetailViewerRole,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<Participant>,agenda: null == agenda ? _self._agenda : agenda // ignore: cast_nullable_to_non_nullable
as List<AgendaItem>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as MeetingNoteList,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedBy: freezed == deletedBy ? _self.deletedBy : deletedBy // ignore: cast_nullable_to_non_nullable
as MeetingDeletedBy?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as MeetingSummary?,
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
$LastConferenceCopyWith<$Res>? get lastConference {
    if (_self.lastConference == null) {
    return null;
  }

  return $LastConferenceCopyWith<$Res>(_self.lastConference!, (value) {
    return _then(_self.copyWith(lastConference: value));
  });
}/// Create a copy of MeetingDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingNoteListCopyWith<$Res> get notes {
  
  return $MeetingNoteListCopyWith<$Res>(_self.notes, (value) {
    return _then(_self.copyWith(notes: value));
  });
}/// Create a copy of MeetingDetail
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
}/// Create a copy of MeetingDetail
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
