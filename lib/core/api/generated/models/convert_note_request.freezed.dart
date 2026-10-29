// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'convert_note_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConvertNoteRequest {

/// Zorunlu; bitişten sonra olamaz ve bugünden önce olamaz.
@JsonKey(name: 'start_date') DateTime get startDate;/// Zorunlu; başlangıçtan önce olamaz.
@JsonKey(name: 'end_date') DateTime get endDate;/// Boşsa notun ilk 100 karakteri.
 String? get title;/// Gönderilmezse `orta`; boş dizge de `orta` sayılır.
 ConvertNoteRequestPriority? get priority;@JsonKey(name: 'department_id') String? get departmentId;@JsonKey(name: 'assignee_account_ids') List<String>? get assigneeAccountIds;
/// Create a copy of ConvertNoteRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConvertNoteRequestCopyWith<ConvertNoteRequest> get copyWith => _$ConvertNoteRequestCopyWithImpl<ConvertNoteRequest>(this as ConvertNoteRequest, _$identity);

  /// Serializes this ConvertNoteRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ConvertNoteRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConvertNoteRequest&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.endDate, _this.endDate) || other.endDate == _this.endDate)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&const DeepCollectionEquality().equals(other.assigneeAccountIds, _this.assigneeAccountIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ConvertNoteRequest;
  return Object.hash(runtimeType,_this.startDate,_this.endDate,_this.title,_this.priority,_this.departmentId,const DeepCollectionEquality().hash(_this.assigneeAccountIds));
}

@override
String toString() {
  final _this = this as ConvertNoteRequest;
  return 'ConvertNoteRequest(startDate: ${_this.startDate}, endDate: ${_this.endDate}, title: ${_this.title}, priority: ${_this.priority}, departmentId: ${_this.departmentId}, assigneeAccountIds: ${_this.assigneeAccountIds})';
}


}

/// @nodoc
abstract mixin class $ConvertNoteRequestCopyWith<$Res>  {
  factory $ConvertNoteRequestCopyWith(ConvertNoteRequest value, $Res Function(ConvertNoteRequest) _then) = _$ConvertNoteRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'start_date') DateTime startDate,@JsonKey(name: 'end_date') DateTime endDate, String? title, ConvertNoteRequestPriority? priority,@JsonKey(name: 'department_id') String? departmentId,@JsonKey(name: 'assignee_account_ids') List<String>? assigneeAccountIds
});




}
/// @nodoc
class _$ConvertNoteRequestCopyWithImpl<$Res>
    implements $ConvertNoteRequestCopyWith<$Res> {
  _$ConvertNoteRequestCopyWithImpl(this._self, this._then);

  final ConvertNoteRequest _self;
  final $Res Function(ConvertNoteRequest) _then;

/// Create a copy of ConvertNoteRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startDate = null,Object? endDate = null,Object? title = freezed,Object? priority = freezed,Object? departmentId = freezed,Object? assigneeAccountIds = freezed,}) {
  return _then(ConvertNoteRequest(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as ConvertNoteRequestPriority?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,assigneeAccountIds: freezed == assigneeAccountIds ? _self.assigneeAccountIds : assigneeAccountIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConvertNoteRequest].
extension ConvertNoteRequestPatterns on ConvertNoteRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConvertNoteRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConvertNoteRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConvertNoteRequest value)  $default,){
final _that = this;
switch (_that) {
case _ConvertNoteRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConvertNoteRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ConvertNoteRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'start_date')  DateTime startDate, @JsonKey(name: 'end_date')  DateTime endDate,  String? title,  ConvertNoteRequestPriority? priority, @JsonKey(name: 'department_id')  String? departmentId, @JsonKey(name: 'assignee_account_ids')  List<String>? assigneeAccountIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConvertNoteRequest() when $default != null:
return $default(_that.startDate,_that.endDate,_that.title,_that.priority,_that.departmentId,_that.assigneeAccountIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'start_date')  DateTime startDate, @JsonKey(name: 'end_date')  DateTime endDate,  String? title,  ConvertNoteRequestPriority? priority, @JsonKey(name: 'department_id')  String? departmentId, @JsonKey(name: 'assignee_account_ids')  List<String>? assigneeAccountIds)  $default,) {final _that = this;
switch (_that) {
case _ConvertNoteRequest():
return $default(_that.startDate,_that.endDate,_that.title,_that.priority,_that.departmentId,_that.assigneeAccountIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'start_date')  DateTime startDate, @JsonKey(name: 'end_date')  DateTime endDate,  String? title,  ConvertNoteRequestPriority? priority, @JsonKey(name: 'department_id')  String? departmentId, @JsonKey(name: 'assignee_account_ids')  List<String>? assigneeAccountIds)?  $default,) {final _that = this;
switch (_that) {
case _ConvertNoteRequest() when $default != null:
return $default(_that.startDate,_that.endDate,_that.title,_that.priority,_that.departmentId,_that.assigneeAccountIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConvertNoteRequest implements ConvertNoteRequest {
  const _ConvertNoteRequest({@JsonKey(name: 'start_date') required this.startDate, @JsonKey(name: 'end_date') required this.endDate, this.title, this.priority, @JsonKey(name: 'department_id') this.departmentId, @JsonKey(name: 'assignee_account_ids')  List<String>? assigneeAccountIds}): _assigneeAccountIds = assigneeAccountIds;
  factory _ConvertNoteRequest.fromJson(Map<String, dynamic> json) => _$ConvertNoteRequestFromJson(json);

/// Zorunlu; bitişten sonra olamaz ve bugünden önce olamaz.
@override@JsonKey(name: 'start_date') final  DateTime startDate;
/// Zorunlu; başlangıçtan önce olamaz.
@override@JsonKey(name: 'end_date') final  DateTime endDate;
/// Boşsa notun ilk 100 karakteri.
@override final  String? title;
/// Gönderilmezse `orta`; boş dizge de `orta` sayılır.
@override final  ConvertNoteRequestPriority? priority;
@override@JsonKey(name: 'department_id') final  String? departmentId;
 final  List<String>? _assigneeAccountIds;
@override@JsonKey(name: 'assignee_account_ids') List<String>? get assigneeAccountIds {
  final value = _assigneeAccountIds;
  if (value == null) return null;
  if (_assigneeAccountIds is EqualUnmodifiableListView) return _assigneeAccountIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ConvertNoteRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConvertNoteRequestCopyWith<_ConvertNoteRequest> get copyWith => __$ConvertNoteRequestCopyWithImpl<_ConvertNoteRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConvertNoteRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConvertNoteRequest&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.title, title) || other.title == title)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&const DeepCollectionEquality().equals(other.assigneeAccountIds, _assigneeAccountIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,startDate,endDate,title,priority,departmentId,const DeepCollectionEquality().hash(_assigneeAccountIds));
}

@override
String toString() {
    return 'ConvertNoteRequest(startDate: $startDate, endDate: $endDate, title: $title, priority: $priority, departmentId: $departmentId, assigneeAccountIds: $assigneeAccountIds)';
}


}

/// @nodoc
abstract mixin class _$ConvertNoteRequestCopyWith<$Res> implements $ConvertNoteRequestCopyWith<$Res> {
  factory _$ConvertNoteRequestCopyWith(_ConvertNoteRequest value, $Res Function(_ConvertNoteRequest) _then) = __$ConvertNoteRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'start_date') DateTime startDate,@JsonKey(name: 'end_date') DateTime endDate, String? title, ConvertNoteRequestPriority? priority,@JsonKey(name: 'department_id') String? departmentId,@JsonKey(name: 'assignee_account_ids') List<String>? assigneeAccountIds
});




}
/// @nodoc
class __$ConvertNoteRequestCopyWithImpl<$Res>
    implements _$ConvertNoteRequestCopyWith<$Res> {
  __$ConvertNoteRequestCopyWithImpl(this._self, this._then);

  final _ConvertNoteRequest _self;
  final $Res Function(_ConvertNoteRequest) _then;

/// Create a copy of ConvertNoteRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startDate = null,Object? endDate = null,Object? title = freezed,Object? priority = freezed,Object? departmentId = freezed,Object? assigneeAccountIds = freezed,}) {
  return _then(_ConvertNoteRequest(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as ConvertNoteRequestPriority?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,assigneeAccountIds: freezed == assigneeAccountIds ? _self._assigneeAccountIds : assigneeAccountIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
