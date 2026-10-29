// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_item_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkItemList {

 List<WorkItem> get items;@JsonKey(name: 'next_cursor') String? get nextCursor;
/// Create a copy of WorkItemList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkItemListCopyWith<WorkItemList> get copyWith => _$WorkItemListCopyWithImpl<WorkItemList>(this as WorkItemList, _$identity);

  /// Serializes this WorkItemList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkItemList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkItemList&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkItemList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.nextCursor);
}

@override
String toString() {
  final _this = this as WorkItemList;
  return 'WorkItemList(items: ${_this.items}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $WorkItemListCopyWith<$Res>  {
  factory $WorkItemListCopyWith(WorkItemList value, $Res Function(WorkItemList) _then) = _$WorkItemListCopyWithImpl;
@useResult
$Res call({
 List<WorkItem> items,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class _$WorkItemListCopyWithImpl<$Res>
    implements $WorkItemListCopyWith<$Res> {
  _$WorkItemListCopyWithImpl(this._self, this._then);

  final WorkItemList _self;
  final $Res Function(WorkItemList) _then;

/// Create a copy of WorkItemList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(WorkItemList(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<WorkItem>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkItemList].
extension WorkItemListPatterns on WorkItemList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkItemList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkItemList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkItemList value)  $default,){
final _that = this;
switch (_that) {
case _WorkItemList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkItemList value)?  $default,){
final _that = this;
switch (_that) {
case _WorkItemList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WorkItem> items, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkItemList() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WorkItem> items, @JsonKey(name: 'next_cursor')  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _WorkItemList():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WorkItem> items, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _WorkItemList() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkItemList implements WorkItemList {
  const _WorkItemList({required  List<WorkItem> items, @JsonKey(name: 'next_cursor') this.nextCursor}): _items = items;
  factory _WorkItemList.fromJson(Map<String, dynamic> json) => _$WorkItemListFromJson(json);

 final  List<WorkItem> _items;
@override List<WorkItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'next_cursor') final  String? nextCursor;

/// Create a copy of WorkItemList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkItemListCopyWith<_WorkItemList> get copyWith => __$WorkItemListCopyWithImpl<_WorkItemList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkItemListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkItemList&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);
}

@override
String toString() {
    return 'WorkItemList(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$WorkItemListCopyWith<$Res> implements $WorkItemListCopyWith<$Res> {
  factory _$WorkItemListCopyWith(_WorkItemList value, $Res Function(_WorkItemList) _then) = __$WorkItemListCopyWithImpl;
@override @useResult
$Res call({
 List<WorkItem> items,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class __$WorkItemListCopyWithImpl<$Res>
    implements _$WorkItemListCopyWith<$Res> {
  __$WorkItemListCopyWithImpl(this._self, this._then);

  final _WorkItemList _self;
  final $Res Function(_WorkItemList) _then;

/// Create a copy of WorkItemList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_WorkItemList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<WorkItem>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
