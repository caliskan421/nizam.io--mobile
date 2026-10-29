// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssistantMessage {

 int get sira; AssistantMessageRol get rol; String get icerik;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of AssistantMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssistantMessageCopyWith<AssistantMessage> get copyWith => _$AssistantMessageCopyWithImpl<AssistantMessage>(this as AssistantMessage, _$identity);

  /// Serializes this AssistantMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AssistantMessage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssistantMessage&&(identical(other.sira, _this.sira) || other.sira == _this.sira)&&(identical(other.rol, _this.rol) || other.rol == _this.rol)&&(identical(other.icerik, _this.icerik) || other.icerik == _this.icerik)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AssistantMessage;
  return Object.hash(runtimeType,_this.sira,_this.rol,_this.icerik,_this.createdAt);
}

@override
String toString() {
  final _this = this as AssistantMessage;
  return 'AssistantMessage(sira: ${_this.sira}, rol: ${_this.rol}, icerik: ${_this.icerik}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $AssistantMessageCopyWith<$Res>  {
  factory $AssistantMessageCopyWith(AssistantMessage value, $Res Function(AssistantMessage) _then) = _$AssistantMessageCopyWithImpl;
@useResult
$Res call({
 int sira, AssistantMessageRol rol, String icerik,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$AssistantMessageCopyWithImpl<$Res>
    implements $AssistantMessageCopyWith<$Res> {
  _$AssistantMessageCopyWithImpl(this._self, this._then);

  final AssistantMessage _self;
  final $Res Function(AssistantMessage) _then;

/// Create a copy of AssistantMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sira = null,Object? rol = null,Object? icerik = null,Object? createdAt = null,}) {
  return _then(AssistantMessage(
sira: null == sira ? _self.sira : sira // ignore: cast_nullable_to_non_nullable
as int,rol: null == rol ? _self.rol : rol // ignore: cast_nullable_to_non_nullable
as AssistantMessageRol,icerik: null == icerik ? _self.icerik : icerik // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AssistantMessage].
extension AssistantMessagePatterns on AssistantMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssistantMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssistantMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssistantMessage value)  $default,){
final _that = this;
switch (_that) {
case _AssistantMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssistantMessage value)?  $default,){
final _that = this;
switch (_that) {
case _AssistantMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int sira,  AssistantMessageRol rol,  String icerik, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssistantMessage() when $default != null:
return $default(_that.sira,_that.rol,_that.icerik,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int sira,  AssistantMessageRol rol,  String icerik, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AssistantMessage():
return $default(_that.sira,_that.rol,_that.icerik,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int sira,  AssistantMessageRol rol,  String icerik, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AssistantMessage() when $default != null:
return $default(_that.sira,_that.rol,_that.icerik,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssistantMessage implements AssistantMessage {
  const _AssistantMessage({required this.sira, required this.rol, required this.icerik, @JsonKey(name: 'created_at') required this.createdAt});
  factory _AssistantMessage.fromJson(Map<String, dynamic> json) => _$AssistantMessageFromJson(json);

@override final  int sira;
@override final  AssistantMessageRol rol;
@override final  String icerik;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of AssistantMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssistantMessageCopyWith<_AssistantMessage> get copyWith => __$AssistantMessageCopyWithImpl<_AssistantMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssistantMessageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssistantMessage&&(identical(other.sira, sira) || other.sira == sira)&&(identical(other.rol, rol) || other.rol == rol)&&(identical(other.icerik, icerik) || other.icerik == icerik)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,sira,rol,icerik,createdAt);
}

@override
String toString() {
    return 'AssistantMessage(sira: $sira, rol: $rol, icerik: $icerik, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AssistantMessageCopyWith<$Res> implements $AssistantMessageCopyWith<$Res> {
  factory _$AssistantMessageCopyWith(_AssistantMessage value, $Res Function(_AssistantMessage) _then) = __$AssistantMessageCopyWithImpl;
@override @useResult
$Res call({
 int sira, AssistantMessageRol rol, String icerik,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$AssistantMessageCopyWithImpl<$Res>
    implements _$AssistantMessageCopyWith<$Res> {
  __$AssistantMessageCopyWithImpl(this._self, this._then);

  final _AssistantMessage _self;
  final $Res Function(_AssistantMessage) _then;

/// Create a copy of AssistantMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sira = null,Object? rol = null,Object? icerik = null,Object? createdAt = null,}) {
  return _then(_AssistantMessage(
sira: null == sira ? _self.sira : sira // ignore: cast_nullable_to_non_nullable
as int,rol: null == rol ? _self.rol : rol // ignore: cast_nullable_to_non_nullable
as AssistantMessageRol,icerik: null == icerik ? _self.icerik : icerik // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
