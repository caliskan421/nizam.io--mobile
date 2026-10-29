// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deleted_work_item_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeletedWorkItemList {

 List<DeletedWorkItem> get items;@JsonKey(name: 'next_cursor') String? get nextCursor;
/// Create a copy of DeletedWorkItemList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeletedWorkItemListCopyWith<DeletedWorkItemList> get copyWith => _$DeletedWorkItemListCopyWithImpl<DeletedWorkItemList>(this as DeletedWorkItemList, _$identity);

  /// Serializes this DeletedWorkItemList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeletedWorkItemList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeletedWorkItemList&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeletedWorkItemList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.nextCursor);
}

@override
String toString() {
  final _this = this as DeletedWorkItemList;
  return 'DeletedWorkItemList(items: ${_this.items}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $DeletedWorkItemListCopyWith<$Res>  {
  factory $DeletedWorkItemListCopyWith(DeletedWorkItemList value, $Res Function(DeletedWorkItemList) _then) = _$DeletedWorkItemListCopyWithImpl;
@useResult
$Res call({
 List<DeletedWorkItem> items,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class _$DeletedWorkItemListCopyWithImpl<$Res>
    implements $DeletedWorkItemListCopyWith<$Res> {
  _$DeletedWorkItemListCopyWithImpl(this._self, this._then);

  final DeletedWorkItemList _self;
  final $Res Function(DeletedWorkItemList) _then;

/// Create a copy of DeletedWorkItemList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(DeletedWorkItemList(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<DeletedWorkItem>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeletedWorkItemList].
extension DeletedWorkItemListPatterns on DeletedWorkItemList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeletedWorkItemList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeletedWorkItemList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeletedWorkItemList value)  $default,){
final _that = this;
switch (_that) {
case _DeletedWorkItemList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeletedWorkItemList value)?  $default,){
final _that = this;
switch (_that) {
case _DeletedWorkItemList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DeletedWorkItem> items, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeletedWorkItemList() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DeletedWorkItem> items, @JsonKey(name: 'next_cursor')  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _DeletedWorkItemList():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DeletedWorkItem> items, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _DeletedWorkItemList() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeletedWorkItemList implements DeletedWorkItemList {
  const _DeletedWorkItemList({required  List<DeletedWorkItem> items, @JsonKey(name: 'next_cursor') this.nextCursor}): _items = items;
  factory _DeletedWorkItemList.fromJson(Map<String, dynamic> json) => _$DeletedWorkItemListFromJson(json);

 final  List<DeletedWorkItem> _items;
@override List<DeletedWorkItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'next_cursor') final  String? nextCursor;

/// Create a copy of DeletedWorkItemList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeletedWorkItemListCopyWith<_DeletedWorkItemList> get copyWith => __$DeletedWorkItemListCopyWithImpl<_DeletedWorkItemList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeletedWorkItemListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeletedWorkItemList&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);
}

@override
String toString() {
    return 'DeletedWorkItemList(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$DeletedWorkItemListCopyWith<$Res> implements $DeletedWorkItemListCopyWith<$Res> {
  factory _$DeletedWorkItemListCopyWith(_DeletedWorkItemList value, $Res Function(_DeletedWorkItemList) _then) = __$DeletedWorkItemListCopyWithImpl;
@override @useResult
$Res call({
 List<DeletedWorkItem> items,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class __$DeletedWorkItemListCopyWithImpl<$Res>
    implements _$DeletedWorkItemListCopyWith<$Res> {
  __$DeletedWorkItemListCopyWithImpl(this._self, this._then);

  final _DeletedWorkItemList _self;
  final $Res Function(_DeletedWorkItemList) _then;

/// Create a copy of DeletedWorkItemList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_DeletedWorkItemList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<DeletedWorkItem>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
