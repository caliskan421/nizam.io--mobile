// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_note_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeetingNoteList {

 List<MeetingNote> get items;@JsonKey(name: 'next_cursor') String get nextCursor;/// İstekteki süzgeçlere (`converted`, `author`) uyan notların sayısı (COLLABORATION-K80); imleçten bağımsızdır, her sayfada aynıdır. Detaydaki `notes` süzgeçsizdir (`total == counts.all`).
 int get total; MeetingNoteCounts get counts;
/// Create a copy of MeetingNoteList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingNoteListCopyWith<MeetingNoteList> get copyWith => _$MeetingNoteListCopyWithImpl<MeetingNoteList>(this as MeetingNoteList, _$identity);

  /// Serializes this MeetingNoteList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeetingNoteList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingNoteList&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.counts, _this.counts) || other.counts == _this.counts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeetingNoteList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.nextCursor,_this.total,_this.counts);
}

@override
String toString() {
  final _this = this as MeetingNoteList;
  return 'MeetingNoteList(items: ${_this.items}, nextCursor: ${_this.nextCursor}, total: ${_this.total}, counts: ${_this.counts})';
}


}

/// @nodoc
abstract mixin class $MeetingNoteListCopyWith<$Res>  {
  factory $MeetingNoteListCopyWith(MeetingNoteList value, $Res Function(MeetingNoteList) _then) = _$MeetingNoteListCopyWithImpl;
@useResult
$Res call({
 List<MeetingNote> items,@JsonKey(name: 'next_cursor') String nextCursor, int total, MeetingNoteCounts counts
});


$MeetingNoteCountsCopyWith<$Res> get counts;

}
/// @nodoc
class _$MeetingNoteListCopyWithImpl<$Res>
    implements $MeetingNoteListCopyWith<$Res> {
  _$MeetingNoteListCopyWithImpl(this._self, this._then);

  final MeetingNoteList _self;
  final $Res Function(MeetingNoteList) _then;

/// Create a copy of MeetingNoteList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = null,Object? total = null,Object? counts = null,}) {
  return _then(MeetingNoteList(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MeetingNote>,nextCursor: null == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,counts: null == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as MeetingNoteCounts,
  ));
}
/// Create a copy of MeetingNoteList
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingNoteCountsCopyWith<$Res> get counts {
  
  return $MeetingNoteCountsCopyWith<$Res>(_self.counts, (value) {
    return _then(_self.copyWith(counts: value));
  });
}
}


/// Adds pattern-matching-related methods to [MeetingNoteList].
extension MeetingNoteListPatterns on MeetingNoteList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetingNoteList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetingNoteList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetingNoteList value)  $default,){
final _that = this;
switch (_that) {
case _MeetingNoteList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetingNoteList value)?  $default,){
final _that = this;
switch (_that) {
case _MeetingNoteList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MeetingNote> items, @JsonKey(name: 'next_cursor')  String nextCursor,  int total,  MeetingNoteCounts counts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingNoteList() when $default != null:
return $default(_that.items,_that.nextCursor,_that.total,_that.counts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MeetingNote> items, @JsonKey(name: 'next_cursor')  String nextCursor,  int total,  MeetingNoteCounts counts)  $default,) {final _that = this;
switch (_that) {
case _MeetingNoteList():
return $default(_that.items,_that.nextCursor,_that.total,_that.counts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MeetingNote> items, @JsonKey(name: 'next_cursor')  String nextCursor,  int total,  MeetingNoteCounts counts)?  $default,) {final _that = this;
switch (_that) {
case _MeetingNoteList() when $default != null:
return $default(_that.items,_that.nextCursor,_that.total,_that.counts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetingNoteList implements MeetingNoteList {
  const _MeetingNoteList({required  List<MeetingNote> items, @JsonKey(name: 'next_cursor') required this.nextCursor, required this.total, required this.counts}): _items = items;
  factory _MeetingNoteList.fromJson(Map<String, dynamic> json) => _$MeetingNoteListFromJson(json);

 final  List<MeetingNote> _items;
@override List<MeetingNote> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'next_cursor') final  String nextCursor;
/// İstekteki süzgeçlere (`converted`, `author`) uyan notların sayısı (COLLABORATION-K80); imleçten bağımsızdır, her sayfada aynıdır. Detaydaki `notes` süzgeçsizdir (`total == counts.all`).
@override final  int total;
@override final  MeetingNoteCounts counts;

/// Create a copy of MeetingNoteList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingNoteListCopyWith<_MeetingNoteList> get copyWith => __$MeetingNoteListCopyWithImpl<_MeetingNoteList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetingNoteListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingNoteList&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.total, total) || other.total == total)&&(identical(other.counts, counts) || other.counts == counts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor,total,counts);
}

@override
String toString() {
    return 'MeetingNoteList(items: $items, nextCursor: $nextCursor, total: $total, counts: $counts)';
}


}

/// @nodoc
abstract mixin class _$MeetingNoteListCopyWith<$Res> implements $MeetingNoteListCopyWith<$Res> {
  factory _$MeetingNoteListCopyWith(_MeetingNoteList value, $Res Function(_MeetingNoteList) _then) = __$MeetingNoteListCopyWithImpl;
@override @useResult
$Res call({
 List<MeetingNote> items,@JsonKey(name: 'next_cursor') String nextCursor, int total, MeetingNoteCounts counts
});


@override $MeetingNoteCountsCopyWith<$Res> get counts;

}
/// @nodoc
class __$MeetingNoteListCopyWithImpl<$Res>
    implements _$MeetingNoteListCopyWith<$Res> {
  __$MeetingNoteListCopyWithImpl(this._self, this._then);

  final _MeetingNoteList _self;
  final $Res Function(_MeetingNoteList) _then;

/// Create a copy of MeetingNoteList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = null,Object? total = null,Object? counts = null,}) {
  return _then(_MeetingNoteList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MeetingNote>,nextCursor: null == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,counts: null == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as MeetingNoteCounts,
  ));
}

/// Create a copy of MeetingNoteList
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingNoteCountsCopyWith<$Res> get counts {
  
  return $MeetingNoteCountsCopyWith<$Res>(_self.counts, (value) {
    return _then(_self.copyWith(counts: value));
  });
}
}

// dart format on
