// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatList {

 List<ChatSummary> get items;/// Boşsa son sayfa.
@JsonKey(name: 'next_cursor') String get nextCursor;
/// Create a copy of ChatList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatListCopyWith<ChatList> get copyWith => _$ChatListCopyWithImpl<ChatList>(this as ChatList, _$identity);

  /// Serializes this ChatList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatList&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.nextCursor);
}

@override
String toString() {
  final _this = this as ChatList;
  return 'ChatList(items: ${_this.items}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $ChatListCopyWith<$Res>  {
  factory $ChatListCopyWith(ChatList value, $Res Function(ChatList) _then) = _$ChatListCopyWithImpl;
@useResult
$Res call({
 List<ChatSummary> items,@JsonKey(name: 'next_cursor') String nextCursor
});




}
/// @nodoc
class _$ChatListCopyWithImpl<$Res>
    implements $ChatListCopyWith<$Res> {
  _$ChatListCopyWithImpl(this._self, this._then);

  final ChatList _self;
  final $Res Function(ChatList) _then;

/// Create a copy of ChatList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = null,}) {
  return _then(ChatList(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ChatSummary>,nextCursor: null == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatList].
extension ChatListPatterns on ChatList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatList value)  $default,){
final _that = this;
switch (_that) {
case _ChatList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatList value)?  $default,){
final _that = this;
switch (_that) {
case _ChatList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChatSummary> items, @JsonKey(name: 'next_cursor')  String nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatList() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChatSummary> items, @JsonKey(name: 'next_cursor')  String nextCursor)  $default,) {final _that = this;
switch (_that) {
case _ChatList():
return $default(_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChatSummary> items, @JsonKey(name: 'next_cursor')  String nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _ChatList() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatList implements ChatList {
  const _ChatList({required  List<ChatSummary> items, @JsonKey(name: 'next_cursor') required this.nextCursor}): _items = items;
  factory _ChatList.fromJson(Map<String, dynamic> json) => _$ChatListFromJson(json);

 final  List<ChatSummary> _items;
@override List<ChatSummary> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Boşsa son sayfa.
@override@JsonKey(name: 'next_cursor') final  String nextCursor;

/// Create a copy of ChatList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatListCopyWith<_ChatList> get copyWith => __$ChatListCopyWithImpl<_ChatList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatList&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);
}

@override
String toString() {
    return 'ChatList(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$ChatListCopyWith<$Res> implements $ChatListCopyWith<$Res> {
  factory _$ChatListCopyWith(_ChatList value, $Res Function(_ChatList) _then) = __$ChatListCopyWithImpl;
@override @useResult
$Res call({
 List<ChatSummary> items,@JsonKey(name: 'next_cursor') String nextCursor
});




}
/// @nodoc
class __$ChatListCopyWithImpl<$Res>
    implements _$ChatListCopyWith<$Res> {
  __$ChatListCopyWithImpl(this._self, this._then);

  final _ChatList _self;
  final $Res Function(_ChatList) _then;

/// Create a copy of ChatList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = null,}) {
  return _then(_ChatList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ChatSummary>,nextCursor: null == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
