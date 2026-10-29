// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'date_change_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DateChangeStats {

 int get total; int get approved; int get rejected; int get pending;
/// Create a copy of DateChangeStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DateChangeStatsCopyWith<DateChangeStats> get copyWith => _$DateChangeStatsCopyWithImpl<DateChangeStats>(this as DateChangeStats, _$identity);

  /// Serializes this DateChangeStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DateChangeStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DateChangeStats&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.approved, _this.approved) || other.approved == _this.approved)&&(identical(other.rejected, _this.rejected) || other.rejected == _this.rejected)&&(identical(other.pending, _this.pending) || other.pending == _this.pending));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DateChangeStats;
  return Object.hash(runtimeType,_this.total,_this.approved,_this.rejected,_this.pending);
}

@override
String toString() {
  final _this = this as DateChangeStats;
  return 'DateChangeStats(total: ${_this.total}, approved: ${_this.approved}, rejected: ${_this.rejected}, pending: ${_this.pending})';
}


}

/// @nodoc
abstract mixin class $DateChangeStatsCopyWith<$Res>  {
  factory $DateChangeStatsCopyWith(DateChangeStats value, $Res Function(DateChangeStats) _then) = _$DateChangeStatsCopyWithImpl;
@useResult
$Res call({
 int total, int approved, int rejected, int pending
});




}
/// @nodoc
class _$DateChangeStatsCopyWithImpl<$Res>
    implements $DateChangeStatsCopyWith<$Res> {
  _$DateChangeStatsCopyWithImpl(this._self, this._then);

  final DateChangeStats _self;
  final $Res Function(DateChangeStats) _then;

/// Create a copy of DateChangeStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? approved = null,Object? rejected = null,Object? pending = null,}) {
  return _then(DateChangeStats(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,approved: null == approved ? _self.approved : approved // ignore: cast_nullable_to_non_nullable
as int,rejected: null == rejected ? _self.rejected : rejected // ignore: cast_nullable_to_non_nullable
as int,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DateChangeStats].
extension DateChangeStatsPatterns on DateChangeStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DateChangeStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DateChangeStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DateChangeStats value)  $default,){
final _that = this;
switch (_that) {
case _DateChangeStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DateChangeStats value)?  $default,){
final _that = this;
switch (_that) {
case _DateChangeStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int approved,  int rejected,  int pending)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DateChangeStats() when $default != null:
return $default(_that.total,_that.approved,_that.rejected,_that.pending);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int approved,  int rejected,  int pending)  $default,) {final _that = this;
switch (_that) {
case _DateChangeStats():
return $default(_that.total,_that.approved,_that.rejected,_that.pending);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int approved,  int rejected,  int pending)?  $default,) {final _that = this;
switch (_that) {
case _DateChangeStats() when $default != null:
return $default(_that.total,_that.approved,_that.rejected,_that.pending);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DateChangeStats implements DateChangeStats {
  const _DateChangeStats({required this.total, required this.approved, required this.rejected, required this.pending});
  factory _DateChangeStats.fromJson(Map<String, dynamic> json) => _$DateChangeStatsFromJson(json);

@override final  int total;
@override final  int approved;
@override final  int rejected;
@override final  int pending;

/// Create a copy of DateChangeStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DateChangeStatsCopyWith<_DateChangeStats> get copyWith => __$DateChangeStatsCopyWithImpl<_DateChangeStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DateChangeStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DateChangeStats&&(identical(other.total, total) || other.total == total)&&(identical(other.approved, approved) || other.approved == approved)&&(identical(other.rejected, rejected) || other.rejected == rejected)&&(identical(other.pending, pending) || other.pending == pending));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,approved,rejected,pending);
}

@override
String toString() {
    return 'DateChangeStats(total: $total, approved: $approved, rejected: $rejected, pending: $pending)';
}


}

/// @nodoc
abstract mixin class _$DateChangeStatsCopyWith<$Res> implements $DateChangeStatsCopyWith<$Res> {
  factory _$DateChangeStatsCopyWith(_DateChangeStats value, $Res Function(_DateChangeStats) _then) = __$DateChangeStatsCopyWithImpl;
@override @useResult
$Res call({
 int total, int approved, int rejected, int pending
});




}
/// @nodoc
class __$DateChangeStatsCopyWithImpl<$Res>
    implements _$DateChangeStatsCopyWith<$Res> {
  __$DateChangeStatsCopyWithImpl(this._self, this._then);

  final _DateChangeStats _self;
  final $Res Function(_DateChangeStats) _then;

/// Create a copy of DateChangeStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? approved = null,Object? rejected = null,Object? pending = null,}) {
  return _then(_DateChangeStats(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,approved: null == approved ? _self.approved : approved // ignore: cast_nullable_to_non_nullable
as int,rejected: null == rejected ? _self.rejected : rejected // ignore: cast_nullable_to_non_nullable
as int,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
