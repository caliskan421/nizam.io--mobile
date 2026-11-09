// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conference_connected.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConferenceConnected {

 int get count;/// Sıralı ve tekil hesap kimlikleri.
@JsonKey(name: 'account_ids') List<String> get accountIds;@JsonKey(name: 'observed_at') DateTime? get observedAt;
/// Create a copy of ConferenceConnected
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConferenceConnectedCopyWith<ConferenceConnected> get copyWith => _$ConferenceConnectedCopyWithImpl<ConferenceConnected>(this as ConferenceConnected, _$identity);

  /// Serializes this ConferenceConnected to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ConferenceConnected;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConferenceConnected&&(identical(other.count, _this.count) || other.count == _this.count)&&const DeepCollectionEquality().equals(other.accountIds, _this.accountIds)&&(identical(other.observedAt, _this.observedAt) || other.observedAt == _this.observedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ConferenceConnected;
  return Object.hash(runtimeType,_this.count,const DeepCollectionEquality().hash(_this.accountIds),_this.observedAt);
}

@override
String toString() {
  final _this = this as ConferenceConnected;
  return 'ConferenceConnected(count: ${_this.count}, accountIds: ${_this.accountIds}, observedAt: ${_this.observedAt})';
}


}

/// @nodoc
abstract mixin class $ConferenceConnectedCopyWith<$Res>  {
  factory $ConferenceConnectedCopyWith(ConferenceConnected value, $Res Function(ConferenceConnected) _then) = _$ConferenceConnectedCopyWithImpl;
@useResult
$Res call({
 int count,@JsonKey(name: 'account_ids') List<String> accountIds,@JsonKey(name: 'observed_at') DateTime? observedAt
});




}
/// @nodoc
class _$ConferenceConnectedCopyWithImpl<$Res>
    implements $ConferenceConnectedCopyWith<$Res> {
  _$ConferenceConnectedCopyWithImpl(this._self, this._then);

  final ConferenceConnected _self;
  final $Res Function(ConferenceConnected) _then;

/// Create a copy of ConferenceConnected
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? accountIds = null,Object? observedAt = freezed,}) {
  return _then(ConferenceConnected(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,accountIds: null == accountIds ? _self.accountIds : accountIds // ignore: cast_nullable_to_non_nullable
as List<String>,observedAt: freezed == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConferenceConnected].
extension ConferenceConnectedPatterns on ConferenceConnected {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConferenceConnected value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConferenceConnected() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConferenceConnected value)  $default,){
final _that = this;
switch (_that) {
case _ConferenceConnected():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConferenceConnected value)?  $default,){
final _that = this;
switch (_that) {
case _ConferenceConnected() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count, @JsonKey(name: 'account_ids')  List<String> accountIds, @JsonKey(name: 'observed_at')  DateTime? observedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConferenceConnected() when $default != null:
return $default(_that.count,_that.accountIds,_that.observedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count, @JsonKey(name: 'account_ids')  List<String> accountIds, @JsonKey(name: 'observed_at')  DateTime? observedAt)  $default,) {final _that = this;
switch (_that) {
case _ConferenceConnected():
return $default(_that.count,_that.accountIds,_that.observedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count, @JsonKey(name: 'account_ids')  List<String> accountIds, @JsonKey(name: 'observed_at')  DateTime? observedAt)?  $default,) {final _that = this;
switch (_that) {
case _ConferenceConnected() when $default != null:
return $default(_that.count,_that.accountIds,_that.observedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConferenceConnected implements ConferenceConnected {
  const _ConferenceConnected({required this.count, @JsonKey(name: 'account_ids') required  List<String> accountIds, @JsonKey(name: 'observed_at') required this.observedAt}): _accountIds = accountIds;
  factory _ConferenceConnected.fromJson(Map<String, dynamic> json) => _$ConferenceConnectedFromJson(json);

@override final  int count;
/// Sıralı ve tekil hesap kimlikleri.
 final  List<String> _accountIds;
/// Sıralı ve tekil hesap kimlikleri.
@override@JsonKey(name: 'account_ids') List<String> get accountIds {
  if (_accountIds is EqualUnmodifiableListView) return _accountIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accountIds);
}

@override@JsonKey(name: 'observed_at') final  DateTime? observedAt;

/// Create a copy of ConferenceConnected
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConferenceConnectedCopyWith<_ConferenceConnected> get copyWith => __$ConferenceConnectedCopyWithImpl<_ConferenceConnected>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConferenceConnectedToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConferenceConnected&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other.accountIds, _accountIds)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,count,const DeepCollectionEquality().hash(_accountIds),observedAt);
}

@override
String toString() {
    return 'ConferenceConnected(count: $count, accountIds: $accountIds, observedAt: $observedAt)';
}


}

/// @nodoc
abstract mixin class _$ConferenceConnectedCopyWith<$Res> implements $ConferenceConnectedCopyWith<$Res> {
  factory _$ConferenceConnectedCopyWith(_ConferenceConnected value, $Res Function(_ConferenceConnected) _then) = __$ConferenceConnectedCopyWithImpl;
@override @useResult
$Res call({
 int count,@JsonKey(name: 'account_ids') List<String> accountIds,@JsonKey(name: 'observed_at') DateTime? observedAt
});




}
/// @nodoc
class __$ConferenceConnectedCopyWithImpl<$Res>
    implements _$ConferenceConnectedCopyWith<$Res> {
  __$ConferenceConnectedCopyWithImpl(this._self, this._then);

  final _ConferenceConnected _self;
  final $Res Function(_ConferenceConnected) _then;

/// Create a copy of ConferenceConnected
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? accountIds = null,Object? observedAt = freezed,}) {
  return _then(_ConferenceConnected(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,accountIds: null == accountIds ? _self._accountIds : accountIds // ignore: cast_nullable_to_non_nullable
as List<String>,observedAt: freezed == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
