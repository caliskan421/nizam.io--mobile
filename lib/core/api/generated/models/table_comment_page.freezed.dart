// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_comment_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableCommentPage {

 List<TableComment> get items;/// Yalnız sonraki sayfa varsa; son öğenin `seq`'i.
@JsonKey(name: 'next_cursor') String? get nextCursor;
/// Create a copy of TableCommentPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCommentPageCopyWith<TableCommentPage> get copyWith => _$TableCommentPageCopyWithImpl<TableCommentPage>(this as TableCommentPage, _$identity);

  /// Serializes this TableCommentPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableCommentPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCommentPage&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableCommentPage;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.nextCursor);
}

@override
String toString() {
  final _this = this as TableCommentPage;
  return 'TableCommentPage(items: ${_this.items}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $TableCommentPageCopyWith<$Res>  {
  factory $TableCommentPageCopyWith(TableCommentPage value, $Res Function(TableCommentPage) _then) = _$TableCommentPageCopyWithImpl;
@useResult
$Res call({
 List<TableComment> items,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class _$TableCommentPageCopyWithImpl<$Res>
    implements $TableCommentPageCopyWith<$Res> {
  _$TableCommentPageCopyWithImpl(this._self, this._then);

  final TableCommentPage _self;
  final $Res Function(TableCommentPage) _then;

/// Create a copy of TableCommentPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(TableCommentPage(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TableComment>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TableCommentPage].
extension TableCommentPagePatterns on TableCommentPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableCommentPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableCommentPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableCommentPage value)  $default,){
final _that = this;
switch (_that) {
case _TableCommentPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableCommentPage value)?  $default,){
final _that = this;
switch (_that) {
case _TableCommentPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TableComment> items, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableCommentPage() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TableComment> items, @JsonKey(name: 'next_cursor')  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _TableCommentPage():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TableComment> items, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _TableCommentPage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableCommentPage implements TableCommentPage {
  const _TableCommentPage({required  List<TableComment> items, @JsonKey(name: 'next_cursor') this.nextCursor}): _items = items;
  factory _TableCommentPage.fromJson(Map<String, dynamic> json) => _$TableCommentPageFromJson(json);

 final  List<TableComment> _items;
@override List<TableComment> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Yalnız sonraki sayfa varsa; son öğenin `seq`'i.
@override@JsonKey(name: 'next_cursor') final  String? nextCursor;

/// Create a copy of TableCommentPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableCommentPageCopyWith<_TableCommentPage> get copyWith => __$TableCommentPageCopyWithImpl<_TableCommentPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCommentPageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableCommentPage&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);
}

@override
String toString() {
    return 'TableCommentPage(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$TableCommentPageCopyWith<$Res> implements $TableCommentPageCopyWith<$Res> {
  factory _$TableCommentPageCopyWith(_TableCommentPage value, $Res Function(_TableCommentPage) _then) = __$TableCommentPageCopyWithImpl;
@override @useResult
$Res call({
 List<TableComment> items,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class __$TableCommentPageCopyWithImpl<$Res>
    implements _$TableCommentPageCopyWith<$Res> {
  __$TableCommentPageCopyWithImpl(this._self, this._then);

  final _TableCommentPage _self;
  final $Res Function(_TableCommentPage) _then;

/// Create a copy of TableCommentPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_TableCommentPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TableComment>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
