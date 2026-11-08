// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_group_chat_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateGroupChatRequest {

/// Tek satır, en çok 100 karakter.
 String get name;@JsonKey(name: 'member_account_ids') List<String> get memberAccountIds; CreateGroupChatRequestSource? get source;/// `source=department` iken zorunlu; programa bağlı koordinatörlük.
@JsonKey(name: 'source_department_id') String? get sourceDepartmentId;
/// Create a copy of CreateGroupChatRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateGroupChatRequestCopyWith<CreateGroupChatRequest> get copyWith => _$CreateGroupChatRequestCopyWithImpl<CreateGroupChatRequest>(this as CreateGroupChatRequest, _$identity);

  /// Serializes this CreateGroupChatRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateGroupChatRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateGroupChatRequest&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.memberAccountIds, _this.memberAccountIds)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.sourceDepartmentId, _this.sourceDepartmentId) || other.sourceDepartmentId == _this.sourceDepartmentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateGroupChatRequest;
  return Object.hash(runtimeType,_this.name,const DeepCollectionEquality().hash(_this.memberAccountIds),_this.source,_this.sourceDepartmentId);
}

@override
String toString() {
  final _this = this as CreateGroupChatRequest;
  return 'CreateGroupChatRequest(name: ${_this.name}, memberAccountIds: ${_this.memberAccountIds}, source: ${_this.source}, sourceDepartmentId: ${_this.sourceDepartmentId})';
}


}

/// @nodoc
abstract mixin class $CreateGroupChatRequestCopyWith<$Res>  {
  factory $CreateGroupChatRequestCopyWith(CreateGroupChatRequest value, $Res Function(CreateGroupChatRequest) _then) = _$CreateGroupChatRequestCopyWithImpl;
@useResult
$Res call({
 String name,@JsonKey(name: 'member_account_ids') List<String> memberAccountIds, CreateGroupChatRequestSource? source,@JsonKey(name: 'source_department_id') String? sourceDepartmentId
});




}
/// @nodoc
class _$CreateGroupChatRequestCopyWithImpl<$Res>
    implements $CreateGroupChatRequestCopyWith<$Res> {
  _$CreateGroupChatRequestCopyWithImpl(this._self, this._then);

  final CreateGroupChatRequest _self;
  final $Res Function(CreateGroupChatRequest) _then;

/// Create a copy of CreateGroupChatRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? memberAccountIds = null,Object? source = freezed,Object? sourceDepartmentId = freezed,}) {
  return _then(CreateGroupChatRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,memberAccountIds: null == memberAccountIds ? _self.memberAccountIds : memberAccountIds // ignore: cast_nullable_to_non_nullable
as List<String>,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as CreateGroupChatRequestSource?,sourceDepartmentId: freezed == sourceDepartmentId ? _self.sourceDepartmentId : sourceDepartmentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateGroupChatRequest].
extension CreateGroupChatRequestPatterns on CreateGroupChatRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateGroupChatRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateGroupChatRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateGroupChatRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateGroupChatRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateGroupChatRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateGroupChatRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name, @JsonKey(name: 'member_account_ids')  List<String> memberAccountIds,  CreateGroupChatRequestSource? source, @JsonKey(name: 'source_department_id')  String? sourceDepartmentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateGroupChatRequest() when $default != null:
return $default(_that.name,_that.memberAccountIds,_that.source,_that.sourceDepartmentId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name, @JsonKey(name: 'member_account_ids')  List<String> memberAccountIds,  CreateGroupChatRequestSource? source, @JsonKey(name: 'source_department_id')  String? sourceDepartmentId)  $default,) {final _that = this;
switch (_that) {
case _CreateGroupChatRequest():
return $default(_that.name,_that.memberAccountIds,_that.source,_that.sourceDepartmentId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name, @JsonKey(name: 'member_account_ids')  List<String> memberAccountIds,  CreateGroupChatRequestSource? source, @JsonKey(name: 'source_department_id')  String? sourceDepartmentId)?  $default,) {final _that = this;
switch (_that) {
case _CreateGroupChatRequest() when $default != null:
return $default(_that.name,_that.memberAccountIds,_that.source,_that.sourceDepartmentId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateGroupChatRequest implements CreateGroupChatRequest {
  const _CreateGroupChatRequest({required this.name, @JsonKey(name: 'member_account_ids') required  List<String> memberAccountIds, this.source, @JsonKey(name: 'source_department_id') this.sourceDepartmentId}): _memberAccountIds = memberAccountIds;
  factory _CreateGroupChatRequest.fromJson(Map<String, dynamic> json) => _$CreateGroupChatRequestFromJson(json);

/// Tek satır, en çok 100 karakter.
@override final  String name;
 final  List<String> _memberAccountIds;
@override@JsonKey(name: 'member_account_ids') List<String> get memberAccountIds {
  if (_memberAccountIds is EqualUnmodifiableListView) return _memberAccountIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memberAccountIds);
}

@override final  CreateGroupChatRequestSource? source;
/// `source=department` iken zorunlu; programa bağlı koordinatörlük.
@override@JsonKey(name: 'source_department_id') final  String? sourceDepartmentId;

/// Create a copy of CreateGroupChatRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateGroupChatRequestCopyWith<_CreateGroupChatRequest> get copyWith => __$CreateGroupChatRequestCopyWithImpl<_CreateGroupChatRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateGroupChatRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateGroupChatRequest&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.memberAccountIds, _memberAccountIds)&&(identical(other.source, source) || other.source == source)&&(identical(other.sourceDepartmentId, sourceDepartmentId) || other.sourceDepartmentId == sourceDepartmentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_memberAccountIds),source,sourceDepartmentId);
}

@override
String toString() {
    return 'CreateGroupChatRequest(name: $name, memberAccountIds: $memberAccountIds, source: $source, sourceDepartmentId: $sourceDepartmentId)';
}


}

/// @nodoc
abstract mixin class _$CreateGroupChatRequestCopyWith<$Res> implements $CreateGroupChatRequestCopyWith<$Res> {
  factory _$CreateGroupChatRequestCopyWith(_CreateGroupChatRequest value, $Res Function(_CreateGroupChatRequest) _then) = __$CreateGroupChatRequestCopyWithImpl;
@override @useResult
$Res call({
 String name,@JsonKey(name: 'member_account_ids') List<String> memberAccountIds, CreateGroupChatRequestSource? source,@JsonKey(name: 'source_department_id') String? sourceDepartmentId
});




}
/// @nodoc
class __$CreateGroupChatRequestCopyWithImpl<$Res>
    implements _$CreateGroupChatRequestCopyWith<$Res> {
  __$CreateGroupChatRequestCopyWithImpl(this._self, this._then);

  final _CreateGroupChatRequest _self;
  final $Res Function(_CreateGroupChatRequest) _then;

/// Create a copy of CreateGroupChatRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? memberAccountIds = null,Object? source = freezed,Object? sourceDepartmentId = freezed,}) {
  return _then(_CreateGroupChatRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,memberAccountIds: null == memberAccountIds ? _self._memberAccountIds : memberAccountIds // ignore: cast_nullable_to_non_nullable
as List<String>,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as CreateGroupChatRequestSource?,sourceDepartmentId: freezed == sourceDepartmentId ? _self.sourceDepartmentId : sourceDepartmentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
