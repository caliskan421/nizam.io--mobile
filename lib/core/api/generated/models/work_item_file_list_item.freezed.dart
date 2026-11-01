// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_item_file_list_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkItemFileListItem {

@JsonKey(name: 'file_id') String get fileId;@JsonKey(name: 'work_item_id') String get workItemId;@JsonKey(name: 'display_name') String get displayName;@JsonKey(name: 'content_type') String get contentType;@JsonKey(name: 'size_bytes') int get sizeBytes; String get tag;@JsonKey(name: 'uploaded_by_account_id') String get uploadedByAccountId;/// Yükleyenin görünen adı; satırı olmayan hesapta ya da ad okuması o an başarısızsa (geçici) `null`, silinmiş hesabın adı döner.
@JsonKey(name: 'uploaded_by_full_name') String? get uploadedByFullName;/// Dosyanın bağlı olduğu alt görev (ADR-0024); yoksa alan yoktur. Alt görev silinince boşalır.
@JsonKey(name: 'subtask_id') String? get subtaskId;
/// Create a copy of WorkItemFileListItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkItemFileListItemCopyWith<WorkItemFileListItem> get copyWith => _$WorkItemFileListItemCopyWithImpl<WorkItemFileListItem>(this as WorkItemFileListItem, _$identity);

  /// Serializes this WorkItemFileListItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkItemFileListItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkItemFileListItem&&(identical(other.fileId, _this.fileId) || other.fileId == _this.fileId)&&(identical(other.workItemId, _this.workItemId) || other.workItemId == _this.workItemId)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.contentType, _this.contentType) || other.contentType == _this.contentType)&&(identical(other.sizeBytes, _this.sizeBytes) || other.sizeBytes == _this.sizeBytes)&&(identical(other.tag, _this.tag) || other.tag == _this.tag)&&(identical(other.uploadedByAccountId, _this.uploadedByAccountId) || other.uploadedByAccountId == _this.uploadedByAccountId)&&(identical(other.uploadedByFullName, _this.uploadedByFullName) || other.uploadedByFullName == _this.uploadedByFullName)&&(identical(other.subtaskId, _this.subtaskId) || other.subtaskId == _this.subtaskId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkItemFileListItem;
  return Object.hash(runtimeType,_this.fileId,_this.workItemId,_this.displayName,_this.contentType,_this.sizeBytes,_this.tag,_this.uploadedByAccountId,_this.uploadedByFullName,_this.subtaskId);
}

@override
String toString() {
  final _this = this as WorkItemFileListItem;
  return 'WorkItemFileListItem(fileId: ${_this.fileId}, workItemId: ${_this.workItemId}, displayName: ${_this.displayName}, contentType: ${_this.contentType}, sizeBytes: ${_this.sizeBytes}, tag: ${_this.tag}, uploadedByAccountId: ${_this.uploadedByAccountId}, uploadedByFullName: ${_this.uploadedByFullName}, subtaskId: ${_this.subtaskId})';
}


}

/// @nodoc
abstract mixin class $WorkItemFileListItemCopyWith<$Res>  {
  factory $WorkItemFileListItemCopyWith(WorkItemFileListItem value, $Res Function(WorkItemFileListItem) _then) = _$WorkItemFileListItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'file_id') String fileId,@JsonKey(name: 'work_item_id') String workItemId,@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'content_type') String contentType,@JsonKey(name: 'size_bytes') int sizeBytes, String tag,@JsonKey(name: 'uploaded_by_account_id') String uploadedByAccountId,@JsonKey(name: 'uploaded_by_full_name') String? uploadedByFullName,@JsonKey(name: 'subtask_id') String? subtaskId
});




}
/// @nodoc
class _$WorkItemFileListItemCopyWithImpl<$Res>
    implements $WorkItemFileListItemCopyWith<$Res> {
  _$WorkItemFileListItemCopyWithImpl(this._self, this._then);

  final WorkItemFileListItem _self;
  final $Res Function(WorkItemFileListItem) _then;

/// Create a copy of WorkItemFileListItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileId = null,Object? workItemId = null,Object? displayName = null,Object? contentType = null,Object? sizeBytes = null,Object? tag = null,Object? uploadedByAccountId = null,Object? uploadedByFullName = freezed,Object? subtaskId = freezed,}) {
  return _then(WorkItemFileListItem(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,uploadedByAccountId: null == uploadedByAccountId ? _self.uploadedByAccountId : uploadedByAccountId // ignore: cast_nullable_to_non_nullable
as String,uploadedByFullName: freezed == uploadedByFullName ? _self.uploadedByFullName : uploadedByFullName // ignore: cast_nullable_to_non_nullable
as String?,subtaskId: freezed == subtaskId ? _self.subtaskId : subtaskId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkItemFileListItem].
extension WorkItemFileListItemPatterns on WorkItemFileListItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkItemFileListItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkItemFileListItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkItemFileListItem value)  $default,){
final _that = this;
switch (_that) {
case _WorkItemFileListItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkItemFileListItem value)?  $default,){
final _that = this;
switch (_that) {
case _WorkItemFileListItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'file_id')  String fileId, @JsonKey(name: 'work_item_id')  String workItemId, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'content_type')  String contentType, @JsonKey(name: 'size_bytes')  int sizeBytes,  String tag, @JsonKey(name: 'uploaded_by_account_id')  String uploadedByAccountId, @JsonKey(name: 'uploaded_by_full_name')  String? uploadedByFullName, @JsonKey(name: 'subtask_id')  String? subtaskId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkItemFileListItem() when $default != null:
return $default(_that.fileId,_that.workItemId,_that.displayName,_that.contentType,_that.sizeBytes,_that.tag,_that.uploadedByAccountId,_that.uploadedByFullName,_that.subtaskId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'file_id')  String fileId, @JsonKey(name: 'work_item_id')  String workItemId, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'content_type')  String contentType, @JsonKey(name: 'size_bytes')  int sizeBytes,  String tag, @JsonKey(name: 'uploaded_by_account_id')  String uploadedByAccountId, @JsonKey(name: 'uploaded_by_full_name')  String? uploadedByFullName, @JsonKey(name: 'subtask_id')  String? subtaskId)  $default,) {final _that = this;
switch (_that) {
case _WorkItemFileListItem():
return $default(_that.fileId,_that.workItemId,_that.displayName,_that.contentType,_that.sizeBytes,_that.tag,_that.uploadedByAccountId,_that.uploadedByFullName,_that.subtaskId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'file_id')  String fileId, @JsonKey(name: 'work_item_id')  String workItemId, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'content_type')  String contentType, @JsonKey(name: 'size_bytes')  int sizeBytes,  String tag, @JsonKey(name: 'uploaded_by_account_id')  String uploadedByAccountId, @JsonKey(name: 'uploaded_by_full_name')  String? uploadedByFullName, @JsonKey(name: 'subtask_id')  String? subtaskId)?  $default,) {final _that = this;
switch (_that) {
case _WorkItemFileListItem() when $default != null:
return $default(_that.fileId,_that.workItemId,_that.displayName,_that.contentType,_that.sizeBytes,_that.tag,_that.uploadedByAccountId,_that.uploadedByFullName,_that.subtaskId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkItemFileListItem implements WorkItemFileListItem {
  const _WorkItemFileListItem({@JsonKey(name: 'file_id') required this.fileId, @JsonKey(name: 'work_item_id') required this.workItemId, @JsonKey(name: 'display_name') required this.displayName, @JsonKey(name: 'content_type') required this.contentType, @JsonKey(name: 'size_bytes') required this.sizeBytes, required this.tag, @JsonKey(name: 'uploaded_by_account_id') required this.uploadedByAccountId, @JsonKey(name: 'uploaded_by_full_name') required this.uploadedByFullName, @JsonKey(name: 'subtask_id') this.subtaskId});
  factory _WorkItemFileListItem.fromJson(Map<String, dynamic> json) => _$WorkItemFileListItemFromJson(json);

@override@JsonKey(name: 'file_id') final  String fileId;
@override@JsonKey(name: 'work_item_id') final  String workItemId;
@override@JsonKey(name: 'display_name') final  String displayName;
@override@JsonKey(name: 'content_type') final  String contentType;
@override@JsonKey(name: 'size_bytes') final  int sizeBytes;
@override final  String tag;
@override@JsonKey(name: 'uploaded_by_account_id') final  String uploadedByAccountId;
/// Yükleyenin görünen adı; satırı olmayan hesapta ya da ad okuması o an başarısızsa (geçici) `null`, silinmiş hesabın adı döner.
@override@JsonKey(name: 'uploaded_by_full_name') final  String? uploadedByFullName;
/// Dosyanın bağlı olduğu alt görev (ADR-0024); yoksa alan yoktur. Alt görev silinince boşalır.
@override@JsonKey(name: 'subtask_id') final  String? subtaskId;

/// Create a copy of WorkItemFileListItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkItemFileListItemCopyWith<_WorkItemFileListItem> get copyWith => __$WorkItemFileListItemCopyWithImpl<_WorkItemFileListItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkItemFileListItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkItemFileListItem&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.workItemId, workItemId) || other.workItemId == workItemId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.uploadedByAccountId, uploadedByAccountId) || other.uploadedByAccountId == uploadedByAccountId)&&(identical(other.uploadedByFullName, uploadedByFullName) || other.uploadedByFullName == uploadedByFullName)&&(identical(other.subtaskId, subtaskId) || other.subtaskId == subtaskId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,fileId,workItemId,displayName,contentType,sizeBytes,tag,uploadedByAccountId,uploadedByFullName,subtaskId);
}

@override
String toString() {
    return 'WorkItemFileListItem(fileId: $fileId, workItemId: $workItemId, displayName: $displayName, contentType: $contentType, sizeBytes: $sizeBytes, tag: $tag, uploadedByAccountId: $uploadedByAccountId, uploadedByFullName: $uploadedByFullName, subtaskId: $subtaskId)';
}


}

/// @nodoc
abstract mixin class _$WorkItemFileListItemCopyWith<$Res> implements $WorkItemFileListItemCopyWith<$Res> {
  factory _$WorkItemFileListItemCopyWith(_WorkItemFileListItem value, $Res Function(_WorkItemFileListItem) _then) = __$WorkItemFileListItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'file_id') String fileId,@JsonKey(name: 'work_item_id') String workItemId,@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'content_type') String contentType,@JsonKey(name: 'size_bytes') int sizeBytes, String tag,@JsonKey(name: 'uploaded_by_account_id') String uploadedByAccountId,@JsonKey(name: 'uploaded_by_full_name') String? uploadedByFullName,@JsonKey(name: 'subtask_id') String? subtaskId
});




}
/// @nodoc
class __$WorkItemFileListItemCopyWithImpl<$Res>
    implements _$WorkItemFileListItemCopyWith<$Res> {
  __$WorkItemFileListItemCopyWithImpl(this._self, this._then);

  final _WorkItemFileListItem _self;
  final $Res Function(_WorkItemFileListItem) _then;

/// Create a copy of WorkItemFileListItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileId = null,Object? workItemId = null,Object? displayName = null,Object? contentType = null,Object? sizeBytes = null,Object? tag = null,Object? uploadedByAccountId = null,Object? uploadedByFullName = freezed,Object? subtaskId = freezed,}) {
  return _then(_WorkItemFileListItem(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,uploadedByAccountId: null == uploadedByAccountId ? _self.uploadedByAccountId : uploadedByAccountId // ignore: cast_nullable_to_non_nullable
as String,uploadedByFullName: freezed == uploadedByFullName ? _self.uploadedByFullName : uploadedByFullName // ignore: cast_nullable_to_non_nullable
as String?,subtaskId: freezed == subtaskId ? _self.subtaskId : subtaskId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
