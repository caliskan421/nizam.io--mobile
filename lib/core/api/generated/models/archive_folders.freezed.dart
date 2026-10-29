// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'archive_folders.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ArchiveFolders {

 List<ArchiveFolder> get folders;
/// Create a copy of ArchiveFolders
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchiveFoldersCopyWith<ArchiveFolders> get copyWith => _$ArchiveFoldersCopyWithImpl<ArchiveFolders>(this as ArchiveFolders, _$identity);

  /// Serializes this ArchiveFolders to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ArchiveFolders;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchiveFolders&&const DeepCollectionEquality().equals(other.folders, _this.folders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ArchiveFolders;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.folders));
}

@override
String toString() {
  final _this = this as ArchiveFolders;
  return 'ArchiveFolders(folders: ${_this.folders})';
}


}

/// @nodoc
abstract mixin class $ArchiveFoldersCopyWith<$Res>  {
  factory $ArchiveFoldersCopyWith(ArchiveFolders value, $Res Function(ArchiveFolders) _then) = _$ArchiveFoldersCopyWithImpl;
@useResult
$Res call({
 List<ArchiveFolder> folders
});




}
/// @nodoc
class _$ArchiveFoldersCopyWithImpl<$Res>
    implements $ArchiveFoldersCopyWith<$Res> {
  _$ArchiveFoldersCopyWithImpl(this._self, this._then);

  final ArchiveFolders _self;
  final $Res Function(ArchiveFolders) _then;

/// Create a copy of ArchiveFolders
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? folders = null,}) {
  return _then(ArchiveFolders(
folders: null == folders ? _self.folders : folders // ignore: cast_nullable_to_non_nullable
as List<ArchiveFolder>,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchiveFolders].
extension ArchiveFoldersPatterns on ArchiveFolders {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchiveFolders value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchiveFolders() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchiveFolders value)  $default,){
final _that = this;
switch (_that) {
case _ArchiveFolders():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchiveFolders value)?  $default,){
final _that = this;
switch (_that) {
case _ArchiveFolders() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ArchiveFolder> folders)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchiveFolders() when $default != null:
return $default(_that.folders);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ArchiveFolder> folders)  $default,) {final _that = this;
switch (_that) {
case _ArchiveFolders():
return $default(_that.folders);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ArchiveFolder> folders)?  $default,) {final _that = this;
switch (_that) {
case _ArchiveFolders() when $default != null:
return $default(_that.folders);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArchiveFolders implements ArchiveFolders {
  const _ArchiveFolders({required  List<ArchiveFolder> folders}): _folders = folders;
  factory _ArchiveFolders.fromJson(Map<String, dynamic> json) => _$ArchiveFoldersFromJson(json);

 final  List<ArchiveFolder> _folders;
@override List<ArchiveFolder> get folders {
  if (_folders is EqualUnmodifiableListView) return _folders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_folders);
}


/// Create a copy of ArchiveFolders
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchiveFoldersCopyWith<_ArchiveFolders> get copyWith => __$ArchiveFoldersCopyWithImpl<_ArchiveFolders>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArchiveFoldersToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchiveFolders&&const DeepCollectionEquality().equals(other.folders, _folders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_folders));
}

@override
String toString() {
    return 'ArchiveFolders(folders: $folders)';
}


}

/// @nodoc
abstract mixin class _$ArchiveFoldersCopyWith<$Res> implements $ArchiveFoldersCopyWith<$Res> {
  factory _$ArchiveFoldersCopyWith(_ArchiveFolders value, $Res Function(_ArchiveFolders) _then) = __$ArchiveFoldersCopyWithImpl;
@override @useResult
$Res call({
 List<ArchiveFolder> folders
});




}
/// @nodoc
class __$ArchiveFoldersCopyWithImpl<$Res>
    implements _$ArchiveFoldersCopyWith<$Res> {
  __$ArchiveFoldersCopyWithImpl(this._self, this._then);

  final _ArchiveFolders _self;
  final $Res Function(_ArchiveFolders) _then;

/// Create a copy of ArchiveFolders
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? folders = null,}) {
  return _then(_ArchiveFolders(
folders: null == folders ? _self._folders : folders // ignore: cast_nullable_to_non_nullable
as List<ArchiveFolder>,
  ));
}


}

// dart format on
