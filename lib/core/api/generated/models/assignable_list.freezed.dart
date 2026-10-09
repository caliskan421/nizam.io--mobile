// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assignable_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssignableList {

 List<AssignableAccount>? get accounts;
/// Create a copy of AssignableList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssignableListCopyWith<AssignableList> get copyWith => _$AssignableListCopyWithImpl<AssignableList>(this as AssignableList, _$identity);

  /// Serializes this AssignableList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AssignableList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssignableList&&const DeepCollectionEquality().equals(other.accounts, _this.accounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AssignableList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.accounts));
}

@override
String toString() {
  final _this = this as AssignableList;
  return 'AssignableList(accounts: ${_this.accounts})';
}


}

/// @nodoc
abstract mixin class $AssignableListCopyWith<$Res>  {
  factory $AssignableListCopyWith(AssignableList value, $Res Function(AssignableList) _then) = _$AssignableListCopyWithImpl;
@useResult
$Res call({
 List<AssignableAccount>? accounts
});




}
/// @nodoc
class _$AssignableListCopyWithImpl<$Res>
    implements $AssignableListCopyWith<$Res> {
  _$AssignableListCopyWithImpl(this._self, this._then);

  final AssignableList _self;
  final $Res Function(AssignableList) _then;

/// Create a copy of AssignableList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accounts = freezed,}) {
  return _then(AssignableList(
accounts: freezed == accounts ? _self.accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<AssignableAccount>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssignableList].
extension AssignableListPatterns on AssignableList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssignableList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssignableList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssignableList value)  $default,){
final _that = this;
switch (_that) {
case _AssignableList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssignableList value)?  $default,){
final _that = this;
switch (_that) {
case _AssignableList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AssignableAccount>? accounts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssignableList() when $default != null:
return $default(_that.accounts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AssignableAccount>? accounts)  $default,) {final _that = this;
switch (_that) {
case _AssignableList():
return $default(_that.accounts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AssignableAccount>? accounts)?  $default,) {final _that = this;
switch (_that) {
case _AssignableList() when $default != null:
return $default(_that.accounts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssignableList implements AssignableList {
  const _AssignableList({required  List<AssignableAccount>? accounts}): _accounts = accounts;
  factory _AssignableList.fromJson(Map<String, dynamic> json) => _$AssignableListFromJson(json);

 final  List<AssignableAccount>? _accounts;
@override List<AssignableAccount>? get accounts {
  final value = _accounts;
  if (value == null) return null;
  if (_accounts is EqualUnmodifiableListView) return _accounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of AssignableList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssignableListCopyWith<_AssignableList> get copyWith => __$AssignableListCopyWithImpl<_AssignableList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssignableListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssignableList&&const DeepCollectionEquality().equals(other.accounts, _accounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_accounts));
}

@override
String toString() {
    return 'AssignableList(accounts: $accounts)';
}


}

/// @nodoc
abstract mixin class _$AssignableListCopyWith<$Res> implements $AssignableListCopyWith<$Res> {
  factory _$AssignableListCopyWith(_AssignableList value, $Res Function(_AssignableList) _then) = __$AssignableListCopyWithImpl;
@override @useResult
$Res call({
 List<AssignableAccount>? accounts
});




}
/// @nodoc
class __$AssignableListCopyWithImpl<$Res>
    implements _$AssignableListCopyWith<$Res> {
  __$AssignableListCopyWithImpl(this._self, this._then);

  final _AssignableList _self;
  final $Res Function(_AssignableList) _then;

/// Create a copy of AssignableList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accounts = freezed,}) {
  return _then(_AssignableList(
accounts: freezed == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<AssignableAccount>?,
  ));
}


}

// dart format on
