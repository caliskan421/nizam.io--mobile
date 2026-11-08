// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_unread_program.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatUnreadProgram {

@JsonKey(name: 'program_id') String get programId;@JsonKey(name: 'program_name') String get programName;@JsonKey(name: 'unread_chats') int get unreadChats; bool get mentioned;
/// Create a copy of ChatUnreadProgram
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatUnreadProgramCopyWith<ChatUnreadProgram> get copyWith => _$ChatUnreadProgramCopyWithImpl<ChatUnreadProgram>(this as ChatUnreadProgram, _$identity);

  /// Serializes this ChatUnreadProgram to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatUnreadProgram;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatUnreadProgram&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.programName, _this.programName) || other.programName == _this.programName)&&(identical(other.unreadChats, _this.unreadChats) || other.unreadChats == _this.unreadChats)&&(identical(other.mentioned, _this.mentioned) || other.mentioned == _this.mentioned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatUnreadProgram;
  return Object.hash(runtimeType,_this.programId,_this.programName,_this.unreadChats,_this.mentioned);
}

@override
String toString() {
  final _this = this as ChatUnreadProgram;
  return 'ChatUnreadProgram(programId: ${_this.programId}, programName: ${_this.programName}, unreadChats: ${_this.unreadChats}, mentioned: ${_this.mentioned})';
}


}

/// @nodoc
abstract mixin class $ChatUnreadProgramCopyWith<$Res>  {
  factory $ChatUnreadProgramCopyWith(ChatUnreadProgram value, $Res Function(ChatUnreadProgram) _then) = _$ChatUnreadProgramCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'program_name') String programName,@JsonKey(name: 'unread_chats') int unreadChats, bool mentioned
});




}
/// @nodoc
class _$ChatUnreadProgramCopyWithImpl<$Res>
    implements $ChatUnreadProgramCopyWith<$Res> {
  _$ChatUnreadProgramCopyWithImpl(this._self, this._then);

  final ChatUnreadProgram _self;
  final $Res Function(ChatUnreadProgram) _then;

/// Create a copy of ChatUnreadProgram
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? programId = null,Object? programName = null,Object? unreadChats = null,Object? mentioned = null,}) {
  return _then(ChatUnreadProgram(
programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,programName: null == programName ? _self.programName : programName // ignore: cast_nullable_to_non_nullable
as String,unreadChats: null == unreadChats ? _self.unreadChats : unreadChats // ignore: cast_nullable_to_non_nullable
as int,mentioned: null == mentioned ? _self.mentioned : mentioned // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatUnreadProgram].
extension ChatUnreadProgramPatterns on ChatUnreadProgram {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatUnreadProgram value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatUnreadProgram() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatUnreadProgram value)  $default,){
final _that = this;
switch (_that) {
case _ChatUnreadProgram():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatUnreadProgram value)?  $default,){
final _that = this;
switch (_that) {
case _ChatUnreadProgram() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'program_name')  String programName, @JsonKey(name: 'unread_chats')  int unreadChats,  bool mentioned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatUnreadProgram() when $default != null:
return $default(_that.programId,_that.programName,_that.unreadChats,_that.mentioned);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'program_name')  String programName, @JsonKey(name: 'unread_chats')  int unreadChats,  bool mentioned)  $default,) {final _that = this;
switch (_that) {
case _ChatUnreadProgram():
return $default(_that.programId,_that.programName,_that.unreadChats,_that.mentioned);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'program_name')  String programName, @JsonKey(name: 'unread_chats')  int unreadChats,  bool mentioned)?  $default,) {final _that = this;
switch (_that) {
case _ChatUnreadProgram() when $default != null:
return $default(_that.programId,_that.programName,_that.unreadChats,_that.mentioned);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatUnreadProgram implements ChatUnreadProgram {
  const _ChatUnreadProgram({@JsonKey(name: 'program_id') required this.programId, @JsonKey(name: 'program_name') required this.programName, @JsonKey(name: 'unread_chats') required this.unreadChats, required this.mentioned});
  factory _ChatUnreadProgram.fromJson(Map<String, dynamic> json) => _$ChatUnreadProgramFromJson(json);

@override@JsonKey(name: 'program_id') final  String programId;
@override@JsonKey(name: 'program_name') final  String programName;
@override@JsonKey(name: 'unread_chats') final  int unreadChats;
@override final  bool mentioned;

/// Create a copy of ChatUnreadProgram
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatUnreadProgramCopyWith<_ChatUnreadProgram> get copyWith => __$ChatUnreadProgramCopyWithImpl<_ChatUnreadProgram>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatUnreadProgramToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatUnreadProgram&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.programName, programName) || other.programName == programName)&&(identical(other.unreadChats, unreadChats) || other.unreadChats == unreadChats)&&(identical(other.mentioned, mentioned) || other.mentioned == mentioned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,programId,programName,unreadChats,mentioned);
}

@override
String toString() {
    return 'ChatUnreadProgram(programId: $programId, programName: $programName, unreadChats: $unreadChats, mentioned: $mentioned)';
}


}

/// @nodoc
abstract mixin class _$ChatUnreadProgramCopyWith<$Res> implements $ChatUnreadProgramCopyWith<$Res> {
  factory _$ChatUnreadProgramCopyWith(_ChatUnreadProgram value, $Res Function(_ChatUnreadProgram) _then) = __$ChatUnreadProgramCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'program_name') String programName,@JsonKey(name: 'unread_chats') int unreadChats, bool mentioned
});




}
/// @nodoc
class __$ChatUnreadProgramCopyWithImpl<$Res>
    implements _$ChatUnreadProgramCopyWith<$Res> {
  __$ChatUnreadProgramCopyWithImpl(this._self, this._then);

  final _ChatUnreadProgram _self;
  final $Res Function(_ChatUnreadProgram) _then;

/// Create a copy of ChatUnreadProgram
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? programId = null,Object? programName = null,Object? unreadChats = null,Object? mentioned = null,}) {
  return _then(_ChatUnreadProgram(
programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,programName: null == programName ? _self.programName : programName // ignore: cast_nullable_to_non_nullable
as String,unreadChats: null == unreadChats ? _self.unreadChats : unreadChats // ignore: cast_nullable_to_non_nullable
as int,mentioned: null == mentioned ? _self.mentioned : mentioned // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
