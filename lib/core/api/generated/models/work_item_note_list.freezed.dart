// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_item_note_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkItemNoteList {

 List<WorkItemNote> get notes; int get total;
/// Create a copy of WorkItemNoteList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkItemNoteListCopyWith<WorkItemNoteList> get copyWith => _$WorkItemNoteListCopyWithImpl<WorkItemNoteList>(this as WorkItemNoteList, _$identity);

  /// Serializes this WorkItemNoteList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkItemNoteList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkItemNoteList&&const DeepCollectionEquality().equals(other.notes, _this.notes)&&(identical(other.total, _this.total) || other.total == _this.total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkItemNoteList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.notes),_this.total);
}

@override
String toString() {
  final _this = this as WorkItemNoteList;
  return 'WorkItemNoteList(notes: ${_this.notes}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $WorkItemNoteListCopyWith<$Res>  {
  factory $WorkItemNoteListCopyWith(WorkItemNoteList value, $Res Function(WorkItemNoteList) _then) = _$WorkItemNoteListCopyWithImpl;
@useResult
$Res call({
 List<WorkItemNote> notes, int total
});




}
/// @nodoc
class _$WorkItemNoteListCopyWithImpl<$Res>
    implements $WorkItemNoteListCopyWith<$Res> {
  _$WorkItemNoteListCopyWithImpl(this._self, this._then);

  final WorkItemNoteList _self;
  final $Res Function(WorkItemNoteList) _then;

/// Create a copy of WorkItemNoteList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notes = null,Object? total = null,}) {
  return _then(WorkItemNoteList(
notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as List<WorkItemNote>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkItemNoteList].
extension WorkItemNoteListPatterns on WorkItemNoteList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkItemNoteList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkItemNoteList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkItemNoteList value)  $default,){
final _that = this;
switch (_that) {
case _WorkItemNoteList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkItemNoteList value)?  $default,){
final _that = this;
switch (_that) {
case _WorkItemNoteList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WorkItemNote> notes,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkItemNoteList() when $default != null:
return $default(_that.notes,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WorkItemNote> notes,  int total)  $default,) {final _that = this;
switch (_that) {
case _WorkItemNoteList():
return $default(_that.notes,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WorkItemNote> notes,  int total)?  $default,) {final _that = this;
switch (_that) {
case _WorkItemNoteList() when $default != null:
return $default(_that.notes,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkItemNoteList implements WorkItemNoteList {
  const _WorkItemNoteList({required  List<WorkItemNote> notes, required this.total}): _notes = notes;
  factory _WorkItemNoteList.fromJson(Map<String, dynamic> json) => _$WorkItemNoteListFromJson(json);

 final  List<WorkItemNote> _notes;
@override List<WorkItemNote> get notes {
  if (_notes is EqualUnmodifiableListView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notes);
}

@override final  int total;

/// Create a copy of WorkItemNoteList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkItemNoteListCopyWith<_WorkItemNoteList> get copyWith => __$WorkItemNoteListCopyWithImpl<_WorkItemNoteList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkItemNoteListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkItemNoteList&&const DeepCollectionEquality().equals(other.notes, _notes)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_notes),total);
}

@override
String toString() {
    return 'WorkItemNoteList(notes: $notes, total: $total)';
}


}

/// @nodoc
abstract mixin class _$WorkItemNoteListCopyWith<$Res> implements $WorkItemNoteListCopyWith<$Res> {
  factory _$WorkItemNoteListCopyWith(_WorkItemNoteList value, $Res Function(_WorkItemNoteList) _then) = __$WorkItemNoteListCopyWithImpl;
@override @useResult
$Res call({
 List<WorkItemNote> notes, int total
});




}
/// @nodoc
class __$WorkItemNoteListCopyWithImpl<$Res>
    implements _$WorkItemNoteListCopyWith<$Res> {
  __$WorkItemNoteListCopyWithImpl(this._self, this._then);

  final _WorkItemNoteList _self;
  final $Res Function(_WorkItemNoteList) _then;

/// Create a copy of WorkItemNoteList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notes = null,Object? total = null,}) {
  return _then(_WorkItemNoteList(
notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as List<WorkItemNote>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
