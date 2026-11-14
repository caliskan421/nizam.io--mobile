// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableComment {

 String get id;@JsonKey(name: 'row_id') String get rowId;/// Yalnız satıra bağlı yorumda `null`.
@JsonKey(name: 'column_id') String? get columnId;/// Yazar okuyana görünmüyorsa `null` (kimlik/e-posta yok).
 Author? get author;/// Yorum okuyanındır (yazar görünmese de doludur).
 bool get mine; String get body;/// Yorumu oluşturan komutun tablo işlem sırası; değişmez, imleç anahtarıdır.
 int get seq;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'edited_at') DateTime? get editedAt;
/// Create a copy of TableComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommentCopyWith<TableComment> get copyWith => _$TableCommentCopyWithImpl<TableComment>(this as TableComment, _$identity);

  /// Serializes this TableComment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableComment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableComment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.rowId, _this.rowId) || other.rowId == _this.rowId)&&(identical(other.columnId, _this.columnId) || other.columnId == _this.columnId)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.mine, _this.mine) || other.mine == _this.mine)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.seq, _this.seq) || other.seq == _this.seq)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.editedAt, _this.editedAt) || other.editedAt == _this.editedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableComment;
  return Object.hash(runtimeType,_this.id,_this.rowId,_this.columnId,_this.author,_this.mine,_this.body,_this.seq,_this.createdAt,_this.editedAt);
}

@override
String toString() {
  final _this = this as TableComment;
  return 'TableComment(id: ${_this.id}, rowId: ${_this.rowId}, columnId: ${_this.columnId}, author: ${_this.author}, mine: ${_this.mine}, body: ${_this.body}, seq: ${_this.seq}, createdAt: ${_this.createdAt}, editedAt: ${_this.editedAt})';
}


}

/// @nodoc
abstract mixin class $TableCommentCopyWith<$Res>  {
  factory $TableCommentCopyWith(TableComment value, $Res Function(TableComment) _then) = _$TableCommentCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'row_id') String rowId,@JsonKey(name: 'column_id') String? columnId, Author? author, bool mine, String body, int seq,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'edited_at') DateTime? editedAt
});




}
/// @nodoc
class _$TableCommentCopyWithImpl<$Res>
    implements $TableCommentCopyWith<$Res> {
  _$TableCommentCopyWithImpl(this._self, this._then);

  final TableComment _self;
  final $Res Function(TableComment) _then;

/// Create a copy of TableComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? rowId = null,Object? columnId = freezed,Object? author = freezed,Object? mine = null,Object? body = null,Object? seq = null,Object? createdAt = null,Object? editedAt = freezed,}) {
  return _then(TableComment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,rowId: null == rowId ? _self.rowId : rowId // ignore: cast_nullable_to_non_nullable
as String,columnId: freezed == columnId ? _self.columnId : columnId // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as Author?,mine: null == mine ? _self.mine : mine // ignore: cast_nullable_to_non_nullable
as bool,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,editedAt: freezed == editedAt ? _self.editedAt : editedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TableComment].
extension TableCommentPatterns on TableComment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableComment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableComment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableComment value)  $default,){
final _that = this;
switch (_that) {
case _TableComment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableComment value)?  $default,){
final _that = this;
switch (_that) {
case _TableComment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'row_id')  String rowId, @JsonKey(name: 'column_id')  String? columnId,  Author? author,  bool mine,  String body,  int seq, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'edited_at')  DateTime? editedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableComment() when $default != null:
return $default(_that.id,_that.rowId,_that.columnId,_that.author,_that.mine,_that.body,_that.seq,_that.createdAt,_that.editedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'row_id')  String rowId, @JsonKey(name: 'column_id')  String? columnId,  Author? author,  bool mine,  String body,  int seq, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'edited_at')  DateTime? editedAt)  $default,) {final _that = this;
switch (_that) {
case _TableComment():
return $default(_that.id,_that.rowId,_that.columnId,_that.author,_that.mine,_that.body,_that.seq,_that.createdAt,_that.editedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'row_id')  String rowId, @JsonKey(name: 'column_id')  String? columnId,  Author? author,  bool mine,  String body,  int seq, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'edited_at')  DateTime? editedAt)?  $default,) {final _that = this;
switch (_that) {
case _TableComment() when $default != null:
return $default(_that.id,_that.rowId,_that.columnId,_that.author,_that.mine,_that.body,_that.seq,_that.createdAt,_that.editedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableComment implements TableComment {
  const _TableComment({required this.id, @JsonKey(name: 'row_id') required this.rowId, @JsonKey(name: 'column_id') required this.columnId, required this.author, required this.mine, required this.body, required this.seq, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'edited_at') required this.editedAt});
  factory _TableComment.fromJson(Map<String, dynamic> json) => _$TableCommentFromJson(json);

@override final  String id;
@override@JsonKey(name: 'row_id') final  String rowId;
/// Yalnız satıra bağlı yorumda `null`.
@override@JsonKey(name: 'column_id') final  String? columnId;
/// Yazar okuyana görünmüyorsa `null` (kimlik/e-posta yok).
@override final  Author? author;
/// Yorum okuyanındır (yazar görünmese de doludur).
@override final  bool mine;
@override final  String body;
/// Yorumu oluşturan komutun tablo işlem sırası; değişmez, imleç anahtarıdır.
@override final  int seq;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'edited_at') final  DateTime? editedAt;

/// Create a copy of TableComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableCommentCopyWith<_TableComment> get copyWith => __$TableCommentCopyWithImpl<_TableComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableComment&&(identical(other.id, id) || other.id == id)&&(identical(other.rowId, rowId) || other.rowId == rowId)&&(identical(other.columnId, columnId) || other.columnId == columnId)&&(identical(other.author, author) || other.author == author)&&(identical(other.mine, mine) || other.mine == mine)&&(identical(other.body, body) || other.body == body)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.editedAt, editedAt) || other.editedAt == editedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,rowId,columnId,author,mine,body,seq,createdAt,editedAt);
}

@override
String toString() {
    return 'TableComment(id: $id, rowId: $rowId, columnId: $columnId, author: $author, mine: $mine, body: $body, seq: $seq, createdAt: $createdAt, editedAt: $editedAt)';
}


}

/// @nodoc
abstract mixin class _$TableCommentCopyWith<$Res> implements $TableCommentCopyWith<$Res> {
  factory _$TableCommentCopyWith(_TableComment value, $Res Function(_TableComment) _then) = __$TableCommentCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'row_id') String rowId,@JsonKey(name: 'column_id') String? columnId, Author? author, bool mine, String body, int seq,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'edited_at') DateTime? editedAt
});




}
/// @nodoc
class __$TableCommentCopyWithImpl<$Res>
    implements _$TableCommentCopyWith<$Res> {
  __$TableCommentCopyWithImpl(this._self, this._then);

  final _TableComment _self;
  final $Res Function(_TableComment) _then;

/// Create a copy of TableComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? rowId = null,Object? columnId = freezed,Object? author = freezed,Object? mine = null,Object? body = null,Object? seq = null,Object? createdAt = null,Object? editedAt = freezed,}) {
  return _then(_TableComment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,rowId: null == rowId ? _self.rowId : rowId // ignore: cast_nullable_to_non_nullable
as String,columnId: freezed == columnId ? _self.columnId : columnId // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as Author?,mine: null == mine ? _self.mine : mine // ignore: cast_nullable_to_non_nullable
as bool,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,editedAt: freezed == editedAt ? _self.editedAt : editedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
