// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poll.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Poll {

/// 2–10 tekil, tek satır seçenek (en çok 100 karakter).
 List<String> get options; bool? get multi;/// Şimdiden sonra olmalıdır.
@JsonKey(name: 'closes_at') DateTime? get closesAt;
/// Create a copy of Poll
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollCopyWith<Poll> get copyWith => _$PollCopyWithImpl<Poll>(this as Poll, _$identity);

  /// Serializes this Poll to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Poll;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Poll&&const DeepCollectionEquality().equals(other.options, _this.options)&&(identical(other.multi, _this.multi) || other.multi == _this.multi)&&(identical(other.closesAt, _this.closesAt) || other.closesAt == _this.closesAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Poll;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.options),_this.multi,_this.closesAt);
}

@override
String toString() {
  final _this = this as Poll;
  return 'Poll(options: ${_this.options}, multi: ${_this.multi}, closesAt: ${_this.closesAt})';
}


}

/// @nodoc
abstract mixin class $PollCopyWith<$Res>  {
  factory $PollCopyWith(Poll value, $Res Function(Poll) _then) = _$PollCopyWithImpl;
@useResult
$Res call({
 List<String> options, bool? multi,@JsonKey(name: 'closes_at') DateTime? closesAt
});




}
/// @nodoc
class _$PollCopyWithImpl<$Res>
    implements $PollCopyWith<$Res> {
  _$PollCopyWithImpl(this._self, this._then);

  final Poll _self;
  final $Res Function(Poll) _then;

/// Create a copy of Poll
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? options = null,Object? multi = freezed,Object? closesAt = freezed,}) {
  return _then(Poll(
options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,multi: freezed == multi ? _self.multi : multi // ignore: cast_nullable_to_non_nullable
as bool?,closesAt: freezed == closesAt ? _self.closesAt : closesAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Poll].
extension PollPatterns on Poll {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Poll value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Poll() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Poll value)  $default,){
final _that = this;
switch (_that) {
case _Poll():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Poll value)?  $default,){
final _that = this;
switch (_that) {
case _Poll() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> options,  bool? multi, @JsonKey(name: 'closes_at')  DateTime? closesAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Poll() when $default != null:
return $default(_that.options,_that.multi,_that.closesAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> options,  bool? multi, @JsonKey(name: 'closes_at')  DateTime? closesAt)  $default,) {final _that = this;
switch (_that) {
case _Poll():
return $default(_that.options,_that.multi,_that.closesAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> options,  bool? multi, @JsonKey(name: 'closes_at')  DateTime? closesAt)?  $default,) {final _that = this;
switch (_that) {
case _Poll() when $default != null:
return $default(_that.options,_that.multi,_that.closesAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Poll implements Poll {
  const _Poll({required  List<String> options, this.multi, @JsonKey(name: 'closes_at') this.closesAt}): _options = options;
  factory _Poll.fromJson(Map<String, dynamic> json) => _$PollFromJson(json);

/// 2–10 tekil, tek satır seçenek (en çok 100 karakter).
 final  List<String> _options;
/// 2–10 tekil, tek satır seçenek (en çok 100 karakter).
@override List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  bool? multi;
/// Şimdiden sonra olmalıdır.
@override@JsonKey(name: 'closes_at') final  DateTime? closesAt;

/// Create a copy of Poll
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollCopyWith<_Poll> get copyWith => __$PollCopyWithImpl<_Poll>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PollToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Poll&&const DeepCollectionEquality().equals(other.options, _options)&&(identical(other.multi, multi) || other.multi == multi)&&(identical(other.closesAt, closesAt) || other.closesAt == closesAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_options),multi,closesAt);
}

@override
String toString() {
    return 'Poll(options: $options, multi: $multi, closesAt: $closesAt)';
}


}

/// @nodoc
abstract mixin class _$PollCopyWith<$Res> implements $PollCopyWith<$Res> {
  factory _$PollCopyWith(_Poll value, $Res Function(_Poll) _then) = __$PollCopyWithImpl;
@override @useResult
$Res call({
 List<String> options, bool? multi,@JsonKey(name: 'closes_at') DateTime? closesAt
});




}
/// @nodoc
class __$PollCopyWithImpl<$Res>
    implements _$PollCopyWith<$Res> {
  __$PollCopyWithImpl(this._self, this._then);

  final _Poll _self;
  final $Res Function(_Poll) _then;

/// Create a copy of Poll
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? options = null,Object? multi = freezed,Object? closesAt = freezed,}) {
  return _then(_Poll(
options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,multi: freezed == multi ? _self.multi : multi // ignore: cast_nullable_to_non_nullable
as bool?,closesAt: freezed == closesAt ? _self.closesAt : closesAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
