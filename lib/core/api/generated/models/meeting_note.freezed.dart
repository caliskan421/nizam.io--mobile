// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeetingNote {

@JsonKey(name: 'note_id') String get noteId;@JsonKey(name: 'meeting_id') String get meetingId;@JsonKey(name: 'author_account_id') String? get authorAccountId;@JsonKey(name: 'author_name') String get authorName;/// Yazarın rol kopyası; eski notlarda boş (null) olabilir.
@JsonKey(name: 'author_role') MeetingNoteAuthorRole? get authorRole; String get content;@JsonKey(name: 'converted_to_work_item_id') String? get convertedToWorkItemId;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of MeetingNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingNoteCopyWith<MeetingNote> get copyWith => _$MeetingNoteCopyWithImpl<MeetingNote>(this as MeetingNote, _$identity);

  /// Serializes this MeetingNote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeetingNote;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingNote&&(identical(other.noteId, _this.noteId) || other.noteId == _this.noteId)&&(identical(other.meetingId, _this.meetingId) || other.meetingId == _this.meetingId)&&(identical(other.authorAccountId, _this.authorAccountId) || other.authorAccountId == _this.authorAccountId)&&(identical(other.authorName, _this.authorName) || other.authorName == _this.authorName)&&(identical(other.authorRole, _this.authorRole) || other.authorRole == _this.authorRole)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.convertedToWorkItemId, _this.convertedToWorkItemId) || other.convertedToWorkItemId == _this.convertedToWorkItemId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeetingNote;
  return Object.hash(runtimeType,_this.noteId,_this.meetingId,_this.authorAccountId,_this.authorName,_this.authorRole,_this.content,_this.convertedToWorkItemId,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as MeetingNote;
  return 'MeetingNote(noteId: ${_this.noteId}, meetingId: ${_this.meetingId}, authorAccountId: ${_this.authorAccountId}, authorName: ${_this.authorName}, authorRole: ${_this.authorRole}, content: ${_this.content}, convertedToWorkItemId: ${_this.convertedToWorkItemId}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $MeetingNoteCopyWith<$Res>  {
  factory $MeetingNoteCopyWith(MeetingNote value, $Res Function(MeetingNote) _then) = _$MeetingNoteCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'note_id') String noteId,@JsonKey(name: 'meeting_id') String meetingId,@JsonKey(name: 'author_account_id') String? authorAccountId,@JsonKey(name: 'author_name') String authorName,@JsonKey(name: 'author_role') MeetingNoteAuthorRole? authorRole, String content,@JsonKey(name: 'converted_to_work_item_id') String? convertedToWorkItemId,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$MeetingNoteCopyWithImpl<$Res>
    implements $MeetingNoteCopyWith<$Res> {
  _$MeetingNoteCopyWithImpl(this._self, this._then);

  final MeetingNote _self;
  final $Res Function(MeetingNote) _then;

/// Create a copy of MeetingNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? noteId = null,Object? meetingId = null,Object? authorAccountId = freezed,Object? authorName = null,Object? authorRole = freezed,Object? content = null,Object? convertedToWorkItemId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(MeetingNote(
noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,authorAccountId: freezed == authorAccountId ? _self.authorAccountId : authorAccountId // ignore: cast_nullable_to_non_nullable
as String?,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorRole: freezed == authorRole ? _self.authorRole : authorRole // ignore: cast_nullable_to_non_nullable
as MeetingNoteAuthorRole?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,convertedToWorkItemId: freezed == convertedToWorkItemId ? _self.convertedToWorkItemId : convertedToWorkItemId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MeetingNote].
extension MeetingNotePatterns on MeetingNote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetingNote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetingNote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetingNote value)  $default,){
final _that = this;
switch (_that) {
case _MeetingNote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetingNote value)?  $default,){
final _that = this;
switch (_that) {
case _MeetingNote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'note_id')  String noteId, @JsonKey(name: 'meeting_id')  String meetingId, @JsonKey(name: 'author_account_id')  String? authorAccountId, @JsonKey(name: 'author_name')  String authorName, @JsonKey(name: 'author_role')  MeetingNoteAuthorRole? authorRole,  String content, @JsonKey(name: 'converted_to_work_item_id')  String? convertedToWorkItemId, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingNote() when $default != null:
return $default(_that.noteId,_that.meetingId,_that.authorAccountId,_that.authorName,_that.authorRole,_that.content,_that.convertedToWorkItemId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'note_id')  String noteId, @JsonKey(name: 'meeting_id')  String meetingId, @JsonKey(name: 'author_account_id')  String? authorAccountId, @JsonKey(name: 'author_name')  String authorName, @JsonKey(name: 'author_role')  MeetingNoteAuthorRole? authorRole,  String content, @JsonKey(name: 'converted_to_work_item_id')  String? convertedToWorkItemId, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MeetingNote():
return $default(_that.noteId,_that.meetingId,_that.authorAccountId,_that.authorName,_that.authorRole,_that.content,_that.convertedToWorkItemId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'note_id')  String noteId, @JsonKey(name: 'meeting_id')  String meetingId, @JsonKey(name: 'author_account_id')  String? authorAccountId, @JsonKey(name: 'author_name')  String authorName, @JsonKey(name: 'author_role')  MeetingNoteAuthorRole? authorRole,  String content, @JsonKey(name: 'converted_to_work_item_id')  String? convertedToWorkItemId, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MeetingNote() when $default != null:
return $default(_that.noteId,_that.meetingId,_that.authorAccountId,_that.authorName,_that.authorRole,_that.content,_that.convertedToWorkItemId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetingNote implements MeetingNote {
  const _MeetingNote({@JsonKey(name: 'note_id') required this.noteId, @JsonKey(name: 'meeting_id') required this.meetingId, @JsonKey(name: 'author_account_id') required this.authorAccountId, @JsonKey(name: 'author_name') required this.authorName, @JsonKey(name: 'author_role') required this.authorRole, required this.content, @JsonKey(name: 'converted_to_work_item_id') required this.convertedToWorkItemId, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _MeetingNote.fromJson(Map<String, dynamic> json) => _$MeetingNoteFromJson(json);

@override@JsonKey(name: 'note_id') final  String noteId;
@override@JsonKey(name: 'meeting_id') final  String meetingId;
@override@JsonKey(name: 'author_account_id') final  String? authorAccountId;
@override@JsonKey(name: 'author_name') final  String authorName;
/// Yazarın rol kopyası; eski notlarda boş (null) olabilir.
@override@JsonKey(name: 'author_role') final  MeetingNoteAuthorRole? authorRole;
@override final  String content;
@override@JsonKey(name: 'converted_to_work_item_id') final  String? convertedToWorkItemId;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of MeetingNote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingNoteCopyWith<_MeetingNote> get copyWith => __$MeetingNoteCopyWithImpl<_MeetingNote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetingNoteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingNote&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.meetingId, meetingId) || other.meetingId == meetingId)&&(identical(other.authorAccountId, authorAccountId) || other.authorAccountId == authorAccountId)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorRole, authorRole) || other.authorRole == authorRole)&&(identical(other.content, content) || other.content == content)&&(identical(other.convertedToWorkItemId, convertedToWorkItemId) || other.convertedToWorkItemId == convertedToWorkItemId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,noteId,meetingId,authorAccountId,authorName,authorRole,content,convertedToWorkItemId,createdAt,updatedAt);
}

@override
String toString() {
    return 'MeetingNote(noteId: $noteId, meetingId: $meetingId, authorAccountId: $authorAccountId, authorName: $authorName, authorRole: $authorRole, content: $content, convertedToWorkItemId: $convertedToWorkItemId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MeetingNoteCopyWith<$Res> implements $MeetingNoteCopyWith<$Res> {
  factory _$MeetingNoteCopyWith(_MeetingNote value, $Res Function(_MeetingNote) _then) = __$MeetingNoteCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'note_id') String noteId,@JsonKey(name: 'meeting_id') String meetingId,@JsonKey(name: 'author_account_id') String? authorAccountId,@JsonKey(name: 'author_name') String authorName,@JsonKey(name: 'author_role') MeetingNoteAuthorRole? authorRole, String content,@JsonKey(name: 'converted_to_work_item_id') String? convertedToWorkItemId,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$MeetingNoteCopyWithImpl<$Res>
    implements _$MeetingNoteCopyWith<$Res> {
  __$MeetingNoteCopyWithImpl(this._self, this._then);

  final _MeetingNote _self;
  final $Res Function(_MeetingNote) _then;

/// Create a copy of MeetingNote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? noteId = null,Object? meetingId = null,Object? authorAccountId = freezed,Object? authorName = null,Object? authorRole = freezed,Object? content = null,Object? convertedToWorkItemId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_MeetingNote(
noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,authorAccountId: freezed == authorAccountId ? _self.authorAccountId : authorAccountId // ignore: cast_nullable_to_non_nullable
as String?,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorRole: freezed == authorRole ? _self.authorRole : authorRole // ignore: cast_nullable_to_non_nullable
as MeetingNoteAuthorRole?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,convertedToWorkItemId: freezed == convertedToWorkItemId ? _self.convertedToWorkItemId : convertedToWorkItemId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
