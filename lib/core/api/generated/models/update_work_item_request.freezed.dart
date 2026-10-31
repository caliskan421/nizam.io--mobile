// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_work_item_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateWorkItemRequest {

 String? get title; String? get description; UpdateWorkItemRequestPriority? get priority;@DateOnlyConverter()@JsonKey(name: 'start_on') DateTime? get startOn;@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime? get endOn;@DateOnlyConverter()@JsonKey(name: 'planned_end_on') DateTime? get plannedEndOn;/// Tamamlanma kanıtı bayrağı (ADR-0024); verilmezse değişmez. Değişim audit ve olay yazar.
@JsonKey(name: 'completion_evidence_required') bool? get completionEvidenceRequired;/// Korumalı alan; dolu gönderilirse 422 work.input_invalid.
@JsonKey(name: 'completed_on') String? get completedOn;/// Korumalı alan; dolu gönderilirse 422 work.input_invalid.
@JsonKey(name: 'submitted_on') String? get submittedOn;
/// Create a copy of UpdateWorkItemRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateWorkItemRequestCopyWith<UpdateWorkItemRequest> get copyWith => _$UpdateWorkItemRequestCopyWithImpl<UpdateWorkItemRequest>(this as UpdateWorkItemRequest, _$identity);

  /// Serializes this UpdateWorkItemRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateWorkItemRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateWorkItemRequest&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&(identical(other.startOn, _this.startOn) || other.startOn == _this.startOn)&&(identical(other.endOn, _this.endOn) || other.endOn == _this.endOn)&&(identical(other.plannedEndOn, _this.plannedEndOn) || other.plannedEndOn == _this.plannedEndOn)&&(identical(other.completionEvidenceRequired, _this.completionEvidenceRequired) || other.completionEvidenceRequired == _this.completionEvidenceRequired)&&(identical(other.completedOn, _this.completedOn) || other.completedOn == _this.completedOn)&&(identical(other.submittedOn, _this.submittedOn) || other.submittedOn == _this.submittedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateWorkItemRequest;
  return Object.hash(runtimeType,_this.title,_this.description,_this.priority,_this.startOn,_this.endOn,_this.plannedEndOn,_this.completionEvidenceRequired,_this.completedOn,_this.submittedOn);
}

@override
String toString() {
  final _this = this as UpdateWorkItemRequest;
  return 'UpdateWorkItemRequest(title: ${_this.title}, description: ${_this.description}, priority: ${_this.priority}, startOn: ${_this.startOn}, endOn: ${_this.endOn}, plannedEndOn: ${_this.plannedEndOn}, completionEvidenceRequired: ${_this.completionEvidenceRequired}, completedOn: ${_this.completedOn}, submittedOn: ${_this.submittedOn})';
}


}

/// @nodoc
abstract mixin class $UpdateWorkItemRequestCopyWith<$Res>  {
  factory $UpdateWorkItemRequestCopyWith(UpdateWorkItemRequest value, $Res Function(UpdateWorkItemRequest) _then) = _$UpdateWorkItemRequestCopyWithImpl;
@useResult
$Res call({
 String? title, String? description, UpdateWorkItemRequestPriority? priority,@DateOnlyConverter()@JsonKey(name: 'start_on') DateTime? startOn,@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime? endOn,@DateOnlyConverter()@JsonKey(name: 'planned_end_on') DateTime? plannedEndOn,@JsonKey(name: 'completion_evidence_required') bool? completionEvidenceRequired,@JsonKey(name: 'completed_on') String? completedOn,@JsonKey(name: 'submitted_on') String? submittedOn
});




}
/// @nodoc
class _$UpdateWorkItemRequestCopyWithImpl<$Res>
    implements $UpdateWorkItemRequestCopyWith<$Res> {
  _$UpdateWorkItemRequestCopyWithImpl(this._self, this._then);

  final UpdateWorkItemRequest _self;
  final $Res Function(UpdateWorkItemRequest) _then;

/// Create a copy of UpdateWorkItemRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? description = freezed,Object? priority = freezed,Object? startOn = freezed,Object? endOn = freezed,Object? plannedEndOn = freezed,Object? completionEvidenceRequired = freezed,Object? completedOn = freezed,Object? submittedOn = freezed,}) {
  return _then(UpdateWorkItemRequest(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as UpdateWorkItemRequestPriority?,startOn: freezed == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as DateTime?,endOn: freezed == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as DateTime?,plannedEndOn: freezed == plannedEndOn ? _self.plannedEndOn : plannedEndOn // ignore: cast_nullable_to_non_nullable
as DateTime?,completionEvidenceRequired: freezed == completionEvidenceRequired ? _self.completionEvidenceRequired : completionEvidenceRequired // ignore: cast_nullable_to_non_nullable
as bool?,completedOn: freezed == completedOn ? _self.completedOn : completedOn // ignore: cast_nullable_to_non_nullable
as String?,submittedOn: freezed == submittedOn ? _self.submittedOn : submittedOn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateWorkItemRequest].
extension UpdateWorkItemRequestPatterns on UpdateWorkItemRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateWorkItemRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateWorkItemRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateWorkItemRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateWorkItemRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateWorkItemRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateWorkItemRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? description,  UpdateWorkItemRequestPriority? priority, @DateOnlyConverter()@JsonKey(name: 'start_on')  DateTime? startOn, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime? endOn, @DateOnlyConverter()@JsonKey(name: 'planned_end_on')  DateTime? plannedEndOn, @JsonKey(name: 'completion_evidence_required')  bool? completionEvidenceRequired, @JsonKey(name: 'completed_on')  String? completedOn, @JsonKey(name: 'submitted_on')  String? submittedOn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateWorkItemRequest() when $default != null:
return $default(_that.title,_that.description,_that.priority,_that.startOn,_that.endOn,_that.plannedEndOn,_that.completionEvidenceRequired,_that.completedOn,_that.submittedOn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? description,  UpdateWorkItemRequestPriority? priority, @DateOnlyConverter()@JsonKey(name: 'start_on')  DateTime? startOn, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime? endOn, @DateOnlyConverter()@JsonKey(name: 'planned_end_on')  DateTime? plannedEndOn, @JsonKey(name: 'completion_evidence_required')  bool? completionEvidenceRequired, @JsonKey(name: 'completed_on')  String? completedOn, @JsonKey(name: 'submitted_on')  String? submittedOn)  $default,) {final _that = this;
switch (_that) {
case _UpdateWorkItemRequest():
return $default(_that.title,_that.description,_that.priority,_that.startOn,_that.endOn,_that.plannedEndOn,_that.completionEvidenceRequired,_that.completedOn,_that.submittedOn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? description,  UpdateWorkItemRequestPriority? priority, @DateOnlyConverter()@JsonKey(name: 'start_on')  DateTime? startOn, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime? endOn, @DateOnlyConverter()@JsonKey(name: 'planned_end_on')  DateTime? plannedEndOn, @JsonKey(name: 'completion_evidence_required')  bool? completionEvidenceRequired, @JsonKey(name: 'completed_on')  String? completedOn, @JsonKey(name: 'submitted_on')  String? submittedOn)?  $default,) {final _that = this;
switch (_that) {
case _UpdateWorkItemRequest() when $default != null:
return $default(_that.title,_that.description,_that.priority,_that.startOn,_that.endOn,_that.plannedEndOn,_that.completionEvidenceRequired,_that.completedOn,_that.submittedOn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateWorkItemRequest implements UpdateWorkItemRequest {
  const _UpdateWorkItemRequest({this.title, this.description, this.priority, @DateOnlyConverter()@JsonKey(name: 'start_on') this.startOn, @DateOnlyConverter()@JsonKey(name: 'end_on') this.endOn, @DateOnlyConverter()@JsonKey(name: 'planned_end_on') this.plannedEndOn, @JsonKey(name: 'completion_evidence_required') this.completionEvidenceRequired, @JsonKey(name: 'completed_on') this.completedOn, @JsonKey(name: 'submitted_on') this.submittedOn});
  factory _UpdateWorkItemRequest.fromJson(Map<String, dynamic> json) => _$UpdateWorkItemRequestFromJson(json);

@override final  String? title;
@override final  String? description;
@override final  UpdateWorkItemRequestPriority? priority;
@override@DateOnlyConverter()@JsonKey(name: 'start_on') final  DateTime? startOn;
@override@DateOnlyConverter()@JsonKey(name: 'end_on') final  DateTime? endOn;
@override@DateOnlyConverter()@JsonKey(name: 'planned_end_on') final  DateTime? plannedEndOn;
/// Tamamlanma kanıtı bayrağı (ADR-0024); verilmezse değişmez. Değişim audit ve olay yazar.
@override@JsonKey(name: 'completion_evidence_required') final  bool? completionEvidenceRequired;
/// Korumalı alan; dolu gönderilirse 422 work.input_invalid.
@override@JsonKey(name: 'completed_on') final  String? completedOn;
/// Korumalı alan; dolu gönderilirse 422 work.input_invalid.
@override@JsonKey(name: 'submitted_on') final  String? submittedOn;

/// Create a copy of UpdateWorkItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateWorkItemRequestCopyWith<_UpdateWorkItemRequest> get copyWith => __$UpdateWorkItemRequestCopyWithImpl<_UpdateWorkItemRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateWorkItemRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateWorkItemRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startOn, startOn) || other.startOn == startOn)&&(identical(other.endOn, endOn) || other.endOn == endOn)&&(identical(other.plannedEndOn, plannedEndOn) || other.plannedEndOn == plannedEndOn)&&(identical(other.completionEvidenceRequired, completionEvidenceRequired) || other.completionEvidenceRequired == completionEvidenceRequired)&&(identical(other.completedOn, completedOn) || other.completedOn == completedOn)&&(identical(other.submittedOn, submittedOn) || other.submittedOn == submittedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,description,priority,startOn,endOn,plannedEndOn,completionEvidenceRequired,completedOn,submittedOn);
}

@override
String toString() {
    return 'UpdateWorkItemRequest(title: $title, description: $description, priority: $priority, startOn: $startOn, endOn: $endOn, plannedEndOn: $plannedEndOn, completionEvidenceRequired: $completionEvidenceRequired, completedOn: $completedOn, submittedOn: $submittedOn)';
}


}

/// @nodoc
abstract mixin class _$UpdateWorkItemRequestCopyWith<$Res> implements $UpdateWorkItemRequestCopyWith<$Res> {
  factory _$UpdateWorkItemRequestCopyWith(_UpdateWorkItemRequest value, $Res Function(_UpdateWorkItemRequest) _then) = __$UpdateWorkItemRequestCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? description, UpdateWorkItemRequestPriority? priority,@DateOnlyConverter()@JsonKey(name: 'start_on') DateTime? startOn,@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime? endOn,@DateOnlyConverter()@JsonKey(name: 'planned_end_on') DateTime? plannedEndOn,@JsonKey(name: 'completion_evidence_required') bool? completionEvidenceRequired,@JsonKey(name: 'completed_on') String? completedOn,@JsonKey(name: 'submitted_on') String? submittedOn
});




}
/// @nodoc
class __$UpdateWorkItemRequestCopyWithImpl<$Res>
    implements _$UpdateWorkItemRequestCopyWith<$Res> {
  __$UpdateWorkItemRequestCopyWithImpl(this._self, this._then);

  final _UpdateWorkItemRequest _self;
  final $Res Function(_UpdateWorkItemRequest) _then;

/// Create a copy of UpdateWorkItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? description = freezed,Object? priority = freezed,Object? startOn = freezed,Object? endOn = freezed,Object? plannedEndOn = freezed,Object? completionEvidenceRequired = freezed,Object? completedOn = freezed,Object? submittedOn = freezed,}) {
  return _then(_UpdateWorkItemRequest(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as UpdateWorkItemRequestPriority?,startOn: freezed == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as DateTime?,endOn: freezed == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as DateTime?,plannedEndOn: freezed == plannedEndOn ? _self.plannedEndOn : plannedEndOn // ignore: cast_nullable_to_non_nullable
as DateTime?,completionEvidenceRequired: freezed == completionEvidenceRequired ? _self.completionEvidenceRequired : completionEvidenceRequired // ignore: cast_nullable_to_non_nullable
as bool?,completedOn: freezed == completedOn ? _self.completedOn : completedOn // ignore: cast_nullable_to_non_nullable
as String?,submittedOn: freezed == submittedOn ? _self.submittedOn : submittedOn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
