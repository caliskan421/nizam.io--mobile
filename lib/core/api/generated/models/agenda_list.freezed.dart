// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agenda_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AgendaList {

 List<AgendaItem> get items;/// Gündem tek sayfadır; her zaman boş.
@JsonKey(name: 'next_cursor') String get nextCursor;
/// Create a copy of AgendaList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgendaListCopyWith<AgendaList> get copyWith => _$AgendaListCopyWithImpl<AgendaList>(this as AgendaList, _$identity);

  /// Serializes this AgendaList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AgendaList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgendaList&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AgendaList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.nextCursor);
}

@override
String toString() {
  final _this = this as AgendaList;
  return 'AgendaList(items: ${_this.items}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $AgendaListCopyWith<$Res>  {
  factory $AgendaListCopyWith(AgendaList value, $Res Function(AgendaList) _then) = _$AgendaListCopyWithImpl;
@useResult
$Res call({
 List<AgendaItem> items,@JsonKey(name: 'next_cursor') String nextCursor
});




}
/// @nodoc
class _$AgendaListCopyWithImpl<$Res>
    implements $AgendaListCopyWith<$Res> {
  _$AgendaListCopyWithImpl(this._self, this._then);

  final AgendaList _self;
  final $Res Function(AgendaList) _then;

/// Create a copy of AgendaList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = null,}) {
  return _then(AgendaList(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<AgendaItem>,nextCursor: null == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AgendaList].
extension AgendaListPatterns on AgendaList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgendaList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgendaList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgendaList value)  $default,){
final _that = this;
switch (_that) {
case _AgendaList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgendaList value)?  $default,){
final _that = this;
switch (_that) {
case _AgendaList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AgendaItem> items, @JsonKey(name: 'next_cursor')  String nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgendaList() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AgendaItem> items, @JsonKey(name: 'next_cursor')  String nextCursor)  $default,) {final _that = this;
switch (_that) {
case _AgendaList():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AgendaItem> items, @JsonKey(name: 'next_cursor')  String nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _AgendaList() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgendaList implements AgendaList {
  const _AgendaList({required  List<AgendaItem> items, @JsonKey(name: 'next_cursor') required this.nextCursor}): _items = items;
  factory _AgendaList.fromJson(Map<String, dynamic> json) => _$AgendaListFromJson(json);

 final  List<AgendaItem> _items;
@override List<AgendaItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Gündem tek sayfadır; her zaman boş.
@override@JsonKey(name: 'next_cursor') final  String nextCursor;

/// Create a copy of AgendaList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgendaListCopyWith<_AgendaList> get copyWith => __$AgendaListCopyWithImpl<_AgendaList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgendaListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgendaList&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);
}

@override
String toString() {
    return 'AgendaList(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$AgendaListCopyWith<$Res> implements $AgendaListCopyWith<$Res> {
  factory _$AgendaListCopyWith(_AgendaList value, $Res Function(_AgendaList) _then) = __$AgendaListCopyWithImpl;
@override @useResult
$Res call({
 List<AgendaItem> items,@JsonKey(name: 'next_cursor') String nextCursor
});




}
/// @nodoc
class __$AgendaListCopyWithImpl<$Res>
    implements _$AgendaListCopyWith<$Res> {
  __$AgendaListCopyWithImpl(this._self, this._then);

  final _AgendaList _self;
  final $Res Function(_AgendaList) _then;

/// Create a copy of AgendaList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = null,}) {
  return _then(_AgendaList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AgendaItem>,nextCursor: null == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
