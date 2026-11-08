// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poll2.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Poll2 {

 bool get multi;@JsonKey(name: 'closes_at') DateTime? get closesAt;@JsonKey(name: 'closed_at') DateTime? get closedAt; List<Results> get results;
/// Create a copy of Poll2
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Poll2CopyWith<Poll2> get copyWith => _$Poll2CopyWithImpl<Poll2>(this as Poll2, _$identity);

  /// Serializes this Poll2 to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Poll2;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Poll2&&(identical(other.multi, _this.multi) || other.multi == _this.multi)&&(identical(other.closesAt, _this.closesAt) || other.closesAt == _this.closesAt)&&(identical(other.closedAt, _this.closedAt) || other.closedAt == _this.closedAt)&&const DeepCollectionEquality().equals(other.results, _this.results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Poll2;
  return Object.hash(runtimeType,_this.multi,_this.closesAt,_this.closedAt,const DeepCollectionEquality().hash(_this.results));
}

@override
String toString() {
  final _this = this as Poll2;
  return 'Poll2(multi: ${_this.multi}, closesAt: ${_this.closesAt}, closedAt: ${_this.closedAt}, results: ${_this.results})';
}


}

/// @nodoc
abstract mixin class $Poll2CopyWith<$Res>  {
  factory $Poll2CopyWith(Poll2 value, $Res Function(Poll2) _then) = _$Poll2CopyWithImpl;
@useResult
$Res call({
 bool multi,@JsonKey(name: 'closes_at') DateTime? closesAt,@JsonKey(name: 'closed_at') DateTime? closedAt, List<Results> results
});




}
/// @nodoc
class _$Poll2CopyWithImpl<$Res>
    implements $Poll2CopyWith<$Res> {
  _$Poll2CopyWithImpl(this._self, this._then);

  final Poll2 _self;
  final $Res Function(Poll2) _then;

/// Create a copy of Poll2
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? multi = null,Object? closesAt = freezed,Object? closedAt = freezed,Object? results = null,}) {
  return _then(Poll2(
multi: null == multi ? _self.multi : multi // ignore: cast_nullable_to_non_nullable
as bool,closesAt: freezed == closesAt ? _self.closesAt : closesAt // ignore: cast_nullable_to_non_nullable
as DateTime?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<Results>,
  ));
}

}


/// Adds pattern-matching-related methods to [Poll2].
extension Poll2Patterns on Poll2 {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Poll2 value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Poll2() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Poll2 value)  $default,){
final _that = this;
switch (_that) {
case _Poll2():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Poll2 value)?  $default,){
final _that = this;
switch (_that) {
case _Poll2() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool multi, @JsonKey(name: 'closes_at')  DateTime? closesAt, @JsonKey(name: 'closed_at')  DateTime? closedAt,  List<Results> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Poll2() when $default != null:
return $default(_that.multi,_that.closesAt,_that.closedAt,_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool multi, @JsonKey(name: 'closes_at')  DateTime? closesAt, @JsonKey(name: 'closed_at')  DateTime? closedAt,  List<Results> results)  $default,) {final _that = this;
switch (_that) {
case _Poll2():
return $default(_that.multi,_that.closesAt,_that.closedAt,_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool multi, @JsonKey(name: 'closes_at')  DateTime? closesAt, @JsonKey(name: 'closed_at')  DateTime? closedAt,  List<Results> results)?  $default,) {final _that = this;
switch (_that) {
case _Poll2() when $default != null:
return $default(_that.multi,_that.closesAt,_that.closedAt,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Poll2 implements Poll2 {
  const _Poll2({required this.multi, @JsonKey(name: 'closes_at') required this.closesAt, @JsonKey(name: 'closed_at') required this.closedAt, required  List<Results> results}): _results = results;
  factory _Poll2.fromJson(Map<String, dynamic> json) => _$Poll2FromJson(json);

@override final  bool multi;
@override@JsonKey(name: 'closes_at') final  DateTime? closesAt;
@override@JsonKey(name: 'closed_at') final  DateTime? closedAt;
 final  List<Results> _results;
@override List<Results> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of Poll2
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$Poll2CopyWith<_Poll2> get copyWith => __$Poll2CopyWithImpl<_Poll2>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$Poll2ToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Poll2&&(identical(other.multi, multi) || other.multi == multi)&&(identical(other.closesAt, closesAt) || other.closesAt == closesAt)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&const DeepCollectionEquality().equals(other.results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,multi,closesAt,closedAt,const DeepCollectionEquality().hash(_results));
}

@override
String toString() {
    return 'Poll2(multi: $multi, closesAt: $closesAt, closedAt: $closedAt, results: $results)';
}


}

/// @nodoc
abstract mixin class _$Poll2CopyWith<$Res> implements $Poll2CopyWith<$Res> {
  factory _$Poll2CopyWith(_Poll2 value, $Res Function(_Poll2) _then) = __$Poll2CopyWithImpl;
@override @useResult
$Res call({
 bool multi,@JsonKey(name: 'closes_at') DateTime? closesAt,@JsonKey(name: 'closed_at') DateTime? closedAt, List<Results> results
});




}
/// @nodoc
class __$Poll2CopyWithImpl<$Res>
    implements _$Poll2CopyWith<$Res> {
  __$Poll2CopyWithImpl(this._self, this._then);

  final _Poll2 _self;
  final $Res Function(_Poll2) _then;

/// Create a copy of Poll2
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? multi = null,Object? closesAt = freezed,Object? closedAt = freezed,Object? results = null,}) {
  return _then(_Poll2(
multi: null == multi ? _self.multi : multi // ignore: cast_nullable_to_non_nullable
as bool,closesAt: freezed == closesAt ? _self.closesAt : closesAt // ignore: cast_nullable_to_non_nullable
as DateTime?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<Results>,
  ));
}


}

// dart format on
