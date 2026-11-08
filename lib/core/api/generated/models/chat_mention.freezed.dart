// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_mention.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMention {

 ChatMentionKind get kind;/// `all`da yoktur.
@JsonKey(name: 'target_id') String? get targetId;
/// Create a copy of ChatMention
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMentionCopyWith<ChatMention> get copyWith => _$ChatMentionCopyWithImpl<ChatMention>(this as ChatMention, _$identity);

  /// Serializes this ChatMention to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatMention;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMention&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.targetId, _this.targetId) || other.targetId == _this.targetId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatMention;
  return Object.hash(runtimeType,_this.kind,_this.targetId);
}

@override
String toString() {
  final _this = this as ChatMention;
  return 'ChatMention(kind: ${_this.kind}, targetId: ${_this.targetId})';
}


}

/// @nodoc
abstract mixin class $ChatMentionCopyWith<$Res>  {
  factory $ChatMentionCopyWith(ChatMention value, $Res Function(ChatMention) _then) = _$ChatMentionCopyWithImpl;
@useResult
$Res call({
 ChatMentionKind kind,@JsonKey(name: 'target_id') String? targetId
});




}
/// @nodoc
class _$ChatMentionCopyWithImpl<$Res>
    implements $ChatMentionCopyWith<$Res> {
  _$ChatMentionCopyWithImpl(this._self, this._then);

  final ChatMention _self;
  final $Res Function(ChatMention) _then;

/// Create a copy of ChatMention
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? targetId = freezed,}) {
  return _then(ChatMention(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChatMentionKind,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMention].
extension ChatMentionPatterns on ChatMention {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMention value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMention() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMention value)  $default,){
final _that = this;
switch (_that) {
case _ChatMention():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMention value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMention() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChatMentionKind kind, @JsonKey(name: 'target_id')  String? targetId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMention() when $default != null:
return $default(_that.kind,_that.targetId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChatMentionKind kind, @JsonKey(name: 'target_id')  String? targetId)  $default,) {final _that = this;
switch (_that) {
case _ChatMention():
return $default(_that.kind,_that.targetId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChatMentionKind kind, @JsonKey(name: 'target_id')  String? targetId)?  $default,) {final _that = this;
switch (_that) {
case _ChatMention() when $default != null:
return $default(_that.kind,_that.targetId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMention implements ChatMention {
  const _ChatMention({required this.kind, @JsonKey(name: 'target_id') this.targetId});
  factory _ChatMention.fromJson(Map<String, dynamic> json) => _$ChatMentionFromJson(json);

@override final  ChatMentionKind kind;
/// `all`da yoktur.
@override@JsonKey(name: 'target_id') final  String? targetId;

/// Create a copy of ChatMention
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMentionCopyWith<_ChatMention> get copyWith => __$ChatMentionCopyWithImpl<_ChatMention>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMentionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMention&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.targetId, targetId) || other.targetId == targetId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,targetId);
}

@override
String toString() {
    return 'ChatMention(kind: $kind, targetId: $targetId)';
}


}

/// @nodoc
abstract mixin class _$ChatMentionCopyWith<$Res> implements $ChatMentionCopyWith<$Res> {
  factory _$ChatMentionCopyWith(_ChatMention value, $Res Function(_ChatMention) _then) = __$ChatMentionCopyWithImpl;
@override @useResult
$Res call({
 ChatMentionKind kind,@JsonKey(name: 'target_id') String? targetId
});




}
/// @nodoc
class __$ChatMentionCopyWithImpl<$Res>
    implements _$ChatMentionCopyWith<$Res> {
  __$ChatMentionCopyWithImpl(this._self, this._then);

  final _ChatMention _self;
  final $Res Function(_ChatMention) _then;

/// Create a copy of ChatMention
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? targetId = freezed,}) {
  return _then(_ChatMention(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChatMentionKind,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
