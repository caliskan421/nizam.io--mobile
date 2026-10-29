// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conference.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Conference {

 String get id;/// starting: sağlayıcı onayı bekleniyor; live: sürüyor; ending: kapatıldı, oda henüz kapanmadı.
 ConferenceStatus get status;@JsonKey(name: 'started_at') DateTime get startedAt;@JsonKey(name: 'started_by_account_id') String get startedByAccountId;
/// Create a copy of Conference
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConferenceCopyWith<Conference> get copyWith => _$ConferenceCopyWithImpl<Conference>(this as Conference, _$identity);

  /// Serializes this Conference to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Conference;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Conference&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.startedByAccountId, _this.startedByAccountId) || other.startedByAccountId == _this.startedByAccountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Conference;
  return Object.hash(runtimeType,_this.id,_this.status,_this.startedAt,_this.startedByAccountId);
}

@override
String toString() {
  final _this = this as Conference;
  return 'Conference(id: ${_this.id}, status: ${_this.status}, startedAt: ${_this.startedAt}, startedByAccountId: ${_this.startedByAccountId})';
}


}

/// @nodoc
abstract mixin class $ConferenceCopyWith<$Res>  {
  factory $ConferenceCopyWith(Conference value, $Res Function(Conference) _then) = _$ConferenceCopyWithImpl;
@useResult
$Res call({
 String id, ConferenceStatus status,@JsonKey(name: 'started_at') DateTime startedAt,@JsonKey(name: 'started_by_account_id') String startedByAccountId
});




}
/// @nodoc
class _$ConferenceCopyWithImpl<$Res>
    implements $ConferenceCopyWith<$Res> {
  _$ConferenceCopyWithImpl(this._self, this._then);

  final Conference _self;
  final $Res Function(Conference) _then;

/// Create a copy of Conference
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? startedAt = null,Object? startedByAccountId = null,}) {
  return _then(Conference(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ConferenceStatus,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,startedByAccountId: null == startedByAccountId ? _self.startedByAccountId : startedByAccountId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Conference].
extension ConferencePatterns on Conference {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Conference value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Conference() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Conference value)  $default,){
final _that = this;
switch (_that) {
case _Conference():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Conference value)?  $default,){
final _that = this;
switch (_that) {
case _Conference() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ConferenceStatus status, @JsonKey(name: 'started_at')  DateTime startedAt, @JsonKey(name: 'started_by_account_id')  String startedByAccountId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Conference() when $default != null:
return $default(_that.id,_that.status,_that.startedAt,_that.startedByAccountId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ConferenceStatus status, @JsonKey(name: 'started_at')  DateTime startedAt, @JsonKey(name: 'started_by_account_id')  String startedByAccountId)  $default,) {final _that = this;
switch (_that) {
case _Conference():
return $default(_that.id,_that.status,_that.startedAt,_that.startedByAccountId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ConferenceStatus status, @JsonKey(name: 'started_at')  DateTime startedAt, @JsonKey(name: 'started_by_account_id')  String startedByAccountId)?  $default,) {final _that = this;
switch (_that) {
case _Conference() when $default != null:
return $default(_that.id,_that.status,_that.startedAt,_that.startedByAccountId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Conference implements Conference {
  const _Conference({required this.id, required this.status, @JsonKey(name: 'started_at') required this.startedAt, @JsonKey(name: 'started_by_account_id') required this.startedByAccountId});
  factory _Conference.fromJson(Map<String, dynamic> json) => _$ConferenceFromJson(json);

@override final  String id;
/// starting: sağlayıcı onayı bekleniyor; live: sürüyor; ending: kapatıldı, oda henüz kapanmadı.
@override final  ConferenceStatus status;
@override@JsonKey(name: 'started_at') final  DateTime startedAt;
@override@JsonKey(name: 'started_by_account_id') final  String startedByAccountId;

/// Create a copy of Conference
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConferenceCopyWith<_Conference> get copyWith => __$ConferenceCopyWithImpl<_Conference>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConferenceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Conference&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.startedByAccountId, startedByAccountId) || other.startedByAccountId == startedByAccountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,status,startedAt,startedByAccountId);
}

@override
String toString() {
    return 'Conference(id: $id, status: $status, startedAt: $startedAt, startedByAccountId: $startedByAccountId)';
}


}

/// @nodoc
abstract mixin class _$ConferenceCopyWith<$Res> implements $ConferenceCopyWith<$Res> {
  factory _$ConferenceCopyWith(_Conference value, $Res Function(_Conference) _then) = __$ConferenceCopyWithImpl;
@override @useResult
$Res call({
 String id, ConferenceStatus status,@JsonKey(name: 'started_at') DateTime startedAt,@JsonKey(name: 'started_by_account_id') String startedByAccountId
});




}
/// @nodoc
class __$ConferenceCopyWithImpl<$Res>
    implements _$ConferenceCopyWith<$Res> {
  __$ConferenceCopyWithImpl(this._self, this._then);

  final _Conference _self;
  final $Res Function(_Conference) _then;

/// Create a copy of Conference
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? startedAt = null,Object? startedByAccountId = null,}) {
  return _then(_Conference(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ConferenceStatus,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,startedByAccountId: null == startedByAccountId ? _self.startedByAccountId : startedByAccountId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
