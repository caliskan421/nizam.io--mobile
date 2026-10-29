// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_record_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FileRecordList {

 List<FileListItem> get files;
/// Create a copy of FileRecordList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileRecordListCopyWith<FileRecordList> get copyWith => _$FileRecordListCopyWithImpl<FileRecordList>(this as FileRecordList, _$identity);

  /// Serializes this FileRecordList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FileRecordList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileRecordList&&const DeepCollectionEquality().equals(other.files, _this.files));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FileRecordList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.files));
}

@override
String toString() {
  final _this = this as FileRecordList;
  return 'FileRecordList(files: ${_this.files})';
}


}

/// @nodoc
abstract mixin class $FileRecordListCopyWith<$Res>  {
  factory $FileRecordListCopyWith(FileRecordList value, $Res Function(FileRecordList) _then) = _$FileRecordListCopyWithImpl;
@useResult
$Res call({
 List<FileListItem> files
});




}
/// @nodoc
class _$FileRecordListCopyWithImpl<$Res>
    implements $FileRecordListCopyWith<$Res> {
  _$FileRecordListCopyWithImpl(this._self, this._then);

  final FileRecordList _self;
  final $Res Function(FileRecordList) _then;

/// Create a copy of FileRecordList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? files = null,}) {
  return _then(FileRecordList(
files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<FileListItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [FileRecordList].
extension FileRecordListPatterns on FileRecordList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileRecordList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileRecordList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileRecordList value)  $default,){
final _that = this;
switch (_that) {
case _FileRecordList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileRecordList value)?  $default,){
final _that = this;
switch (_that) {
case _FileRecordList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<FileListItem> files)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileRecordList() when $default != null:
return $default(_that.files);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<FileListItem> files)  $default,) {final _that = this;
switch (_that) {
case _FileRecordList():
return $default(_that.files);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<FileListItem> files)?  $default,) {final _that = this;
switch (_that) {
case _FileRecordList() when $default != null:
return $default(_that.files);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FileRecordList implements FileRecordList {
  const _FileRecordList({required  List<FileListItem> files}): _files = files;
  factory _FileRecordList.fromJson(Map<String, dynamic> json) => _$FileRecordListFromJson(json);

 final  List<FileListItem> _files;
@override List<FileListItem> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}


/// Create a copy of FileRecordList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileRecordListCopyWith<_FileRecordList> get copyWith => __$FileRecordListCopyWithImpl<_FileRecordList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FileRecordListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileRecordList&&const DeepCollectionEquality().equals(other.files, _files));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_files));
}

@override
String toString() {
    return 'FileRecordList(files: $files)';
}


}

/// @nodoc
abstract mixin class _$FileRecordListCopyWith<$Res> implements $FileRecordListCopyWith<$Res> {
  factory _$FileRecordListCopyWith(_FileRecordList value, $Res Function(_FileRecordList) _then) = __$FileRecordListCopyWithImpl;
@override @useResult
$Res call({
 List<FileListItem> files
});




}
/// @nodoc
class __$FileRecordListCopyWithImpl<$Res>
    implements _$FileRecordListCopyWith<$Res> {
  __$FileRecordListCopyWithImpl(this._self, this._then);

  final _FileRecordList _self;
  final $Res Function(_FileRecordList) _then;

/// Create a copy of FileRecordList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? files = null,}) {
  return _then(_FileRecordList(
files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<FileListItem>,
  ));
}


}

// dart format on
