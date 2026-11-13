// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeetingList {

 List<Meeting> get items;@JsonKey(name: 'next_cursor') String get nextCursor;/// Yalnız `GET /v1/meetings` cevabında vardır ve orada her zaman doludur (COLLABORATION-K79); silinenler listeleri taşımaz. Bu isteğin süzülmüş kümesinin boyu: görünürlük, `department_id`, `from`/`to` ve `when`. İmleçten bağımsızdır; her sayfada aynı değerdir (sayfalar arasındaki yazımlar hariç). `when` yoksa `tab_counts.upcoming + tab_counts.past`'tır.
 int? get total;/// Yalnız `GET /v1/meetings` cevabında vardır ve orada her zaman doludur (COLLABORATION-K79); silinenler listeleri taşımaz.
@JsonKey(name: 'tab_counts') MeetingTabCounts? get tabCounts;
/// Create a copy of MeetingList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingListCopyWith<MeetingList> get copyWith => _$MeetingListCopyWithImpl<MeetingList>(this as MeetingList, _$identity);

  /// Serializes this MeetingList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeetingList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingList&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.tabCounts, _this.tabCounts) || other.tabCounts == _this.tabCounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeetingList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.nextCursor,_this.total,_this.tabCounts);
}

@override
String toString() {
  final _this = this as MeetingList;
  return 'MeetingList(items: ${_this.items}, nextCursor: ${_this.nextCursor}, total: ${_this.total}, tabCounts: ${_this.tabCounts})';
}


}

/// @nodoc
abstract mixin class $MeetingListCopyWith<$Res>  {
  factory $MeetingListCopyWith(MeetingList value, $Res Function(MeetingList) _then) = _$MeetingListCopyWithImpl;
@useResult
$Res call({
 List<Meeting> items,@JsonKey(name: 'next_cursor') String nextCursor, int? total,@JsonKey(name: 'tab_counts') MeetingTabCounts? tabCounts
});


$MeetingTabCountsCopyWith<$Res>? get tabCounts;

}
/// @nodoc
class _$MeetingListCopyWithImpl<$Res>
    implements $MeetingListCopyWith<$Res> {
  _$MeetingListCopyWithImpl(this._self, this._then);

  final MeetingList _self;
  final $Res Function(MeetingList) _then;

/// Create a copy of MeetingList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = null,Object? total = freezed,Object? tabCounts = freezed,}) {
  return _then(MeetingList(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Meeting>,nextCursor: null == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,tabCounts: freezed == tabCounts ? _self.tabCounts : tabCounts // ignore: cast_nullable_to_non_nullable
as MeetingTabCounts?,
  ));
}
/// Create a copy of MeetingList
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingTabCountsCopyWith<$Res>? get tabCounts {
    if (_self.tabCounts == null) {
    return null;
  }

  return $MeetingTabCountsCopyWith<$Res>(_self.tabCounts!, (value) {
    return _then(_self.copyWith(tabCounts: value));
  });
}
}


/// Adds pattern-matching-related methods to [MeetingList].
extension MeetingListPatterns on MeetingList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetingList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetingList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetingList value)  $default,){
final _that = this;
switch (_that) {
case _MeetingList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetingList value)?  $default,){
final _that = this;
switch (_that) {
case _MeetingList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Meeting> items, @JsonKey(name: 'next_cursor')  String nextCursor,  int? total, @JsonKey(name: 'tab_counts')  MeetingTabCounts? tabCounts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingList() when $default != null:
return $default(_that.items,_that.nextCursor,_that.total,_that.tabCounts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Meeting> items, @JsonKey(name: 'next_cursor')  String nextCursor,  int? total, @JsonKey(name: 'tab_counts')  MeetingTabCounts? tabCounts)  $default,) {final _that = this;
switch (_that) {
case _MeetingList():
return $default(_that.items,_that.nextCursor,_that.total,_that.tabCounts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Meeting> items, @JsonKey(name: 'next_cursor')  String nextCursor,  int? total, @JsonKey(name: 'tab_counts')  MeetingTabCounts? tabCounts)?  $default,) {final _that = this;
switch (_that) {
case _MeetingList() when $default != null:
return $default(_that.items,_that.nextCursor,_that.total,_that.tabCounts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetingList implements MeetingList {
  const _MeetingList({required  List<Meeting> items, @JsonKey(name: 'next_cursor') required this.nextCursor, this.total, @JsonKey(name: 'tab_counts') this.tabCounts}): _items = items;
  factory _MeetingList.fromJson(Map<String, dynamic> json) => _$MeetingListFromJson(json);

 final  List<Meeting> _items;
@override List<Meeting> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'next_cursor') final  String nextCursor;
/// Yalnız `GET /v1/meetings` cevabında vardır ve orada her zaman doludur (COLLABORATION-K79); silinenler listeleri taşımaz. Bu isteğin süzülmüş kümesinin boyu: görünürlük, `department_id`, `from`/`to` ve `when`. İmleçten bağımsızdır; her sayfada aynı değerdir (sayfalar arasındaki yazımlar hariç). `when` yoksa `tab_counts.upcoming + tab_counts.past`'tır.
@override final  int? total;
/// Yalnız `GET /v1/meetings` cevabında vardır ve orada her zaman doludur (COLLABORATION-K79); silinenler listeleri taşımaz.
@override@JsonKey(name: 'tab_counts') final  MeetingTabCounts? tabCounts;

/// Create a copy of MeetingList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingListCopyWith<_MeetingList> get copyWith => __$MeetingListCopyWithImpl<_MeetingList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetingListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingList&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.total, total) || other.total == total)&&(identical(other.tabCounts, tabCounts) || other.tabCounts == tabCounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor,total,tabCounts);
}

@override
String toString() {
    return 'MeetingList(items: $items, nextCursor: $nextCursor, total: $total, tabCounts: $tabCounts)';
}


}

/// @nodoc
abstract mixin class _$MeetingListCopyWith<$Res> implements $MeetingListCopyWith<$Res> {
  factory _$MeetingListCopyWith(_MeetingList value, $Res Function(_MeetingList) _then) = __$MeetingListCopyWithImpl;
@override @useResult
$Res call({
 List<Meeting> items,@JsonKey(name: 'next_cursor') String nextCursor, int? total,@JsonKey(name: 'tab_counts') MeetingTabCounts? tabCounts
});


@override $MeetingTabCountsCopyWith<$Res>? get tabCounts;

}
/// @nodoc
class __$MeetingListCopyWithImpl<$Res>
    implements _$MeetingListCopyWith<$Res> {
  __$MeetingListCopyWithImpl(this._self, this._then);

  final _MeetingList _self;
  final $Res Function(_MeetingList) _then;

/// Create a copy of MeetingList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = null,Object? total = freezed,Object? tabCounts = freezed,}) {
  return _then(_MeetingList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Meeting>,nextCursor: null == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,tabCounts: freezed == tabCounts ? _self.tabCounts : tabCounts // ignore: cast_nullable_to_non_nullable
as MeetingTabCounts?,
  ));
}

/// Create a copy of MeetingList
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingTabCountsCopyWith<$Res>? get tabCounts {
    if (_self.tabCounts == null) {
    return null;
  }

  return $MeetingTabCountsCopyWith<$Res>(_self.tabCounts!, (value) {
    return _then(_self.copyWith(tabCounts: value));
  });
}
}

// dart format on
