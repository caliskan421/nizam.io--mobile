// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipient_groups.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecipientGroups {

 List<RecipientGroup> get groups;
/// Create a copy of RecipientGroups
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipientGroupsCopyWith<RecipientGroups> get copyWith => _$RecipientGroupsCopyWithImpl<RecipientGroups>(this as RecipientGroups, _$identity);

  /// Serializes this RecipientGroups to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RecipientGroups;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipientGroups&&const DeepCollectionEquality().equals(other.groups, _this.groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RecipientGroups;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.groups));
}

@override
String toString() {
  final _this = this as RecipientGroups;
  return 'RecipientGroups(groups: ${_this.groups})';
}


}

/// @nodoc
abstract mixin class $RecipientGroupsCopyWith<$Res>  {
  factory $RecipientGroupsCopyWith(RecipientGroups value, $Res Function(RecipientGroups) _then) = _$RecipientGroupsCopyWithImpl;
@useResult
$Res call({
 List<RecipientGroup> groups
});




}
/// @nodoc
class _$RecipientGroupsCopyWithImpl<$Res>
    implements $RecipientGroupsCopyWith<$Res> {
  _$RecipientGroupsCopyWithImpl(this._self, this._then);

  final RecipientGroups _self;
  final $Res Function(RecipientGroups) _then;

/// Create a copy of RecipientGroups
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groups = null,}) {
  return _then(RecipientGroups(
groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<RecipientGroup>,
  ));
}

}


/// Adds pattern-matching-related methods to [RecipientGroups].
extension RecipientGroupsPatterns on RecipientGroups {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipientGroups value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipientGroups() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipientGroups value)  $default,){
final _that = this;
switch (_that) {
case _RecipientGroups():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipientGroups value)?  $default,){
final _that = this;
switch (_that) {
case _RecipientGroups() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RecipientGroup> groups)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipientGroups() when $default != null:
return $default(_that.groups);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RecipientGroup> groups)  $default,) {final _that = this;
switch (_that) {
case _RecipientGroups():
return $default(_that.groups);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RecipientGroup> groups)?  $default,) {final _that = this;
switch (_that) {
case _RecipientGroups() when $default != null:
return $default(_that.groups);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecipientGroups implements RecipientGroups {
  const _RecipientGroups({required  List<RecipientGroup> groups}): _groups = groups;
  factory _RecipientGroups.fromJson(Map<String, dynamic> json) => _$RecipientGroupsFromJson(json);

 final  List<RecipientGroup> _groups;
@override List<RecipientGroup> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}


/// Create a copy of RecipientGroups
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipientGroupsCopyWith<_RecipientGroups> get copyWith => __$RecipientGroupsCopyWithImpl<_RecipientGroups>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipientGroupsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipientGroups&&const DeepCollectionEquality().equals(other.groups, _groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_groups));
}

@override
String toString() {
    return 'RecipientGroups(groups: $groups)';
}


}

/// @nodoc
abstract mixin class _$RecipientGroupsCopyWith<$Res> implements $RecipientGroupsCopyWith<$Res> {
  factory _$RecipientGroupsCopyWith(_RecipientGroups value, $Res Function(_RecipientGroups) _then) = __$RecipientGroupsCopyWithImpl;
@override @useResult
$Res call({
 List<RecipientGroup> groups
});




}
/// @nodoc
class __$RecipientGroupsCopyWithImpl<$Res>
    implements _$RecipientGroupsCopyWith<$Res> {
  __$RecipientGroupsCopyWithImpl(this._self, this._then);

  final _RecipientGroups _self;
  final $Res Function(_RecipientGroups) _then;

/// Create a copy of RecipientGroups
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groups = null,}) {
  return _then(_RecipientGroups(
groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<RecipientGroup>,
  ));
}


}

// dart format on
