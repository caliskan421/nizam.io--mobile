// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_ref_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatRefSummary {

@JsonKey(name: 'ref_id') String get refId; ChatRefSummaryKind get kind;@JsonKey(name: 'target_id') String get targetId;@JsonKey(name: 'chat_id') String get chatId;@JsonKey(name: 'message_id') String get messageId;/// `false` ise hedef artık yoktur; kart alanları gelmez.
 bool get available; Task? get task; ChatRefSummaryDepartment? get department; File? get file;
/// Create a copy of ChatRefSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatRefSummaryCopyWith<ChatRefSummary> get copyWith => _$ChatRefSummaryCopyWithImpl<ChatRefSummary>(this as ChatRefSummary, _$identity);

  /// Serializes this ChatRefSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatRefSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatRefSummary&&(identical(other.refId, _this.refId) || other.refId == _this.refId)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.targetId, _this.targetId) || other.targetId == _this.targetId)&&(identical(other.chatId, _this.chatId) || other.chatId == _this.chatId)&&(identical(other.messageId, _this.messageId) || other.messageId == _this.messageId)&&(identical(other.available, _this.available) || other.available == _this.available)&&(identical(other.task, _this.task) || other.task == _this.task)&&(identical(other.department, _this.department) || other.department == _this.department)&&(identical(other.file, _this.file) || other.file == _this.file));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatRefSummary;
  return Object.hash(runtimeType,_this.refId,_this.kind,_this.targetId,_this.chatId,_this.messageId,_this.available,_this.task,_this.department,_this.file);
}

@override
String toString() {
  final _this = this as ChatRefSummary;
  return 'ChatRefSummary(refId: ${_this.refId}, kind: ${_this.kind}, targetId: ${_this.targetId}, chatId: ${_this.chatId}, messageId: ${_this.messageId}, available: ${_this.available}, task: ${_this.task}, department: ${_this.department}, file: ${_this.file})';
}


}

/// @nodoc
abstract mixin class $ChatRefSummaryCopyWith<$Res>  {
  factory $ChatRefSummaryCopyWith(ChatRefSummary value, $Res Function(ChatRefSummary) _then) = _$ChatRefSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ref_id') String refId, ChatRefSummaryKind kind,@JsonKey(name: 'target_id') String targetId,@JsonKey(name: 'chat_id') String chatId,@JsonKey(name: 'message_id') String messageId, bool available, Task? task, ChatRefSummaryDepartment? department, File? file
});


$TaskCopyWith<$Res>? get task;$ChatRefSummaryDepartmentCopyWith<$Res>? get department;$FileCopyWith<$Res>? get file;

}
/// @nodoc
class _$ChatRefSummaryCopyWithImpl<$Res>
    implements $ChatRefSummaryCopyWith<$Res> {
  _$ChatRefSummaryCopyWithImpl(this._self, this._then);

  final ChatRefSummary _self;
  final $Res Function(ChatRefSummary) _then;

/// Create a copy of ChatRefSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? refId = null,Object? kind = null,Object? targetId = null,Object? chatId = null,Object? messageId = null,Object? available = null,Object? task = freezed,Object? department = freezed,Object? file = freezed,}) {
  return _then(ChatRefSummary(
refId: null == refId ? _self.refId : refId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChatRefSummaryKind,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,task: freezed == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as Task?,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as ChatRefSummaryDepartment?,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as File?,
  ));
}
/// Create a copy of ChatRefSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskCopyWith<$Res>? get task {
    if (_self.task == null) {
    return null;
  }

  return $TaskCopyWith<$Res>(_self.task!, (value) {
    return _then(_self.copyWith(task: value));
  });
}/// Create a copy of ChatRefSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatRefSummaryDepartmentCopyWith<$Res>? get department {
    if (_self.department == null) {
    return null;
  }

  return $ChatRefSummaryDepartmentCopyWith<$Res>(_self.department!, (value) {
    return _then(_self.copyWith(department: value));
  });
}/// Create a copy of ChatRefSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FileCopyWith<$Res>? get file {
    if (_self.file == null) {
    return null;
  }

  return $FileCopyWith<$Res>(_self.file!, (value) {
    return _then(_self.copyWith(file: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatRefSummary].
extension ChatRefSummaryPatterns on ChatRefSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatRefSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatRefSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatRefSummary value)  $default,){
final _that = this;
switch (_that) {
case _ChatRefSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatRefSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ChatRefSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ref_id')  String refId,  ChatRefSummaryKind kind, @JsonKey(name: 'target_id')  String targetId, @JsonKey(name: 'chat_id')  String chatId, @JsonKey(name: 'message_id')  String messageId,  bool available,  Task? task,  ChatRefSummaryDepartment? department,  File? file)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatRefSummary() when $default != null:
return $default(_that.refId,_that.kind,_that.targetId,_that.chatId,_that.messageId,_that.available,_that.task,_that.department,_that.file);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ref_id')  String refId,  ChatRefSummaryKind kind, @JsonKey(name: 'target_id')  String targetId, @JsonKey(name: 'chat_id')  String chatId, @JsonKey(name: 'message_id')  String messageId,  bool available,  Task? task,  ChatRefSummaryDepartment? department,  File? file)  $default,) {final _that = this;
switch (_that) {
case _ChatRefSummary():
return $default(_that.refId,_that.kind,_that.targetId,_that.chatId,_that.messageId,_that.available,_that.task,_that.department,_that.file);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ref_id')  String refId,  ChatRefSummaryKind kind, @JsonKey(name: 'target_id')  String targetId, @JsonKey(name: 'chat_id')  String chatId, @JsonKey(name: 'message_id')  String messageId,  bool available,  Task? task,  ChatRefSummaryDepartment? department,  File? file)?  $default,) {final _that = this;
switch (_that) {
case _ChatRefSummary() when $default != null:
return $default(_that.refId,_that.kind,_that.targetId,_that.chatId,_that.messageId,_that.available,_that.task,_that.department,_that.file);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatRefSummary implements ChatRefSummary {
  const _ChatRefSummary({@JsonKey(name: 'ref_id') required this.refId, required this.kind, @JsonKey(name: 'target_id') required this.targetId, @JsonKey(name: 'chat_id') required this.chatId, @JsonKey(name: 'message_id') required this.messageId, required this.available, this.task, this.department, this.file});
  factory _ChatRefSummary.fromJson(Map<String, dynamic> json) => _$ChatRefSummaryFromJson(json);

@override@JsonKey(name: 'ref_id') final  String refId;
@override final  ChatRefSummaryKind kind;
@override@JsonKey(name: 'target_id') final  String targetId;
@override@JsonKey(name: 'chat_id') final  String chatId;
@override@JsonKey(name: 'message_id') final  String messageId;
/// `false` ise hedef artık yoktur; kart alanları gelmez.
@override final  bool available;
@override final  Task? task;
@override final  ChatRefSummaryDepartment? department;
@override final  File? file;

/// Create a copy of ChatRefSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatRefSummaryCopyWith<_ChatRefSummary> get copyWith => __$ChatRefSummaryCopyWithImpl<_ChatRefSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatRefSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatRefSummary&&(identical(other.refId, refId) || other.refId == refId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.available, available) || other.available == available)&&(identical(other.task, task) || other.task == task)&&(identical(other.department, department) || other.department == department)&&(identical(other.file, file) || other.file == file));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,refId,kind,targetId,chatId,messageId,available,task,department,file);
}

@override
String toString() {
    return 'ChatRefSummary(refId: $refId, kind: $kind, targetId: $targetId, chatId: $chatId, messageId: $messageId, available: $available, task: $task, department: $department, file: $file)';
}


}

/// @nodoc
abstract mixin class _$ChatRefSummaryCopyWith<$Res> implements $ChatRefSummaryCopyWith<$Res> {
  factory _$ChatRefSummaryCopyWith(_ChatRefSummary value, $Res Function(_ChatRefSummary) _then) = __$ChatRefSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ref_id') String refId, ChatRefSummaryKind kind,@JsonKey(name: 'target_id') String targetId,@JsonKey(name: 'chat_id') String chatId,@JsonKey(name: 'message_id') String messageId, bool available, Task? task, ChatRefSummaryDepartment? department, File? file
});


@override $TaskCopyWith<$Res>? get task;@override $ChatRefSummaryDepartmentCopyWith<$Res>? get department;@override $FileCopyWith<$Res>? get file;

}
/// @nodoc
class __$ChatRefSummaryCopyWithImpl<$Res>
    implements _$ChatRefSummaryCopyWith<$Res> {
  __$ChatRefSummaryCopyWithImpl(this._self, this._then);

  final _ChatRefSummary _self;
  final $Res Function(_ChatRefSummary) _then;

/// Create a copy of ChatRefSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? refId = null,Object? kind = null,Object? targetId = null,Object? chatId = null,Object? messageId = null,Object? available = null,Object? task = freezed,Object? department = freezed,Object? file = freezed,}) {
  return _then(_ChatRefSummary(
refId: null == refId ? _self.refId : refId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChatRefSummaryKind,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,task: freezed == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as Task?,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as ChatRefSummaryDepartment?,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as File?,
  ));
}

/// Create a copy of ChatRefSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskCopyWith<$Res>? get task {
    if (_self.task == null) {
    return null;
  }

  return $TaskCopyWith<$Res>(_self.task!, (value) {
    return _then(_self.copyWith(task: value));
  });
}/// Create a copy of ChatRefSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatRefSummaryDepartmentCopyWith<$Res>? get department {
    if (_self.department == null) {
    return null;
  }

  return $ChatRefSummaryDepartmentCopyWith<$Res>(_self.department!, (value) {
    return _then(_self.copyWith(department: value));
  });
}/// Create a copy of ChatRefSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FileCopyWith<$Res>? get file {
    if (_self.file == null) {
    return null;
  }

  return $FileCopyWith<$Res>(_self.file!, (value) {
    return _then(_self.copyWith(file: value));
  });
}
}

// dart format on
