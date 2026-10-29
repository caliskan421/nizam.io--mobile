// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'archive_folder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ArchiveFolder {

@JsonKey(name: 'folder_id') String get folderId; String get name;@JsonKey(name: 'file_count') int get fileCount;/// Üyenin "Görevlerim" sanal klasörü.
@JsonKey(name: 'is_virtual') bool get isVirtual;
/// Create a copy of ArchiveFolder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchiveFolderCopyWith<ArchiveFolder> get copyWith => _$ArchiveFolderCopyWithImpl<ArchiveFolder>(this as ArchiveFolder, _$identity);

  /// Serializes this ArchiveFolder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ArchiveFolder;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchiveFolder&&(identical(other.folderId, _this.folderId) || other.folderId == _this.folderId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.fileCount, _this.fileCount) || other.fileCount == _this.fileCount)&&(identical(other.isVirtual, _this.isVirtual) || other.isVirtual == _this.isVirtual));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ArchiveFolder;
  return Object.hash(runtimeType,_this.folderId,_this.name,_this.fileCount,_this.isVirtual);
}

@override
String toString() {
  final _this = this as ArchiveFolder;
  return 'ArchiveFolder(folderId: ${_this.folderId}, name: ${_this.name}, fileCount: ${_this.fileCount}, isVirtual: ${_this.isVirtual})';
}


}

/// @nodoc
abstract mixin class $ArchiveFolderCopyWith<$Res>  {
  factory $ArchiveFolderCopyWith(ArchiveFolder value, $Res Function(ArchiveFolder) _then) = _$ArchiveFolderCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'folder_id') String folderId, String name,@JsonKey(name: 'file_count') int fileCount,@JsonKey(name: 'is_virtual') bool isVirtual
});




}
/// @nodoc
class _$ArchiveFolderCopyWithImpl<$Res>
    implements $ArchiveFolderCopyWith<$Res> {
  _$ArchiveFolderCopyWithImpl(this._self, this._then);

  final ArchiveFolder _self;
  final $Res Function(ArchiveFolder) _then;

/// Create a copy of ArchiveFolder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? folderId = null,Object? name = null,Object? fileCount = null,Object? isVirtual = null,}) {
  return _then(ArchiveFolder(
folderId: null == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fileCount: null == fileCount ? _self.fileCount : fileCount // ignore: cast_nullable_to_non_nullable
as int,isVirtual: null == isVirtual ? _self.isVirtual : isVirtual // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchiveFolder].
extension ArchiveFolderPatterns on ArchiveFolder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchiveFolder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchiveFolder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchiveFolder value)  $default,){
final _that = this;
switch (_that) {
case _ArchiveFolder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchiveFolder value)?  $default,){
final _that = this;
switch (_that) {
case _ArchiveFolder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'folder_id')  String folderId,  String name, @JsonKey(name: 'file_count')  int fileCount, @JsonKey(name: 'is_virtual')  bool isVirtual)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchiveFolder() when $default != null:
return $default(_that.folderId,_that.name,_that.fileCount,_that.isVirtual);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'folder_id')  String folderId,  String name, @JsonKey(name: 'file_count')  int fileCount, @JsonKey(name: 'is_virtual')  bool isVirtual)  $default,) {final _that = this;
switch (_that) {
case _ArchiveFolder():
return $default(_that.folderId,_that.name,_that.fileCount,_that.isVirtual);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'folder_id')  String folderId,  String name, @JsonKey(name: 'file_count')  int fileCount, @JsonKey(name: 'is_virtual')  bool isVirtual)?  $default,) {final _that = this;
switch (_that) {
case _ArchiveFolder() when $default != null:
return $default(_that.folderId,_that.name,_that.fileCount,_that.isVirtual);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArchiveFolder implements ArchiveFolder {
  const _ArchiveFolder({@JsonKey(name: 'folder_id') required this.folderId, required this.name, @JsonKey(name: 'file_count') required this.fileCount, @JsonKey(name: 'is_virtual') required this.isVirtual});
  factory _ArchiveFolder.fromJson(Map<String, dynamic> json) => _$ArchiveFolderFromJson(json);

@override@JsonKey(name: 'folder_id') final  String folderId;
@override final  String name;
@override@JsonKey(name: 'file_count') final  int fileCount;
/// Üyenin "Görevlerim" sanal klasörü.
@override@JsonKey(name: 'is_virtual') final  bool isVirtual;

/// Create a copy of ArchiveFolder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchiveFolderCopyWith<_ArchiveFolder> get copyWith => __$ArchiveFolderCopyWithImpl<_ArchiveFolder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArchiveFolderToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchiveFolder&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.name, name) || other.name == name)&&(identical(other.fileCount, fileCount) || other.fileCount == fileCount)&&(identical(other.isVirtual, isVirtual) || other.isVirtual == isVirtual));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,folderId,name,fileCount,isVirtual);
}

@override
String toString() {
    return 'ArchiveFolder(folderId: $folderId, name: $name, fileCount: $fileCount, isVirtual: $isVirtual)';
}


}

/// @nodoc
abstract mixin class _$ArchiveFolderCopyWith<$Res> implements $ArchiveFolderCopyWith<$Res> {
  factory _$ArchiveFolderCopyWith(_ArchiveFolder value, $Res Function(_ArchiveFolder) _then) = __$ArchiveFolderCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'folder_id') String folderId, String name,@JsonKey(name: 'file_count') int fileCount,@JsonKey(name: 'is_virtual') bool isVirtual
});




}
/// @nodoc
class __$ArchiveFolderCopyWithImpl<$Res>
    implements _$ArchiveFolderCopyWith<$Res> {
  __$ArchiveFolderCopyWithImpl(this._self, this._then);

  final _ArchiveFolder _self;
  final $Res Function(_ArchiveFolder) _then;

/// Create a copy of ArchiveFolder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? folderId = null,Object? name = null,Object? fileCount = null,Object? isVirtual = null,}) {
  return _then(_ArchiveFolder(
folderId: null == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fileCount: null == fileCount ? _self.fileCount : fileCount // ignore: cast_nullable_to_non_nullable
as int,isVirtual: null == isVirtual ? _self.isVirtual : isVirtual // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
