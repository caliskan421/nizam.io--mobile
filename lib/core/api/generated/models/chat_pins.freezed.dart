// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_pins.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatPins {

 List<ChatMessage> get items; bool get truncated;
/// Create a copy of ChatPins
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatPinsCopyWith<ChatPins> get copyWith => _$ChatPinsCopyWithImpl<ChatPins>(this as ChatPins, _$identity);

  /// Serializes this ChatPins to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatPins;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatPins&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.truncated, _this.truncated) || other.truncated == _this.truncated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatPins;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.truncated);
}

@override
String toString() {
  final _this = this as ChatPins;
  return 'ChatPins(items: ${_this.items}, truncated: ${_this.truncated})';
}


}

/// @nodoc
abstract mixin class $ChatPinsCopyWith<$Res>  {
  factory $ChatPinsCopyWith(ChatPins value, $Res Function(ChatPins) _then) = _$ChatPinsCopyWithImpl;
@useResult
$Res call({
 List<ChatMessage> items, bool truncated
});




}
/// @nodoc
class _$ChatPinsCopyWithImpl<$Res>
    implements $ChatPinsCopyWith<$Res> {
  _$ChatPinsCopyWithImpl(this._self, this._then);

  final ChatPins _self;
  final $Res Function(ChatPins) _then;

/// Create a copy of ChatPins
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? truncated = null,}) {
  return _then(ChatPins(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatPins].
extension ChatPinsPatterns on ChatPins {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatPins value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatPins() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatPins value)  $default,){
final _that = this;
switch (_that) {
case _ChatPins():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatPins value)?  $default,){
final _that = this;
switch (_that) {
case _ChatPins() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChatMessage> items,  bool truncated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatPins() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChatMessage> items,  bool truncated)  $default,) {final _that = this;
switch (_that) {
case _ChatPins():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChatMessage> items,  bool truncated)?  $default,) {final _that = this;
switch (_that) {
case _ChatPins() when $default != null:
return $default(_that.items,_that.truncated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatPins implements ChatPins {
  const _ChatPins({required  List<ChatMessage> items, required this.truncated}): _items = items;
  factory _ChatPins.fromJson(Map<String, dynamic> json) => _$ChatPinsFromJson(json);

 final  List<ChatMessage> _items;
@override List<ChatMessage> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  bool truncated;

/// Create a copy of ChatPins
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatPinsCopyWith<_ChatPins> get copyWith => __$ChatPinsCopyWithImpl<_ChatPins>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatPinsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatPins&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.truncated, truncated) || other.truncated == truncated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),truncated);
}

@override
String toString() {
    return 'ChatPins(items: $items, truncated: $truncated)';
}


}

/// @nodoc
abstract mixin class _$ChatPinsCopyWith<$Res> implements $ChatPinsCopyWith<$Res> {
  factory _$ChatPinsCopyWith(_ChatPins value, $Res Function(_ChatPins) _then) = __$ChatPinsCopyWithImpl;
@override @useResult
$Res call({
 List<ChatMessage> items, bool truncated
});




}
/// @nodoc
class __$ChatPinsCopyWithImpl<$Res>
    implements _$ChatPinsCopyWith<$Res> {
  __$ChatPinsCopyWithImpl(this._self, this._then);

  final _ChatPins _self;
  final $Res Function(_ChatPins) _then;

/// Create a copy of ChatPins
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? truncated = null,}) {
  return _then(_ChatPins(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
