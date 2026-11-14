// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_candidate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeetingCandidate {

@JsonKey(name: 'account_id') String get accountId;@JsonKey(name: 'full_name') String get fullName; List<ParticipantTeam> get teams;/// Hesap `meeting_id` toplantısının katılımcısı mı; `meeting_id` yoksa her zaman false.
@JsonKey(name: 'is_participant') bool get isParticipant;
/// Create a copy of MeetingCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingCandidateCopyWith<MeetingCandidate> get copyWith => _$MeetingCandidateCopyWithImpl<MeetingCandidate>(this as MeetingCandidate, _$identity);

  /// Serializes this MeetingCandidate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeetingCandidate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingCandidate&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&const DeepCollectionEquality().equals(other.teams, _this.teams)&&(identical(other.isParticipant, _this.isParticipant) || other.isParticipant == _this.isParticipant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeetingCandidate;
  return Object.hash(runtimeType,_this.accountId,_this.fullName,const DeepCollectionEquality().hash(_this.teams),_this.isParticipant);
}

@override
String toString() {
  final _this = this as MeetingCandidate;
  return 'MeetingCandidate(accountId: ${_this.accountId}, fullName: ${_this.fullName}, teams: ${_this.teams}, isParticipant: ${_this.isParticipant})';
}


}

/// @nodoc
abstract mixin class $MeetingCandidateCopyWith<$Res>  {
  factory $MeetingCandidateCopyWith(MeetingCandidate value, $Res Function(MeetingCandidate) _then) = _$MeetingCandidateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName, List<ParticipantTeam> teams,@JsonKey(name: 'is_participant') bool isParticipant
});




}
/// @nodoc
class _$MeetingCandidateCopyWithImpl<$Res>
    implements $MeetingCandidateCopyWith<$Res> {
  _$MeetingCandidateCopyWithImpl(this._self, this._then);

  final MeetingCandidate _self;
  final $Res Function(MeetingCandidate) _then;

/// Create a copy of MeetingCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? fullName = null,Object? teams = null,Object? isParticipant = null,}) {
  return _then(MeetingCandidate(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,teams: null == teams ? _self.teams : teams // ignore: cast_nullable_to_non_nullable
as List<ParticipantTeam>,isParticipant: null == isParticipant ? _self.isParticipant : isParticipant // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MeetingCandidate].
extension MeetingCandidatePatterns on MeetingCandidate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetingCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetingCandidate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetingCandidate value)  $default,){
final _that = this;
switch (_that) {
case _MeetingCandidate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetingCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _MeetingCandidate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  List<ParticipantTeam> teams, @JsonKey(name: 'is_participant')  bool isParticipant)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingCandidate() when $default != null:
return $default(_that.accountId,_that.fullName,_that.teams,_that.isParticipant);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  List<ParticipantTeam> teams, @JsonKey(name: 'is_participant')  bool isParticipant)  $default,) {final _that = this;
switch (_that) {
case _MeetingCandidate():
return $default(_that.accountId,_that.fullName,_that.teams,_that.isParticipant);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  List<ParticipantTeam> teams, @JsonKey(name: 'is_participant')  bool isParticipant)?  $default,) {final _that = this;
switch (_that) {
case _MeetingCandidate() when $default != null:
return $default(_that.accountId,_that.fullName,_that.teams,_that.isParticipant);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetingCandidate implements MeetingCandidate {
  const _MeetingCandidate({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'full_name') required this.fullName, required  List<ParticipantTeam> teams, @JsonKey(name: 'is_participant') required this.isParticipant}): _teams = teams;
  factory _MeetingCandidate.fromJson(Map<String, dynamic> json) => _$MeetingCandidateFromJson(json);

@override@JsonKey(name: 'account_id') final  String accountId;
@override@JsonKey(name: 'full_name') final  String fullName;
 final  List<ParticipantTeam> _teams;
@override List<ParticipantTeam> get teams {
  if (_teams is EqualUnmodifiableListView) return _teams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_teams);
}

/// Hesap `meeting_id` toplantısının katılımcısı mı; `meeting_id` yoksa her zaman false.
@override@JsonKey(name: 'is_participant') final  bool isParticipant;

/// Create a copy of MeetingCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingCandidateCopyWith<_MeetingCandidate> get copyWith => __$MeetingCandidateCopyWithImpl<_MeetingCandidate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetingCandidateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingCandidate&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&const DeepCollectionEquality().equals(other.teams, _teams)&&(identical(other.isParticipant, isParticipant) || other.isParticipant == isParticipant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountId,fullName,const DeepCollectionEquality().hash(_teams),isParticipant);
}

@override
String toString() {
    return 'MeetingCandidate(accountId: $accountId, fullName: $fullName, teams: $teams, isParticipant: $isParticipant)';
}


}

/// @nodoc
abstract mixin class _$MeetingCandidateCopyWith<$Res> implements $MeetingCandidateCopyWith<$Res> {
  factory _$MeetingCandidateCopyWith(_MeetingCandidate value, $Res Function(_MeetingCandidate) _then) = __$MeetingCandidateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName, List<ParticipantTeam> teams,@JsonKey(name: 'is_participant') bool isParticipant
});




}
/// @nodoc
class __$MeetingCandidateCopyWithImpl<$Res>
    implements _$MeetingCandidateCopyWith<$Res> {
  __$MeetingCandidateCopyWithImpl(this._self, this._then);

  final _MeetingCandidate _self;
  final $Res Function(_MeetingCandidate) _then;

/// Create a copy of MeetingCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? fullName = null,Object? teams = null,Object? isParticipant = null,}) {
  return _then(_MeetingCandidate(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,teams: null == teams ? _self._teams : teams // ignore: cast_nullable_to_non_nullable
as List<ParticipantTeam>,isParticipant: null == isParticipant ? _self.isParticipant : isParticipant // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
