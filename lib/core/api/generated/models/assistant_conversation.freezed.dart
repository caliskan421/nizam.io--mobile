// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant_conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssistantConversation {

 String get id; String get baslik;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of AssistantConversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssistantConversationCopyWith<AssistantConversation> get copyWith => _$AssistantConversationCopyWithImpl<AssistantConversation>(this as AssistantConversation, _$identity);

  /// Serializes this AssistantConversation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AssistantConversation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssistantConversation&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.baslik, _this.baslik) || other.baslik == _this.baslik)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AssistantConversation;
  return Object.hash(runtimeType,_this.id,_this.baslik,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as AssistantConversation;
  return 'AssistantConversation(id: ${_this.id}, baslik: ${_this.baslik}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $AssistantConversationCopyWith<$Res>  {
  factory $AssistantConversationCopyWith(AssistantConversation value, $Res Function(AssistantConversation) _then) = _$AssistantConversationCopyWithImpl;
@useResult
$Res call({
 String id, String baslik,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$AssistantConversationCopyWithImpl<$Res>
    implements $AssistantConversationCopyWith<$Res> {
  _$AssistantConversationCopyWithImpl(this._self, this._then);

  final AssistantConversation _self;
  final $Res Function(AssistantConversation) _then;

/// Create a copy of AssistantConversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? baslik = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(AssistantConversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,baslik: null == baslik ? _self.baslik : baslik // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AssistantConversation].
extension AssistantConversationPatterns on AssistantConversation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssistantConversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssistantConversation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssistantConversation value)  $default,){
final _that = this;
switch (_that) {
case _AssistantConversation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssistantConversation value)?  $default,){
final _that = this;
switch (_that) {
case _AssistantConversation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String baslik, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssistantConversation() when $default != null:
return $default(_that.id,_that.baslik,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String baslik, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AssistantConversation():
return $default(_that.id,_that.baslik,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String baslik, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AssistantConversation() when $default != null:
return $default(_that.id,_that.baslik,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssistantConversation implements AssistantConversation {
  const _AssistantConversation({required this.id, required this.baslik, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _AssistantConversation.fromJson(Map<String, dynamic> json) => _$AssistantConversationFromJson(json);

@override final  String id;
@override final  String baslik;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of AssistantConversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssistantConversationCopyWith<_AssistantConversation> get copyWith => __$AssistantConversationCopyWithImpl<_AssistantConversation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssistantConversationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssistantConversation&&(identical(other.id, id) || other.id == id)&&(identical(other.baslik, baslik) || other.baslik == baslik)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,baslik,createdAt,updatedAt);
}

@override
String toString() {
    return 'AssistantConversation(id: $id, baslik: $baslik, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AssistantConversationCopyWith<$Res> implements $AssistantConversationCopyWith<$Res> {
  factory _$AssistantConversationCopyWith(_AssistantConversation value, $Res Function(_AssistantConversation) _then) = __$AssistantConversationCopyWithImpl;
@override @useResult
$Res call({
 String id, String baslik,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$AssistantConversationCopyWithImpl<$Res>
    implements _$AssistantConversationCopyWith<$Res> {
  __$AssistantConversationCopyWithImpl(this._self, this._then);

  final _AssistantConversation _self;
  final $Res Function(_AssistantConversation) _then;

/// Create a copy of AssistantConversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? baslik = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_AssistantConversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,baslik: null == baslik ? _self.baslik : baslik // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
