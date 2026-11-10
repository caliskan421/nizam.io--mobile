// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserList {

 List<KnownUser>? get users;/// Bütün süzgeçlere (rol dahil) uyan hesap sayısı; imleç zincirinin toplam satır sayısıdır.
 int get total;@JsonKey(name: 'role_counts') UserRoleCounts get roleCounts;/// Devam eden listede dolu. Süzgeçli listede sayfa `limit`ten az satırla (boş da olabilir) ve dolu `next_cursor` ile dönebilir (istek başına tarama bütçesi); istemci `next_cursor` boşalana dek devam eder, satır atlanmaz ve tekrar etmez.
@JsonKey(name: 'next_cursor') String? get nextCursor;
/// Create a copy of UserList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserListCopyWith<UserList> get copyWith => _$UserListCopyWithImpl<UserList>(this as UserList, _$identity);

  /// Serializes this UserList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserList&&const DeepCollectionEquality().equals(other.users, _this.users)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.roleCounts, _this.roleCounts) || other.roleCounts == _this.roleCounts)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.users),_this.total,_this.roleCounts,_this.nextCursor);
}

@override
String toString() {
  final _this = this as UserList;
  return 'UserList(users: ${_this.users}, total: ${_this.total}, roleCounts: ${_this.roleCounts}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $UserListCopyWith<$Res>  {
  factory $UserListCopyWith(UserList value, $Res Function(UserList) _then) = _$UserListCopyWithImpl;
@useResult
$Res call({
 List<KnownUser>? users, int total,@JsonKey(name: 'role_counts') UserRoleCounts roleCounts,@JsonKey(name: 'next_cursor') String? nextCursor
});


$UserRoleCountsCopyWith<$Res> get roleCounts;

}
/// @nodoc
class _$UserListCopyWithImpl<$Res>
    implements $UserListCopyWith<$Res> {
  _$UserListCopyWithImpl(this._self, this._then);

  final UserList _self;
  final $Res Function(UserList) _then;

/// Create a copy of UserList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? users = freezed,Object? total = null,Object? roleCounts = null,Object? nextCursor = freezed,}) {
  return _then(UserList(
users: freezed == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<KnownUser>?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,roleCounts: null == roleCounts ? _self.roleCounts : roleCounts // ignore: cast_nullable_to_non_nullable
as UserRoleCounts,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of UserList
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserRoleCountsCopyWith<$Res> get roleCounts {
  
  return $UserRoleCountsCopyWith<$Res>(_self.roleCounts, (value) {
    return _then(_self.copyWith(roleCounts: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserList].
extension UserListPatterns on UserList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserList value)  $default,){
final _that = this;
switch (_that) {
case _UserList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserList value)?  $default,){
final _that = this;
switch (_that) {
case _UserList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<KnownUser>? users,  int total, @JsonKey(name: 'role_counts')  UserRoleCounts roleCounts, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserList() when $default != null:
return $default(_that.users,_that.total,_that.roleCounts,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<KnownUser>? users,  int total, @JsonKey(name: 'role_counts')  UserRoleCounts roleCounts, @JsonKey(name: 'next_cursor')  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _UserList():
return $default(_that.users,_that.total,_that.roleCounts,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<KnownUser>? users,  int total, @JsonKey(name: 'role_counts')  UserRoleCounts roleCounts, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _UserList() when $default != null:
return $default(_that.users,_that.total,_that.roleCounts,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserList implements UserList {
  const _UserList({required  List<KnownUser>? users, required this.total, @JsonKey(name: 'role_counts') required this.roleCounts, @JsonKey(name: 'next_cursor') this.nextCursor}): _users = users;
  factory _UserList.fromJson(Map<String, dynamic> json) => _$UserListFromJson(json);

 final  List<KnownUser>? _users;
@override List<KnownUser>? get users {
  final value = _users;
  if (value == null) return null;
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Bütün süzgeçlere (rol dahil) uyan hesap sayısı; imleç zincirinin toplam satır sayısıdır.
@override final  int total;
@override@JsonKey(name: 'role_counts') final  UserRoleCounts roleCounts;
/// Devam eden listede dolu. Süzgeçli listede sayfa `limit`ten az satırla (boş da olabilir) ve dolu `next_cursor` ile dönebilir (istek başına tarama bütçesi); istemci `next_cursor` boşalana dek devam eder, satır atlanmaz ve tekrar etmez.
@override@JsonKey(name: 'next_cursor') final  String? nextCursor;

/// Create a copy of UserList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserListCopyWith<_UserList> get copyWith => __$UserListCopyWithImpl<_UserList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserList&&const DeepCollectionEquality().equals(other.users, _users)&&(identical(other.total, total) || other.total == total)&&(identical(other.roleCounts, roleCounts) || other.roleCounts == roleCounts)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_users),total,roleCounts,nextCursor);
}

@override
String toString() {
    return 'UserList(users: $users, total: $total, roleCounts: $roleCounts, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$UserListCopyWith<$Res> implements $UserListCopyWith<$Res> {
  factory _$UserListCopyWith(_UserList value, $Res Function(_UserList) _then) = __$UserListCopyWithImpl;
@override @useResult
$Res call({
 List<KnownUser>? users, int total,@JsonKey(name: 'role_counts') UserRoleCounts roleCounts,@JsonKey(name: 'next_cursor') String? nextCursor
});


@override $UserRoleCountsCopyWith<$Res> get roleCounts;

}
/// @nodoc
class __$UserListCopyWithImpl<$Res>
    implements _$UserListCopyWith<$Res> {
  __$UserListCopyWithImpl(this._self, this._then);

  final _UserList _self;
  final $Res Function(_UserList) _then;

/// Create a copy of UserList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? users = freezed,Object? total = null,Object? roleCounts = null,Object? nextCursor = freezed,}) {
  return _then(_UserList(
users: freezed == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<KnownUser>?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,roleCounts: null == roleCounts ? _self.roleCounts : roleCounts // ignore: cast_nullable_to_non_nullable
as UserRoleCounts,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of UserList
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserRoleCountsCopyWith<$Res> get roleCounts {
  
  return $UserRoleCountsCopyWith<$Res>(_self.roleCounts, (value) {
    return _then(_self.copyWith(roleCounts: value));
  });
}
}

// dart format on
