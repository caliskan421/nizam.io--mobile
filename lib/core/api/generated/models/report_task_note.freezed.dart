// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_task_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportTaskNote {

 String get content; ReportPerson get author;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of ReportTaskNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportTaskNoteCopyWith<ReportTaskNote> get copyWith => _$ReportTaskNoteCopyWithImpl<ReportTaskNote>(this as ReportTaskNote, _$identity);

  /// Serializes this ReportTaskNote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportTaskNote;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportTaskNote&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportTaskNote;
  return Object.hash(runtimeType,_this.content,_this.author,_this.createdAt);
}

@override
String toString() {
  final _this = this as ReportTaskNote;
  return 'ReportTaskNote(content: ${_this.content}, author: ${_this.author}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ReportTaskNoteCopyWith<$Res>  {
  factory $ReportTaskNoteCopyWith(ReportTaskNote value, $Res Function(ReportTaskNote) _then) = _$ReportTaskNoteCopyWithImpl;
@useResult
$Res call({
 String content, ReportPerson author,@JsonKey(name: 'created_at') DateTime createdAt
});


$ReportPersonCopyWith<$Res> get author;

}
/// @nodoc
class _$ReportTaskNoteCopyWithImpl<$Res>
    implements $ReportTaskNoteCopyWith<$Res> {
  _$ReportTaskNoteCopyWithImpl(this._self, this._then);

  final ReportTaskNote _self;
  final $Res Function(ReportTaskNote) _then;

/// Create a copy of ReportTaskNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? author = null,Object? createdAt = null,}) {
  return _then(ReportTaskNote(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as ReportPerson,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of ReportTaskNote
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportPersonCopyWith<$Res> get author {
  
  return $ReportPersonCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReportTaskNote].
extension ReportTaskNotePatterns on ReportTaskNote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportTaskNote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportTaskNote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportTaskNote value)  $default,){
final _that = this;
switch (_that) {
case _ReportTaskNote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportTaskNote value)?  $default,){
final _that = this;
switch (_that) {
case _ReportTaskNote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String content,  ReportPerson author, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportTaskNote() when $default != null:
return $default(_that.content,_that.author,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String content,  ReportPerson author, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ReportTaskNote():
return $default(_that.content,_that.author,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String content,  ReportPerson author, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ReportTaskNote() when $default != null:
return $default(_that.content,_that.author,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportTaskNote implements ReportTaskNote {
  const _ReportTaskNote({required this.content, required this.author, @JsonKey(name: 'created_at') required this.createdAt});
  factory _ReportTaskNote.fromJson(Map<String, dynamic> json) => _$ReportTaskNoteFromJson(json);

@override final  String content;
@override final  ReportPerson author;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of ReportTaskNote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportTaskNoteCopyWith<_ReportTaskNote> get copyWith => __$ReportTaskNoteCopyWithImpl<_ReportTaskNote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportTaskNoteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportTaskNote&&(identical(other.content, content) || other.content == content)&&(identical(other.author, author) || other.author == author)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,content,author,createdAt);
}

@override
String toString() {
    return 'ReportTaskNote(content: $content, author: $author, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ReportTaskNoteCopyWith<$Res> implements $ReportTaskNoteCopyWith<$Res> {
  factory _$ReportTaskNoteCopyWith(_ReportTaskNote value, $Res Function(_ReportTaskNote) _then) = __$ReportTaskNoteCopyWithImpl;
@override @useResult
$Res call({
 String content, ReportPerson author,@JsonKey(name: 'created_at') DateTime createdAt
});


@override $ReportPersonCopyWith<$Res> get author;

}
/// @nodoc
class __$ReportTaskNoteCopyWithImpl<$Res>
    implements _$ReportTaskNoteCopyWith<$Res> {
  __$ReportTaskNoteCopyWithImpl(this._self, this._then);

  final _ReportTaskNote _self;
  final $Res Function(_ReportTaskNote) _then;

/// Create a copy of ReportTaskNote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? author = null,Object? createdAt = null,}) {
  return _then(_ReportTaskNote(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as ReportPerson,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of ReportTaskNote
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
