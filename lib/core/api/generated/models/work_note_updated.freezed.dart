// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_note_updated.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkNoteUpdated {

/// Her zaman `updated`.
 String get status;/// Notun yeni düzenleme sürümü (ADR-0027); içerik zaten günceldeyse mevcut sürüm.
@JsonKey(name: 'edit_revision') int get editRevision;
/// Create a copy of WorkNoteUpdated
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkNoteUpdatedCopyWith<WorkNoteUpdated> get copyWith => _$WorkNoteUpdatedCopyWithImpl<WorkNoteUpdated>(this as WorkNoteUpdated, _$identity);

  /// Serializes this WorkNoteUpdated to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkNoteUpdated;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkNoteUpdated&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.editRevision, _this.editRevision) || other.editRevision == _this.editRevision));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkNoteUpdated;
  return Object.hash(runtimeType,_this.status,_this.editRevision);
}

@override
String toString() {
  final _this = this as WorkNoteUpdated;
  return 'WorkNoteUpdated(status: ${_this.status}, editRevision: ${_this.editRevision})';
}


}

/// @nodoc
abstract mixin class $WorkNoteUpdatedCopyWith<$Res>  {
  factory $WorkNoteUpdatedCopyWith(WorkNoteUpdated value, $Res Function(WorkNoteUpdated) _then) = _$WorkNoteUpdatedCopyWithImpl;
@useResult
$Res call({
 String status,@JsonKey(name: 'edit_revision') int editRevision
});




}
/// @nodoc
class _$WorkNoteUpdatedCopyWithImpl<$Res>
    implements $WorkNoteUpdatedCopyWith<$Res> {
  _$WorkNoteUpdatedCopyWithImpl(this._self, this._then);

  final WorkNoteUpdated _self;
  final $Res Function(WorkNoteUpdated) _then;

/// Create a copy of WorkNoteUpdated
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? editRevision = null,}) {
  return _then(WorkNoteUpdated(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,editRevision: null == editRevision ? _self.editRevision : editRevision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkNoteUpdated].
extension WorkNoteUpdatedPatterns on WorkNoteUpdated {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkNoteUpdated value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkNoteUpdated() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkNoteUpdated value)  $default,){
final _that = this;
switch (_that) {
case _WorkNoteUpdated():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkNoteUpdated value)?  $default,){
final _that = this;
switch (_that) {
case _WorkNoteUpdated() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status, @JsonKey(name: 'edit_revision')  int editRevision)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkNoteUpdated() when $default != null:
return $default(_that.status,_that.editRevision);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status, @JsonKey(name: 'edit_revision')  int editRevision)  $default,) {final _that = this;
switch (_that) {
case _WorkNoteUpdated():
return $default(_that.status,_that.editRevision);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status, @JsonKey(name: 'edit_revision')  int editRevision)?  $default,) {final _that = this;
switch (_that) {
case _WorkNoteUpdated() when $default != null:
return $default(_that.status,_that.editRevision);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkNoteUpdated implements WorkNoteUpdated {
  const _WorkNoteUpdated({required this.status, @JsonKey(name: 'edit_revision') required this.editRevision});
  factory _WorkNoteUpdated.fromJson(Map<String, dynamic> json) => _$WorkNoteUpdatedFromJson(json);

/// Her zaman `updated`.
@override final  String status;
/// Notun yeni düzenleme sürümü (ADR-0027); içerik zaten günceldeyse mevcut sürüm.
@override@JsonKey(name: 'edit_revision') final  int editRevision;

/// Create a copy of WorkNoteUpdated
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkNoteUpdatedCopyWith<_WorkNoteUpdated> get copyWith => __$WorkNoteUpdatedCopyWithImpl<_WorkNoteUpdated>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkNoteUpdatedToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkNoteUpdated&&(identical(other.status, status) || other.status == status)&&(identical(other.editRevision, editRevision) || other.editRevision == editRevision));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,status,editRevision);
}

@override
String toString() {
    return 'WorkNoteUpdated(status: $status, editRevision: $editRevision)';
}


}

/// @nodoc
abstract mixin class _$WorkNoteUpdatedCopyWith<$Res> implements $WorkNoteUpdatedCopyWith<$Res> {
  factory _$WorkNoteUpdatedCopyWith(_WorkNoteUpdated value, $Res Function(_WorkNoteUpdated) _then) = __$WorkNoteUpdatedCopyWithImpl;
@override @useResult
$Res call({
 String status,@JsonKey(name: 'edit_revision') int editRevision
});




}
/// @nodoc
class __$WorkNoteUpdatedCopyWithImpl<$Res>
    implements _$WorkNoteUpdatedCopyWith<$Res> {
  __$WorkNoteUpdatedCopyWithImpl(this._self, this._then);

  final _WorkNoteUpdated _self;
  final $Res Function(_WorkNoteUpdated) _then;

/// Create a copy of WorkNoteUpdated
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? editRevision = null,}) {
  return _then(_WorkNoteUpdated(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,editRevision: null == editRevision ? _self.editRevision : editRevision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
