// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coordinatorship_stat_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoordinatorshipStatList {

 List<CoordinatorshipStat> get coordinatorships;
/// Create a copy of CoordinatorshipStatList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoordinatorshipStatListCopyWith<CoordinatorshipStatList> get copyWith => _$CoordinatorshipStatListCopyWithImpl<CoordinatorshipStatList>(this as CoordinatorshipStatList, _$identity);

  /// Serializes this CoordinatorshipStatList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CoordinatorshipStatList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoordinatorshipStatList&&const DeepCollectionEquality().equals(other.coordinatorships, _this.coordinatorships));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CoordinatorshipStatList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.coordinatorships));
}

@override
String toString() {
  final _this = this as CoordinatorshipStatList;
  return 'CoordinatorshipStatList(coordinatorships: ${_this.coordinatorships})';
}


}

/// @nodoc
abstract mixin class $CoordinatorshipStatListCopyWith<$Res>  {
  factory $CoordinatorshipStatListCopyWith(CoordinatorshipStatList value, $Res Function(CoordinatorshipStatList) _then) = _$CoordinatorshipStatListCopyWithImpl;
@useResult
$Res call({
 List<CoordinatorshipStat> coordinatorships
});




}
/// @nodoc
class _$CoordinatorshipStatListCopyWithImpl<$Res>
    implements $CoordinatorshipStatListCopyWith<$Res> {
  _$CoordinatorshipStatListCopyWithImpl(this._self, this._then);

  final CoordinatorshipStatList _self;
  final $Res Function(CoordinatorshipStatList) _then;

/// Create a copy of CoordinatorshipStatList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coordinatorships = null,}) {
  return _then(CoordinatorshipStatList(
coordinatorships: null == coordinatorships ? _self.coordinatorships : coordinatorships // ignore: cast_nullable_to_non_nullable
as List<CoordinatorshipStat>,
  ));
}

}


/// Adds pattern-matching-related methods to [CoordinatorshipStatList].
extension CoordinatorshipStatListPatterns on CoordinatorshipStatList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoordinatorshipStatList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoordinatorshipStatList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoordinatorshipStatList value)  $default,){
final _that = this;
switch (_that) {
case _CoordinatorshipStatList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoordinatorshipStatList value)?  $default,){
final _that = this;
switch (_that) {
case _CoordinatorshipStatList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CoordinatorshipStat> coordinatorships)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoordinatorshipStatList() when $default != null:
return $default(_that.coordinatorships);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CoordinatorshipStat> coordinatorships)  $default,) {final _that = this;
switch (_that) {
case _CoordinatorshipStatList():
return $default(_that.coordinatorships);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CoordinatorshipStat> coordinatorships)?  $default,) {final _that = this;
switch (_that) {
case _CoordinatorshipStatList() when $default != null:
return $default(_that.coordinatorships);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoordinatorshipStatList implements CoordinatorshipStatList {
  const _CoordinatorshipStatList({required  List<CoordinatorshipStat> coordinatorships}): _coordinatorships = coordinatorships;
  factory _CoordinatorshipStatList.fromJson(Map<String, dynamic> json) => _$CoordinatorshipStatListFromJson(json);

 final  List<CoordinatorshipStat> _coordinatorships;
@override List<CoordinatorshipStat> get coordinatorships {
  if (_coordinatorships is EqualUnmodifiableListView) return _coordinatorships;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coordinatorships);
}


/// Create a copy of CoordinatorshipStatList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoordinatorshipStatListCopyWith<_CoordinatorshipStatList> get copyWith => __$CoordinatorshipStatListCopyWithImpl<_CoordinatorshipStatList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoordinatorshipStatListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoordinatorshipStatList&&const DeepCollectionEquality().equals(other.coordinatorships, _coordinatorships));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_coordinatorships));
}

@override
String toString() {
    return 'CoordinatorshipStatList(coordinatorships: $coordinatorships)';
}


}

/// @nodoc
abstract mixin class _$CoordinatorshipStatListCopyWith<$Res> implements $CoordinatorshipStatListCopyWith<$Res> {
  factory _$CoordinatorshipStatListCopyWith(_CoordinatorshipStatList value, $Res Function(_CoordinatorshipStatList) _then) = __$CoordinatorshipStatListCopyWithImpl;
@override @useResult
$Res call({
 List<CoordinatorshipStat> coordinatorships
});




}
/// @nodoc
class __$CoordinatorshipStatListCopyWithImpl<$Res>
    implements _$CoordinatorshipStatListCopyWith<$Res> {
  __$CoordinatorshipStatListCopyWithImpl(this._self, this._then);

  final _CoordinatorshipStatList _self;
  final $Res Function(_CoordinatorshipStatList) _then;

/// Create a copy of CoordinatorshipStatList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coordinatorships = null,}) {
  return _then(_CoordinatorshipStatList(
coordinatorships: null == coordinatorships ? _self._coordinatorships : coordinatorships // ignore: cast_nullable_to_non_nullable
as List<CoordinatorshipStat>,
  ));
}


}

// dart format on
