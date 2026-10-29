// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonthlyActivity {

 String get month;@JsonKey(name: 'created_tasks') int get createdTasks;@JsonKey(name: 'completed_tasks') int get completedTasks; int get meetings; int get messages; int get count;
/// Create a copy of MonthlyActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyActivityCopyWith<MonthlyActivity> get copyWith => _$MonthlyActivityCopyWithImpl<MonthlyActivity>(this as MonthlyActivity, _$identity);

  /// Serializes this MonthlyActivity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonthlyActivity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyActivity&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.createdTasks, _this.createdTasks) || other.createdTasks == _this.createdTasks)&&(identical(other.completedTasks, _this.completedTasks) || other.completedTasks == _this.completedTasks)&&(identical(other.meetings, _this.meetings) || other.meetings == _this.meetings)&&(identical(other.messages, _this.messages) || other.messages == _this.messages)&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonthlyActivity;
  return Object.hash(runtimeType,_this.month,_this.createdTasks,_this.completedTasks,_this.meetings,_this.messages,_this.count);
}

@override
String toString() {
  final _this = this as MonthlyActivity;
  return 'MonthlyActivity(month: ${_this.month}, createdTasks: ${_this.createdTasks}, completedTasks: ${_this.completedTasks}, meetings: ${_this.meetings}, messages: ${_this.messages}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $MonthlyActivityCopyWith<$Res>  {
  factory $MonthlyActivityCopyWith(MonthlyActivity value, $Res Function(MonthlyActivity) _then) = _$MonthlyActivityCopyWithImpl;
@useResult
$Res call({
 String month,@JsonKey(name: 'created_tasks') int createdTasks,@JsonKey(name: 'completed_tasks') int completedTasks, int meetings, int messages, int count
});




}
/// @nodoc
class _$MonthlyActivityCopyWithImpl<$Res>
    implements $MonthlyActivityCopyWith<$Res> {
  _$MonthlyActivityCopyWithImpl(this._self, this._then);

  final MonthlyActivity _self;
  final $Res Function(MonthlyActivity) _then;

/// Create a copy of MonthlyActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? createdTasks = null,Object? completedTasks = null,Object? meetings = null,Object? messages = null,Object? count = null,}) {
  return _then(MonthlyActivity(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,createdTasks: null == createdTasks ? _self.createdTasks : createdTasks // ignore: cast_nullable_to_non_nullable
as int,completedTasks: null == completedTasks ? _self.completedTasks : completedTasks // ignore: cast_nullable_to_non_nullable
as int,meetings: null == meetings ? _self.meetings : meetings // ignore: cast_nullable_to_non_nullable
as int,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyActivity].
extension MonthlyActivityPatterns on MonthlyActivity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyActivity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyActivity value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyActivity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyActivity value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyActivity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String month, @JsonKey(name: 'created_tasks')  int createdTasks, @JsonKey(name: 'completed_tasks')  int completedTasks,  int meetings,  int messages,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyActivity() when $default != null:
return $default(_that.month,_that.createdTasks,_that.completedTasks,_that.meetings,_that.messages,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String month, @JsonKey(name: 'created_tasks')  int createdTasks, @JsonKey(name: 'completed_tasks')  int completedTasks,  int meetings,  int messages,  int count)  $default,) {final _that = this;
switch (_that) {
case _MonthlyActivity():
return $default(_that.month,_that.createdTasks,_that.completedTasks,_that.meetings,_that.messages,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String month, @JsonKey(name: 'created_tasks')  int createdTasks, @JsonKey(name: 'completed_tasks')  int completedTasks,  int meetings,  int messages,  int count)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyActivity() when $default != null:
return $default(_that.month,_that.createdTasks,_that.completedTasks,_that.meetings,_that.messages,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthlyActivity implements MonthlyActivity {
  const _MonthlyActivity({required this.month, @JsonKey(name: 'created_tasks') required this.createdTasks, @JsonKey(name: 'completed_tasks') required this.completedTasks, required this.meetings, required this.messages, required this.count});
  factory _MonthlyActivity.fromJson(Map<String, dynamic> json) => _$MonthlyActivityFromJson(json);

@override final  String month;
@override@JsonKey(name: 'created_tasks') final  int createdTasks;
@override@JsonKey(name: 'completed_tasks') final  int completedTasks;
@override final  int meetings;
@override final  int messages;
@override final  int count;

/// Create a copy of MonthlyActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyActivityCopyWith<_MonthlyActivity> get copyWith => __$MonthlyActivityCopyWithImpl<_MonthlyActivity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyActivityToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyActivity&&(identical(other.month, month) || other.month == month)&&(identical(other.createdTasks, createdTasks) || other.createdTasks == createdTasks)&&(identical(other.completedTasks, completedTasks) || other.completedTasks == completedTasks)&&(identical(other.meetings, meetings) || other.meetings == meetings)&&(identical(other.messages, messages) || other.messages == messages)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,month,createdTasks,completedTasks,meetings,messages,count);
}

@override
String toString() {
    return 'MonthlyActivity(month: $month, createdTasks: $createdTasks, completedTasks: $completedTasks, meetings: $meetings, messages: $messages, count: $count)';
}


}

/// @nodoc
abstract mixin class _$MonthlyActivityCopyWith<$Res> implements $MonthlyActivityCopyWith<$Res> {
  factory _$MonthlyActivityCopyWith(_MonthlyActivity value, $Res Function(_MonthlyActivity) _then) = __$MonthlyActivityCopyWithImpl;
@override @useResult
$Res call({
 String month,@JsonKey(name: 'created_tasks') int createdTasks,@JsonKey(name: 'completed_tasks') int completedTasks, int meetings, int messages, int count
});




}
/// @nodoc
class __$MonthlyActivityCopyWithImpl<$Res>
    implements _$MonthlyActivityCopyWith<$Res> {
  __$MonthlyActivityCopyWithImpl(this._self, this._then);

  final _MonthlyActivity _self;
  final $Res Function(_MonthlyActivity) _then;

/// Create a copy of MonthlyActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? createdTasks = null,Object? completedTasks = null,Object? meetings = null,Object? messages = null,Object? count = null,}) {
  return _then(_MonthlyActivity(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,createdTasks: null == createdTasks ? _self.createdTasks : createdTasks // ignore: cast_nullable_to_non_nullable
as int,completedTasks: null == completedTasks ? _self.completedTasks : completedTasks // ignore: cast_nullable_to_non_nullable
as int,meetings: null == meetings ? _self.meetings : meetings // ignore: cast_nullable_to_non_nullable
as int,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
