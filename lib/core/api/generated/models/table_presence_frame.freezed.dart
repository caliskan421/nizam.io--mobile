// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_presence_frame.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TablePresenceFrame {

@JsonKey(name: 'table_id') String get tableId; List<Participants> get participants;
/// Create a copy of TablePresenceFrame
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TablePresenceFrameCopyWith<TablePresenceFrame> get copyWith => _$TablePresenceFrameCopyWithImpl<TablePresenceFrame>(this as TablePresenceFrame, _$identity);

  /// Serializes this TablePresenceFrame to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TablePresenceFrame;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TablePresenceFrame&&(identical(other.tableId, _this.tableId) || other.tableId == _this.tableId)&&const DeepCollectionEquality().equals(other.participants, _this.participants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TablePresenceFrame;
  return Object.hash(runtimeType,_this.tableId,const DeepCollectionEquality().hash(_this.participants));
}

@override
String toString() {
  final _this = this as TablePresenceFrame;
  return 'TablePresenceFrame(tableId: ${_this.tableId}, participants: ${_this.participants})';
}


}

/// @nodoc
abstract mixin class $TablePresenceFrameCopyWith<$Res>  {
  factory $TablePresenceFrameCopyWith(TablePresenceFrame value, $Res Function(TablePresenceFrame) _then) = _$TablePresenceFrameCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'table_id') String tableId, List<Participants> participants
});




}
/// @nodoc
class _$TablePresenceFrameCopyWithImpl<$Res>
    implements $TablePresenceFrameCopyWith<$Res> {
  _$TablePresenceFrameCopyWithImpl(this._self, this._then);

  final TablePresenceFrame _self;
  final $Res Function(TablePresenceFrame) _then;

/// Create a copy of TablePresenceFrame
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tableId = null,Object? participants = null,}) {
  return _then(TablePresenceFrame(
tableId: null == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<Participants>,
  ));
}

}


/// Adds pattern-matching-related methods to [TablePresenceFrame].
extension TablePresenceFramePatterns on TablePresenceFrame {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TablePresenceFrame value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TablePresenceFrame() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TablePresenceFrame value)  $default,){
final _that = this;
switch (_that) {
case _TablePresenceFrame():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TablePresenceFrame value)?  $default,){
final _that = this;
switch (_that) {
case _TablePresenceFrame() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'table_id')  String tableId,  List<Participants> participants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TablePresenceFrame() when $default != null:
return $default(_that.tableId,_that.participants);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'table_id')  String tableId,  List<Participants> participants)  $default,) {final _that = this;
switch (_that) {
case _TablePresenceFrame():
return $default(_that.tableId,_that.participants);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'table_id')  String tableId,  List<Participants> participants)?  $default,) {final _that = this;
switch (_that) {
case _TablePresenceFrame() when $default != null:
return $default(_that.tableId,_that.participants);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TablePresenceFrame implements TablePresenceFrame {
  const _TablePresenceFrame({@JsonKey(name: 'table_id') required this.tableId, required  List<Participants> participants}): _participants = participants;
  factory _TablePresenceFrame.fromJson(Map<String, dynamic> json) => _$TablePresenceFrameFromJson(json);

@override@JsonKey(name: 'table_id') final  String tableId;
 final  List<Participants> _participants;
@override List<Participants> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}


/// Create a copy of TablePresenceFrame
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TablePresenceFrameCopyWith<_TablePresenceFrame> get copyWith => __$TablePresenceFrameCopyWithImpl<_TablePresenceFrame>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TablePresenceFrameToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TablePresenceFrame&&(identical(other.tableId, tableId) || other.tableId == tableId)&&const DeepCollectionEquality().equals(other.participants, _participants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tableId,const DeepCollectionEquality().hash(_participants));
}

@override
String toString() {
    return 'TablePresenceFrame(tableId: $tableId, participants: $participants)';
}


}

/// @nodoc
abstract mixin class _$TablePresenceFrameCopyWith<$Res> implements $TablePresenceFrameCopyWith<$Res> {
  factory _$TablePresenceFrameCopyWith(_TablePresenceFrame value, $Res Function(_TablePresenceFrame) _then) = __$TablePresenceFrameCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'table_id') String tableId, List<Participants> participants
});




}
/// @nodoc
class __$TablePresenceFrameCopyWithImpl<$Res>
    implements _$TablePresenceFrameCopyWith<$Res> {
  __$TablePresenceFrameCopyWithImpl(this._self, this._then);

  final _TablePresenceFrame _self;
  final $Res Function(_TablePresenceFrame) _then;

/// Create a copy of TablePresenceFrame
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tableId = null,Object? participants = null,}) {
  return _then(_TablePresenceFrame(
tableId: null == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<Participants>,
  ));
}


}

// dart format on
