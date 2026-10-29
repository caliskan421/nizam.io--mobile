// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Stats {

@JsonKey(name: 'total_tasks') int get totalTasks;@JsonKey(name: 'completed_tasks') int get completedTasks;@JsonKey(name: 'completion_rate') num get completionRate;@JsonKey(name: 'overdue_tasks') int get overdueTasks;@JsonKey(name: 'total_notes') int get totalNotes;@JsonKey(name: 'total_attachments') int get totalAttachments;@JsonKey(name: 'total_meetings') int get totalMeetings;@JsonKey(name: 'total_messages') int get totalMessages;@JsonKey(name: 'total_coordinatorships') int get totalCoordinatorships;@JsonKey(name: 'total_users') int get totalUsers;@JsonKey(name: 'total_members') int get totalMembers;
/// Create a copy of Stats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatsCopyWith<Stats> get copyWith => _$StatsCopyWithImpl<Stats>(this as Stats, _$identity);

  /// Serializes this Stats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Stats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Stats&&(identical(other.totalTasks, _this.totalTasks) || other.totalTasks == _this.totalTasks)&&(identical(other.completedTasks, _this.completedTasks) || other.completedTasks == _this.completedTasks)&&(identical(other.completionRate, _this.completionRate) || other.completionRate == _this.completionRate)&&(identical(other.overdueTasks, _this.overdueTasks) || other.overdueTasks == _this.overdueTasks)&&(identical(other.totalNotes, _this.totalNotes) || other.totalNotes == _this.totalNotes)&&(identical(other.totalAttachments, _this.totalAttachments) || other.totalAttachments == _this.totalAttachments)&&(identical(other.totalMeetings, _this.totalMeetings) || other.totalMeetings == _this.totalMeetings)&&(identical(other.totalMessages, _this.totalMessages) || other.totalMessages == _this.totalMessages)&&(identical(other.totalCoordinatorships, _this.totalCoordinatorships) || other.totalCoordinatorships == _this.totalCoordinatorships)&&(identical(other.totalUsers, _this.totalUsers) || other.totalUsers == _this.totalUsers)&&(identical(other.totalMembers, _this.totalMembers) || other.totalMembers == _this.totalMembers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Stats;
  return Object.hash(runtimeType,_this.totalTasks,_this.completedTasks,_this.completionRate,_this.overdueTasks,_this.totalNotes,_this.totalAttachments,_this.totalMeetings,_this.totalMessages,_this.totalCoordinatorships,_this.totalUsers,_this.totalMembers);
}

@override
String toString() {
  final _this = this as Stats;
  return 'Stats(totalTasks: ${_this.totalTasks}, completedTasks: ${_this.completedTasks}, completionRate: ${_this.completionRate}, overdueTasks: ${_this.overdueTasks}, totalNotes: ${_this.totalNotes}, totalAttachments: ${_this.totalAttachments}, totalMeetings: ${_this.totalMeetings}, totalMessages: ${_this.totalMessages}, totalCoordinatorships: ${_this.totalCoordinatorships}, totalUsers: ${_this.totalUsers}, totalMembers: ${_this.totalMembers})';
}


}

/// @nodoc
abstract mixin class $StatsCopyWith<$Res>  {
  factory $StatsCopyWith(Stats value, $Res Function(Stats) _then) = _$StatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_tasks') int totalTasks,@JsonKey(name: 'completed_tasks') int completedTasks,@JsonKey(name: 'completion_rate') num completionRate,@JsonKey(name: 'overdue_tasks') int overdueTasks,@JsonKey(name: 'total_notes') int totalNotes,@JsonKey(name: 'total_attachments') int totalAttachments,@JsonKey(name: 'total_meetings') int totalMeetings,@JsonKey(name: 'total_messages') int totalMessages,@JsonKey(name: 'total_coordinatorships') int totalCoordinatorships,@JsonKey(name: 'total_users') int totalUsers,@JsonKey(name: 'total_members') int totalMembers
});




}
/// @nodoc
class _$StatsCopyWithImpl<$Res>
    implements $StatsCopyWith<$Res> {
  _$StatsCopyWithImpl(this._self, this._then);

  final Stats _self;
  final $Res Function(Stats) _then;

/// Create a copy of Stats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalTasks = null,Object? completedTasks = null,Object? completionRate = null,Object? overdueTasks = null,Object? totalNotes = null,Object? totalAttachments = null,Object? totalMeetings = null,Object? totalMessages = null,Object? totalCoordinatorships = null,Object? totalUsers = null,Object? totalMembers = null,}) {
  return _then(Stats(
totalTasks: null == totalTasks ? _self.totalTasks : totalTasks // ignore: cast_nullable_to_non_nullable
as int,completedTasks: null == completedTasks ? _self.completedTasks : completedTasks // ignore: cast_nullable_to_non_nullable
as int,completionRate: null == completionRate ? _self.completionRate : completionRate // ignore: cast_nullable_to_non_nullable
as num,overdueTasks: null == overdueTasks ? _self.overdueTasks : overdueTasks // ignore: cast_nullable_to_non_nullable
as int,totalNotes: null == totalNotes ? _self.totalNotes : totalNotes // ignore: cast_nullable_to_non_nullable
as int,totalAttachments: null == totalAttachments ? _self.totalAttachments : totalAttachments // ignore: cast_nullable_to_non_nullable
as int,totalMeetings: null == totalMeetings ? _self.totalMeetings : totalMeetings // ignore: cast_nullable_to_non_nullable
as int,totalMessages: null == totalMessages ? _self.totalMessages : totalMessages // ignore: cast_nullable_to_non_nullable
as int,totalCoordinatorships: null == totalCoordinatorships ? _self.totalCoordinatorships : totalCoordinatorships // ignore: cast_nullable_to_non_nullable
as int,totalUsers: null == totalUsers ? _self.totalUsers : totalUsers // ignore: cast_nullable_to_non_nullable
as int,totalMembers: null == totalMembers ? _self.totalMembers : totalMembers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Stats].
extension StatsPatterns on Stats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Stats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Stats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Stats value)  $default,){
final _that = this;
switch (_that) {
case _Stats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Stats value)?  $default,){
final _that = this;
switch (_that) {
case _Stats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_tasks')  int totalTasks, @JsonKey(name: 'completed_tasks')  int completedTasks, @JsonKey(name: 'completion_rate')  num completionRate, @JsonKey(name: 'overdue_tasks')  int overdueTasks, @JsonKey(name: 'total_notes')  int totalNotes, @JsonKey(name: 'total_attachments')  int totalAttachments, @JsonKey(name: 'total_meetings')  int totalMeetings, @JsonKey(name: 'total_messages')  int totalMessages, @JsonKey(name: 'total_coordinatorships')  int totalCoordinatorships, @JsonKey(name: 'total_users')  int totalUsers, @JsonKey(name: 'total_members')  int totalMembers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Stats() when $default != null:
return $default(_that.totalTasks,_that.completedTasks,_that.completionRate,_that.overdueTasks,_that.totalNotes,_that.totalAttachments,_that.totalMeetings,_that.totalMessages,_that.totalCoordinatorships,_that.totalUsers,_that.totalMembers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_tasks')  int totalTasks, @JsonKey(name: 'completed_tasks')  int completedTasks, @JsonKey(name: 'completion_rate')  num completionRate, @JsonKey(name: 'overdue_tasks')  int overdueTasks, @JsonKey(name: 'total_notes')  int totalNotes, @JsonKey(name: 'total_attachments')  int totalAttachments, @JsonKey(name: 'total_meetings')  int totalMeetings, @JsonKey(name: 'total_messages')  int totalMessages, @JsonKey(name: 'total_coordinatorships')  int totalCoordinatorships, @JsonKey(name: 'total_users')  int totalUsers, @JsonKey(name: 'total_members')  int totalMembers)  $default,) {final _that = this;
switch (_that) {
case _Stats():
return $default(_that.totalTasks,_that.completedTasks,_that.completionRate,_that.overdueTasks,_that.totalNotes,_that.totalAttachments,_that.totalMeetings,_that.totalMessages,_that.totalCoordinatorships,_that.totalUsers,_that.totalMembers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_tasks')  int totalTasks, @JsonKey(name: 'completed_tasks')  int completedTasks, @JsonKey(name: 'completion_rate')  num completionRate, @JsonKey(name: 'overdue_tasks')  int overdueTasks, @JsonKey(name: 'total_notes')  int totalNotes, @JsonKey(name: 'total_attachments')  int totalAttachments, @JsonKey(name: 'total_meetings')  int totalMeetings, @JsonKey(name: 'total_messages')  int totalMessages, @JsonKey(name: 'total_coordinatorships')  int totalCoordinatorships, @JsonKey(name: 'total_users')  int totalUsers, @JsonKey(name: 'total_members')  int totalMembers)?  $default,) {final _that = this;
switch (_that) {
case _Stats() when $default != null:
return $default(_that.totalTasks,_that.completedTasks,_that.completionRate,_that.overdueTasks,_that.totalNotes,_that.totalAttachments,_that.totalMeetings,_that.totalMessages,_that.totalCoordinatorships,_that.totalUsers,_that.totalMembers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Stats implements Stats {
  const _Stats({@JsonKey(name: 'total_tasks') required this.totalTasks, @JsonKey(name: 'completed_tasks') required this.completedTasks, @JsonKey(name: 'completion_rate') required this.completionRate, @JsonKey(name: 'overdue_tasks') required this.overdueTasks, @JsonKey(name: 'total_notes') required this.totalNotes, @JsonKey(name: 'total_attachments') required this.totalAttachments, @JsonKey(name: 'total_meetings') required this.totalMeetings, @JsonKey(name: 'total_messages') required this.totalMessages, @JsonKey(name: 'total_coordinatorships') required this.totalCoordinatorships, @JsonKey(name: 'total_users') required this.totalUsers, @JsonKey(name: 'total_members') required this.totalMembers});
  factory _Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);

@override@JsonKey(name: 'total_tasks') final  int totalTasks;
@override@JsonKey(name: 'completed_tasks') final  int completedTasks;
@override@JsonKey(name: 'completion_rate') final  num completionRate;
@override@JsonKey(name: 'overdue_tasks') final  int overdueTasks;
@override@JsonKey(name: 'total_notes') final  int totalNotes;
@override@JsonKey(name: 'total_attachments') final  int totalAttachments;
@override@JsonKey(name: 'total_meetings') final  int totalMeetings;
@override@JsonKey(name: 'total_messages') final  int totalMessages;
@override@JsonKey(name: 'total_coordinatorships') final  int totalCoordinatorships;
@override@JsonKey(name: 'total_users') final  int totalUsers;
@override@JsonKey(name: 'total_members') final  int totalMembers;

/// Create a copy of Stats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatsCopyWith<_Stats> get copyWith => __$StatsCopyWithImpl<_Stats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Stats&&(identical(other.totalTasks, totalTasks) || other.totalTasks == totalTasks)&&(identical(other.completedTasks, completedTasks) || other.completedTasks == completedTasks)&&(identical(other.completionRate, completionRate) || other.completionRate == completionRate)&&(identical(other.overdueTasks, overdueTasks) || other.overdueTasks == overdueTasks)&&(identical(other.totalNotes, totalNotes) || other.totalNotes == totalNotes)&&(identical(other.totalAttachments, totalAttachments) || other.totalAttachments == totalAttachments)&&(identical(other.totalMeetings, totalMeetings) || other.totalMeetings == totalMeetings)&&(identical(other.totalMessages, totalMessages) || other.totalMessages == totalMessages)&&(identical(other.totalCoordinatorships, totalCoordinatorships) || other.totalCoordinatorships == totalCoordinatorships)&&(identical(other.totalUsers, totalUsers) || other.totalUsers == totalUsers)&&(identical(other.totalMembers, totalMembers) || other.totalMembers == totalMembers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalTasks,completedTasks,completionRate,overdueTasks,totalNotes,totalAttachments,totalMeetings,totalMessages,totalCoordinatorships,totalUsers,totalMembers);
}

@override
String toString() {
    return 'Stats(totalTasks: $totalTasks, completedTasks: $completedTasks, completionRate: $completionRate, overdueTasks: $overdueTasks, totalNotes: $totalNotes, totalAttachments: $totalAttachments, totalMeetings: $totalMeetings, totalMessages: $totalMessages, totalCoordinatorships: $totalCoordinatorships, totalUsers: $totalUsers, totalMembers: $totalMembers)';
}


}

/// @nodoc
abstract mixin class _$StatsCopyWith<$Res> implements $StatsCopyWith<$Res> {
  factory _$StatsCopyWith(_Stats value, $Res Function(_Stats) _then) = __$StatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_tasks') int totalTasks,@JsonKey(name: 'completed_tasks') int completedTasks,@JsonKey(name: 'completion_rate') num completionRate,@JsonKey(name: 'overdue_tasks') int overdueTasks,@JsonKey(name: 'total_notes') int totalNotes,@JsonKey(name: 'total_attachments') int totalAttachments,@JsonKey(name: 'total_meetings') int totalMeetings,@JsonKey(name: 'total_messages') int totalMessages,@JsonKey(name: 'total_coordinatorships') int totalCoordinatorships,@JsonKey(name: 'total_users') int totalUsers,@JsonKey(name: 'total_members') int totalMembers
});




}
/// @nodoc
class __$StatsCopyWithImpl<$Res>
    implements _$StatsCopyWith<$Res> {
  __$StatsCopyWithImpl(this._self, this._then);

  final _Stats _self;
  final $Res Function(_Stats) _then;

/// Create a copy of Stats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalTasks = null,Object? completedTasks = null,Object? completionRate = null,Object? overdueTasks = null,Object? totalNotes = null,Object? totalAttachments = null,Object? totalMeetings = null,Object? totalMessages = null,Object? totalCoordinatorships = null,Object? totalUsers = null,Object? totalMembers = null,}) {
  return _then(_Stats(
totalTasks: null == totalTasks ? _self.totalTasks : totalTasks // ignore: cast_nullable_to_non_nullable
as int,completedTasks: null == completedTasks ? _self.completedTasks : completedTasks // ignore: cast_nullable_to_non_nullable
as int,completionRate: null == completionRate ? _self.completionRate : completionRate // ignore: cast_nullable_to_non_nullable
as num,overdueTasks: null == overdueTasks ? _self.overdueTasks : overdueTasks // ignore: cast_nullable_to_non_nullable
as int,totalNotes: null == totalNotes ? _self.totalNotes : totalNotes // ignore: cast_nullable_to_non_nullable
as int,totalAttachments: null == totalAttachments ? _self.totalAttachments : totalAttachments // ignore: cast_nullable_to_non_nullable
as int,totalMeetings: null == totalMeetings ? _self.totalMeetings : totalMeetings // ignore: cast_nullable_to_non_nullable
as int,totalMessages: null == totalMessages ? _self.totalMessages : totalMessages // ignore: cast_nullable_to_non_nullable
as int,totalCoordinatorships: null == totalCoordinatorships ? _self.totalCoordinatorships : totalCoordinatorships // ignore: cast_nullable_to_non_nullable
as int,totalUsers: null == totalUsers ? _self.totalUsers : totalUsers // ignore: cast_nullable_to_non_nullable
as int,totalMembers: null == totalMembers ? _self.totalMembers : totalMembers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
