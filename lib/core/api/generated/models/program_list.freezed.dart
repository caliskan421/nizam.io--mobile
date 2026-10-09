// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'program_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProgramList {

 List<Program> get programs;
/// Create a copy of ProgramList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgramListCopyWith<ProgramList> get copyWith => _$ProgramListCopyWithImpl<ProgramList>(this as ProgramList, _$identity);

  /// Serializes this ProgramList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProgramList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgramList&&const DeepCollectionEquality().equals(other.programs, _this.programs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProgramList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.programs));
}

@override
String toString() {
  final _this = this as ProgramList;
  return 'ProgramList(programs: ${_this.programs})';
}


}

/// @nodoc
abstract mixin class $ProgramListCopyWith<$Res>  {
  factory $ProgramListCopyWith(ProgramList value, $Res Function(ProgramList) _then) = _$ProgramListCopyWithImpl;
@useResult
$Res call({
 List<Program> programs
});




}
/// @nodoc
class _$ProgramListCopyWithImpl<$Res>
    implements $ProgramListCopyWith<$Res> {
  _$ProgramListCopyWithImpl(this._self, this._then);

  final ProgramList _self;
  final $Res Function(ProgramList) _then;

/// Create a copy of ProgramList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? programs = null,}) {
  return _then(ProgramList(
programs: null == programs ? _self.programs : programs // ignore: cast_nullable_to_non_nullable
as List<Program>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgramList].
extension ProgramListPatterns on ProgramList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgramList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgramList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgramList value)  $default,){
final _that = this;
switch (_that) {
case _ProgramList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgramList value)?  $default,){
final _that = this;
switch (_that) {
case _ProgramList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Program> programs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgramList() when $default != null:
return $default(_that.programs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Program> programs)  $default,) {final _that = this;
switch (_that) {
case _ProgramList():
return $default(_that.programs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Program> programs)?  $default,) {final _that = this;
switch (_that) {
case _ProgramList() when $default != null:
return $default(_that.programs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgramList implements ProgramList {
  const _ProgramList({required  List<Program> programs}): _programs = programs;
  factory _ProgramList.fromJson(Map<String, dynamic> json) => _$ProgramListFromJson(json);

 final  List<Program> _programs;
@override List<Program> get programs {
  if (_programs is EqualUnmodifiableListView) return _programs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_programs);
}


/// Create a copy of ProgramList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgramListCopyWith<_ProgramList> get copyWith => __$ProgramListCopyWithImpl<_ProgramList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgramListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgramList&&const DeepCollectionEquality().equals(other.programs, _programs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_programs));
}

@override
String toString() {
    return 'ProgramList(programs: $programs)';
}


}

/// @nodoc
abstract mixin class _$ProgramListCopyWith<$Res> implements $ProgramListCopyWith<$Res> {
  factory _$ProgramListCopyWith(_ProgramList value, $Res Function(_ProgramList) _then) = __$ProgramListCopyWithImpl;
@override @useResult
$Res call({
 List<Program> programs
});




}
/// @nodoc
class __$ProgramListCopyWithImpl<$Res>
    implements _$ProgramListCopyWith<$Res> {
  __$ProgramListCopyWithImpl(this._self, this._then);

  final _ProgramList _self;
  final $Res Function(_ProgramList) _then;

/// Create a copy of ProgramList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? programs = null,}) {
  return _then(_ProgramList(
programs: null == programs ? _self._programs : programs // ignore: cast_nullable_to_non_nullable
as List<Program>,
  ));
}


}

// dart format on
