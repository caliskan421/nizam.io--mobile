// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_candidate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatCandidate {

@JsonKey(name: 'account_id') String get accountId;@JsonKey(name: 'full_name') String get fullName;/// Seçili programdaki en yüksek rol.
 ChatCandidateRole get role;
/// Create a copy of ChatCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatCandidateCopyWith<ChatCandidate> get copyWith => _$ChatCandidateCopyWithImpl<ChatCandidate>(this as ChatCandidate, _$identity);

  /// Serializes this ChatCandidate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatCandidate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatCandidate&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.role, _this.role) || other.role == _this.role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatCandidate;
  return Object.hash(runtimeType,_this.accountId,_this.fullName,_this.role);
}

@override
String toString() {
  final _this = this as ChatCandidate;
  return 'ChatCandidate(accountId: ${_this.accountId}, fullName: ${_this.fullName}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $ChatCandidateCopyWith<$Res>  {
  factory $ChatCandidateCopyWith(ChatCandidate value, $Res Function(ChatCandidate) _then) = _$ChatCandidateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName, ChatCandidateRole role
});




}
/// @nodoc
class _$ChatCandidateCopyWithImpl<$Res>
    implements $ChatCandidateCopyWith<$Res> {
  _$ChatCandidateCopyWithImpl(this._self, this._then);

  final ChatCandidate _self;
  final $Res Function(ChatCandidate) _then;

/// Create a copy of ChatCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? fullName = null,Object? role = null,}) {
  return _then(ChatCandidate(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ChatCandidateRole,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatCandidate].
extension ChatCandidatePatterns on ChatCandidate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatCandidate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatCandidate value)  $default,){
final _that = this;
switch (_that) {
case _ChatCandidate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _ChatCandidate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  ChatCandidateRole role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatCandidate() when $default != null:
return $default(_that.accountId,_that.fullName,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  ChatCandidateRole role)  $default,) {final _that = this;
switch (_that) {
case _ChatCandidate():
return $default(_that.accountId,_that.fullName,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  ChatCandidateRole role)?  $default,) {final _that = this;
switch (_that) {
case _ChatCandidate() when $default != null:
return $default(_that.accountId,_that.fullName,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatCandidate implements ChatCandidate {
  const _ChatCandidate({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'full_name') required this.fullName, required this.role});
  factory _ChatCandidate.fromJson(Map<String, dynamic> json) => _$ChatCandidateFromJson(json);

@override@JsonKey(name: 'account_id') final  String accountId;
@override@JsonKey(name: 'full_name') final  String fullName;
/// Seçili programdaki en yüksek rol.
@override final  ChatCandidateRole role;

/// Create a copy of ChatCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatCandidateCopyWith<_ChatCandidate> get copyWith => __$ChatCandidateCopyWithImpl<_ChatCandidate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatCandidateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatCandidate&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountId,fullName,role);
}

@override
String toString() {
    return 'ChatCandidate(accountId: $accountId, fullName: $fullName, role: $role)';
}


}

/// @nodoc
abstract mixin class _$ChatCandidateCopyWith<$Res> implements $ChatCandidateCopyWith<$Res> {
  factory _$ChatCandidateCopyWith(_ChatCandidate value, $Res Function(_ChatCandidate) _then) = __$ChatCandidateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName, ChatCandidateRole role
});




}
/// @nodoc
class __$ChatCandidateCopyWithImpl<$Res>
    implements _$ChatCandidateCopyWith<$Res> {
  __$ChatCandidateCopyWithImpl(this._self, this._then);

  final _ChatCandidate _self;
  final $Res Function(_ChatCandidate) _then;

/// Create a copy of ChatCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? fullName = null,Object? role = null,}) {
  return _then(_ChatCandidate(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ChatCandidateRole,
  ));
}


}

// dart format on
