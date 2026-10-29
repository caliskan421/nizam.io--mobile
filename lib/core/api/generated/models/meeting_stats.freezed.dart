// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeetingStats {

@JsonKey(name: 'total_meetings') int get totalMeetings;@JsonKey(name: 'total_notes') int get totalNotes;@JsonKey(name: 'converted_to_task') int get convertedToTask;@JsonKey(name: 'total_participants') int get totalParticipants;
/// Create a copy of MeetingStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingStatsCopyWith<MeetingStats> get copyWith => _$MeetingStatsCopyWithImpl<MeetingStats>(this as MeetingStats, _$identity);

  /// Serializes this MeetingStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeetingStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingStats&&(identical(other.totalMeetings, _this.totalMeetings) || other.totalMeetings == _this.totalMeetings)&&(identical(other.totalNotes, _this.totalNotes) || other.totalNotes == _this.totalNotes)&&(identical(other.convertedToTask, _this.convertedToTask) || other.convertedToTask == _this.convertedToTask)&&(identical(other.totalParticipants, _this.totalParticipants) || other.totalParticipants == _this.totalParticipants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeetingStats;
  return Object.hash(runtimeType,_this.totalMeetings,_this.totalNotes,_this.convertedToTask,_this.totalParticipants);
}

@override
String toString() {
  final _this = this as MeetingStats;
  return 'MeetingStats(totalMeetings: ${_this.totalMeetings}, totalNotes: ${_this.totalNotes}, convertedToTask: ${_this.convertedToTask}, totalParticipants: ${_this.totalParticipants})';
}


}

/// @nodoc
abstract mixin class $MeetingStatsCopyWith<$Res>  {
  factory $MeetingStatsCopyWith(MeetingStats value, $Res Function(MeetingStats) _then) = _$MeetingStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_meetings') int totalMeetings,@JsonKey(name: 'total_notes') int totalNotes,@JsonKey(name: 'converted_to_task') int convertedToTask,@JsonKey(name: 'total_participants') int totalParticipants
});




}
/// @nodoc
class _$MeetingStatsCopyWithImpl<$Res>
    implements $MeetingStatsCopyWith<$Res> {
  _$MeetingStatsCopyWithImpl(this._self, this._then);

  final MeetingStats _self;
  final $Res Function(MeetingStats) _then;

/// Create a copy of MeetingStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalMeetings = null,Object? totalNotes = null,Object? convertedToTask = null,Object? totalParticipants = null,}) {
  return _then(MeetingStats(
totalMeetings: null == totalMeetings ? _self.totalMeetings : totalMeetings // ignore: cast_nullable_to_non_nullable
as int,totalNotes: null == totalNotes ? _self.totalNotes : totalNotes // ignore: cast_nullable_to_non_nullable
as int,convertedToTask: null == convertedToTask ? _self.convertedToTask : convertedToTask // ignore: cast_nullable_to_non_nullable
as int,totalParticipants: null == totalParticipants ? _self.totalParticipants : totalParticipants // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MeetingStats].
extension MeetingStatsPatterns on MeetingStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetingStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetingStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetingStats value)  $default,){
final _that = this;
switch (_that) {
case _MeetingStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetingStats value)?  $default,){
final _that = this;
switch (_that) {
case _MeetingStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_meetings')  int totalMeetings, @JsonKey(name: 'total_notes')  int totalNotes, @JsonKey(name: 'converted_to_task')  int convertedToTask, @JsonKey(name: 'total_participants')  int totalParticipants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingStats() when $default != null:
return $default(_that.totalMeetings,_that.totalNotes,_that.convertedToTask,_that.totalParticipants);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_meetings')  int totalMeetings, @JsonKey(name: 'total_notes')  int totalNotes, @JsonKey(name: 'converted_to_task')  int convertedToTask, @JsonKey(name: 'total_participants')  int totalParticipants)  $default,) {final _that = this;
switch (_that) {
case _MeetingStats():
return $default(_that.totalMeetings,_that.totalNotes,_that.convertedToTask,_that.totalParticipants);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_meetings')  int totalMeetings, @JsonKey(name: 'total_notes')  int totalNotes, @JsonKey(name: 'converted_to_task')  int convertedToTask, @JsonKey(name: 'total_participants')  int totalParticipants)?  $default,) {final _that = this;
switch (_that) {
case _MeetingStats() when $default != null:
return $default(_that.totalMeetings,_that.totalNotes,_that.convertedToTask,_that.totalParticipants);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetingStats implements MeetingStats {
  const _MeetingStats({@JsonKey(name: 'total_meetings') required this.totalMeetings, @JsonKey(name: 'total_notes') required this.totalNotes, @JsonKey(name: 'converted_to_task') required this.convertedToTask, @JsonKey(name: 'total_participants') required this.totalParticipants});
  factory _MeetingStats.fromJson(Map<String, dynamic> json) => _$MeetingStatsFromJson(json);

@override@JsonKey(name: 'total_meetings') final  int totalMeetings;
@override@JsonKey(name: 'total_notes') final  int totalNotes;
@override@JsonKey(name: 'converted_to_task') final  int convertedToTask;
@override@JsonKey(name: 'total_participants') final  int totalParticipants;

/// Create a copy of MeetingStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingStatsCopyWith<_MeetingStats> get copyWith => __$MeetingStatsCopyWithImpl<_MeetingStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetingStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingStats&&(identical(other.totalMeetings, totalMeetings) || other.totalMeetings == totalMeetings)&&(identical(other.totalNotes, totalNotes) || other.totalNotes == totalNotes)&&(identical(other.convertedToTask, convertedToTask) || other.convertedToTask == convertedToTask)&&(identical(other.totalParticipants, totalParticipants) || other.totalParticipants == totalParticipants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalMeetings,totalNotes,convertedToTask,totalParticipants);
}

@override
String toString() {
    return 'MeetingStats(totalMeetings: $totalMeetings, totalNotes: $totalNotes, convertedToTask: $convertedToTask, totalParticipants: $totalParticipants)';
}


}

/// @nodoc
abstract mixin class _$MeetingStatsCopyWith<$Res> implements $MeetingStatsCopyWith<$Res> {
  factory _$MeetingStatsCopyWith(_MeetingStats value, $Res Function(_MeetingStats) _then) = __$MeetingStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_meetings') int totalMeetings,@JsonKey(name: 'total_notes') int totalNotes,@JsonKey(name: 'converted_to_task') int convertedToTask,@JsonKey(name: 'total_participants') int totalParticipants
});




}
/// @nodoc
class __$MeetingStatsCopyWithImpl<$Res>
    implements _$MeetingStatsCopyWith<$Res> {
  __$MeetingStatsCopyWithImpl(this._self, this._then);

  final _MeetingStats _self;
  final $Res Function(_MeetingStats) _then;

/// Create a copy of MeetingStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalMeetings = null,Object? totalNotes = null,Object? convertedToTask = null,Object? totalParticipants = null,}) {
  return _then(_MeetingStats(
totalMeetings: null == totalMeetings ? _self.totalMeetings : totalMeetings // ignore: cast_nullable_to_non_nullable
as int,totalNotes: null == totalNotes ? _self.totalNotes : totalNotes // ignore: cast_nullable_to_non_nullable
as int,convertedToTask: null == convertedToTask ? _self.convertedToTask : convertedToTask // ignore: cast_nullable_to_non_nullable
as int,totalParticipants: null == totalParticipants ? _self.totalParticipants : totalParticipants // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
