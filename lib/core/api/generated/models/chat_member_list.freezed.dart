// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_member_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMemberList {

 List<ChatMember> get items; bool get truncated;
/// Create a copy of ChatMemberList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMemberListCopyWith<ChatMemberList> get copyWith => _$ChatMemberListCopyWithImpl<ChatMemberList>(this as ChatMemberList, _$identity);

  /// Serializes this ChatMemberList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatMemberList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMemberList&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.truncated, _this.truncated) || other.truncated == _this.truncated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatMemberList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.truncated);
}

@override
String toString() {
  final _this = this as ChatMemberList;
  return 'ChatMemberList(items: ${_this.items}, truncated: ${_this.truncated})';
}


}

/// @nodoc
abstract mixin class $ChatMemberListCopyWith<$Res>  {
  factory $ChatMemberListCopyWith(ChatMemberList value, $Res Function(ChatMemberList) _then) = _$ChatMemberListCopyWithImpl;
@useResult
$Res call({
 List<ChatMember> items, bool truncated
});




}
/// @nodoc
class _$ChatMemberListCopyWithImpl<$Res>
    implements $ChatMemberListCopyWith<$Res> {
  _$ChatMemberListCopyWithImpl(this._self, this._then);

  final ChatMemberList _self;
  final $Res Function(ChatMemberList) _then;

/// Create a copy of ChatMemberList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? truncated = null,}) {
  return _then(ChatMemberList(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ChatMember>,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMemberList].
extension ChatMemberListPatterns on ChatMemberList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMemberList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMemberList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMemberList value)  $default,){
final _that = this;
switch (_that) {
case _ChatMemberList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMemberList value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMemberList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChatMember> items,  bool truncated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMemberList() when $default != null:
return $default(_that.items,_that.truncated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChatMember> items,  bool truncated)  $default,) {final _that = this;
switch (_that) {
case _ChatMemberList():
return $default(_that.items,_that.truncated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChatMember> items,  bool truncated)?  $default,) {final _that = this;
switch (_that) {
case _ChatMemberList() when $default != null:
return $default(_that.items,_that.truncated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMemberList implements ChatMemberList {
  const _ChatMemberList({required  List<ChatMember> items, required this.truncated}): _items = items;
  factory _ChatMemberList.fromJson(Map<String, dynamic> json) => _$ChatMemberListFromJson(json);

 final  List<ChatMember> _items;
@override List<ChatMember> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  bool truncated;

/// Create a copy of ChatMemberList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMemberListCopyWith<_ChatMemberList> get copyWith => __$ChatMemberListCopyWithImpl<_ChatMemberList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMemberListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMemberList&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.truncated, truncated) || other.truncated == truncated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),truncated);
}

@override
String toString() {
    return 'ChatMemberList(items: $items, truncated: $truncated)';
}


}

/// @nodoc
abstract mixin class _$ChatMemberListCopyWith<$Res> implements $ChatMemberListCopyWith<$Res> {
  factory _$ChatMemberListCopyWith(_ChatMemberList value, $Res Function(_ChatMemberList) _then) = __$ChatMemberListCopyWithImpl;
@override @useResult
$Res call({
 List<ChatMember> items, bool truncated
});




}
/// @nodoc
class __$ChatMemberListCopyWithImpl<$Res>
    implements _$ChatMemberListCopyWith<$Res> {
  __$ChatMemberListCopyWithImpl(this._self, this._then);

  final _ChatMemberList _self;
  final $Res Function(_ChatMemberList) _then;

/// Create a copy of ChatMemberList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? truncated = null,}) {
  return _then(_ChatMemberList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ChatMember>,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
