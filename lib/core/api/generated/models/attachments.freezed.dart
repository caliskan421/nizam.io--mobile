// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attachments.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Attachments {

@JsonKey(name: 'attachment_id') String get attachmentId;@JsonKey(name: 'file_name') String get fileName;@JsonKey(name: 'content_type') String get contentType;@JsonKey(name: 'size_bytes') int get sizeBytes;
/// Create a copy of Attachments
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachmentsCopyWith<Attachments> get copyWith => _$AttachmentsCopyWithImpl<Attachments>(this as Attachments, _$identity);

  /// Serializes this Attachments to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Attachments;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Attachments&&(identical(other.attachmentId, _this.attachmentId) || other.attachmentId == _this.attachmentId)&&(identical(other.fileName, _this.fileName) || other.fileName == _this.fileName)&&(identical(other.contentType, _this.contentType) || other.contentType == _this.contentType)&&(identical(other.sizeBytes, _this.sizeBytes) || other.sizeBytes == _this.sizeBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Attachments;
  return Object.hash(runtimeType,_this.attachmentId,_this.fileName,_this.contentType,_this.sizeBytes);
}

@override
String toString() {
  final _this = this as Attachments;
  return 'Attachments(attachmentId: ${_this.attachmentId}, fileName: ${_this.fileName}, contentType: ${_this.contentType}, sizeBytes: ${_this.sizeBytes})';
}


}

/// @nodoc
abstract mixin class $AttachmentsCopyWith<$Res>  {
  factory $AttachmentsCopyWith(Attachments value, $Res Function(Attachments) _then) = _$AttachmentsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'attachment_id') String attachmentId,@JsonKey(name: 'file_name') String fileName,@JsonKey(name: 'content_type') String contentType,@JsonKey(name: 'size_bytes') int sizeBytes
});




}
/// @nodoc
class _$AttachmentsCopyWithImpl<$Res>
    implements $AttachmentsCopyWith<$Res> {
  _$AttachmentsCopyWithImpl(this._self, this._then);

  final Attachments _self;
  final $Res Function(Attachments) _then;

/// Create a copy of Attachments
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attachmentId = null,Object? fileName = null,Object? contentType = null,Object? sizeBytes = null,}) {
  return _then(Attachments(
attachmentId: null == attachmentId ? _self.attachmentId : attachmentId // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Attachments].
extension AttachmentsPatterns on Attachments {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Attachments value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Attachments() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Attachments value)  $default,){
final _that = this;
switch (_that) {
case _Attachments():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Attachments value)?  $default,){
final _that = this;
switch (_that) {
case _Attachments() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'attachment_id')  String attachmentId, @JsonKey(name: 'file_name')  String fileName, @JsonKey(name: 'content_type')  String contentType, @JsonKey(name: 'size_bytes')  int sizeBytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Attachments() when $default != null:
return $default(_that.attachmentId,_that.fileName,_that.contentType,_that.sizeBytes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'attachment_id')  String attachmentId, @JsonKey(name: 'file_name')  String fileName, @JsonKey(name: 'content_type')  String contentType, @JsonKey(name: 'size_bytes')  int sizeBytes)  $default,) {final _that = this;
switch (_that) {
case _Attachments():
return $default(_that.attachmentId,_that.fileName,_that.contentType,_that.sizeBytes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'attachment_id')  String attachmentId, @JsonKey(name: 'file_name')  String fileName, @JsonKey(name: 'content_type')  String contentType, @JsonKey(name: 'size_bytes')  int sizeBytes)?  $default,) {final _that = this;
switch (_that) {
case _Attachments() when $default != null:
return $default(_that.attachmentId,_that.fileName,_that.contentType,_that.sizeBytes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Attachments implements Attachments {
  const _Attachments({@JsonKey(name: 'attachment_id') required this.attachmentId, @JsonKey(name: 'file_name') required this.fileName, @JsonKey(name: 'content_type') required this.contentType, @JsonKey(name: 'size_bytes') required this.sizeBytes});
  factory _Attachments.fromJson(Map<String, dynamic> json) => _$AttachmentsFromJson(json);

@override@JsonKey(name: 'attachment_id') final  String attachmentId;
@override@JsonKey(name: 'file_name') final  String fileName;
@override@JsonKey(name: 'content_type') final  String contentType;
@override@JsonKey(name: 'size_bytes') final  int sizeBytes;

/// Create a copy of Attachments
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachmentsCopyWith<_Attachments> get copyWith => __$AttachmentsCopyWithImpl<_Attachments>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttachmentsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Attachments&&(identical(other.attachmentId, attachmentId) || other.attachmentId == attachmentId)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,attachmentId,fileName,contentType,sizeBytes);
}

@override
String toString() {
    return 'Attachments(attachmentId: $attachmentId, fileName: $fileName, contentType: $contentType, sizeBytes: $sizeBytes)';
}


}

/// @nodoc
abstract mixin class _$AttachmentsCopyWith<$Res> implements $AttachmentsCopyWith<$Res> {
  factory _$AttachmentsCopyWith(_Attachments value, $Res Function(_Attachments) _then) = __$AttachmentsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'attachment_id') String attachmentId,@JsonKey(name: 'file_name') String fileName,@JsonKey(name: 'content_type') String contentType,@JsonKey(name: 'size_bytes') int sizeBytes
});




}
/// @nodoc
class __$AttachmentsCopyWithImpl<$Res>
    implements _$AttachmentsCopyWith<$Res> {
  __$AttachmentsCopyWithImpl(this._self, this._then);

  final _Attachments _self;
  final $Res Function(_Attachments) _then;

/// Create a copy of Attachments
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attachmentId = null,Object? fileName = null,Object? contentType = null,Object? sizeBytes = null,}) {
  return _then(_Attachments(
attachmentId: null == attachmentId ? _self.attachmentId : attachmentId // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
