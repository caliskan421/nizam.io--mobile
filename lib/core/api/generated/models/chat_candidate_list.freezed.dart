// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_candidate_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatCandidateList {

 List<ChatCandidate> get items; bool get truncated;
/// Create a copy of ChatCandidateList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatCandidateListCopyWith<ChatCandidateList> get copyWith => _$ChatCandidateListCopyWithImpl<ChatCandidateList>(this as ChatCandidateList, _$identity);

  /// Serializes this ChatCandidateList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatCandidateList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatCandidateList&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.truncated, _this.truncated) || other.truncated == _this.truncated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatCandidateList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.truncated);
}

@override
String toString() {
  final _this = this as ChatCandidateList;
  return 'ChatCandidateList(items: ${_this.items}, truncated: ${_this.truncated})';
}


}

/// @nodoc
abstract mixin class $ChatCandidateListCopyWith<$Res>  {
  factory $ChatCandidateListCopyWith(ChatCandidateList value, $Res Function(ChatCandidateList) _then) = _$ChatCandidateListCopyWithImpl;
@useResult
$Res call({
 List<ChatCandidate> items, bool truncated
});




}
/// @nodoc
class _$ChatCandidateListCopyWithImpl<$Res>
    implements $ChatCandidateListCopyWith<$Res> {
  _$ChatCandidateListCopyWithImpl(this._self, this._then);

  final ChatCandidateList _self;
  final $Res Function(ChatCandidateList) _then;

/// Create a copy of ChatCandidateList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? truncated = null,}) {
  return _then(ChatCandidateList(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ChatCandidate>,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatCandidateList].
extension ChatCandidateListPatterns on ChatCandidateList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatCandidateList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatCandidateList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatCandidateList value)  $default,){
final _that = this;
switch (_that) {
case _ChatCandidateList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatCandidateList value)?  $default,){
final _that = this;
switch (_that) {
case _ChatCandidateList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChatCandidate> items,  bool truncated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatCandidateList() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChatCandidate> items,  bool truncated)  $default,) {final _that = this;
switch (_that) {
case _ChatCandidateList():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChatCandidate> items,  bool truncated)?  $default,) {final _that = this;
switch (_that) {
case _ChatCandidateList() when $default != null:
return $default(_that.items,_that.truncated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatCandidateList implements ChatCandidateList {
  const _ChatCandidateList({required  List<ChatCandidate> items, required this.truncated}): _items = items;
  factory _ChatCandidateList.fromJson(Map<String, dynamic> json) => _$ChatCandidateListFromJson(json);

 final  List<ChatCandidate> _items;
@override List<ChatCandidate> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  bool truncated;

/// Create a copy of ChatCandidateList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatCandidateListCopyWith<_ChatCandidateList> get copyWith => __$ChatCandidateListCopyWithImpl<_ChatCandidateList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatCandidateListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatCandidateList&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.truncated, truncated) || other.truncated == truncated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),truncated);
}

@override
String toString() {
    return 'ChatCandidateList(items: $items, truncated: $truncated)';
}


}

/// @nodoc
abstract mixin class _$ChatCandidateListCopyWith<$Res> implements $ChatCandidateListCopyWith<$Res> {
  factory _$ChatCandidateListCopyWith(_ChatCandidateList value, $Res Function(_ChatCandidateList) _then) = __$ChatCandidateListCopyWithImpl;
@override @useResult
$Res call({
 List<ChatCandidate> items, bool truncated
});




}
/// @nodoc
class __$ChatCandidateListCopyWithImpl<$Res>
    implements _$ChatCandidateListCopyWith<$Res> {
  __$ChatCandidateListCopyWithImpl(this._self, this._then);

  final _ChatCandidateList _self;
  final $Res Function(_ChatCandidateList) _then;

/// Create a copy of ChatCandidateList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? truncated = null,}) {
  return _then(_ChatCandidateList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ChatCandidate>,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
