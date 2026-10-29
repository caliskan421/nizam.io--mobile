// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_task_ref.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportTaskRef {

@JsonKey(name: 'work_item_id') String get workItemId; String get title; String get status;@JsonKey(name: 'department_name') String get departmentName;
/// Create a copy of ReportTaskRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportTaskRefCopyWith<ReportTaskRef> get copyWith => _$ReportTaskRefCopyWithImpl<ReportTaskRef>(this as ReportTaskRef, _$identity);

  /// Serializes this ReportTaskRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportTaskRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportTaskRef&&(identical(other.workItemId, _this.workItemId) || other.workItemId == _this.workItemId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.departmentName, _this.departmentName) || other.departmentName == _this.departmentName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportTaskRef;
  return Object.hash(runtimeType,_this.workItemId,_this.title,_this.status,_this.departmentName);
}

@override
String toString() {
  final _this = this as ReportTaskRef;
  return 'ReportTaskRef(workItemId: ${_this.workItemId}, title: ${_this.title}, status: ${_this.status}, departmentName: ${_this.departmentName})';
}


}

/// @nodoc
abstract mixin class $ReportTaskRefCopyWith<$Res>  {
  factory $ReportTaskRefCopyWith(ReportTaskRef value, $Res Function(ReportTaskRef) _then) = _$ReportTaskRefCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, String title, String status,@JsonKey(name: 'department_name') String departmentName
});




}
/// @nodoc
class _$ReportTaskRefCopyWithImpl<$Res>
    implements $ReportTaskRefCopyWith<$Res> {
  _$ReportTaskRefCopyWithImpl(this._self, this._then);

  final ReportTaskRef _self;
  final $Res Function(ReportTaskRef) _then;

/// Create a copy of ReportTaskRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workItemId = null,Object? title = null,Object? status = null,Object? departmentName = null,}) {
  return _then(ReportTaskRef(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,departmentName: null == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportTaskRef].
extension ReportTaskRefPatterns on ReportTaskRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportTaskRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportTaskRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportTaskRef value)  $default,){
final _that = this;
switch (_that) {
case _ReportTaskRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportTaskRef value)?  $default,){
final _that = this;
switch (_that) {
case _ReportTaskRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title,  String status, @JsonKey(name: 'department_name')  String departmentName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportTaskRef() when $default != null:
return $default(_that.workItemId,_that.title,_that.status,_that.departmentName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title,  String status, @JsonKey(name: 'department_name')  String departmentName)  $default,) {final _that = this;
switch (_that) {
case _ReportTaskRef():
return $default(_that.workItemId,_that.title,_that.status,_that.departmentName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'work_item_id')  String workItemId,  String title,  String status, @JsonKey(name: 'department_name')  String departmentName)?  $default,) {final _that = this;
switch (_that) {
case _ReportTaskRef() when $default != null:
return $default(_that.workItemId,_that.title,_that.status,_that.departmentName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportTaskRef implements ReportTaskRef {
  const _ReportTaskRef({@JsonKey(name: 'work_item_id') required this.workItemId, required this.title, required this.status, @JsonKey(name: 'department_name') required this.departmentName});
  factory _ReportTaskRef.fromJson(Map<String, dynamic> json) => _$ReportTaskRefFromJson(json);

@override@JsonKey(name: 'work_item_id') final  String workItemId;
@override final  String title;
@override final  String status;
@override@JsonKey(name: 'department_name') final  String departmentName;

/// Create a copy of ReportTaskRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportTaskRefCopyWith<_ReportTaskRef> get copyWith => __$ReportTaskRefCopyWithImpl<_ReportTaskRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportTaskRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportTaskRef&&(identical(other.workItemId, workItemId) || other.workItemId == workItemId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,workItemId,title,status,departmentName);
}

@override
String toString() {
    return 'ReportTaskRef(workItemId: $workItemId, title: $title, status: $status, departmentName: $departmentName)';
}


}

/// @nodoc
abstract mixin class _$ReportTaskRefCopyWith<$Res> implements $ReportTaskRefCopyWith<$Res> {
  factory _$ReportTaskRefCopyWith(_ReportTaskRef value, $Res Function(_ReportTaskRef) _then) = __$ReportTaskRefCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, String title, String status,@JsonKey(name: 'department_name') String departmentName
});




}
/// @nodoc
class __$ReportTaskRefCopyWithImpl<$Res>
    implements _$ReportTaskRefCopyWith<$Res> {
  __$ReportTaskRefCopyWithImpl(this._self, this._then);

  final _ReportTaskRef _self;
  final $Res Function(_ReportTaskRef) _then;

/// Create a copy of ReportTaskRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workItemId = null,Object? title = null,Object? status = null,Object? departmentName = null,}) {
  return _then(_ReportTaskRef(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,departmentName: null == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
