// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lateness.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Lateness {

@JsonKey(name: 'is_overdue') bool get isOverdue;@JsonKey(name: 'days_overdue') int get daysOverdue;@JsonKey(name: 'is_completed_late') bool get isCompletedLate;@JsonKey(name: 'days_late') int get daysLate;@JsonKey(name: 'is_completed_early') bool get isCompletedEarly;@JsonKey(name: 'days_early') int get daysEarly;
/// Create a copy of Lateness
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LatenessCopyWith<Lateness> get copyWith => _$LatenessCopyWithImpl<Lateness>(this as Lateness, _$identity);

  /// Serializes this Lateness to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Lateness;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Lateness&&(identical(other.isOverdue, _this.isOverdue) || other.isOverdue == _this.isOverdue)&&(identical(other.daysOverdue, _this.daysOverdue) || other.daysOverdue == _this.daysOverdue)&&(identical(other.isCompletedLate, _this.isCompletedLate) || other.isCompletedLate == _this.isCompletedLate)&&(identical(other.daysLate, _this.daysLate) || other.daysLate == _this.daysLate)&&(identical(other.isCompletedEarly, _this.isCompletedEarly) || other.isCompletedEarly == _this.isCompletedEarly)&&(identical(other.daysEarly, _this.daysEarly) || other.daysEarly == _this.daysEarly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Lateness;
  return Object.hash(runtimeType,_this.isOverdue,_this.daysOverdue,_this.isCompletedLate,_this.daysLate,_this.isCompletedEarly,_this.daysEarly);
}

@override
String toString() {
  final _this = this as Lateness;
  return 'Lateness(isOverdue: ${_this.isOverdue}, daysOverdue: ${_this.daysOverdue}, isCompletedLate: ${_this.isCompletedLate}, daysLate: ${_this.daysLate}, isCompletedEarly: ${_this.isCompletedEarly}, daysEarly: ${_this.daysEarly})';
}


}

/// @nodoc
abstract mixin class $LatenessCopyWith<$Res>  {
  factory $LatenessCopyWith(Lateness value, $Res Function(Lateness) _then) = _$LatenessCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'is_overdue') bool isOverdue,@JsonKey(name: 'days_overdue') int daysOverdue,@JsonKey(name: 'is_completed_late') bool isCompletedLate,@JsonKey(name: 'days_late') int daysLate,@JsonKey(name: 'is_completed_early') bool isCompletedEarly,@JsonKey(name: 'days_early') int daysEarly
});




}
/// @nodoc
class _$LatenessCopyWithImpl<$Res>
    implements $LatenessCopyWith<$Res> {
  _$LatenessCopyWithImpl(this._self, this._then);

  final Lateness _self;
  final $Res Function(Lateness) _then;

/// Create a copy of Lateness
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isOverdue = null,Object? daysOverdue = null,Object? isCompletedLate = null,Object? daysLate = null,Object? isCompletedEarly = null,Object? daysEarly = null,}) {
  return _then(Lateness(
isOverdue: null == isOverdue ? _self.isOverdue : isOverdue // ignore: cast_nullable_to_non_nullable
as bool,daysOverdue: null == daysOverdue ? _self.daysOverdue : daysOverdue // ignore: cast_nullable_to_non_nullable
as int,isCompletedLate: null == isCompletedLate ? _self.isCompletedLate : isCompletedLate // ignore: cast_nullable_to_non_nullable
as bool,daysLate: null == daysLate ? _self.daysLate : daysLate // ignore: cast_nullable_to_non_nullable
as int,isCompletedEarly: null == isCompletedEarly ? _self.isCompletedEarly : isCompletedEarly // ignore: cast_nullable_to_non_nullable
as bool,daysEarly: null == daysEarly ? _self.daysEarly : daysEarly // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Lateness].
extension LatenessPatterns on Lateness {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Lateness value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Lateness() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Lateness value)  $default,){
final _that = this;
switch (_that) {
case _Lateness():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Lateness value)?  $default,){
final _that = this;
switch (_that) {
case _Lateness() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'is_overdue')  bool isOverdue, @JsonKey(name: 'days_overdue')  int daysOverdue, @JsonKey(name: 'is_completed_late')  bool isCompletedLate, @JsonKey(name: 'days_late')  int daysLate, @JsonKey(name: 'is_completed_early')  bool isCompletedEarly, @JsonKey(name: 'days_early')  int daysEarly)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Lateness() when $default != null:
return $default(_that.isOverdue,_that.daysOverdue,_that.isCompletedLate,_that.daysLate,_that.isCompletedEarly,_that.daysEarly);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'is_overdue')  bool isOverdue, @JsonKey(name: 'days_overdue')  int daysOverdue, @JsonKey(name: 'is_completed_late')  bool isCompletedLate, @JsonKey(name: 'days_late')  int daysLate, @JsonKey(name: 'is_completed_early')  bool isCompletedEarly, @JsonKey(name: 'days_early')  int daysEarly)  $default,) {final _that = this;
switch (_that) {
case _Lateness():
return $default(_that.isOverdue,_that.daysOverdue,_that.isCompletedLate,_that.daysLate,_that.isCompletedEarly,_that.daysEarly);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'is_overdue')  bool isOverdue, @JsonKey(name: 'days_overdue')  int daysOverdue, @JsonKey(name: 'is_completed_late')  bool isCompletedLate, @JsonKey(name: 'days_late')  int daysLate, @JsonKey(name: 'is_completed_early')  bool isCompletedEarly, @JsonKey(name: 'days_early')  int daysEarly)?  $default,) {final _that = this;
switch (_that) {
case _Lateness() when $default != null:
return $default(_that.isOverdue,_that.daysOverdue,_that.isCompletedLate,_that.daysLate,_that.isCompletedEarly,_that.daysEarly);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Lateness implements Lateness {
  const _Lateness({@JsonKey(name: 'is_overdue') required this.isOverdue, @JsonKey(name: 'days_overdue') required this.daysOverdue, @JsonKey(name: 'is_completed_late') required this.isCompletedLate, @JsonKey(name: 'days_late') required this.daysLate, @JsonKey(name: 'is_completed_early') required this.isCompletedEarly, @JsonKey(name: 'days_early') required this.daysEarly});
  factory _Lateness.fromJson(Map<String, dynamic> json) => _$LatenessFromJson(json);

@override@JsonKey(name: 'is_overdue') final  bool isOverdue;
@override@JsonKey(name: 'days_overdue') final  int daysOverdue;
@override@JsonKey(name: 'is_completed_late') final  bool isCompletedLate;
@override@JsonKey(name: 'days_late') final  int daysLate;
@override@JsonKey(name: 'is_completed_early') final  bool isCompletedEarly;
@override@JsonKey(name: 'days_early') final  int daysEarly;

/// Create a copy of Lateness
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LatenessCopyWith<_Lateness> get copyWith => __$LatenessCopyWithImpl<_Lateness>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LatenessToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Lateness&&(identical(other.isOverdue, isOverdue) || other.isOverdue == isOverdue)&&(identical(other.daysOverdue, daysOverdue) || other.daysOverdue == daysOverdue)&&(identical(other.isCompletedLate, isCompletedLate) || other.isCompletedLate == isCompletedLate)&&(identical(other.daysLate, daysLate) || other.daysLate == daysLate)&&(identical(other.isCompletedEarly, isCompletedEarly) || other.isCompletedEarly == isCompletedEarly)&&(identical(other.daysEarly, daysEarly) || other.daysEarly == daysEarly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,isOverdue,daysOverdue,isCompletedLate,daysLate,isCompletedEarly,daysEarly);
}

@override
String toString() {
    return 'Lateness(isOverdue: $isOverdue, daysOverdue: $daysOverdue, isCompletedLate: $isCompletedLate, daysLate: $daysLate, isCompletedEarly: $isCompletedEarly, daysEarly: $daysEarly)';
}


}

/// @nodoc
abstract mixin class _$LatenessCopyWith<$Res> implements $LatenessCopyWith<$Res> {
  factory _$LatenessCopyWith(_Lateness value, $Res Function(_Lateness) _then) = __$LatenessCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'is_overdue') bool isOverdue,@JsonKey(name: 'days_overdue') int daysOverdue,@JsonKey(name: 'is_completed_late') bool isCompletedLate,@JsonKey(name: 'days_late') int daysLate,@JsonKey(name: 'is_completed_early') bool isCompletedEarly,@JsonKey(name: 'days_early') int daysEarly
});




}
/// @nodoc
class __$LatenessCopyWithImpl<$Res>
    implements _$LatenessCopyWith<$Res> {
  __$LatenessCopyWithImpl(this._self, this._then);

  final _Lateness _self;
  final $Res Function(_Lateness) _then;

/// Create a copy of Lateness
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isOverdue = null,Object? daysOverdue = null,Object? isCompletedLate = null,Object? daysLate = null,Object? isCompletedEarly = null,Object? daysEarly = null,}) {
  return _then(_Lateness(
isOverdue: null == isOverdue ? _self.isOverdue : isOverdue // ignore: cast_nullable_to_non_nullable
as bool,daysOverdue: null == daysOverdue ? _self.daysOverdue : daysOverdue // ignore: cast_nullable_to_non_nullable
as int,isCompletedLate: null == isCompletedLate ? _self.isCompletedLate : isCompletedLate // ignore: cast_nullable_to_non_nullable
as bool,daysLate: null == daysLate ? _self.daysLate : daysLate // ignore: cast_nullable_to_non_nullable
as int,isCompletedEarly: null == isCompletedEarly ? _self.isCompletedEarly : isCompletedEarly // ignore: cast_nullable_to_non_nullable
as bool,daysEarly: null == daysEarly ? _self.daysEarly : daysEarly // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
