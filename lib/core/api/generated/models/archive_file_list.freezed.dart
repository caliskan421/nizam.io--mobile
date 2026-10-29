// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'archive_file_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ArchiveFileList {

 List<FileListItem> get files;@JsonKey(name: 'next_cursor') String? get nextCursor;
/// Create a copy of ArchiveFileList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchiveFileListCopyWith<ArchiveFileList> get copyWith => _$ArchiveFileListCopyWithImpl<ArchiveFileList>(this as ArchiveFileList, _$identity);

  /// Serializes this ArchiveFileList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ArchiveFileList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchiveFileList&&const DeepCollectionEquality().equals(other.files, _this.files)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ArchiveFileList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.files),_this.nextCursor);
}

@override
String toString() {
  final _this = this as ArchiveFileList;
  return 'ArchiveFileList(files: ${_this.files}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $ArchiveFileListCopyWith<$Res>  {
  factory $ArchiveFileListCopyWith(ArchiveFileList value, $Res Function(ArchiveFileList) _then) = _$ArchiveFileListCopyWithImpl;
@useResult
$Res call({
 List<FileListItem> files,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class _$ArchiveFileListCopyWithImpl<$Res>
    implements $ArchiveFileListCopyWith<$Res> {
  _$ArchiveFileListCopyWithImpl(this._self, this._then);

  final ArchiveFileList _self;
  final $Res Function(ArchiveFileList) _then;

/// Create a copy of ArchiveFileList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? files = null,Object? nextCursor = freezed,}) {
  return _then(ArchiveFileList(
files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<FileListItem>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchiveFileList].
extension ArchiveFileListPatterns on ArchiveFileList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchiveFileList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchiveFileList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchiveFileList value)  $default,){
final _that = this;
switch (_that) {
case _ArchiveFileList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchiveFileList value)?  $default,){
final _that = this;
switch (_that) {
case _ArchiveFileList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<FileListItem> files, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchiveFileList() when $default != null:
return $default(_that.files,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<FileListItem> files, @JsonKey(name: 'next_cursor')  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _ArchiveFileList():
return $default(_that.files,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<FileListItem> files, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _ArchiveFileList() when $default != null:
return $default(_that.files,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArchiveFileList implements ArchiveFileList {
  const _ArchiveFileList({required  List<FileListItem> files, @JsonKey(name: 'next_cursor') this.nextCursor}): _files = files;
  factory _ArchiveFileList.fromJson(Map<String, dynamic> json) => _$ArchiveFileListFromJson(json);

 final  List<FileListItem> _files;
@override List<FileListItem> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}

@override@JsonKey(name: 'next_cursor') final  String? nextCursor;

/// Create a copy of ArchiveFileList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchiveFileListCopyWith<_ArchiveFileList> get copyWith => __$ArchiveFileListCopyWithImpl<_ArchiveFileList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArchiveFileListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchiveFileList&&const DeepCollectionEquality().equals(other.files, _files)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_files),nextCursor);
}

@override
String toString() {
    return 'ArchiveFileList(files: $files, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$ArchiveFileListCopyWith<$Res> implements $ArchiveFileListCopyWith<$Res> {
  factory _$ArchiveFileListCopyWith(_ArchiveFileList value, $Res Function(_ArchiveFileList) _then) = __$ArchiveFileListCopyWithImpl;
@override @useResult
$Res call({
 List<FileListItem> files,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class __$ArchiveFileListCopyWithImpl<$Res>
    implements _$ArchiveFileListCopyWith<$Res> {
  __$ArchiveFileListCopyWithImpl(this._self, this._then);

  final _ArchiveFileList _self;
  final $Res Function(_ArchiveFileList) _then;

/// Create a copy of ArchiveFileList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? files = null,Object? nextCursor = freezed,}) {
  return _then(_ArchiveFileList(
files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<FileListItem>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
