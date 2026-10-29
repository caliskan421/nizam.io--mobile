// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'archive_uploaders.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ArchiveUploaders {

 List<String> get uploaders;
/// Create a copy of ArchiveUploaders
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchiveUploadersCopyWith<ArchiveUploaders> get copyWith => _$ArchiveUploadersCopyWithImpl<ArchiveUploaders>(this as ArchiveUploaders, _$identity);

  /// Serializes this ArchiveUploaders to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ArchiveUploaders;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchiveUploaders&&const DeepCollectionEquality().equals(other.uploaders, _this.uploaders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ArchiveUploaders;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.uploaders));
}

@override
String toString() {
  final _this = this as ArchiveUploaders;
  return 'ArchiveUploaders(uploaders: ${_this.uploaders})';
}


}

/// @nodoc
abstract mixin class $ArchiveUploadersCopyWith<$Res>  {
  factory $ArchiveUploadersCopyWith(ArchiveUploaders value, $Res Function(ArchiveUploaders) _then) = _$ArchiveUploadersCopyWithImpl;
@useResult
$Res call({
 List<String> uploaders
});




}
/// @nodoc
class _$ArchiveUploadersCopyWithImpl<$Res>
    implements $ArchiveUploadersCopyWith<$Res> {
  _$ArchiveUploadersCopyWithImpl(this._self, this._then);

  final ArchiveUploaders _self;
  final $Res Function(ArchiveUploaders) _then;

/// Create a copy of ArchiveUploaders
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uploaders = null,}) {
  return _then(ArchiveUploaders(
uploaders: null == uploaders ? _self.uploaders : uploaders // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchiveUploaders].
extension ArchiveUploadersPatterns on ArchiveUploaders {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchiveUploaders value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchiveUploaders() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchiveUploaders value)  $default,){
final _that = this;
switch (_that) {
case _ArchiveUploaders():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchiveUploaders value)?  $default,){
final _that = this;
switch (_that) {
case _ArchiveUploaders() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> uploaders)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchiveUploaders() when $default != null:
return $default(_that.uploaders);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> uploaders)  $default,) {final _that = this;
switch (_that) {
case _ArchiveUploaders():
return $default(_that.uploaders);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> uploaders)?  $default,) {final _that = this;
switch (_that) {
case _ArchiveUploaders() when $default != null:
return $default(_that.uploaders);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArchiveUploaders implements ArchiveUploaders {
  const _ArchiveUploaders({required  List<String> uploaders}): _uploaders = uploaders;
  factory _ArchiveUploaders.fromJson(Map<String, dynamic> json) => _$ArchiveUploadersFromJson(json);

 final  List<String> _uploaders;
@override List<String> get uploaders {
  if (_uploaders is EqualUnmodifiableListView) return _uploaders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_uploaders);
}


/// Create a copy of ArchiveUploaders
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchiveUploadersCopyWith<_ArchiveUploaders> get copyWith => __$ArchiveUploadersCopyWithImpl<_ArchiveUploaders>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArchiveUploadersToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchiveUploaders&&const DeepCollectionEquality().equals(other.uploaders, _uploaders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_uploaders));
}

@override
String toString() {
    return 'ArchiveUploaders(uploaders: $uploaders)';
}


}

/// @nodoc
abstract mixin class _$ArchiveUploadersCopyWith<$Res> implements $ArchiveUploadersCopyWith<$Res> {
  factory _$ArchiveUploadersCopyWith(_ArchiveUploaders value, $Res Function(_ArchiveUploaders) _then) = __$ArchiveUploadersCopyWithImpl;
@override @useResult
$Res call({
 List<String> uploaders
});




}
/// @nodoc
class __$ArchiveUploadersCopyWithImpl<$Res>
    implements _$ArchiveUploadersCopyWith<$Res> {
  __$ArchiveUploadersCopyWithImpl(this._self, this._then);

  final _ArchiveUploaders _self;
  final $Res Function(_ArchiveUploaders) _then;

/// Create a copy of ArchiveUploaders
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uploaders = null,}) {
  return _then(_ArchiveUploaders(
uploaders: null == uploaders ? _self._uploaders : uploaders // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
