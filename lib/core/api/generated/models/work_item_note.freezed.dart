// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_item_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkItemNote {

@JsonKey(name: 'note_id') String get noteId;@JsonKey(name: 'work_item_id') String get workItemId;@JsonKey(name: 'author_account_id') String get authorAccountId;/// Yazarın görünen adı; ad çözülemezse (geçici okuma hatası dahil) `null`.
@JsonKey(name: 'author_full_name') String? get authorFullName; String get content;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of WorkItemNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkItemNoteCopyWith<WorkItemNote> get copyWith => _$WorkItemNoteCopyWithImpl<WorkItemNote>(this as WorkItemNote, _$identity);

  /// Serializes this WorkItemNote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkItemNote;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkItemNote&&(identical(other.noteId, _this.noteId) || other.noteId == _this.noteId)&&(identical(other.workItemId, _this.workItemId) || other.workItemId == _this.workItemId)&&(identical(other.authorAccountId, _this.authorAccountId) || other.authorAccountId == _this.authorAccountId)&&(identical(other.authorFullName, _this.authorFullName) || other.authorFullName == _this.authorFullName)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkItemNote;
  return Object.hash(runtimeType,_this.noteId,_this.workItemId,_this.authorAccountId,_this.authorFullName,_this.content,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as WorkItemNote;
  return 'WorkItemNote(noteId: ${_this.noteId}, workItemId: ${_this.workItemId}, authorAccountId: ${_this.authorAccountId}, authorFullName: ${_this.authorFullName}, content: ${_this.content}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $WorkItemNoteCopyWith<$Res>  {
  factory $WorkItemNoteCopyWith(WorkItemNote value, $Res Function(WorkItemNote) _then) = _$WorkItemNoteCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'note_id') String noteId,@JsonKey(name: 'work_item_id') String workItemId,@JsonKey(name: 'author_account_id') String authorAccountId,@JsonKey(name: 'author_full_name') String? authorFullName, String content,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$WorkItemNoteCopyWithImpl<$Res>
    implements $WorkItemNoteCopyWith<$Res> {
  _$WorkItemNoteCopyWithImpl(this._self, this._then);

  final WorkItemNote _self;
  final $Res Function(WorkItemNote) _then;

/// Create a copy of WorkItemNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? noteId = null,Object? workItemId = null,Object? authorAccountId = null,Object? authorFullName = freezed,Object? content = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(WorkItemNote(
noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,authorAccountId: null == authorAccountId ? _self.authorAccountId : authorAccountId // ignore: cast_nullable_to_non_nullable
as String,authorFullName: freezed == authorFullName ? _self.authorFullName : authorFullName // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkItemNote].
extension WorkItemNotePatterns on WorkItemNote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkItemNote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkItemNote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkItemNote value)  $default,){
final _that = this;
switch (_that) {
case _WorkItemNote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkItemNote value)?  $default,){
final _that = this;
switch (_that) {
case _WorkItemNote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'note_id')  String noteId, @JsonKey(name: 'work_item_id')  String workItemId, @JsonKey(name: 'author_account_id')  String authorAccountId, @JsonKey(name: 'author_full_name')  String? authorFullName,  String content, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkItemNote() when $default != null:
return $default(_that.noteId,_that.workItemId,_that.authorAccountId,_that.authorFullName,_that.content,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'note_id')  String noteId, @JsonKey(name: 'work_item_id')  String workItemId, @JsonKey(name: 'author_account_id')  String authorAccountId, @JsonKey(name: 'author_full_name')  String? authorFullName,  String content, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _WorkItemNote():
return $default(_that.noteId,_that.workItemId,_that.authorAccountId,_that.authorFullName,_that.content,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'note_id')  String noteId, @JsonKey(name: 'work_item_id')  String workItemId, @JsonKey(name: 'author_account_id')  String authorAccountId, @JsonKey(name: 'author_full_name')  String? authorFullName,  String content, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _WorkItemNote() when $default != null:
return $default(_that.noteId,_that.workItemId,_that.authorAccountId,_that.authorFullName,_that.content,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkItemNote implements WorkItemNote {
  const _WorkItemNote({@JsonKey(name: 'note_id') required this.noteId, @JsonKey(name: 'work_item_id') required this.workItemId, @JsonKey(name: 'author_account_id') required this.authorAccountId, @JsonKey(name: 'author_full_name') required this.authorFullName, required this.content, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _WorkItemNote.fromJson(Map<String, dynamic> json) => _$WorkItemNoteFromJson(json);

@override@JsonKey(name: 'note_id') final  String noteId;
@override@JsonKey(name: 'work_item_id') final  String workItemId;
@override@JsonKey(name: 'author_account_id') final  String authorAccountId;
/// Yazarın görünen adı; ad çözülemezse (geçici okuma hatası dahil) `null`.
@override@JsonKey(name: 'author_full_name') final  String? authorFullName;
@override final  String content;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of WorkItemNote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkItemNoteCopyWith<_WorkItemNote> get copyWith => __$WorkItemNoteCopyWithImpl<_WorkItemNote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkItemNoteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkItemNote&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.workItemId, workItemId) || other.workItemId == workItemId)&&(identical(other.authorAccountId, authorAccountId) || other.authorAccountId == authorAccountId)&&(identical(other.authorFullName, authorFullName) || other.authorFullName == authorFullName)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,noteId,workItemId,authorAccountId,authorFullName,content,createdAt,updatedAt);
}

@override
String toString() {
    return 'WorkItemNote(noteId: $noteId, workItemId: $workItemId, authorAccountId: $authorAccountId, authorFullName: $authorFullName, content: $content, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$WorkItemNoteCopyWith<$Res> implements $WorkItemNoteCopyWith<$Res> {
  factory _$WorkItemNoteCopyWith(_WorkItemNote value, $Res Function(_WorkItemNote) _then) = __$WorkItemNoteCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'note_id') String noteId,@JsonKey(name: 'work_item_id') String workItemId,@JsonKey(name: 'author_account_id') String authorAccountId,@JsonKey(name: 'author_full_name') String? authorFullName, String content,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$WorkItemNoteCopyWithImpl<$Res>
    implements _$WorkItemNoteCopyWith<$Res> {
  __$WorkItemNoteCopyWithImpl(this._self, this._then);

  final _WorkItemNote _self;
  final $Res Function(_WorkItemNote) _then;

/// Create a copy of WorkItemNote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? noteId = null,Object? workItemId = null,Object? authorAccountId = null,Object? authorFullName = freezed,Object? content = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_WorkItemNote(
noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,authorAccountId: null == authorAccountId ? _self.authorAccountId : authorAccountId // ignore: cast_nullable_to_non_nullable
as String,authorFullName: freezed == authorFullName ? _self.authorFullName : authorFullName // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
