// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_project_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableProjectList {

 List<TableProject> get items;/// Sonraki sayfa; son sayfada yoktur.
@JsonKey(name: 'next_cursor') String? get nextCursor;
/// Create a copy of TableProjectList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableProjectListCopyWith<TableProjectList> get copyWith => _$TableProjectListCopyWithImpl<TableProjectList>(this as TableProjectList, _$identity);

  /// Serializes this TableProjectList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableProjectList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableProjectList&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableProjectList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.nextCursor);
}

@override
String toString() {
  final _this = this as TableProjectList;
  return 'TableProjectList(items: ${_this.items}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $TableProjectListCopyWith<$Res>  {
  factory $TableProjectListCopyWith(TableProjectList value, $Res Function(TableProjectList) _then) = _$TableProjectListCopyWithImpl;
@useResult
$Res call({
 List<TableProject> items,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class _$TableProjectListCopyWithImpl<$Res>
    implements $TableProjectListCopyWith<$Res> {
  _$TableProjectListCopyWithImpl(this._self, this._then);

  final TableProjectList _self;
  final $Res Function(TableProjectList) _then;

/// Create a copy of TableProjectList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(TableProjectList(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TableProject>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TableProjectList].
extension TableProjectListPatterns on TableProjectList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableProjectList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableProjectList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableProjectList value)  $default,){
final _that = this;
switch (_that) {
case _TableProjectList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableProjectList value)?  $default,){
final _that = this;
switch (_that) {
case _TableProjectList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TableProject> items, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableProjectList() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TableProject> items, @JsonKey(name: 'next_cursor')  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _TableProjectList():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TableProject> items, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _TableProjectList() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableProjectList implements TableProjectList {
  const _TableProjectList({required  List<TableProject> items, @JsonKey(name: 'next_cursor') this.nextCursor}): _items = items;
  factory _TableProjectList.fromJson(Map<String, dynamic> json) => _$TableProjectListFromJson(json);

 final  List<TableProject> _items;
@override List<TableProject> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Sonraki sayfa; son sayfada yoktur.
@override@JsonKey(name: 'next_cursor') final  String? nextCursor;

/// Create a copy of TableProjectList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableProjectListCopyWith<_TableProjectList> get copyWith => __$TableProjectListCopyWithImpl<_TableProjectList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableProjectListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableProjectList&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);
}

@override
String toString() {
    return 'TableProjectList(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$TableProjectListCopyWith<$Res> implements $TableProjectListCopyWith<$Res> {
  factory _$TableProjectListCopyWith(_TableProjectList value, $Res Function(_TableProjectList) _then) = __$TableProjectListCopyWithImpl;
@override @useResult
$Res call({
 List<TableProject> items,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class __$TableProjectListCopyWithImpl<$Res>
    implements _$TableProjectListCopyWith<$Res> {
  __$TableProjectListCopyWithImpl(this._self, this._then);

  final _TableProjectList _self;
  final $Res Function(_TableProjectList) _then;

/// Create a copy of TableProjectList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_TableProjectList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TableProject>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
