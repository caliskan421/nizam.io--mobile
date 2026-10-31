// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_work_item_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateWorkItemRequest {

 String get title;/// Şirket yöneticisi dışındaki çağıranda en çok 40 gün geçmişte olabilir (aksi 422 `work.input_invalid`).
@DateOnlyConverter()@JsonKey(name: 'start_on') DateTime get startOn;@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime get endOn; String? get description;/// Gönderilmezse `orta`; boş dizge de `orta` sayılır.
 CreateWorkItemRequestPriority? get priority;/// Boşsa atamasız açılır.
@JsonKey(name: 'assignee_account_id') String? get assigneeAccountId;/// Gönderilmezse `true` (ADR-0024).
@JsonKey(name: 'completion_evidence_required') bool? get completionEvidenceRequired;
/// Create a copy of CreateWorkItemRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateWorkItemRequestCopyWith<CreateWorkItemRequest> get copyWith => _$CreateWorkItemRequestCopyWithImpl<CreateWorkItemRequest>(this as CreateWorkItemRequest, _$identity);

  /// Serializes this CreateWorkItemRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateWorkItemRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateWorkItemRequest&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.startOn, _this.startOn) || other.startOn == _this.startOn)&&(identical(other.endOn, _this.endOn) || other.endOn == _this.endOn)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&(identical(other.assigneeAccountId, _this.assigneeAccountId) || other.assigneeAccountId == _this.assigneeAccountId)&&(identical(other.completionEvidenceRequired, _this.completionEvidenceRequired) || other.completionEvidenceRequired == _this.completionEvidenceRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateWorkItemRequest;
  return Object.hash(runtimeType,_this.title,_this.startOn,_this.endOn,_this.description,_this.priority,_this.assigneeAccountId,_this.completionEvidenceRequired);
}

@override
String toString() {
  final _this = this as CreateWorkItemRequest;
  return 'CreateWorkItemRequest(title: ${_this.title}, startOn: ${_this.startOn}, endOn: ${_this.endOn}, description: ${_this.description}, priority: ${_this.priority}, assigneeAccountId: ${_this.assigneeAccountId}, completionEvidenceRequired: ${_this.completionEvidenceRequired})';
}


}

/// @nodoc
abstract mixin class $CreateWorkItemRequestCopyWith<$Res>  {
  factory $CreateWorkItemRequestCopyWith(CreateWorkItemRequest value, $Res Function(CreateWorkItemRequest) _then) = _$CreateWorkItemRequestCopyWithImpl;
@useResult
$Res call({
 String title,@DateOnlyConverter()@JsonKey(name: 'start_on') DateTime startOn,@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime endOn, String? description, CreateWorkItemRequestPriority? priority,@JsonKey(name: 'assignee_account_id') String? assigneeAccountId,@JsonKey(name: 'completion_evidence_required') bool? completionEvidenceRequired
});




}
/// @nodoc
class _$CreateWorkItemRequestCopyWithImpl<$Res>
    implements $CreateWorkItemRequestCopyWith<$Res> {
  _$CreateWorkItemRequestCopyWithImpl(this._self, this._then);

  final CreateWorkItemRequest _self;
  final $Res Function(CreateWorkItemRequest) _then;

/// Create a copy of CreateWorkItemRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? startOn = null,Object? endOn = null,Object? description = freezed,Object? priority = freezed,Object? assigneeAccountId = freezed,Object? completionEvidenceRequired = freezed,}) {
  return _then(CreateWorkItemRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startOn: null == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as DateTime,endOn: null == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as CreateWorkItemRequestPriority?,assigneeAccountId: freezed == assigneeAccountId ? _self.assigneeAccountId : assigneeAccountId // ignore: cast_nullable_to_non_nullable
as String?,completionEvidenceRequired: freezed == completionEvidenceRequired ? _self.completionEvidenceRequired : completionEvidenceRequired // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateWorkItemRequest].
extension CreateWorkItemRequestPatterns on CreateWorkItemRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateWorkItemRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateWorkItemRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateWorkItemRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateWorkItemRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateWorkItemRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateWorkItemRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title, @DateOnlyConverter()@JsonKey(name: 'start_on')  DateTime startOn, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime endOn,  String? description,  CreateWorkItemRequestPriority? priority, @JsonKey(name: 'assignee_account_id')  String? assigneeAccountId, @JsonKey(name: 'completion_evidence_required')  bool? completionEvidenceRequired)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateWorkItemRequest() when $default != null:
return $default(_that.title,_that.startOn,_that.endOn,_that.description,_that.priority,_that.assigneeAccountId,_that.completionEvidenceRequired);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title, @DateOnlyConverter()@JsonKey(name: 'start_on')  DateTime startOn, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime endOn,  String? description,  CreateWorkItemRequestPriority? priority, @JsonKey(name: 'assignee_account_id')  String? assigneeAccountId, @JsonKey(name: 'completion_evidence_required')  bool? completionEvidenceRequired)  $default,) {final _that = this;
switch (_that) {
case _CreateWorkItemRequest():
return $default(_that.title,_that.startOn,_that.endOn,_that.description,_that.priority,_that.assigneeAccountId,_that.completionEvidenceRequired);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title, @DateOnlyConverter()@JsonKey(name: 'start_on')  DateTime startOn, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime endOn,  String? description,  CreateWorkItemRequestPriority? priority, @JsonKey(name: 'assignee_account_id')  String? assigneeAccountId, @JsonKey(name: 'completion_evidence_required')  bool? completionEvidenceRequired)?  $default,) {final _that = this;
switch (_that) {
case _CreateWorkItemRequest() when $default != null:
return $default(_that.title,_that.startOn,_that.endOn,_that.description,_that.priority,_that.assigneeAccountId,_that.completionEvidenceRequired);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateWorkItemRequest implements CreateWorkItemRequest {
  const _CreateWorkItemRequest({required this.title, @DateOnlyConverter()@JsonKey(name: 'start_on') required this.startOn, @DateOnlyConverter()@JsonKey(name: 'end_on') required this.endOn, this.description, this.priority, @JsonKey(name: 'assignee_account_id') this.assigneeAccountId, @JsonKey(name: 'completion_evidence_required') this.completionEvidenceRequired});
  factory _CreateWorkItemRequest.fromJson(Map<String, dynamic> json) => _$CreateWorkItemRequestFromJson(json);

@override final  String title;
/// Şirket yöneticisi dışındaki çağıranda en çok 40 gün geçmişte olabilir (aksi 422 `work.input_invalid`).
@override@DateOnlyConverter()@JsonKey(name: 'start_on') final  DateTime startOn;
@override@DateOnlyConverter()@JsonKey(name: 'end_on') final  DateTime endOn;
@override final  String? description;
/// Gönderilmezse `orta`; boş dizge de `orta` sayılır.
@override final  CreateWorkItemRequestPriority? priority;
/// Boşsa atamasız açılır.
@override@JsonKey(name: 'assignee_account_id') final  String? assigneeAccountId;
/// Gönderilmezse `true` (ADR-0024).
@override@JsonKey(name: 'completion_evidence_required') final  bool? completionEvidenceRequired;

/// Create a copy of CreateWorkItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateWorkItemRequestCopyWith<_CreateWorkItemRequest> get copyWith => __$CreateWorkItemRequestCopyWithImpl<_CreateWorkItemRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateWorkItemRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateWorkItemRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.startOn, startOn) || other.startOn == startOn)&&(identical(other.endOn, endOn) || other.endOn == endOn)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.assigneeAccountId, assigneeAccountId) || other.assigneeAccountId == assigneeAccountId)&&(identical(other.completionEvidenceRequired, completionEvidenceRequired) || other.completionEvidenceRequired == completionEvidenceRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,startOn,endOn,description,priority,assigneeAccountId,completionEvidenceRequired);
}

@override
String toString() {
    return 'CreateWorkItemRequest(title: $title, startOn: $startOn, endOn: $endOn, description: $description, priority: $priority, assigneeAccountId: $assigneeAccountId, completionEvidenceRequired: $completionEvidenceRequired)';
}


}

/// @nodoc
abstract mixin class _$CreateWorkItemRequestCopyWith<$Res> implements $CreateWorkItemRequestCopyWith<$Res> {
  factory _$CreateWorkItemRequestCopyWith(_CreateWorkItemRequest value, $Res Function(_CreateWorkItemRequest) _then) = __$CreateWorkItemRequestCopyWithImpl;
@override @useResult
$Res call({
 String title,@DateOnlyConverter()@JsonKey(name: 'start_on') DateTime startOn,@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime endOn, String? description, CreateWorkItemRequestPriority? priority,@JsonKey(name: 'assignee_account_id') String? assigneeAccountId,@JsonKey(name: 'completion_evidence_required') bool? completionEvidenceRequired
});




}
/// @nodoc
class __$CreateWorkItemRequestCopyWithImpl<$Res>
    implements _$CreateWorkItemRequestCopyWith<$Res> {
  __$CreateWorkItemRequestCopyWithImpl(this._self, this._then);

  final _CreateWorkItemRequest _self;
  final $Res Function(_CreateWorkItemRequest) _then;

/// Create a copy of CreateWorkItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? startOn = null,Object? endOn = null,Object? description = freezed,Object? priority = freezed,Object? assigneeAccountId = freezed,Object? completionEvidenceRequired = freezed,}) {
  return _then(_CreateWorkItemRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startOn: null == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as DateTime,endOn: null == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as CreateWorkItemRequestPriority?,assigneeAccountId: freezed == assigneeAccountId ? _self.assigneeAccountId : assigneeAccountId // ignore: cast_nullable_to_non_nullable
as String?,completionEvidenceRequired: freezed == completionEvidenceRequired ? _self.completionEvidenceRequired : completionEvidenceRequired // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
