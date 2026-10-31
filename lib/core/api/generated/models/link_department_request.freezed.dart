// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'link_department_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LinkDepartmentRequest {

@JsonKey(name: 'department_id') String get departmentId;/// Departmanın bu programdaki adı; verilmezse katalog adı kopyalanır.
@JsonKey(name: 'display_name') String? get displayName;/// Verilirse bu programdaki aynı departmanın ekibi rolleriyle kopyalanır.
@JsonKey(name: 'copy_members_from_program_id') String? get copyMembersFromProgramId;
/// Create a copy of LinkDepartmentRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LinkDepartmentRequestCopyWith<LinkDepartmentRequest> get copyWith => _$LinkDepartmentRequestCopyWithImpl<LinkDepartmentRequest>(this as LinkDepartmentRequest, _$identity);

  /// Serializes this LinkDepartmentRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LinkDepartmentRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkDepartmentRequest&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.copyMembersFromProgramId, _this.copyMembersFromProgramId) || other.copyMembersFromProgramId == _this.copyMembersFromProgramId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LinkDepartmentRequest;
  return Object.hash(runtimeType,_this.departmentId,_this.displayName,_this.copyMembersFromProgramId);
}

@override
String toString() {
  final _this = this as LinkDepartmentRequest;
  return 'LinkDepartmentRequest(departmentId: ${_this.departmentId}, displayName: ${_this.displayName}, copyMembersFromProgramId: ${_this.copyMembersFromProgramId})';
}


}

/// @nodoc
abstract mixin class $LinkDepartmentRequestCopyWith<$Res>  {
  factory $LinkDepartmentRequestCopyWith(LinkDepartmentRequest value, $Res Function(LinkDepartmentRequest) _then) = _$LinkDepartmentRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'display_name') String? displayName,@JsonKey(name: 'copy_members_from_program_id') String? copyMembersFromProgramId
});




}
/// @nodoc
class _$LinkDepartmentRequestCopyWithImpl<$Res>
    implements $LinkDepartmentRequestCopyWith<$Res> {
  _$LinkDepartmentRequestCopyWithImpl(this._self, this._then);

  final LinkDepartmentRequest _self;
  final $Res Function(LinkDepartmentRequest) _then;

/// Create a copy of LinkDepartmentRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departmentId = null,Object? displayName = freezed,Object? copyMembersFromProgramId = freezed,}) {
  return _then(LinkDepartmentRequest(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,copyMembersFromProgramId: freezed == copyMembersFromProgramId ? _self.copyMembersFromProgramId : copyMembersFromProgramId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LinkDepartmentRequest].
extension LinkDepartmentRequestPatterns on LinkDepartmentRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LinkDepartmentRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LinkDepartmentRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LinkDepartmentRequest value)  $default,){
final _that = this;
switch (_that) {
case _LinkDepartmentRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LinkDepartmentRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LinkDepartmentRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'copy_members_from_program_id')  String? copyMembersFromProgramId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LinkDepartmentRequest() when $default != null:
return $default(_that.departmentId,_that.displayName,_that.copyMembersFromProgramId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'copy_members_from_program_id')  String? copyMembersFromProgramId)  $default,) {final _that = this;
switch (_that) {
case _LinkDepartmentRequest():
return $default(_that.departmentId,_that.displayName,_that.copyMembersFromProgramId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'copy_members_from_program_id')  String? copyMembersFromProgramId)?  $default,) {final _that = this;
switch (_that) {
case _LinkDepartmentRequest() when $default != null:
return $default(_that.departmentId,_that.displayName,_that.copyMembersFromProgramId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LinkDepartmentRequest implements LinkDepartmentRequest {
  const _LinkDepartmentRequest({@JsonKey(name: 'department_id') required this.departmentId, @JsonKey(name: 'display_name') this.displayName, @JsonKey(name: 'copy_members_from_program_id') this.copyMembersFromProgramId});
  factory _LinkDepartmentRequest.fromJson(Map<String, dynamic> json) => _$LinkDepartmentRequestFromJson(json);

@override@JsonKey(name: 'department_id') final  String departmentId;
/// Departmanın bu programdaki adı; verilmezse katalog adı kopyalanır.
@override@JsonKey(name: 'display_name') final  String? displayName;
/// Verilirse bu programdaki aynı departmanın ekibi rolleriyle kopyalanır.
@override@JsonKey(name: 'copy_members_from_program_id') final  String? copyMembersFromProgramId;

/// Create a copy of LinkDepartmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LinkDepartmentRequestCopyWith<_LinkDepartmentRequest> get copyWith => __$LinkDepartmentRequestCopyWithImpl<_LinkDepartmentRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LinkDepartmentRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LinkDepartmentRequest&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.copyMembersFromProgramId, copyMembersFromProgramId) || other.copyMembersFromProgramId == copyMembersFromProgramId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,departmentId,displayName,copyMembersFromProgramId);
}

@override
String toString() {
    return 'LinkDepartmentRequest(departmentId: $departmentId, displayName: $displayName, copyMembersFromProgramId: $copyMembersFromProgramId)';
}


}

/// @nodoc
abstract mixin class _$LinkDepartmentRequestCopyWith<$Res> implements $LinkDepartmentRequestCopyWith<$Res> {
  factory _$LinkDepartmentRequestCopyWith(_LinkDepartmentRequest value, $Res Function(_LinkDepartmentRequest) _then) = __$LinkDepartmentRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'display_name') String? displayName,@JsonKey(name: 'copy_members_from_program_id') String? copyMembersFromProgramId
});




}
/// @nodoc
class __$LinkDepartmentRequestCopyWithImpl<$Res>
    implements _$LinkDepartmentRequestCopyWith<$Res> {
  __$LinkDepartmentRequestCopyWithImpl(this._self, this._then);

  final _LinkDepartmentRequest _self;
  final $Res Function(_LinkDepartmentRequest) _then;

/// Create a copy of LinkDepartmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departmentId = null,Object? displayName = freezed,Object? copyMembersFromProgramId = freezed,}) {
  return _then(_LinkDepartmentRequest(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,copyMembersFromProgramId: freezed == copyMembersFromProgramId ? _self.copyMembersFromProgramId : copyMembersFromProgramId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
