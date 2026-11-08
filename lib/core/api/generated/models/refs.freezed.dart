// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'refs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Refs {

 Kind get kind;@JsonKey(name: 'target_id') String get targetId;
/// Create a copy of Refs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RefsCopyWith<Refs> get copyWith => _$RefsCopyWithImpl<Refs>(this as Refs, _$identity);

  /// Serializes this Refs to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Refs;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Refs&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.targetId, _this.targetId) || other.targetId == _this.targetId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Refs;
  return Object.hash(runtimeType,_this.kind,_this.targetId);
}

@override
String toString() {
  final _this = this as Refs;
  return 'Refs(kind: ${_this.kind}, targetId: ${_this.targetId})';
}


}

/// @nodoc
abstract mixin class $RefsCopyWith<$Res>  {
  factory $RefsCopyWith(Refs value, $Res Function(Refs) _then) = _$RefsCopyWithImpl;
@useResult
$Res call({
 Kind kind,@JsonKey(name: 'target_id') String targetId
});




}
/// @nodoc
class _$RefsCopyWithImpl<$Res>
    implements $RefsCopyWith<$Res> {
  _$RefsCopyWithImpl(this._self, this._then);

  final Refs _self;
  final $Res Function(Refs) _then;

/// Create a copy of Refs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? targetId = null,}) {
  return _then(Refs(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as Kind,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Refs].
extension RefsPatterns on Refs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Refs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Refs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Refs value)  $default,){
final _that = this;
switch (_that) {
case _Refs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Refs value)?  $default,){
final _that = this;
switch (_that) {
case _Refs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Kind kind, @JsonKey(name: 'target_id')  String targetId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Refs() when $default != null:
return $default(_that.kind,_that.targetId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Kind kind, @JsonKey(name: 'target_id')  String targetId)  $default,) {final _that = this;
switch (_that) {
case _Refs():
return $default(_that.kind,_that.targetId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Kind kind, @JsonKey(name: 'target_id')  String targetId)?  $default,) {final _that = this;
switch (_that) {
case _Refs() when $default != null:
return $default(_that.kind,_that.targetId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Refs implements Refs {
  const _Refs({required this.kind, @JsonKey(name: 'target_id') required this.targetId});
  factory _Refs.fromJson(Map<String, dynamic> json) => _$RefsFromJson(json);

@override final  Kind kind;
@override@JsonKey(name: 'target_id') final  String targetId;

/// Create a copy of Refs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RefsCopyWith<_Refs> get copyWith => __$RefsCopyWithImpl<_Refs>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RefsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Refs&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.targetId, targetId) || other.targetId == targetId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,targetId);
}

@override
String toString() {
    return 'Refs(kind: $kind, targetId: $targetId)';
}


}

/// @nodoc
abstract mixin class _$RefsCopyWith<$Res> implements $RefsCopyWith<$Res> {
  factory _$RefsCopyWith(_Refs value, $Res Function(_Refs) _then) = __$RefsCopyWithImpl;
@override @useResult
$Res call({
 Kind kind,@JsonKey(name: 'target_id') String targetId
});




}
/// @nodoc
class __$RefsCopyWithImpl<$Res>
    implements _$RefsCopyWith<$Res> {
  __$RefsCopyWithImpl(this._self, this._then);

  final _Refs _self;
  final $Res Function(_Refs) _then;

/// Create a copy of Refs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? targetId = null,}) {
  return _then(_Refs(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as Kind,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
