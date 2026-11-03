// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reactions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Reactions {

 Kind2 get kind; int get count; bool get mine;
/// Create a copy of Reactions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReactionsCopyWith<Reactions> get copyWith => _$ReactionsCopyWithImpl<Reactions>(this as Reactions, _$identity);

  /// Serializes this Reactions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Reactions;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Reactions&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.mine, _this.mine) || other.mine == _this.mine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Reactions;
  return Object.hash(runtimeType,_this.kind,_this.count,_this.mine);
}

@override
String toString() {
  final _this = this as Reactions;
  return 'Reactions(kind: ${_this.kind}, count: ${_this.count}, mine: ${_this.mine})';
}


}

/// @nodoc
abstract mixin class $ReactionsCopyWith<$Res>  {
  factory $ReactionsCopyWith(Reactions value, $Res Function(Reactions) _then) = _$ReactionsCopyWithImpl;
@useResult
$Res call({
 Kind2 kind, int count, bool mine
});




}
/// @nodoc
class _$ReactionsCopyWithImpl<$Res>
    implements $ReactionsCopyWith<$Res> {
  _$ReactionsCopyWithImpl(this._self, this._then);

  final Reactions _self;
  final $Res Function(Reactions) _then;

/// Create a copy of Reactions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? count = null,Object? mine = null,}) {
  return _then(Reactions(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as Kind2,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,mine: null == mine ? _self.mine : mine // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Reactions].
extension ReactionsPatterns on Reactions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Reactions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Reactions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Reactions value)  $default,){
final _that = this;
switch (_that) {
case _Reactions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Reactions value)?  $default,){
final _that = this;
switch (_that) {
case _Reactions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Kind2 kind,  int count,  bool mine)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Reactions() when $default != null:
return $default(_that.kind,_that.count,_that.mine);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Kind2 kind,  int count,  bool mine)  $default,) {final _that = this;
switch (_that) {
case _Reactions():
return $default(_that.kind,_that.count,_that.mine);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Kind2 kind,  int count,  bool mine)?  $default,) {final _that = this;
switch (_that) {
case _Reactions() when $default != null:
return $default(_that.kind,_that.count,_that.mine);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Reactions implements Reactions {
  const _Reactions({required this.kind, required this.count, required this.mine});
  factory _Reactions.fromJson(Map<String, dynamic> json) => _$ReactionsFromJson(json);

@override final  Kind2 kind;
@override final  int count;
@override final  bool mine;

/// Create a copy of Reactions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReactionsCopyWith<_Reactions> get copyWith => __$ReactionsCopyWithImpl<_Reactions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReactionsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reactions&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.count, count) || other.count == count)&&(identical(other.mine, mine) || other.mine == mine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,count,mine);
}

@override
String toString() {
    return 'Reactions(kind: $kind, count: $count, mine: $mine)';
}


}

/// @nodoc
abstract mixin class _$ReactionsCopyWith<$Res> implements $ReactionsCopyWith<$Res> {
  factory _$ReactionsCopyWith(_Reactions value, $Res Function(_Reactions) _then) = __$ReactionsCopyWithImpl;
@override @useResult
$Res call({
 Kind2 kind, int count, bool mine
});




}
/// @nodoc
class __$ReactionsCopyWithImpl<$Res>
    implements _$ReactionsCopyWith<$Res> {
  __$ReactionsCopyWithImpl(this._self, this._then);

  final _Reactions _self;
  final $Res Function(_Reactions) _then;

/// Create a copy of Reactions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? count = null,Object? mine = null,}) {
  return _then(_Reactions(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as Kind2,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,mine: null == mine ? _self.mine : mine // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
