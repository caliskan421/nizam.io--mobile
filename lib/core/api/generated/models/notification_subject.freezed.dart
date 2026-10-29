// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_subject.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationSubject {

 String get kind; String get id;
/// Create a copy of NotificationSubject
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationSubjectCopyWith<NotificationSubject> get copyWith => _$NotificationSubjectCopyWithImpl<NotificationSubject>(this as NotificationSubject, _$identity);

  /// Serializes this NotificationSubject to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NotificationSubject;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationSubject&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.id, _this.id) || other.id == _this.id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NotificationSubject;
  return Object.hash(runtimeType,_this.kind,_this.id);
}

@override
String toString() {
  final _this = this as NotificationSubject;
  return 'NotificationSubject(kind: ${_this.kind}, id: ${_this.id})';
}


}

/// @nodoc
abstract mixin class $NotificationSubjectCopyWith<$Res>  {
  factory $NotificationSubjectCopyWith(NotificationSubject value, $Res Function(NotificationSubject) _then) = _$NotificationSubjectCopyWithImpl;
@useResult
$Res call({
 String kind, String id
});




}
/// @nodoc
class _$NotificationSubjectCopyWithImpl<$Res>
    implements $NotificationSubjectCopyWith<$Res> {
  _$NotificationSubjectCopyWithImpl(this._self, this._then);

  final NotificationSubject _self;
  final $Res Function(NotificationSubject) _then;

/// Create a copy of NotificationSubject
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? id = null,}) {
  return _then(NotificationSubject(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationSubject].
extension NotificationSubjectPatterns on NotificationSubject {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationSubject value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationSubject() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationSubject value)  $default,){
final _that = this;
switch (_that) {
case _NotificationSubject():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationSubject value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationSubject() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String kind,  String id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationSubject() when $default != null:
return $default(_that.kind,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String kind,  String id)  $default,) {final _that = this;
switch (_that) {
case _NotificationSubject():
return $default(_that.kind,_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String kind,  String id)?  $default,) {final _that = this;
switch (_that) {
case _NotificationSubject() when $default != null:
return $default(_that.kind,_that.id);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationSubject implements NotificationSubject {
  const _NotificationSubject({required this.kind, required this.id});
  factory _NotificationSubject.fromJson(Map<String, dynamic> json) => _$NotificationSubjectFromJson(json);

@override final  String kind;
@override final  String id;

/// Create a copy of NotificationSubject
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationSubjectCopyWith<_NotificationSubject> get copyWith => __$NotificationSubjectCopyWithImpl<_NotificationSubject>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationSubjectToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationSubject&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id);
}

@override
String toString() {
    return 'NotificationSubject(kind: $kind, id: $id)';
}


}

/// @nodoc
abstract mixin class _$NotificationSubjectCopyWith<$Res> implements $NotificationSubjectCopyWith<$Res> {
  factory _$NotificationSubjectCopyWith(_NotificationSubject value, $Res Function(_NotificationSubject) _then) = __$NotificationSubjectCopyWithImpl;
@override @useResult
$Res call({
 String kind, String id
});




}
/// @nodoc
class __$NotificationSubjectCopyWithImpl<$Res>
    implements _$NotificationSubjectCopyWith<$Res> {
  __$NotificationSubjectCopyWithImpl(this._self, this._then);

  final _NotificationSubject _self;
  final $Res Function(_NotificationSubject) _then;

/// Create a copy of NotificationSubject
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,}) {
  return _then(_NotificationSubject(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
