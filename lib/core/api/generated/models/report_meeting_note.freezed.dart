// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_meeting_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportMeetingNote {

@JsonKey(name: 'note_id') String get noteId; String get content; ReportPerson get author;/// Yazarın rol kopyası; rolü kaydedilmemiş eski notlarda boş dizge.
@JsonKey(name: 'author_role') ReportMeetingNoteAuthorRole get authorRole;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'converted_to_task_id') String? get convertedToTaskId;@JsonKey(name: 'converted_task_title') String? get convertedTaskTitle;
/// Create a copy of ReportMeetingNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportMeetingNoteCopyWith<ReportMeetingNote> get copyWith => _$ReportMeetingNoteCopyWithImpl<ReportMeetingNote>(this as ReportMeetingNote, _$identity);

  /// Serializes this ReportMeetingNote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportMeetingNote;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportMeetingNote&&(identical(other.noteId, _this.noteId) || other.noteId == _this.noteId)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.authorRole, _this.authorRole) || other.authorRole == _this.authorRole)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.convertedToTaskId, _this.convertedToTaskId) || other.convertedToTaskId == _this.convertedToTaskId)&&(identical(other.convertedTaskTitle, _this.convertedTaskTitle) || other.convertedTaskTitle == _this.convertedTaskTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportMeetingNote;
  return Object.hash(runtimeType,_this.noteId,_this.content,_this.author,_this.authorRole,_this.createdAt,_this.convertedToTaskId,_this.convertedTaskTitle);
}

@override
String toString() {
  final _this = this as ReportMeetingNote;
  return 'ReportMeetingNote(noteId: ${_this.noteId}, content: ${_this.content}, author: ${_this.author}, authorRole: ${_this.authorRole}, createdAt: ${_this.createdAt}, convertedToTaskId: ${_this.convertedToTaskId}, convertedTaskTitle: ${_this.convertedTaskTitle})';
}


}

/// @nodoc
abstract mixin class $ReportMeetingNoteCopyWith<$Res>  {
  factory $ReportMeetingNoteCopyWith(ReportMeetingNote value, $Res Function(ReportMeetingNote) _then) = _$ReportMeetingNoteCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'note_id') String noteId, String content, ReportPerson author,@JsonKey(name: 'author_role') ReportMeetingNoteAuthorRole authorRole,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'converted_to_task_id') String? convertedToTaskId,@JsonKey(name: 'converted_task_title') String? convertedTaskTitle
});


$ReportPersonCopyWith<$Res> get author;

}
/// @nodoc
class _$ReportMeetingNoteCopyWithImpl<$Res>
    implements $ReportMeetingNoteCopyWith<$Res> {
  _$ReportMeetingNoteCopyWithImpl(this._self, this._then);

  final ReportMeetingNote _self;
  final $Res Function(ReportMeetingNote) _then;

/// Create a copy of ReportMeetingNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? noteId = null,Object? content = null,Object? author = null,Object? authorRole = null,Object? createdAt = null,Object? convertedToTaskId = freezed,Object? convertedTaskTitle = freezed,}) {
  return _then(ReportMeetingNote(
noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as ReportPerson,authorRole: null == authorRole ? _self.authorRole : authorRole // ignore: cast_nullable_to_non_nullable
as ReportMeetingNoteAuthorRole,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,convertedToTaskId: freezed == convertedToTaskId ? _self.convertedToTaskId : convertedToTaskId // ignore: cast_nullable_to_non_nullable
as String?,convertedTaskTitle: freezed == convertedTaskTitle ? _self.convertedTaskTitle : convertedTaskTitle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ReportMeetingNote
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportPersonCopyWith<$Res> get author {
  
  return $ReportPersonCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReportMeetingNote].
extension ReportMeetingNotePatterns on ReportMeetingNote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportMeetingNote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportMeetingNote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportMeetingNote value)  $default,){
final _that = this;
switch (_that) {
case _ReportMeetingNote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportMeetingNote value)?  $default,){
final _that = this;
switch (_that) {
case _ReportMeetingNote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'note_id')  String noteId,  String content,  ReportPerson author, @JsonKey(name: 'author_role')  ReportMeetingNoteAuthorRole authorRole, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'converted_to_task_id')  String? convertedToTaskId, @JsonKey(name: 'converted_task_title')  String? convertedTaskTitle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportMeetingNote() when $default != null:
return $default(_that.noteId,_that.content,_that.author,_that.authorRole,_that.createdAt,_that.convertedToTaskId,_that.convertedTaskTitle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'note_id')  String noteId,  String content,  ReportPerson author, @JsonKey(name: 'author_role')  ReportMeetingNoteAuthorRole authorRole, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'converted_to_task_id')  String? convertedToTaskId, @JsonKey(name: 'converted_task_title')  String? convertedTaskTitle)  $default,) {final _that = this;
switch (_that) {
case _ReportMeetingNote():
return $default(_that.noteId,_that.content,_that.author,_that.authorRole,_that.createdAt,_that.convertedToTaskId,_that.convertedTaskTitle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'note_id')  String noteId,  String content,  ReportPerson author, @JsonKey(name: 'author_role')  ReportMeetingNoteAuthorRole authorRole, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'converted_to_task_id')  String? convertedToTaskId, @JsonKey(name: 'converted_task_title')  String? convertedTaskTitle)?  $default,) {final _that = this;
switch (_that) {
case _ReportMeetingNote() when $default != null:
return $default(_that.noteId,_that.content,_that.author,_that.authorRole,_that.createdAt,_that.convertedToTaskId,_that.convertedTaskTitle);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportMeetingNote implements ReportMeetingNote {
  const _ReportMeetingNote({@JsonKey(name: 'note_id') required this.noteId, required this.content, required this.author, @JsonKey(name: 'author_role') required this.authorRole, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'converted_to_task_id') required this.convertedToTaskId, @JsonKey(name: 'converted_task_title') required this.convertedTaskTitle});
  factory _ReportMeetingNote.fromJson(Map<String, dynamic> json) => _$ReportMeetingNoteFromJson(json);

@override@JsonKey(name: 'note_id') final  String noteId;
@override final  String content;
@override final  ReportPerson author;
/// Yazarın rol kopyası; rolü kaydedilmemiş eski notlarda boş dizge.
@override@JsonKey(name: 'author_role') final  ReportMeetingNoteAuthorRole authorRole;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'converted_to_task_id') final  String? convertedToTaskId;
@override@JsonKey(name: 'converted_task_title') final  String? convertedTaskTitle;

/// Create a copy of ReportMeetingNote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportMeetingNoteCopyWith<_ReportMeetingNote> get copyWith => __$ReportMeetingNoteCopyWithImpl<_ReportMeetingNote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportMeetingNoteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportMeetingNote&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.content, content) || other.content == content)&&(identical(other.author, author) || other.author == author)&&(identical(other.authorRole, authorRole) || other.authorRole == authorRole)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.convertedToTaskId, convertedToTaskId) || other.convertedToTaskId == convertedToTaskId)&&(identical(other.convertedTaskTitle, convertedTaskTitle) || other.convertedTaskTitle == convertedTaskTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,noteId,content,author,authorRole,createdAt,convertedToTaskId,convertedTaskTitle);
}

@override
String toString() {
    return 'ReportMeetingNote(noteId: $noteId, content: $content, author: $author, authorRole: $authorRole, createdAt: $createdAt, convertedToTaskId: $convertedToTaskId, convertedTaskTitle: $convertedTaskTitle)';
}


}

/// @nodoc
abstract mixin class _$ReportMeetingNoteCopyWith<$Res> implements $ReportMeetingNoteCopyWith<$Res> {
  factory _$ReportMeetingNoteCopyWith(_ReportMeetingNote value, $Res Function(_ReportMeetingNote) _then) = __$ReportMeetingNoteCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'note_id') String noteId, String content, ReportPerson author,@JsonKey(name: 'author_role') ReportMeetingNoteAuthorRole authorRole,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'converted_to_task_id') String? convertedToTaskId,@JsonKey(name: 'converted_task_title') String? convertedTaskTitle
});


@override $ReportPersonCopyWith<$Res> get author;

}
/// @nodoc
class __$ReportMeetingNoteCopyWithImpl<$Res>
    implements _$ReportMeetingNoteCopyWith<$Res> {
  __$ReportMeetingNoteCopyWithImpl(this._self, this._then);

  final _ReportMeetingNote _self;
  final $Res Function(_ReportMeetingNote) _then;

/// Create a copy of ReportMeetingNote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? noteId = null,Object? content = null,Object? author = null,Object? authorRole = null,Object? createdAt = null,Object? convertedToTaskId = freezed,Object? convertedTaskTitle = freezed,}) {
  return _then(_ReportMeetingNote(
noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as ReportPerson,authorRole: null == authorRole ? _self.authorRole : authorRole // ignore: cast_nullable_to_non_nullable
as ReportMeetingNoteAuthorRole,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,convertedToTaskId: freezed == convertedToTaskId ? _self.convertedToTaskId : convertedToTaskId // ignore: cast_nullable_to_non_nullable
as String?,convertedTaskTitle: freezed == convertedTaskTitle ? _self.convertedTaskTitle : convertedTaskTitle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ReportMeetingNote
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportPersonCopyWith<$Res> get author {
  
  return $ReportPersonCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}

// dart format on
