// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant_conversation_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssistantConversationList {

 List<AssistantConversation> get conversations;
/// Create a copy of AssistantConversationList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssistantConversationListCopyWith<AssistantConversationList> get copyWith => _$AssistantConversationListCopyWithImpl<AssistantConversationList>(this as AssistantConversationList, _$identity);

  /// Serializes this AssistantConversationList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AssistantConversationList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssistantConversationList&&const DeepCollectionEquality().equals(other.conversations, _this.conversations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AssistantConversationList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.conversations));
}

@override
String toString() {
  final _this = this as AssistantConversationList;
  return 'AssistantConversationList(conversations: ${_this.conversations})';
}


}

/// @nodoc
abstract mixin class $AssistantConversationListCopyWith<$Res>  {
  factory $AssistantConversationListCopyWith(AssistantConversationList value, $Res Function(AssistantConversationList) _then) = _$AssistantConversationListCopyWithImpl;
@useResult
$Res call({
 List<AssistantConversation> conversations
});




}
/// @nodoc
class _$AssistantConversationListCopyWithImpl<$Res>
    implements $AssistantConversationListCopyWith<$Res> {
  _$AssistantConversationListCopyWithImpl(this._self, this._then);

  final AssistantConversationList _self;
  final $Res Function(AssistantConversationList) _then;

/// Create a copy of AssistantConversationList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conversations = null,}) {
  return _then(AssistantConversationList(
conversations: null == conversations ? _self.conversations : conversations // ignore: cast_nullable_to_non_nullable
as List<AssistantConversation>,
  ));
}

}


/// Adds pattern-matching-related methods to [AssistantConversationList].
extension AssistantConversationListPatterns on AssistantConversationList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssistantConversationList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssistantConversationList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssistantConversationList value)  $default,){
final _that = this;
switch (_that) {
case _AssistantConversationList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssistantConversationList value)?  $default,){
final _that = this;
switch (_that) {
case _AssistantConversationList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AssistantConversation> conversations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssistantConversationList() when $default != null:
return $default(_that.conversations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AssistantConversation> conversations)  $default,) {final _that = this;
switch (_that) {
case _AssistantConversationList():
return $default(_that.conversations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AssistantConversation> conversations)?  $default,) {final _that = this;
switch (_that) {
case _AssistantConversationList() when $default != null:
return $default(_that.conversations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssistantConversationList implements AssistantConversationList {
  const _AssistantConversationList({required  List<AssistantConversation> conversations}): _conversations = conversations;
  factory _AssistantConversationList.fromJson(Map<String, dynamic> json) => _$AssistantConversationListFromJson(json);

 final  List<AssistantConversation> _conversations;
@override List<AssistantConversation> get conversations {
  if (_conversations is EqualUnmodifiableListView) return _conversations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conversations);
}


/// Create a copy of AssistantConversationList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssistantConversationListCopyWith<_AssistantConversationList> get copyWith => __$AssistantConversationListCopyWithImpl<_AssistantConversationList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssistantConversationListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssistantConversationList&&const DeepCollectionEquality().equals(other.conversations, _conversations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_conversations));
}

@override
String toString() {
    return 'AssistantConversationList(conversations: $conversations)';
}


}

/// @nodoc
abstract mixin class _$AssistantConversationListCopyWith<$Res> implements $AssistantConversationListCopyWith<$Res> {
  factory _$AssistantConversationListCopyWith(_AssistantConversationList value, $Res Function(_AssistantConversationList) _then) = __$AssistantConversationListCopyWithImpl;
@override @useResult
$Res call({
 List<AssistantConversation> conversations
});




}
/// @nodoc
class __$AssistantConversationListCopyWithImpl<$Res>
    implements _$AssistantConversationListCopyWith<$Res> {
  __$AssistantConversationListCopyWithImpl(this._self, this._then);

  final _AssistantConversationList _self;
  final $Res Function(_AssistantConversationList) _then;

/// Create a copy of AssistantConversationList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conversations = null,}) {
  return _then(_AssistantConversationList(
conversations: null == conversations ? _self._conversations : conversations // ignore: cast_nullable_to_non_nullable
as List<AssistantConversation>,
  ));
}


}

// dart format on
