// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_meeting_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportMeetingDetail {

 ReportMeeting get meeting; List<ReportParticipant> get participants; List<ReportAgendaItem> get agenda; List<ReportMeetingNote> get notes;
/// Create a copy of ReportMeetingDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportMeetingDetailCopyWith<ReportMeetingDetail> get copyWith => _$ReportMeetingDetailCopyWithImpl<ReportMeetingDetail>(this as ReportMeetingDetail, _$identity);

  /// Serializes this ReportMeetingDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportMeetingDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportMeetingDetail&&(identical(other.meeting, _this.meeting) || other.meeting == _this.meeting)&&const DeepCollectionEquality().equals(other.participants, _this.participants)&&const DeepCollectionEquality().equals(other.agenda, _this.agenda)&&const DeepCollectionEquality().equals(other.notes, _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportMeetingDetail;
  return Object.hash(runtimeType,_this.meeting,const DeepCollectionEquality().hash(_this.participants),const DeepCollectionEquality().hash(_this.agenda),const DeepCollectionEquality().hash(_this.notes));
}

@override
String toString() {
  final _this = this as ReportMeetingDetail;
  return 'ReportMeetingDetail(meeting: ${_this.meeting}, participants: ${_this.participants}, agenda: ${_this.agenda}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $ReportMeetingDetailCopyWith<$Res>  {
  factory $ReportMeetingDetailCopyWith(ReportMeetingDetail value, $Res Function(ReportMeetingDetail) _then) = _$ReportMeetingDetailCopyWithImpl;
@useResult
$Res call({
 ReportMeeting meeting, List<ReportParticipant> participants, List<ReportAgendaItem> agenda, List<ReportMeetingNote> notes
});


$ReportMeetingCopyWith<$Res> get meeting;

}
/// @nodoc
class _$ReportMeetingDetailCopyWithImpl<$Res>
    implements $ReportMeetingDetailCopyWith<$Res> {
  _$ReportMeetingDetailCopyWithImpl(this._self, this._then);

  final ReportMeetingDetail _self;
  final $Res Function(ReportMeetingDetail) _then;

/// Create a copy of ReportMeetingDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meeting = null,Object? participants = null,Object? agenda = null,Object? notes = null,}) {
  return _then(ReportMeetingDetail(
meeting: null == meeting ? _self.meeting : meeting // ignore: cast_nullable_to_non_nullable
as ReportMeeting,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<ReportParticipant>,agenda: null == agenda ? _self.agenda : agenda // ignore: cast_nullable_to_non_nullable
as List<ReportAgendaItem>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as List<ReportMeetingNote>,
  ));
}
/// Create a copy of ReportMeetingDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportMeetingCopyWith<$Res> get meeting {
  
  return $ReportMeetingCopyWith<$Res>(_self.meeting, (value) {
    return _then(_self.copyWith(meeting: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReportMeetingDetail].
extension ReportMeetingDetailPatterns on ReportMeetingDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportMeetingDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportMeetingDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportMeetingDetail value)  $default,){
final _that = this;
switch (_that) {
case _ReportMeetingDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportMeetingDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ReportMeetingDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReportMeeting meeting,  List<ReportParticipant> participants,  List<ReportAgendaItem> agenda,  List<ReportMeetingNote> notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportMeetingDetail() when $default != null:
return $default(_that.meeting,_that.participants,_that.agenda,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReportMeeting meeting,  List<ReportParticipant> participants,  List<ReportAgendaItem> agenda,  List<ReportMeetingNote> notes)  $default,) {final _that = this;
switch (_that) {
case _ReportMeetingDetail():
return $default(_that.meeting,_that.participants,_that.agenda,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReportMeeting meeting,  List<ReportParticipant> participants,  List<ReportAgendaItem> agenda,  List<ReportMeetingNote> notes)?  $default,) {final _that = this;
switch (_that) {
case _ReportMeetingDetail() when $default != null:
return $default(_that.meeting,_that.participants,_that.agenda,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportMeetingDetail implements ReportMeetingDetail {
  const _ReportMeetingDetail({required this.meeting, required  List<ReportParticipant> participants, required  List<ReportAgendaItem> agenda, required  List<ReportMeetingNote> notes}): _participants = participants,_agenda = agenda,_notes = notes;
  factory _ReportMeetingDetail.fromJson(Map<String, dynamic> json) => _$ReportMeetingDetailFromJson(json);

@override final  ReportMeeting meeting;
 final  List<ReportParticipant> _participants;
@override List<ReportParticipant> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

 final  List<ReportAgendaItem> _agenda;
@override List<ReportAgendaItem> get agenda {
  if (_agenda is EqualUnmodifiableListView) return _agenda;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_agenda);
}

 final  List<ReportMeetingNote> _notes;
@override List<ReportMeetingNote> get notes {
  if (_notes is EqualUnmodifiableListView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notes);
}


/// Create a copy of ReportMeetingDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportMeetingDetailCopyWith<_ReportMeetingDetail> get copyWith => __$ReportMeetingDetailCopyWithImpl<_ReportMeetingDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportMeetingDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportMeetingDetail&&(identical(other.meeting, meeting) || other.meeting == meeting)&&const DeepCollectionEquality().equals(other.participants, _participants)&&const DeepCollectionEquality().equals(other.agenda, _agenda)&&const DeepCollectionEquality().equals(other.notes, _notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,meeting,const DeepCollectionEquality().hash(_participants),const DeepCollectionEquality().hash(_agenda),const DeepCollectionEquality().hash(_notes));
}

@override
String toString() {
    return 'ReportMeetingDetail(meeting: $meeting, participants: $participants, agenda: $agenda, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$ReportMeetingDetailCopyWith<$Res> implements $ReportMeetingDetailCopyWith<$Res> {
  factory _$ReportMeetingDetailCopyWith(_ReportMeetingDetail value, $Res Function(_ReportMeetingDetail) _then) = __$ReportMeetingDetailCopyWithImpl;
@override @useResult
$Res call({
 ReportMeeting meeting, List<ReportParticipant> participants, List<ReportAgendaItem> agenda, List<ReportMeetingNote> notes
});


@override $ReportMeetingCopyWith<$Res> get meeting;

}
/// @nodoc
class __$ReportMeetingDetailCopyWithImpl<$Res>
    implements _$ReportMeetingDetailCopyWith<$Res> {
  __$ReportMeetingDetailCopyWithImpl(this._self, this._then);

  final _ReportMeetingDetail _self;
  final $Res Function(_ReportMeetingDetail) _then;

/// Create a copy of ReportMeetingDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meeting = null,Object? participants = null,Object? agenda = null,Object? notes = null,}) {
  return _then(_ReportMeetingDetail(
meeting: null == meeting ? _self.meeting : meeting // ignore: cast_nullable_to_non_nullable
as ReportMeeting,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<ReportParticipant>,agenda: null == agenda ? _self._agenda : agenda // ignore: cast_nullable_to_non_nullable
as List<ReportAgendaItem>,notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as List<ReportMeetingNote>,
  ));
}

/// Create a copy of ReportMeetingDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportMeetingCopyWith<$Res> get meeting {
  
  return $ReportMeetingCopyWith<$Res>(_self.meeting, (value) {
    return _then(_self.copyWith(meeting: value));
  });
}
}

// dart format on
