// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_candidate_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeetingCandidateList {

 List<MeetingCandidate> get items;@JsonKey(name: 'next_cursor') String get nextCursor;
/// Create a copy of MeetingCandidateList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingCandidateListCopyWith<MeetingCandidateList> get copyWith => _$MeetingCandidateListCopyWithImpl<MeetingCandidateList>(this as MeetingCandidateList, _$identity);

  /// Serializes this MeetingCandidateList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeetingCandidateList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingCandidateList&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeetingCandidateList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.nextCursor);
}

@override
String toString() {
  final _this = this as MeetingCandidateList;
  return 'MeetingCandidateList(items: ${_this.items}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $MeetingCandidateListCopyWith<$Res>  {
  factory $MeetingCandidateListCopyWith(MeetingCandidateList value, $Res Function(MeetingCandidateList) _then) = _$MeetingCandidateListCopyWithImpl;
@useResult
$Res call({
 List<MeetingCandidate> items,@JsonKey(name: 'next_cursor') String nextCursor
});




}
/// @nodoc
class _$MeetingCandidateListCopyWithImpl<$Res>
    implements $MeetingCandidateListCopyWith<$Res> {
  _$MeetingCandidateListCopyWithImpl(this._self, this._then);

  final MeetingCandidateList _self;
  final $Res Function(MeetingCandidateList) _then;

/// Create a copy of MeetingCandidateList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = null,}) {
  return _then(MeetingCandidateList(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MeetingCandidate>,nextCursor: null == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MeetingCandidateList].
extension MeetingCandidateListPatterns on MeetingCandidateList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetingCandidateList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetingCandidateList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetingCandidateList value)  $default,){
final _that = this;
switch (_that) {
case _MeetingCandidateList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetingCandidateList value)?  $default,){
final _that = this;
switch (_that) {
case _MeetingCandidateList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MeetingCandidate> items, @JsonKey(name: 'next_cursor')  String nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingCandidateList() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MeetingCandidate> items, @JsonKey(name: 'next_cursor')  String nextCursor)  $default,) {final _that = this;
switch (_that) {
case _MeetingCandidateList():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MeetingCandidate> items, @JsonKey(name: 'next_cursor')  String nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _MeetingCandidateList() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetingCandidateList implements MeetingCandidateList {
  const _MeetingCandidateList({required  List<MeetingCandidate> items, @JsonKey(name: 'next_cursor') required this.nextCursor}): _items = items;
  factory _MeetingCandidateList.fromJson(Map<String, dynamic> json) => _$MeetingCandidateListFromJson(json);

 final  List<MeetingCandidate> _items;
@override List<MeetingCandidate> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'next_cursor') final  String nextCursor;

/// Create a copy of MeetingCandidateList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingCandidateListCopyWith<_MeetingCandidateList> get copyWith => __$MeetingCandidateListCopyWithImpl<_MeetingCandidateList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetingCandidateListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingCandidateList&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);
}

@override
String toString() {
    return 'MeetingCandidateList(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$MeetingCandidateListCopyWith<$Res> implements $MeetingCandidateListCopyWith<$Res> {
  factory _$MeetingCandidateListCopyWith(_MeetingCandidateList value, $Res Function(_MeetingCandidateList) _then) = __$MeetingCandidateListCopyWithImpl;
@override @useResult
$Res call({
 List<MeetingCandidate> items,@JsonKey(name: 'next_cursor') String nextCursor
});




}
/// @nodoc
class __$MeetingCandidateListCopyWithImpl<$Res>
    implements _$MeetingCandidateListCopyWith<$Res> {
  __$MeetingCandidateListCopyWithImpl(this._self, this._then);

  final _MeetingCandidateList _self;
  final $Res Function(_MeetingCandidateList) _then;

/// Create a copy of MeetingCandidateList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = null,}) {
  return _then(_MeetingCandidateList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MeetingCandidate>,nextCursor: null == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
