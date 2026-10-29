// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_converted.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NoteConverted {

@JsonKey(name: 'work_item_id') String get workItemId; MeetingNote get note;
/// Create a copy of NoteConverted
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteConvertedCopyWith<NoteConverted> get copyWith => _$NoteConvertedCopyWithImpl<NoteConverted>(this as NoteConverted, _$identity);

  /// Serializes this NoteConverted to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NoteConverted;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteConverted&&(identical(other.workItemId, _this.workItemId) || other.workItemId == _this.workItemId)&&(identical(other.note, _this.note) || other.note == _this.note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NoteConverted;
  return Object.hash(runtimeType,_this.workItemId,_this.note);
}

@override
String toString() {
  final _this = this as NoteConverted;
  return 'NoteConverted(workItemId: ${_this.workItemId}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $NoteConvertedCopyWith<$Res>  {
  factory $NoteConvertedCopyWith(NoteConverted value, $Res Function(NoteConverted) _then) = _$NoteConvertedCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, MeetingNote note
});


$MeetingNoteCopyWith<$Res> get note;

}
/// @nodoc
class _$NoteConvertedCopyWithImpl<$Res>
    implements $NoteConvertedCopyWith<$Res> {
  _$NoteConvertedCopyWithImpl(this._self, this._then);

  final NoteConverted _self;
  final $Res Function(NoteConverted) _then;

/// Create a copy of NoteConverted
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workItemId = null,Object? note = null,}) {
  return _then(NoteConverted(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as MeetingNote,
  ));
}
/// Create a copy of NoteConverted
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingNoteCopyWith<$Res> get note {
  
  return $MeetingNoteCopyWith<$Res>(_self.note, (value) {
    return _then(_self.copyWith(note: value));
  });
}
}


/// Adds pattern-matching-related methods to [NoteConverted].
extension NoteConvertedPatterns on NoteConverted {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteConverted value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteConverted() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteConverted value)  $default,){
final _that = this;
switch (_that) {
case _NoteConverted():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteConverted value)?  $default,){
final _that = this;
switch (_that) {
case _NoteConverted() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  MeetingNote note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteConverted() when $default != null:
return $default(_that.workItemId,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  MeetingNote note)  $default,) {final _that = this;
switch (_that) {
case _NoteConverted():
return $default(_that.workItemId,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'work_item_id')  String workItemId,  MeetingNote note)?  $default,) {final _that = this;
switch (_that) {
case _NoteConverted() when $default != null:
return $default(_that.workItemId,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NoteConverted implements NoteConverted {
  const _NoteConverted({@JsonKey(name: 'work_item_id') required this.workItemId, required this.note});
  factory _NoteConverted.fromJson(Map<String, dynamic> json) => _$NoteConvertedFromJson(json);

@override@JsonKey(name: 'work_item_id') final  String workItemId;
@override final  MeetingNote note;

/// Create a copy of NoteConverted
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteConvertedCopyWith<_NoteConverted> get copyWith => __$NoteConvertedCopyWithImpl<_NoteConverted>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoteConvertedToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteConverted&&(identical(other.workItemId, workItemId) || other.workItemId == workItemId)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,workItemId,note);
}

@override
String toString() {
    return 'NoteConverted(workItemId: $workItemId, note: $note)';
}


}

/// @nodoc
abstract mixin class _$NoteConvertedCopyWith<$Res> implements $NoteConvertedCopyWith<$Res> {
  factory _$NoteConvertedCopyWith(_NoteConverted value, $Res Function(_NoteConverted) _then) = __$NoteConvertedCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, MeetingNote note
});


@override $MeetingNoteCopyWith<$Res> get note;

}
/// @nodoc
class __$NoteConvertedCopyWithImpl<$Res>
    implements _$NoteConvertedCopyWith<$Res> {
  __$NoteConvertedCopyWithImpl(this._self, this._then);

  final _NoteConverted _self;
  final $Res Function(_NoteConverted) _then;

/// Create a copy of NoteConverted
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workItemId = null,Object? note = null,}) {
  return _then(_NoteConverted(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as MeetingNote,
  ));
}

/// Create a copy of NoteConverted
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingNoteCopyWith<$Res> get note {
  
  return $MeetingNoteCopyWith<$Res>(_self.note, (value) {
    return _then(_self.copyWith(note: value));
  });
}
}

// dart format on
