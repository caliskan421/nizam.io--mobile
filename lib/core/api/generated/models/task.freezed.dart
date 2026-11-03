// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Task {

 String get title; String get status;@JsonKey(name: 'department_id') String get departmentId;@JsonKey(name: 'department_name') String? get departmentName; List<Assignees> get assignees;@DateOnlyConverter()@JsonKey(name: 'start_on') DateTime get startOn;@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime get endOn; String get description;
/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCopyWith<Task> get copyWith => _$TaskCopyWithImpl<Task>(this as Task, _$identity);

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Task;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Task&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.departmentName, _this.departmentName) || other.departmentName == _this.departmentName)&&const DeepCollectionEquality().equals(other.assignees, _this.assignees)&&(identical(other.startOn, _this.startOn) || other.startOn == _this.startOn)&&(identical(other.endOn, _this.endOn) || other.endOn == _this.endOn)&&(identical(other.description, _this.description) || other.description == _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Task;
  return Object.hash(runtimeType,_this.title,_this.status,_this.departmentId,_this.departmentName,const DeepCollectionEquality().hash(_this.assignees),_this.startOn,_this.endOn,_this.description);
}

@override
String toString() {
  final _this = this as Task;
  return 'Task(title: ${_this.title}, status: ${_this.status}, departmentId: ${_this.departmentId}, departmentName: ${_this.departmentName}, assignees: ${_this.assignees}, startOn: ${_this.startOn}, endOn: ${_this.endOn}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $TaskCopyWith<$Res>  {
  factory $TaskCopyWith(Task value, $Res Function(Task) _then) = _$TaskCopyWithImpl;
@useResult
$Res call({
 String title, String status,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'department_name') String? departmentName, List<Assignees> assignees,@DateOnlyConverter()@JsonKey(name: 'start_on') DateTime startOn,@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime endOn, String description
});




}
/// @nodoc
class _$TaskCopyWithImpl<$Res>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._self, this._then);

  final Task _self;
  final $Res Function(Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? status = null,Object? departmentId = null,Object? departmentName = freezed,Object? assignees = null,Object? startOn = null,Object? endOn = null,Object? description = null,}) {
  return _then(Task(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,departmentName: freezed == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String?,assignees: null == assignees ? _self.assignees : assignees // ignore: cast_nullable_to_non_nullable
as List<Assignees>,startOn: null == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as DateTime,endOn: null == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Task].
extension TaskPatterns on Task {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Task value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Task value)  $default,){
final _that = this;
switch (_that) {
case _Task():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Task value)?  $default,){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String status, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'department_name')  String? departmentName,  List<Assignees> assignees, @DateOnlyConverter()@JsonKey(name: 'start_on')  DateTime startOn, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime endOn,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.title,_that.status,_that.departmentId,_that.departmentName,_that.assignees,_that.startOn,_that.endOn,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String status, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'department_name')  String? departmentName,  List<Assignees> assignees, @DateOnlyConverter()@JsonKey(name: 'start_on')  DateTime startOn, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime endOn,  String description)  $default,) {final _that = this;
switch (_that) {
case _Task():
return $default(_that.title,_that.status,_that.departmentId,_that.departmentName,_that.assignees,_that.startOn,_that.endOn,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String status, @JsonKey(name: 'department_id')  String departmentId, @JsonKey(name: 'department_name')  String? departmentName,  List<Assignees> assignees, @DateOnlyConverter()@JsonKey(name: 'start_on')  DateTime startOn, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime endOn,  String description)?  $default,) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.title,_that.status,_that.departmentId,_that.departmentName,_that.assignees,_that.startOn,_that.endOn,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Task implements Task {
  const _Task({required this.title, required this.status, @JsonKey(name: 'department_id') required this.departmentId, @JsonKey(name: 'department_name') required this.departmentName, required  List<Assignees> assignees, @DateOnlyConverter()@JsonKey(name: 'start_on') required this.startOn, @DateOnlyConverter()@JsonKey(name: 'end_on') required this.endOn, required this.description}): _assignees = assignees;
  factory _Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

@override final  String title;
@override final  String status;
@override@JsonKey(name: 'department_id') final  String departmentId;
@override@JsonKey(name: 'department_name') final  String? departmentName;
 final  List<Assignees> _assignees;
@override List<Assignees> get assignees {
  if (_assignees is EqualUnmodifiableListView) return _assignees;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assignees);
}

@override@DateOnlyConverter()@JsonKey(name: 'start_on') final  DateTime startOn;
@override@DateOnlyConverter()@JsonKey(name: 'end_on') final  DateTime endOn;
@override final  String description;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskCopyWith<_Task> get copyWith => __$TaskCopyWithImpl<_Task>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Task&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&const DeepCollectionEquality().equals(other.assignees, _assignees)&&(identical(other.startOn, startOn) || other.startOn == startOn)&&(identical(other.endOn, endOn) || other.endOn == endOn)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,status,departmentId,departmentName,const DeepCollectionEquality().hash(_assignees),startOn,endOn,description);
}

@override
String toString() {
    return 'Task(title: $title, status: $status, departmentId: $departmentId, departmentName: $departmentName, assignees: $assignees, startOn: $startOn, endOn: $endOn, description: $description)';
}


}

/// @nodoc
abstract mixin class _$TaskCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$TaskCopyWith(_Task value, $Res Function(_Task) _then) = __$TaskCopyWithImpl;
@override @useResult
$Res call({
 String title, String status,@JsonKey(name: 'department_id') String departmentId,@JsonKey(name: 'department_name') String? departmentName, List<Assignees> assignees,@DateOnlyConverter()@JsonKey(name: 'start_on') DateTime startOn,@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime endOn, String description
});




}
/// @nodoc
class __$TaskCopyWithImpl<$Res>
    implements _$TaskCopyWith<$Res> {
  __$TaskCopyWithImpl(this._self, this._then);

  final _Task _self;
  final $Res Function(_Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? status = null,Object? departmentId = null,Object? departmentName = freezed,Object? assignees = null,Object? startOn = null,Object? endOn = null,Object? description = null,}) {
  return _then(_Task(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,departmentName: freezed == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String?,assignees: null == assignees ? _self._assignees : assignees // ignore: cast_nullable_to_non_nullable
as List<Assignees>,startOn: null == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as DateTime,endOn: null == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
