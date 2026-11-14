// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participants.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Participants {

 String get key;@JsonKey(name: 'account_id') String get accountId; String get name;@JsonKey(name: 'row_id') String get rowId;@JsonKey(name: 'column_id') String get columnId;
/// Create a copy of Participants
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantsCopyWith<Participants> get copyWith => _$ParticipantsCopyWithImpl<Participants>(this as Participants, _$identity);

  /// Serializes this Participants to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Participants;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Participants&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.rowId, _this.rowId) || other.rowId == _this.rowId)&&(identical(other.columnId, _this.columnId) || other.columnId == _this.columnId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Participants;
  return Object.hash(runtimeType,_this.key,_this.accountId,_this.name,_this.rowId,_this.columnId);
}

@override
String toString() {
  final _this = this as Participants;
  return 'Participants(key: ${_this.key}, accountId: ${_this.accountId}, name: ${_this.name}, rowId: ${_this.rowId}, columnId: ${_this.columnId})';
}


}

/// @nodoc
abstract mixin class $ParticipantsCopyWith<$Res>  {
  factory $ParticipantsCopyWith(Participants value, $Res Function(Participants) _then) = _$ParticipantsCopyWithImpl;
@useResult
$Res call({
 String key,@JsonKey(name: 'account_id') String accountId, String name,@JsonKey(name: 'row_id') String rowId,@JsonKey(name: 'column_id') String columnId
});




}
/// @nodoc
class _$ParticipantsCopyWithImpl<$Res>
    implements $ParticipantsCopyWith<$Res> {
  _$ParticipantsCopyWithImpl(this._self, this._then);

  final Participants _self;
  final $Res Function(Participants) _then;

/// Create a copy of Participants
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? accountId = null,Object? name = null,Object? rowId = null,Object? columnId = null,}) {
  return _then(Participants(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rowId: null == rowId ? _self.rowId : rowId // ignore: cast_nullable_to_non_nullable
as String,columnId: null == columnId ? _self.columnId : columnId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Participants].
extension ParticipantsPatterns on Participants {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Participants value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Participants() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Participants value)  $default,){
final _that = this;
switch (_that) {
case _Participants():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Participants value)?  $default,){
final _that = this;
switch (_that) {
case _Participants() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key, @JsonKey(name: 'account_id')  String accountId,  String name, @JsonKey(name: 'row_id')  String rowId, @JsonKey(name: 'column_id')  String columnId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Participants() when $default != null:
return $default(_that.key,_that.accountId,_that.name,_that.rowId,_that.columnId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key, @JsonKey(name: 'account_id')  String accountId,  String name, @JsonKey(name: 'row_id')  String rowId, @JsonKey(name: 'column_id')  String columnId)  $default,) {final _that = this;
switch (_that) {
case _Participants():
return $default(_that.key,_that.accountId,_that.name,_that.rowId,_that.columnId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key, @JsonKey(name: 'account_id')  String accountId,  String name, @JsonKey(name: 'row_id')  String rowId, @JsonKey(name: 'column_id')  String columnId)?  $default,) {final _that = this;
switch (_that) {
case _Participants() when $default != null:
return $default(_that.key,_that.accountId,_that.name,_that.rowId,_that.columnId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Participants implements Participants {
  const _Participants({required this.key, @JsonKey(name: 'account_id') required this.accountId, required this.name, @JsonKey(name: 'row_id') required this.rowId, @JsonKey(name: 'column_id') required this.columnId});
  factory _Participants.fromJson(Map<String, dynamic> json) => _$ParticipantsFromJson(json);

@override final  String key;
@override@JsonKey(name: 'account_id') final  String accountId;
@override final  String name;
@override@JsonKey(name: 'row_id') final  String rowId;
@override@JsonKey(name: 'column_id') final  String columnId;

/// Create a copy of Participants
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantsCopyWith<_Participants> get copyWith => __$ParticipantsCopyWithImpl<_Participants>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Participants&&(identical(other.key, key) || other.key == key)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.name, name) || other.name == name)&&(identical(other.rowId, rowId) || other.rowId == rowId)&&(identical(other.columnId, columnId) || other.columnId == columnId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,accountId,name,rowId,columnId);
}

@override
String toString() {
    return 'Participants(key: $key, accountId: $accountId, name: $name, rowId: $rowId, columnId: $columnId)';
}


}

/// @nodoc
abstract mixin class _$ParticipantsCopyWith<$Res> implements $ParticipantsCopyWith<$Res> {
  factory _$ParticipantsCopyWith(_Participants value, $Res Function(_Participants) _then) = __$ParticipantsCopyWithImpl;
@override @useResult
$Res call({
 String key,@JsonKey(name: 'account_id') String accountId, String name,@JsonKey(name: 'row_id') String rowId,@JsonKey(name: 'column_id') String columnId
});




}
/// @nodoc
class __$ParticipantsCopyWithImpl<$Res>
    implements _$ParticipantsCopyWith<$Res> {
  __$ParticipantsCopyWithImpl(this._self, this._then);

  final _Participants _self;
  final $Res Function(_Participants) _then;

/// Create a copy of Participants
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? accountId = null,Object? name = null,Object? rowId = null,Object? columnId = null,}) {
  return _then(_Participants(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rowId: null == rowId ? _self.rowId : rowId // ignore: cast_nullable_to_non_nullable
as String,columnId: null == columnId ? _self.columnId : columnId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
