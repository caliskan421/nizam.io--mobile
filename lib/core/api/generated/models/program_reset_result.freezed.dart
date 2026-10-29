// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'program_reset_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProgramResetResult {

@JsonKey(name: 'program_id') String get programId; int get tasks; int get files; int get messages; int get meetings;
/// Create a copy of ProgramResetResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgramResetResultCopyWith<ProgramResetResult> get copyWith => _$ProgramResetResultCopyWithImpl<ProgramResetResult>(this as ProgramResetResult, _$identity);

  /// Serializes this ProgramResetResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProgramResetResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgramResetResult&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.tasks, _this.tasks) || other.tasks == _this.tasks)&&(identical(other.files, _this.files) || other.files == _this.files)&&(identical(other.messages, _this.messages) || other.messages == _this.messages)&&(identical(other.meetings, _this.meetings) || other.meetings == _this.meetings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProgramResetResult;
  return Object.hash(runtimeType,_this.programId,_this.tasks,_this.files,_this.messages,_this.meetings);
}

@override
String toString() {
  final _this = this as ProgramResetResult;
  return 'ProgramResetResult(programId: ${_this.programId}, tasks: ${_this.tasks}, files: ${_this.files}, messages: ${_this.messages}, meetings: ${_this.meetings})';
}


}

/// @nodoc
abstract mixin class $ProgramResetResultCopyWith<$Res>  {
  factory $ProgramResetResultCopyWith(ProgramResetResult value, $Res Function(ProgramResetResult) _then) = _$ProgramResetResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'program_id') String programId, int tasks, int files, int messages, int meetings
});




}
/// @nodoc
class _$ProgramResetResultCopyWithImpl<$Res>
    implements $ProgramResetResultCopyWith<$Res> {
  _$ProgramResetResultCopyWithImpl(this._self, this._then);

  final ProgramResetResult _self;
  final $Res Function(ProgramResetResult) _then;

/// Create a copy of ProgramResetResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? programId = null,Object? tasks = null,Object? files = null,Object? messages = null,Object? meetings = null,}) {
  return _then(ProgramResetResult(
programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as int,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as int,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as int,meetings: null == meetings ? _self.meetings : meetings // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgramResetResult].
extension ProgramResetResultPatterns on ProgramResetResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgramResetResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgramResetResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgramResetResult value)  $default,){
final _that = this;
switch (_that) {
case _ProgramResetResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgramResetResult value)?  $default,){
final _that = this;
switch (_that) {
case _ProgramResetResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'program_id')  String programId,  int tasks,  int files,  int messages,  int meetings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgramResetResult() when $default != null:
return $default(_that.programId,_that.tasks,_that.files,_that.messages,_that.meetings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'program_id')  String programId,  int tasks,  int files,  int messages,  int meetings)  $default,) {final _that = this;
switch (_that) {
case _ProgramResetResult():
return $default(_that.programId,_that.tasks,_that.files,_that.messages,_that.meetings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'program_id')  String programId,  int tasks,  int files,  int messages,  int meetings)?  $default,) {final _that = this;
switch (_that) {
case _ProgramResetResult() when $default != null:
return $default(_that.programId,_that.tasks,_that.files,_that.messages,_that.meetings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgramResetResult implements ProgramResetResult {
  const _ProgramResetResult({@JsonKey(name: 'program_id') required this.programId, required this.tasks, required this.files, required this.messages, required this.meetings});
  factory _ProgramResetResult.fromJson(Map<String, dynamic> json) => _$ProgramResetResultFromJson(json);

@override@JsonKey(name: 'program_id') final  String programId;
@override final  int tasks;
@override final  int files;
@override final  int messages;
@override final  int meetings;

/// Create a copy of ProgramResetResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgramResetResultCopyWith<_ProgramResetResult> get copyWith => __$ProgramResetResultCopyWithImpl<_ProgramResetResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgramResetResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgramResetResult&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.tasks, tasks) || other.tasks == tasks)&&(identical(other.files, files) || other.files == files)&&(identical(other.messages, messages) || other.messages == messages)&&(identical(other.meetings, meetings) || other.meetings == meetings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,programId,tasks,files,messages,meetings);
}

@override
String toString() {
    return 'ProgramResetResult(programId: $programId, tasks: $tasks, files: $files, messages: $messages, meetings: $meetings)';
}


}

/// @nodoc
abstract mixin class _$ProgramResetResultCopyWith<$Res> implements $ProgramResetResultCopyWith<$Res> {
  factory _$ProgramResetResultCopyWith(_ProgramResetResult value, $Res Function(_ProgramResetResult) _then) = __$ProgramResetResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'program_id') String programId, int tasks, int files, int messages, int meetings
});




}
/// @nodoc
class __$ProgramResetResultCopyWithImpl<$Res>
    implements _$ProgramResetResultCopyWith<$Res> {
  __$ProgramResetResultCopyWithImpl(this._self, this._then);

  final _ProgramResetResult _self;
  final $Res Function(_ProgramResetResult) _then;

/// Create a copy of ProgramResetResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? programId = null,Object? tasks = null,Object? files = null,Object? messages = null,Object? meetings = null,}) {
  return _then(_ProgramResetResult(
programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as int,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as int,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as int,meetings: null == meetings ? _self.meetings : meetings // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
