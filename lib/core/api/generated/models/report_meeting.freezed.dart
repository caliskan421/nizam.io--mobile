// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_meeting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportMeeting {

@JsonKey(name: 'meeting_id') String get meetingId; String get title;@JsonKey(name: 'meeting_date') DateTime get meetingDate;@JsonKey(name: 'owner_department_id') String get ownerDepartmentId; List<ReportMeetingDepartment> get coordinatorships;@JsonKey(name: 'created_by') ReportPerson get createdBy;@JsonKey(name: 'created_by_role') ReportMeetingCreatedByRole get createdByRole;@JsonKey(name: 'members_included') bool get membersIncluded; List<ReportPerson> get participants;@JsonKey(name: 'participant_count') int get participantCount;@JsonKey(name: 'note_count') int get noteCount;
/// Create a copy of ReportMeeting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportMeetingCopyWith<ReportMeeting> get copyWith => _$ReportMeetingCopyWithImpl<ReportMeeting>(this as ReportMeeting, _$identity);

  /// Serializes this ReportMeeting to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportMeeting;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportMeeting&&(identical(other.meetingId, _this.meetingId) || other.meetingId == _this.meetingId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.meetingDate, _this.meetingDate) || other.meetingDate == _this.meetingDate)&&(identical(other.ownerDepartmentId, _this.ownerDepartmentId) || other.ownerDepartmentId == _this.ownerDepartmentId)&&const DeepCollectionEquality().equals(other.coordinatorships, _this.coordinatorships)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.createdByRole, _this.createdByRole) || other.createdByRole == _this.createdByRole)&&(identical(other.membersIncluded, _this.membersIncluded) || other.membersIncluded == _this.membersIncluded)&&const DeepCollectionEquality().equals(other.participants, _this.participants)&&(identical(other.participantCount, _this.participantCount) || other.participantCount == _this.participantCount)&&(identical(other.noteCount, _this.noteCount) || other.noteCount == _this.noteCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportMeeting;
  return Object.hash(runtimeType,_this.meetingId,_this.title,_this.meetingDate,_this.ownerDepartmentId,const DeepCollectionEquality().hash(_this.coordinatorships),_this.createdBy,_this.createdByRole,_this.membersIncluded,const DeepCollectionEquality().hash(_this.participants),_this.participantCount,_this.noteCount);
}

@override
String toString() {
  final _this = this as ReportMeeting;
  return 'ReportMeeting(meetingId: ${_this.meetingId}, title: ${_this.title}, meetingDate: ${_this.meetingDate}, ownerDepartmentId: ${_this.ownerDepartmentId}, coordinatorships: ${_this.coordinatorships}, createdBy: ${_this.createdBy}, createdByRole: ${_this.createdByRole}, membersIncluded: ${_this.membersIncluded}, participants: ${_this.participants}, participantCount: ${_this.participantCount}, noteCount: ${_this.noteCount})';
}


}

/// @nodoc
abstract mixin class $ReportMeetingCopyWith<$Res>  {
  factory $ReportMeetingCopyWith(ReportMeeting value, $Res Function(ReportMeeting) _then) = _$ReportMeetingCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'meeting_id') String meetingId, String title,@JsonKey(name: 'meeting_date') DateTime meetingDate,@JsonKey(name: 'owner_department_id') String ownerDepartmentId, List<ReportMeetingDepartment> coordinatorships,@JsonKey(name: 'created_by') ReportPerson createdBy,@JsonKey(name: 'created_by_role') ReportMeetingCreatedByRole createdByRole,@JsonKey(name: 'members_included') bool membersIncluded, List<ReportPerson> participants,@JsonKey(name: 'participant_count') int participantCount,@JsonKey(name: 'note_count') int noteCount
});


$ReportPersonCopyWith<$Res> get createdBy;

}
/// @nodoc
class _$ReportMeetingCopyWithImpl<$Res>
    implements $ReportMeetingCopyWith<$Res> {
  _$ReportMeetingCopyWithImpl(this._self, this._then);

  final ReportMeeting _self;
  final $Res Function(ReportMeeting) _then;

/// Create a copy of ReportMeeting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meetingId = null,Object? title = null,Object? meetingDate = null,Object? ownerDepartmentId = null,Object? coordinatorships = null,Object? createdBy = null,Object? createdByRole = null,Object? membersIncluded = null,Object? participants = null,Object? participantCount = null,Object? noteCount = null,}) {
  return _then(ReportMeeting(
meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,meetingDate: null == meetingDate ? _self.meetingDate : meetingDate // ignore: cast_nullable_to_non_nullable
as DateTime,ownerDepartmentId: null == ownerDepartmentId ? _self.ownerDepartmentId : ownerDepartmentId // ignore: cast_nullable_to_non_nullable
as String,coordinatorships: null == coordinatorships ? _self.coordinatorships : coordinatorships // ignore: cast_nullable_to_non_nullable
as List<ReportMeetingDepartment>,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as ReportPerson,createdByRole: null == createdByRole ? _self.createdByRole : createdByRole // ignore: cast_nullable_to_non_nullable
as ReportMeetingCreatedByRole,membersIncluded: null == membersIncluded ? _self.membersIncluded : membersIncluded // ignore: cast_nullable_to_non_nullable
as bool,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<ReportPerson>,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,noteCount: null == noteCount ? _self.noteCount : noteCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ReportMeeting
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportPersonCopyWith<$Res> get createdBy {
  
  return $ReportPersonCopyWith<$Res>(_self.createdBy, (value) {
    return _then(_self.copyWith(createdBy: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReportMeeting].
extension ReportMeetingPatterns on ReportMeeting {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportMeeting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportMeeting() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportMeeting value)  $default,){
final _that = this;
switch (_that) {
case _ReportMeeting():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportMeeting value)?  $default,){
final _that = this;
switch (_that) {
case _ReportMeeting() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'meeting_id')  String meetingId,  String title, @JsonKey(name: 'meeting_date')  DateTime meetingDate, @JsonKey(name: 'owner_department_id')  String ownerDepartmentId,  List<ReportMeetingDepartment> coordinatorships, @JsonKey(name: 'created_by')  ReportPerson createdBy, @JsonKey(name: 'created_by_role')  ReportMeetingCreatedByRole createdByRole, @JsonKey(name: 'members_included')  bool membersIncluded,  List<ReportPerson> participants, @JsonKey(name: 'participant_count')  int participantCount, @JsonKey(name: 'note_count')  int noteCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportMeeting() when $default != null:
return $default(_that.meetingId,_that.title,_that.meetingDate,_that.ownerDepartmentId,_that.coordinatorships,_that.createdBy,_that.createdByRole,_that.membersIncluded,_that.participants,_that.participantCount,_that.noteCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'meeting_id')  String meetingId,  String title, @JsonKey(name: 'meeting_date')  DateTime meetingDate, @JsonKey(name: 'owner_department_id')  String ownerDepartmentId,  List<ReportMeetingDepartment> coordinatorships, @JsonKey(name: 'created_by')  ReportPerson createdBy, @JsonKey(name: 'created_by_role')  ReportMeetingCreatedByRole createdByRole, @JsonKey(name: 'members_included')  bool membersIncluded,  List<ReportPerson> participants, @JsonKey(name: 'participant_count')  int participantCount, @JsonKey(name: 'note_count')  int noteCount)  $default,) {final _that = this;
switch (_that) {
case _ReportMeeting():
return $default(_that.meetingId,_that.title,_that.meetingDate,_that.ownerDepartmentId,_that.coordinatorships,_that.createdBy,_that.createdByRole,_that.membersIncluded,_that.participants,_that.participantCount,_that.noteCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'meeting_id')  String meetingId,  String title, @JsonKey(name: 'meeting_date')  DateTime meetingDate, @JsonKey(name: 'owner_department_id')  String ownerDepartmentId,  List<ReportMeetingDepartment> coordinatorships, @JsonKey(name: 'created_by')  ReportPerson createdBy, @JsonKey(name: 'created_by_role')  ReportMeetingCreatedByRole createdByRole, @JsonKey(name: 'members_included')  bool membersIncluded,  List<ReportPerson> participants, @JsonKey(name: 'participant_count')  int participantCount, @JsonKey(name: 'note_count')  int noteCount)?  $default,) {final _that = this;
switch (_that) {
case _ReportMeeting() when $default != null:
return $default(_that.meetingId,_that.title,_that.meetingDate,_that.ownerDepartmentId,_that.coordinatorships,_that.createdBy,_that.createdByRole,_that.membersIncluded,_that.participants,_that.participantCount,_that.noteCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportMeeting implements ReportMeeting {
  const _ReportMeeting({@JsonKey(name: 'meeting_id') required this.meetingId, required this.title, @JsonKey(name: 'meeting_date') required this.meetingDate, @JsonKey(name: 'owner_department_id') required this.ownerDepartmentId, required  List<ReportMeetingDepartment> coordinatorships, @JsonKey(name: 'created_by') required this.createdBy, @JsonKey(name: 'created_by_role') required this.createdByRole, @JsonKey(name: 'members_included') required this.membersIncluded, required  List<ReportPerson> participants, @JsonKey(name: 'participant_count') required this.participantCount, @JsonKey(name: 'note_count') required this.noteCount}): _coordinatorships = coordinatorships,_participants = participants;
  factory _ReportMeeting.fromJson(Map<String, dynamic> json) => _$ReportMeetingFromJson(json);

@override@JsonKey(name: 'meeting_id') final  String meetingId;
@override final  String title;
@override@JsonKey(name: 'meeting_date') final  DateTime meetingDate;
@override@JsonKey(name: 'owner_department_id') final  String ownerDepartmentId;
 final  List<ReportMeetingDepartment> _coordinatorships;
@override List<ReportMeetingDepartment> get coordinatorships {
  if (_coordinatorships is EqualUnmodifiableListView) return _coordinatorships;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coordinatorships);
}

@override@JsonKey(name: 'created_by') final  ReportPerson createdBy;
@override@JsonKey(name: 'created_by_role') final  ReportMeetingCreatedByRole createdByRole;
@override@JsonKey(name: 'members_included') final  bool membersIncluded;
 final  List<ReportPerson> _participants;
@override List<ReportPerson> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

@override@JsonKey(name: 'participant_count') final  int participantCount;
@override@JsonKey(name: 'note_count') final  int noteCount;

/// Create a copy of ReportMeeting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportMeetingCopyWith<_ReportMeeting> get copyWith => __$ReportMeetingCopyWithImpl<_ReportMeeting>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportMeetingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportMeeting&&(identical(other.meetingId, meetingId) || other.meetingId == meetingId)&&(identical(other.title, title) || other.title == title)&&(identical(other.meetingDate, meetingDate) || other.meetingDate == meetingDate)&&(identical(other.ownerDepartmentId, ownerDepartmentId) || other.ownerDepartmentId == ownerDepartmentId)&&const DeepCollectionEquality().equals(other.coordinatorships, _coordinatorships)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdByRole, createdByRole) || other.createdByRole == createdByRole)&&(identical(other.membersIncluded, membersIncluded) || other.membersIncluded == membersIncluded)&&const DeepCollectionEquality().equals(other.participants, _participants)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&(identical(other.noteCount, noteCount) || other.noteCount == noteCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,meetingId,title,meetingDate,ownerDepartmentId,const DeepCollectionEquality().hash(_coordinatorships),createdBy,createdByRole,membersIncluded,const DeepCollectionEquality().hash(_participants),participantCount,noteCount);
}

@override
String toString() {
    return 'ReportMeeting(meetingId: $meetingId, title: $title, meetingDate: $meetingDate, ownerDepartmentId: $ownerDepartmentId, coordinatorships: $coordinatorships, createdBy: $createdBy, createdByRole: $createdByRole, membersIncluded: $membersIncluded, participants: $participants, participantCount: $participantCount, noteCount: $noteCount)';
}


}

/// @nodoc
abstract mixin class _$ReportMeetingCopyWith<$Res> implements $ReportMeetingCopyWith<$Res> {
  factory _$ReportMeetingCopyWith(_ReportMeeting value, $Res Function(_ReportMeeting) _then) = __$ReportMeetingCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'meeting_id') String meetingId, String title,@JsonKey(name: 'meeting_date') DateTime meetingDate,@JsonKey(name: 'owner_department_id') String ownerDepartmentId, List<ReportMeetingDepartment> coordinatorships,@JsonKey(name: 'created_by') ReportPerson createdBy,@JsonKey(name: 'created_by_role') ReportMeetingCreatedByRole createdByRole,@JsonKey(name: 'members_included') bool membersIncluded, List<ReportPerson> participants,@JsonKey(name: 'participant_count') int participantCount,@JsonKey(name: 'note_count') int noteCount
});


@override $ReportPersonCopyWith<$Res> get createdBy;

}
/// @nodoc
class __$ReportMeetingCopyWithImpl<$Res>
    implements _$ReportMeetingCopyWith<$Res> {
  __$ReportMeetingCopyWithImpl(this._self, this._then);

  final _ReportMeeting _self;
  final $Res Function(_ReportMeeting) _then;

/// Create a copy of ReportMeeting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meetingId = null,Object? title = null,Object? meetingDate = null,Object? ownerDepartmentId = null,Object? coordinatorships = null,Object? createdBy = null,Object? createdByRole = null,Object? membersIncluded = null,Object? participants = null,Object? participantCount = null,Object? noteCount = null,}) {
  return _then(_ReportMeeting(
meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,meetingDate: null == meetingDate ? _self.meetingDate : meetingDate // ignore: cast_nullable_to_non_nullable
as DateTime,ownerDepartmentId: null == ownerDepartmentId ? _self.ownerDepartmentId : ownerDepartmentId // ignore: cast_nullable_to_non_nullable
as String,coordinatorships: null == coordinatorships ? _self._coordinatorships : coordinatorships // ignore: cast_nullable_to_non_nullable
as List<ReportMeetingDepartment>,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as ReportPerson,createdByRole: null == createdByRole ? _self.createdByRole : createdByRole // ignore: cast_nullable_to_non_nullable
as ReportMeetingCreatedByRole,membersIncluded: null == membersIncluded ? _self.membersIncluded : membersIncluded // ignore: cast_nullable_to_non_nullable
as bool,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<ReportPerson>,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,noteCount: null == noteCount ? _self.noteCount : noteCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ReportMeeting
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportPersonCopyWith<$Res> get createdBy {
  
  return $ReportPersonCopyWith<$Res>(_self.createdBy, (value) {
    return _then(_self.copyWith(createdBy: value));
  });
}
}

// dart format on
