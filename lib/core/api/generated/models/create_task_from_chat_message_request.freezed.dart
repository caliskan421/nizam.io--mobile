// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_task_from_chat_message_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateTaskFromChatMessageRequest {

@JsonKey(name: 'department_id') String get departmentId;@DateOnlyConverter()@JsonKey(name: 'start_date') DateTime get startDate;@DateOnlyConverter()@JsonKey(name: 'end_date') DateTime get endDate; String? get title; String? get priority;@JsonKey(name: 'assignee_account_ids') List<String>? get assigneeAccountIds;
/// Create a copy of CreateTaskFromChatMessageRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTaskFromChatMessageRequestCopyWith<CreateTaskFromChatMessageRequest> get copyWith => _$CreateTaskFromChatMessageRequestCopyWithImpl<CreateTaskFromChatMessageRequest>(this as CreateTaskFromChatMessageRequest, _$identity);

  /// Serializes this CreateTaskFromChatMessageRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateTaskFromChatMessageRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTaskFromChatMessageRequest&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.endDate, _this.endDate) || other.endDate == _this.endDate)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&const DeepCollectionEquality().equals(other.assigneeAccountIds, _this.assigneeAccountIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateTaskFromChatMessageRequest;
  return Object.hash(runtimeType,_this.departmentId,_this.startDate,_this.endDate,_this.title,_this.priority,const DeepCollectionEquality().hash(_this.assigneeAccountIds));
}

@override
String toString() {
  final _this = this as CreateTaskFromChatMessageRequest;
  return 'CreateTaskFromChatMessageRequest(departmentId: ${_this.departmentId}, startDate: ${_this.startDate}, endDate: ${_this.endDate}, title: ${_this.title}, priority: ${_this.priority}, assigneeAccountIds: ${_this.assigneeAccountIds})';
}


}

/// @nodoc
abstract mixin class $CreateTaskFromChatMessageRequestCopyWith<$Res>  {
  factory $CreateTaskFromChatMessageRequestCopyWith(CreateTaskFromChatMessageRequest value, $Res Function(CreateTaskFromChatMessageRequest) _then) = _$CreateTaskFromChatMessageRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId,@DateOnlyConverter()@JsonKey(name: 'start_date') DateTime startDate,@DateOnlyConverter()@JsonKey(name: 'end_date') DateTime endDate, String? title, String? priority,@JsonKey(name: 'assignee_account_ids') List<String>? assigneeAccountIds
});




}
/// @nodoc
class _$CreateTaskFromChatMessageRequestCopyWithImpl<$Res>
    implements $CreateTaskFromChatMessageRequestCopyWith<$Res> {
  _$CreateTaskFromChatMessageRequestCopyWithImpl(this._self, this._then);

  final CreateTaskFromChatMessageRequest _self;
  final $Res Function(CreateTaskFromChatMessageRequest) _then;

/// Create a copy of CreateTaskFromChatMessageRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departmentId = null,Object? startDate = null,Object? endDate = null,Object? title = freezed,Object? priority = freezed,Object? assigneeAccountIds = freezed,}) {
  return _then(CreateTaskFromChatMessageRequest(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String?,assigneeAccountIds: freezed == assigneeAccountIds ? _self.assigneeAccountIds : assigneeAccountIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateTaskFromChatMessageRequest].
extension CreateTaskFromChatMessageRequestPatterns on CreateTaskFromChatMessageRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTaskFromChatMessageRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTaskFromChatMessageRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTaskFromChatMessageRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateTaskFromChatMessageRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTaskFromChatMessageRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTaskFromChatMessageRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId, @DateOnlyConverter()@JsonKey(name: 'start_date')  DateTime startDate, @DateOnlyConverter()@JsonKey(name: 'end_date')  DateTime endDate,  String? title,  String? priority, @JsonKey(name: 'assignee_account_ids')  List<String>? assigneeAccountIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTaskFromChatMessageRequest() when $default != null:
return $default(_that.departmentId,_that.startDate,_that.endDate,_that.title,_that.priority,_that.assigneeAccountIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId, @DateOnlyConverter()@JsonKey(name: 'start_date')  DateTime startDate, @DateOnlyConverter()@JsonKey(name: 'end_date')  DateTime endDate,  String? title,  String? priority, @JsonKey(name: 'assignee_account_ids')  List<String>? assigneeAccountIds)  $default,) {final _that = this;
switch (_that) {
case _CreateTaskFromChatMessageRequest():
return $default(_that.departmentId,_that.startDate,_that.endDate,_that.title,_that.priority,_that.assigneeAccountIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'department_id')  String departmentId, @DateOnlyConverter()@JsonKey(name: 'start_date')  DateTime startDate, @DateOnlyConverter()@JsonKey(name: 'end_date')  DateTime endDate,  String? title,  String? priority, @JsonKey(name: 'assignee_account_ids')  List<String>? assigneeAccountIds)?  $default,) {final _that = this;
switch (_that) {
case _CreateTaskFromChatMessageRequest() when $default != null:
return $default(_that.departmentId,_that.startDate,_that.endDate,_that.title,_that.priority,_that.assigneeAccountIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTaskFromChatMessageRequest implements CreateTaskFromChatMessageRequest {
  const _CreateTaskFromChatMessageRequest({@JsonKey(name: 'department_id') required this.departmentId, @DateOnlyConverter()@JsonKey(name: 'start_date') required this.startDate, @DateOnlyConverter()@JsonKey(name: 'end_date') required this.endDate, this.title, this.priority, @JsonKey(name: 'assignee_account_ids')  List<String>? assigneeAccountIds}): _assigneeAccountIds = assigneeAccountIds;
  factory _CreateTaskFromChatMessageRequest.fromJson(Map<String, dynamic> json) => _$CreateTaskFromChatMessageRequestFromJson(json);

@override@JsonKey(name: 'department_id') final  String departmentId;
@override@DateOnlyConverter()@JsonKey(name: 'start_date') final  DateTime startDate;
@override@DateOnlyConverter()@JsonKey(name: 'end_date') final  DateTime endDate;
@override final  String? title;
@override final  String? priority;
 final  List<String>? _assigneeAccountIds;
@override@JsonKey(name: 'assignee_account_ids') List<String>? get assigneeAccountIds {
  final value = _assigneeAccountIds;
  if (value == null) return null;
  if (_assigneeAccountIds is EqualUnmodifiableListView) return _assigneeAccountIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of CreateTaskFromChatMessageRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTaskFromChatMessageRequestCopyWith<_CreateTaskFromChatMessageRequest> get copyWith => __$CreateTaskFromChatMessageRequestCopyWithImpl<_CreateTaskFromChatMessageRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTaskFromChatMessageRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTaskFromChatMessageRequest&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.title, title) || other.title == title)&&(identical(other.priority, priority) || other.priority == priority)&&const DeepCollectionEquality().equals(other.assigneeAccountIds, _assigneeAccountIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,departmentId,startDate,endDate,title,priority,const DeepCollectionEquality().hash(_assigneeAccountIds));
}

@override
String toString() {
    return 'CreateTaskFromChatMessageRequest(departmentId: $departmentId, startDate: $startDate, endDate: $endDate, title: $title, priority: $priority, assigneeAccountIds: $assigneeAccountIds)';
}


}

/// @nodoc
abstract mixin class _$CreateTaskFromChatMessageRequestCopyWith<$Res> implements $CreateTaskFromChatMessageRequestCopyWith<$Res> {
  factory _$CreateTaskFromChatMessageRequestCopyWith(_CreateTaskFromChatMessageRequest value, $Res Function(_CreateTaskFromChatMessageRequest) _then) = __$CreateTaskFromChatMessageRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId,@DateOnlyConverter()@JsonKey(name: 'start_date') DateTime startDate,@DateOnlyConverter()@JsonKey(name: 'end_date') DateTime endDate, String? title, String? priority,@JsonKey(name: 'assignee_account_ids') List<String>? assigneeAccountIds
});




}
/// @nodoc
class __$CreateTaskFromChatMessageRequestCopyWithImpl<$Res>
    implements _$CreateTaskFromChatMessageRequestCopyWith<$Res> {
  __$CreateTaskFromChatMessageRequestCopyWithImpl(this._self, this._then);

  final _CreateTaskFromChatMessageRequest _self;
  final $Res Function(_CreateTaskFromChatMessageRequest) _then;

/// Create a copy of CreateTaskFromChatMessageRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departmentId = null,Object? startDate = null,Object? endDate = null,Object? title = freezed,Object? priority = freezed,Object? assigneeAccountIds = freezed,}) {
  return _then(_CreateTaskFromChatMessageRequest(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String?,assigneeAccountIds: freezed == assigneeAccountIds ? _self._assigneeAccountIds : assigneeAccountIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
