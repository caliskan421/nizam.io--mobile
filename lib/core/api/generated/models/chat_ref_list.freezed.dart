// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_ref_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatRefList {

 List<ChatSharedRef> get items;@JsonKey(name: 'next_cursor') String? get nextCursor;
/// Create a copy of ChatRefList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatRefListCopyWith<ChatRefList> get copyWith => _$ChatRefListCopyWithImpl<ChatRefList>(this as ChatRefList, _$identity);

  /// Serializes this ChatRefList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatRefList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatRefList&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatRefList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.nextCursor);
}

@override
String toString() {
  final _this = this as ChatRefList;
  return 'ChatRefList(items: ${_this.items}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $ChatRefListCopyWith<$Res>  {
  factory $ChatRefListCopyWith(ChatRefList value, $Res Function(ChatRefList) _then) = _$ChatRefListCopyWithImpl;
@useResult
$Res call({
 List<ChatSharedRef> items,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class _$ChatRefListCopyWithImpl<$Res>
    implements $ChatRefListCopyWith<$Res> {
  _$ChatRefListCopyWithImpl(this._self, this._then);

  final ChatRefList _self;
  final $Res Function(ChatRefList) _then;

/// Create a copy of ChatRefList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(ChatRefList(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ChatSharedRef>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatRefList].
extension ChatRefListPatterns on ChatRefList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatRefList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatRefList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatRefList value)  $default,){
final _that = this;
switch (_that) {
case _ChatRefList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatRefList value)?  $default,){
final _that = this;
switch (_that) {
case _ChatRefList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChatSharedRef> items, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatRefList() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChatSharedRef> items, @JsonKey(name: 'next_cursor')  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _ChatRefList():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChatSharedRef> items, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _ChatRefList() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatRefList implements ChatRefList {
  const _ChatRefList({required  List<ChatSharedRef> items, @JsonKey(name: 'next_cursor') required this.nextCursor}): _items = items;
  factory _ChatRefList.fromJson(Map<String, dynamic> json) => _$ChatRefListFromJson(json);

 final  List<ChatSharedRef> _items;
@override List<ChatSharedRef> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'next_cursor') final  String? nextCursor;

/// Create a copy of ChatRefList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatRefListCopyWith<_ChatRefList> get copyWith => __$ChatRefListCopyWithImpl<_ChatRefList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatRefListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatRefList&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);
}

@override
String toString() {
    return 'ChatRefList(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$ChatRefListCopyWith<$Res> implements $ChatRefListCopyWith<$Res> {
  factory _$ChatRefListCopyWith(_ChatRefList value, $Res Function(_ChatRefList) _then) = __$ChatRefListCopyWithImpl;
@override @useResult
$Res call({
 List<ChatSharedRef> items,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class __$ChatRefListCopyWithImpl<$Res>
    implements _$ChatRefListCopyWith<$Res> {
  __$ChatRefListCopyWithImpl(this._self, this._then);

  final _ChatRefList _self;
  final $Res Function(_ChatRefList) _then;

/// Create a copy of ChatRefList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_ChatRefList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ChatSharedRef>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
