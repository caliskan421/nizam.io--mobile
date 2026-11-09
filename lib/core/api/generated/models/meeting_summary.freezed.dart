// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeetingSummary {

@JsonKey(name: 'agenda_total') int get agendaTotal;@JsonKey(name: 'agenda_checked') int get agendaChecked;/// Not sayısı (silinen not kalıcı silinir ve sayılmaz).
@JsonKey(name: 'note_count') int get noteCount;/// Detaydaki `conference.connected.count` ile aynı (COLLABORATION-K78); `none`/`ended` iken 0.
@JsonKey(name: 'connected_count') int get connectedCount;@JsonKey(name: 'participant_count') int get participantCount;@JsonKey(name: 'conference_status') MeetingSummaryConferenceStatus get conferenceStatus;@JsonKey(name: 'conference_started_at') DateTime? get conferenceStartedAt;/// `starting`/`live` iken null; `ending`/`ended` iken kapanma isteğinin ya da sistem kapanışının anı.
@JsonKey(name: 'conference_ended_at') DateTime? get conferenceEndedAt;
/// Create a copy of MeetingSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingSummaryCopyWith<MeetingSummary> get copyWith => _$MeetingSummaryCopyWithImpl<MeetingSummary>(this as MeetingSummary, _$identity);

  /// Serializes this MeetingSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeetingSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingSummary&&(identical(other.agendaTotal, _this.agendaTotal) || other.agendaTotal == _this.agendaTotal)&&(identical(other.agendaChecked, _this.agendaChecked) || other.agendaChecked == _this.agendaChecked)&&(identical(other.noteCount, _this.noteCount) || other.noteCount == _this.noteCount)&&(identical(other.connectedCount, _this.connectedCount) || other.connectedCount == _this.connectedCount)&&(identical(other.participantCount, _this.participantCount) || other.participantCount == _this.participantCount)&&(identical(other.conferenceStatus, _this.conferenceStatus) || other.conferenceStatus == _this.conferenceStatus)&&(identical(other.conferenceStartedAt, _this.conferenceStartedAt) || other.conferenceStartedAt == _this.conferenceStartedAt)&&(identical(other.conferenceEndedAt, _this.conferenceEndedAt) || other.conferenceEndedAt == _this.conferenceEndedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeetingSummary;
  return Object.hash(runtimeType,_this.agendaTotal,_this.agendaChecked,_this.noteCount,_this.connectedCount,_this.participantCount,_this.conferenceStatus,_this.conferenceStartedAt,_this.conferenceEndedAt);
}

@override
String toString() {
  final _this = this as MeetingSummary;
  return 'MeetingSummary(agendaTotal: ${_this.agendaTotal}, agendaChecked: ${_this.agendaChecked}, noteCount: ${_this.noteCount}, connectedCount: ${_this.connectedCount}, participantCount: ${_this.participantCount}, conferenceStatus: ${_this.conferenceStatus}, conferenceStartedAt: ${_this.conferenceStartedAt}, conferenceEndedAt: ${_this.conferenceEndedAt})';
}


}

/// @nodoc
abstract mixin class $MeetingSummaryCopyWith<$Res>  {
  factory $MeetingSummaryCopyWith(MeetingSummary value, $Res Function(MeetingSummary) _then) = _$MeetingSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'agenda_total') int agendaTotal,@JsonKey(name: 'agenda_checked') int agendaChecked,@JsonKey(name: 'note_count') int noteCount,@JsonKey(name: 'connected_count') int connectedCount,@JsonKey(name: 'participant_count') int participantCount,@JsonKey(name: 'conference_status') MeetingSummaryConferenceStatus conferenceStatus,@JsonKey(name: 'conference_started_at') DateTime? conferenceStartedAt,@JsonKey(name: 'conference_ended_at') DateTime? conferenceEndedAt
});




}
/// @nodoc
class _$MeetingSummaryCopyWithImpl<$Res>
    implements $MeetingSummaryCopyWith<$Res> {
  _$MeetingSummaryCopyWithImpl(this._self, this._then);

  final MeetingSummary _self;
  final $Res Function(MeetingSummary) _then;

/// Create a copy of MeetingSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? agendaTotal = null,Object? agendaChecked = null,Object? noteCount = null,Object? connectedCount = null,Object? participantCount = null,Object? conferenceStatus = null,Object? conferenceStartedAt = freezed,Object? conferenceEndedAt = freezed,}) {
  return _then(MeetingSummary(
agendaTotal: null == agendaTotal ? _self.agendaTotal : agendaTotal // ignore: cast_nullable_to_non_nullable
as int,agendaChecked: null == agendaChecked ? _self.agendaChecked : agendaChecked // ignore: cast_nullable_to_non_nullable
as int,noteCount: null == noteCount ? _self.noteCount : noteCount // ignore: cast_nullable_to_non_nullable
as int,connectedCount: null == connectedCount ? _self.connectedCount : connectedCount // ignore: cast_nullable_to_non_nullable
as int,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,conferenceStatus: null == conferenceStatus ? _self.conferenceStatus : conferenceStatus // ignore: cast_nullable_to_non_nullable
as MeetingSummaryConferenceStatus,conferenceStartedAt: freezed == conferenceStartedAt ? _self.conferenceStartedAt : conferenceStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,conferenceEndedAt: freezed == conferenceEndedAt ? _self.conferenceEndedAt : conferenceEndedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MeetingSummary].
extension MeetingSummaryPatterns on MeetingSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetingSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetingSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetingSummary value)  $default,){
final _that = this;
switch (_that) {
case _MeetingSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetingSummary value)?  $default,){
final _that = this;
switch (_that) {
case _MeetingSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'agenda_total')  int agendaTotal, @JsonKey(name: 'agenda_checked')  int agendaChecked, @JsonKey(name: 'note_count')  int noteCount, @JsonKey(name: 'connected_count')  int connectedCount, @JsonKey(name: 'participant_count')  int participantCount, @JsonKey(name: 'conference_status')  MeetingSummaryConferenceStatus conferenceStatus, @JsonKey(name: 'conference_started_at')  DateTime? conferenceStartedAt, @JsonKey(name: 'conference_ended_at')  DateTime? conferenceEndedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingSummary() when $default != null:
return $default(_that.agendaTotal,_that.agendaChecked,_that.noteCount,_that.connectedCount,_that.participantCount,_that.conferenceStatus,_that.conferenceStartedAt,_that.conferenceEndedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'agenda_total')  int agendaTotal, @JsonKey(name: 'agenda_checked')  int agendaChecked, @JsonKey(name: 'note_count')  int noteCount, @JsonKey(name: 'connected_count')  int connectedCount, @JsonKey(name: 'participant_count')  int participantCount, @JsonKey(name: 'conference_status')  MeetingSummaryConferenceStatus conferenceStatus, @JsonKey(name: 'conference_started_at')  DateTime? conferenceStartedAt, @JsonKey(name: 'conference_ended_at')  DateTime? conferenceEndedAt)  $default,) {final _that = this;
switch (_that) {
case _MeetingSummary():
return $default(_that.agendaTotal,_that.agendaChecked,_that.noteCount,_that.connectedCount,_that.participantCount,_that.conferenceStatus,_that.conferenceStartedAt,_that.conferenceEndedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'agenda_total')  int agendaTotal, @JsonKey(name: 'agenda_checked')  int agendaChecked, @JsonKey(name: 'note_count')  int noteCount, @JsonKey(name: 'connected_count')  int connectedCount, @JsonKey(name: 'participant_count')  int participantCount, @JsonKey(name: 'conference_status')  MeetingSummaryConferenceStatus conferenceStatus, @JsonKey(name: 'conference_started_at')  DateTime? conferenceStartedAt, @JsonKey(name: 'conference_ended_at')  DateTime? conferenceEndedAt)?  $default,) {final _that = this;
switch (_that) {
case _MeetingSummary() when $default != null:
return $default(_that.agendaTotal,_that.agendaChecked,_that.noteCount,_that.connectedCount,_that.participantCount,_that.conferenceStatus,_that.conferenceStartedAt,_that.conferenceEndedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetingSummary implements MeetingSummary {
  const _MeetingSummary({@JsonKey(name: 'agenda_total') required this.agendaTotal, @JsonKey(name: 'agenda_checked') required this.agendaChecked, @JsonKey(name: 'note_count') required this.noteCount, @JsonKey(name: 'connected_count') required this.connectedCount, @JsonKey(name: 'participant_count') required this.participantCount, @JsonKey(name: 'conference_status') required this.conferenceStatus, @JsonKey(name: 'conference_started_at') required this.conferenceStartedAt, @JsonKey(name: 'conference_ended_at') required this.conferenceEndedAt});
  factory _MeetingSummary.fromJson(Map<String, dynamic> json) => _$MeetingSummaryFromJson(json);

@override@JsonKey(name: 'agenda_total') final  int agendaTotal;
@override@JsonKey(name: 'agenda_checked') final  int agendaChecked;
/// Not sayısı (silinen not kalıcı silinir ve sayılmaz).
@override@JsonKey(name: 'note_count') final  int noteCount;
/// Detaydaki `conference.connected.count` ile aynı (COLLABORATION-K78); `none`/`ended` iken 0.
@override@JsonKey(name: 'connected_count') final  int connectedCount;
@override@JsonKey(name: 'participant_count') final  int participantCount;
@override@JsonKey(name: 'conference_status') final  MeetingSummaryConferenceStatus conferenceStatus;
@override@JsonKey(name: 'conference_started_at') final  DateTime? conferenceStartedAt;
/// `starting`/`live` iken null; `ending`/`ended` iken kapanma isteğinin ya da sistem kapanışının anı.
@override@JsonKey(name: 'conference_ended_at') final  DateTime? conferenceEndedAt;

/// Create a copy of MeetingSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingSummaryCopyWith<_MeetingSummary> get copyWith => __$MeetingSummaryCopyWithImpl<_MeetingSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetingSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingSummary&&(identical(other.agendaTotal, agendaTotal) || other.agendaTotal == agendaTotal)&&(identical(other.agendaChecked, agendaChecked) || other.agendaChecked == agendaChecked)&&(identical(other.noteCount, noteCount) || other.noteCount == noteCount)&&(identical(other.connectedCount, connectedCount) || other.connectedCount == connectedCount)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&(identical(other.conferenceStatus, conferenceStatus) || other.conferenceStatus == conferenceStatus)&&(identical(other.conferenceStartedAt, conferenceStartedAt) || other.conferenceStartedAt == conferenceStartedAt)&&(identical(other.conferenceEndedAt, conferenceEndedAt) || other.conferenceEndedAt == conferenceEndedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,agendaTotal,agendaChecked,noteCount,connectedCount,participantCount,conferenceStatus,conferenceStartedAt,conferenceEndedAt);
}

@override
String toString() {
    return 'MeetingSummary(agendaTotal: $agendaTotal, agendaChecked: $agendaChecked, noteCount: $noteCount, connectedCount: $connectedCount, participantCount: $participantCount, conferenceStatus: $conferenceStatus, conferenceStartedAt: $conferenceStartedAt, conferenceEndedAt: $conferenceEndedAt)';
}


}

/// @nodoc
abstract mixin class _$MeetingSummaryCopyWith<$Res> implements $MeetingSummaryCopyWith<$Res> {
  factory _$MeetingSummaryCopyWith(_MeetingSummary value, $Res Function(_MeetingSummary) _then) = __$MeetingSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'agenda_total') int agendaTotal,@JsonKey(name: 'agenda_checked') int agendaChecked,@JsonKey(name: 'note_count') int noteCount,@JsonKey(name: 'connected_count') int connectedCount,@JsonKey(name: 'participant_count') int participantCount,@JsonKey(name: 'conference_status') MeetingSummaryConferenceStatus conferenceStatus,@JsonKey(name: 'conference_started_at') DateTime? conferenceStartedAt,@JsonKey(name: 'conference_ended_at') DateTime? conferenceEndedAt
});




}
/// @nodoc
class __$MeetingSummaryCopyWithImpl<$Res>
    implements _$MeetingSummaryCopyWith<$Res> {
  __$MeetingSummaryCopyWithImpl(this._self, this._then);

  final _MeetingSummary _self;
  final $Res Function(_MeetingSummary) _then;

/// Create a copy of MeetingSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? agendaTotal = null,Object? agendaChecked = null,Object? noteCount = null,Object? connectedCount = null,Object? participantCount = null,Object? conferenceStatus = null,Object? conferenceStartedAt = freezed,Object? conferenceEndedAt = freezed,}) {
  return _then(_MeetingSummary(
agendaTotal: null == agendaTotal ? _self.agendaTotal : agendaTotal // ignore: cast_nullable_to_non_nullable
as int,agendaChecked: null == agendaChecked ? _self.agendaChecked : agendaChecked // ignore: cast_nullable_to_non_nullable
as int,noteCount: null == noteCount ? _self.noteCount : noteCount // ignore: cast_nullable_to_non_nullable
as int,connectedCount: null == connectedCount ? _self.connectedCount : connectedCount // ignore: cast_nullable_to_non_nullable
as int,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,conferenceStatus: null == conferenceStatus ? _self.conferenceStatus : conferenceStatus // ignore: cast_nullable_to_non_nullable
as MeetingSummaryConferenceStatus,conferenceStartedAt: freezed == conferenceStartedAt ? _self.conferenceStartedAt : conferenceStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,conferenceEndedAt: freezed == conferenceEndedAt ? _self.conferenceEndedAt : conferenceEndedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
