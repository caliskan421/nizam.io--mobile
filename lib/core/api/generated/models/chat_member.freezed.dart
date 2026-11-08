// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMember {

@JsonKey(name: 'account_id') String get accountId;@JsonKey(name: 'full_name') String get fullName; ChatMemberRole get role; bool get founder;/// `true` ise üye grubun kaynağından gelir; elle çıkarılamaz (409 `messaging.member_source_managed`).
@JsonKey(name: 'from_source') bool get fromSource;
/// Create a copy of ChatMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMemberCopyWith<ChatMember> get copyWith => _$ChatMemberCopyWithImpl<ChatMember>(this as ChatMember, _$identity);

  /// Serializes this ChatMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatMember;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMember&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.founder, _this.founder) || other.founder == _this.founder)&&(identical(other.fromSource, _this.fromSource) || other.fromSource == _this.fromSource));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatMember;
  return Object.hash(runtimeType,_this.accountId,_this.fullName,_this.role,_this.founder,_this.fromSource);
}

@override
String toString() {
  final _this = this as ChatMember;
  return 'ChatMember(accountId: ${_this.accountId}, fullName: ${_this.fullName}, role: ${_this.role}, founder: ${_this.founder}, fromSource: ${_this.fromSource})';
}


}

/// @nodoc
abstract mixin class $ChatMemberCopyWith<$Res>  {
  factory $ChatMemberCopyWith(ChatMember value, $Res Function(ChatMember) _then) = _$ChatMemberCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName, ChatMemberRole role, bool founder,@JsonKey(name: 'from_source') bool fromSource
});




}
/// @nodoc
class _$ChatMemberCopyWithImpl<$Res>
    implements $ChatMemberCopyWith<$Res> {
  _$ChatMemberCopyWithImpl(this._self, this._then);

  final ChatMember _self;
  final $Res Function(ChatMember) _then;

/// Create a copy of ChatMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? fullName = null,Object? role = null,Object? founder = null,Object? fromSource = null,}) {
  return _then(ChatMember(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ChatMemberRole,founder: null == founder ? _self.founder : founder // ignore: cast_nullable_to_non_nullable
as bool,fromSource: null == fromSource ? _self.fromSource : fromSource // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMember].
extension ChatMemberPatterns on ChatMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMember value)  $default,){
final _that = this;
switch (_that) {
case _ChatMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMember value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  ChatMemberRole role,  bool founder, @JsonKey(name: 'from_source')  bool fromSource)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMember() when $default != null:
return $default(_that.accountId,_that.fullName,_that.role,_that.founder,_that.fromSource);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  ChatMemberRole role,  bool founder, @JsonKey(name: 'from_source')  bool fromSource)  $default,) {final _that = this;
switch (_that) {
case _ChatMember():
return $default(_that.accountId,_that.fullName,_that.role,_that.founder,_that.fromSource);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  ChatMemberRole role,  bool founder, @JsonKey(name: 'from_source')  bool fromSource)?  $default,) {final _that = this;
switch (_that) {
case _ChatMember() when $default != null:
return $default(_that.accountId,_that.fullName,_that.role,_that.founder,_that.fromSource);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMember implements ChatMember {
  const _ChatMember({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'full_name') required this.fullName, required this.role, required this.founder, @JsonKey(name: 'from_source') required this.fromSource});
  factory _ChatMember.fromJson(Map<String, dynamic> json) => _$ChatMemberFromJson(json);

@override@JsonKey(name: 'account_id') final  String accountId;
@override@JsonKey(name: 'full_name') final  String fullName;
@override final  ChatMemberRole role;
@override final  bool founder;
/// `true` ise üye grubun kaynağından gelir; elle çıkarılamaz (409 `messaging.member_source_managed`).
@override@JsonKey(name: 'from_source') final  bool fromSource;

/// Create a copy of ChatMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMemberCopyWith<_ChatMember> get copyWith => __$ChatMemberCopyWithImpl<_ChatMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMemberToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMember&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.role, role) || other.role == role)&&(identical(other.founder, founder) || other.founder == founder)&&(identical(other.fromSource, fromSource) || other.fromSource == fromSource));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountId,fullName,role,founder,fromSource);
}

@override
String toString() {
    return 'ChatMember(accountId: $accountId, fullName: $fullName, role: $role, founder: $founder, fromSource: $fromSource)';
}


}

/// @nodoc
abstract mixin class _$ChatMemberCopyWith<$Res> implements $ChatMemberCopyWith<$Res> {
  factory _$ChatMemberCopyWith(_ChatMember value, $Res Function(_ChatMember) _then) = __$ChatMemberCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName, ChatMemberRole role, bool founder,@JsonKey(name: 'from_source') bool fromSource
});




}
/// @nodoc
class __$ChatMemberCopyWithImpl<$Res>
    implements _$ChatMemberCopyWith<$Res> {
  __$ChatMemberCopyWithImpl(this._self, this._then);

  final _ChatMember _self;
  final $Res Function(_ChatMember) _then;

/// Create a copy of ChatMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? fullName = null,Object? role = null,Object? founder = null,Object? fromSource = null,}) {
  return _then(_ChatMember(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ChatMemberRole,founder: null == founder ? _self.founder : founder // ignore: cast_nullable_to_non_nullable
as bool,fromSource: null == fromSource ? _self.fromSource : fromSource // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
