// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_task_created.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMessageTaskCreated {

@JsonKey(name: 'work_item_id') String get workItemId; ChatMessage get message;
/// Create a copy of ChatMessageTaskCreated
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageTaskCreatedCopyWith<ChatMessageTaskCreated> get copyWith => _$ChatMessageTaskCreatedCopyWithImpl<ChatMessageTaskCreated>(this as ChatMessageTaskCreated, _$identity);

  /// Serializes this ChatMessageTaskCreated to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatMessageTaskCreated;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessageTaskCreated&&(identical(other.workItemId, _this.workItemId) || other.workItemId == _this.workItemId)&&(identical(other.message, _this.message) || other.message == _this.message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatMessageTaskCreated;
  return Object.hash(runtimeType,_this.workItemId,_this.message);
}

@override
String toString() {
  final _this = this as ChatMessageTaskCreated;
  return 'ChatMessageTaskCreated(workItemId: ${_this.workItemId}, message: ${_this.message})';
}


}

/// @nodoc
abstract mixin class $ChatMessageTaskCreatedCopyWith<$Res>  {
  factory $ChatMessageTaskCreatedCopyWith(ChatMessageTaskCreated value, $Res Function(ChatMessageTaskCreated) _then) = _$ChatMessageTaskCreatedCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, ChatMessage message
});


$ChatMessageCopyWith<$Res> get message;

}
/// @nodoc
class _$ChatMessageTaskCreatedCopyWithImpl<$Res>
    implements $ChatMessageTaskCreatedCopyWith<$Res> {
  _$ChatMessageTaskCreatedCopyWithImpl(this._self, this._then);

  final ChatMessageTaskCreated _self;
  final $Res Function(ChatMessageTaskCreated) _then;

/// Create a copy of ChatMessageTaskCreated
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workItemId = null,Object? message = null,}) {
  return _then(ChatMessageTaskCreated(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as ChatMessage,
  ));
}
/// Create a copy of ChatMessageTaskCreated
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<$Res> get message {
  
  return $ChatMessageCopyWith<$Res>(_self.message, (value) {
    return _then(_self.copyWith(message: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatMessageTaskCreated].
extension ChatMessageTaskCreatedPatterns on ChatMessageTaskCreated {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessageTaskCreated value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessageTaskCreated() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessageTaskCreated value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessageTaskCreated():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessageTaskCreated value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessageTaskCreated() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  ChatMessage message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessageTaskCreated() when $default != null:
return $default(_that.workItemId,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  ChatMessage message)  $default,) {final _that = this;
switch (_that) {
case _ChatMessageTaskCreated():
return $default(_that.workItemId,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'work_item_id')  String workItemId,  ChatMessage message)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessageTaskCreated() when $default != null:
return $default(_that.workItemId,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessageTaskCreated implements ChatMessageTaskCreated {
  const _ChatMessageTaskCreated({@JsonKey(name: 'work_item_id') required this.workItemId, required this.message});
  factory _ChatMessageTaskCreated.fromJson(Map<String, dynamic> json) => _$ChatMessageTaskCreatedFromJson(json);

@override@JsonKey(name: 'work_item_id') final  String workItemId;
@override final  ChatMessage message;

/// Create a copy of ChatMessageTaskCreated
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageTaskCreatedCopyWith<_ChatMessageTaskCreated> get copyWith => __$ChatMessageTaskCreatedCopyWithImpl<_ChatMessageTaskCreated>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageTaskCreatedToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessageTaskCreated&&(identical(other.workItemId, workItemId) || other.workItemId == workItemId)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,workItemId,message);
}

@override
String toString() {
    return 'ChatMessageTaskCreated(workItemId: $workItemId, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageTaskCreatedCopyWith<$Res> implements $ChatMessageTaskCreatedCopyWith<$Res> {
  factory _$ChatMessageTaskCreatedCopyWith(_ChatMessageTaskCreated value, $Res Function(_ChatMessageTaskCreated) _then) = __$ChatMessageTaskCreatedCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, ChatMessage message
});


@override $ChatMessageCopyWith<$Res> get message;

}
/// @nodoc
class __$ChatMessageTaskCreatedCopyWithImpl<$Res>
    implements _$ChatMessageTaskCreatedCopyWith<$Res> {
  __$ChatMessageTaskCreatedCopyWithImpl(this._self, this._then);

  final _ChatMessageTaskCreated _self;
  final $Res Function(_ChatMessageTaskCreated) _then;

/// Create a copy of ChatMessageTaskCreated
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workItemId = null,Object? message = null,}) {
  return _then(_ChatMessageTaskCreated(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as ChatMessage,
  ));
}

/// Create a copy of ChatMessageTaskCreated
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<$Res> get message {
  
  return $ChatMessageCopyWith<$Res>(_self.message, (value) {
    return _then(_self.copyWith(message: value));
  });
}
}

// dart format on
