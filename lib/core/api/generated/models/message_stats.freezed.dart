// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageStats {

 int get total;@JsonKey(name: 'from_admins') int get fromAdmins;@JsonKey(name: 'from_others') int get fromOthers;
/// Create a copy of MessageStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageStatsCopyWith<MessageStats> get copyWith => _$MessageStatsCopyWithImpl<MessageStats>(this as MessageStats, _$identity);

  /// Serializes this MessageStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MessageStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageStats&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.fromAdmins, _this.fromAdmins) || other.fromAdmins == _this.fromAdmins)&&(identical(other.fromOthers, _this.fromOthers) || other.fromOthers == _this.fromOthers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MessageStats;
  return Object.hash(runtimeType,_this.total,_this.fromAdmins,_this.fromOthers);
}

@override
String toString() {
  final _this = this as MessageStats;
  return 'MessageStats(total: ${_this.total}, fromAdmins: ${_this.fromAdmins}, fromOthers: ${_this.fromOthers})';
}


}

/// @nodoc
abstract mixin class $MessageStatsCopyWith<$Res>  {
  factory $MessageStatsCopyWith(MessageStats value, $Res Function(MessageStats) _then) = _$MessageStatsCopyWithImpl;
@useResult
$Res call({
 int total,@JsonKey(name: 'from_admins') int fromAdmins,@JsonKey(name: 'from_others') int fromOthers
});




}
/// @nodoc
class _$MessageStatsCopyWithImpl<$Res>
    implements $MessageStatsCopyWith<$Res> {
  _$MessageStatsCopyWithImpl(this._self, this._then);

  final MessageStats _self;
  final $Res Function(MessageStats) _then;

/// Create a copy of MessageStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? fromAdmins = null,Object? fromOthers = null,}) {
  return _then(MessageStats(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,fromAdmins: null == fromAdmins ? _self.fromAdmins : fromAdmins // ignore: cast_nullable_to_non_nullable
as int,fromOthers: null == fromOthers ? _self.fromOthers : fromOthers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageStats].
extension MessageStatsPatterns on MessageStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageStats value)  $default,){
final _that = this;
switch (_that) {
case _MessageStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageStats value)?  $default,){
final _that = this;
switch (_that) {
case _MessageStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total, @JsonKey(name: 'from_admins')  int fromAdmins, @JsonKey(name: 'from_others')  int fromOthers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageStats() when $default != null:
return $default(_that.total,_that.fromAdmins,_that.fromOthers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total, @JsonKey(name: 'from_admins')  int fromAdmins, @JsonKey(name: 'from_others')  int fromOthers)  $default,) {final _that = this;
switch (_that) {
case _MessageStats():
return $default(_that.total,_that.fromAdmins,_that.fromOthers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total, @JsonKey(name: 'from_admins')  int fromAdmins, @JsonKey(name: 'from_others')  int fromOthers)?  $default,) {final _that = this;
switch (_that) {
case _MessageStats() when $default != null:
return $default(_that.total,_that.fromAdmins,_that.fromOthers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageStats implements MessageStats {
  const _MessageStats({required this.total, @JsonKey(name: 'from_admins') required this.fromAdmins, @JsonKey(name: 'from_others') required this.fromOthers});
  factory _MessageStats.fromJson(Map<String, dynamic> json) => _$MessageStatsFromJson(json);

@override final  int total;
@override@JsonKey(name: 'from_admins') final  int fromAdmins;
@override@JsonKey(name: 'from_others') final  int fromOthers;

/// Create a copy of MessageStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageStatsCopyWith<_MessageStats> get copyWith => __$MessageStatsCopyWithImpl<_MessageStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageStats&&(identical(other.total, total) || other.total == total)&&(identical(other.fromAdmins, fromAdmins) || other.fromAdmins == fromAdmins)&&(identical(other.fromOthers, fromOthers) || other.fromOthers == fromOthers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,fromAdmins,fromOthers);
}

@override
String toString() {
    return 'MessageStats(total: $total, fromAdmins: $fromAdmins, fromOthers: $fromOthers)';
}


}

/// @nodoc
abstract mixin class _$MessageStatsCopyWith<$Res> implements $MessageStatsCopyWith<$Res> {
  factory _$MessageStatsCopyWith(_MessageStats value, $Res Function(_MessageStats) _then) = __$MessageStatsCopyWithImpl;
@override @useResult
$Res call({
 int total,@JsonKey(name: 'from_admins') int fromAdmins,@JsonKey(name: 'from_others') int fromOthers
});




}
/// @nodoc
class __$MessageStatsCopyWithImpl<$Res>
    implements _$MessageStatsCopyWith<$Res> {
  __$MessageStatsCopyWithImpl(this._self, this._then);

  final _MessageStats _self;
  final $Res Function(_MessageStats) _then;

/// Create a copy of MessageStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? fromAdmins = null,Object? fromOthers = null,}) {
  return _then(_MessageStats(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,fromAdmins: null == fromAdmins ? _self.fromAdmins : fromAdmins // ignore: cast_nullable_to_non_nullable
as int,fromOthers: null == fromOthers ? _self.fromOthers : fromOthers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
