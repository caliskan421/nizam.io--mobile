// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workload_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkloadReport {

@JsonKey(name: 'program_id') String get programId;@JsonKey(name: 'program_name') String get programName; List<WorkloadMember> get members; List<ReportDepartment> get coordinatorships; int get total;@JsonKey(name: 'generated_at') DateTime get generatedAt;
/// Create a copy of WorkloadReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkloadReportCopyWith<WorkloadReport> get copyWith => _$WorkloadReportCopyWithImpl<WorkloadReport>(this as WorkloadReport, _$identity);

  /// Serializes this WorkloadReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkloadReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkloadReport&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.programName, _this.programName) || other.programName == _this.programName)&&const DeepCollectionEquality().equals(other.members, _this.members)&&const DeepCollectionEquality().equals(other.coordinatorships, _this.coordinatorships)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.generatedAt, _this.generatedAt) || other.generatedAt == _this.generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkloadReport;
  return Object.hash(runtimeType,_this.programId,_this.programName,const DeepCollectionEquality().hash(_this.members),const DeepCollectionEquality().hash(_this.coordinatorships),_this.total,_this.generatedAt);
}

@override
String toString() {
  final _this = this as WorkloadReport;
  return 'WorkloadReport(programId: ${_this.programId}, programName: ${_this.programName}, members: ${_this.members}, coordinatorships: ${_this.coordinatorships}, total: ${_this.total}, generatedAt: ${_this.generatedAt})';
}


}

/// @nodoc
abstract mixin class $WorkloadReportCopyWith<$Res>  {
  factory $WorkloadReportCopyWith(WorkloadReport value, $Res Function(WorkloadReport) _then) = _$WorkloadReportCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'program_name') String programName, List<WorkloadMember> members, List<ReportDepartment> coordinatorships, int total,@JsonKey(name: 'generated_at') DateTime generatedAt
});




}
/// @nodoc
class _$WorkloadReportCopyWithImpl<$Res>
    implements $WorkloadReportCopyWith<$Res> {
  _$WorkloadReportCopyWithImpl(this._self, this._then);

  final WorkloadReport _self;
  final $Res Function(WorkloadReport) _then;

/// Create a copy of WorkloadReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? programId = null,Object? programName = null,Object? members = null,Object? coordinatorships = null,Object? total = null,Object? generatedAt = null,}) {
  return _then(WorkloadReport(
programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,programName: null == programName ? _self.programName : programName // ignore: cast_nullable_to_non_nullable
as String,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<WorkloadMember>,coordinatorships: null == coordinatorships ? _self.coordinatorships : coordinatorships // ignore: cast_nullable_to_non_nullable
as List<ReportDepartment>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkloadReport].
extension WorkloadReportPatterns on WorkloadReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkloadReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkloadReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkloadReport value)  $default,){
final _that = this;
switch (_that) {
case _WorkloadReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkloadReport value)?  $default,){
final _that = this;
switch (_that) {
case _WorkloadReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'program_name')  String programName,  List<WorkloadMember> members,  List<ReportDepartment> coordinatorships,  int total, @JsonKey(name: 'generated_at')  DateTime generatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkloadReport() when $default != null:
return $default(_that.programId,_that.programName,_that.members,_that.coordinatorships,_that.total,_that.generatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'program_name')  String programName,  List<WorkloadMember> members,  List<ReportDepartment> coordinatorships,  int total, @JsonKey(name: 'generated_at')  DateTime generatedAt)  $default,) {final _that = this;
switch (_that) {
case _WorkloadReport():
return $default(_that.programId,_that.programName,_that.members,_that.coordinatorships,_that.total,_that.generatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'program_name')  String programName,  List<WorkloadMember> members,  List<ReportDepartment> coordinatorships,  int total, @JsonKey(name: 'generated_at')  DateTime generatedAt)?  $default,) {final _that = this;
switch (_that) {
case _WorkloadReport() when $default != null:
return $default(_that.programId,_that.programName,_that.members,_that.coordinatorships,_that.total,_that.generatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkloadReport implements WorkloadReport {
  const _WorkloadReport({@JsonKey(name: 'program_id') required this.programId, @JsonKey(name: 'program_name') required this.programName, required  List<WorkloadMember> members, required  List<ReportDepartment> coordinatorships, required this.total, @JsonKey(name: 'generated_at') required this.generatedAt}): _members = members,_coordinatorships = coordinatorships;
  factory _WorkloadReport.fromJson(Map<String, dynamic> json) => _$WorkloadReportFromJson(json);

@override@JsonKey(name: 'program_id') final  String programId;
@override@JsonKey(name: 'program_name') final  String programName;
 final  List<WorkloadMember> _members;
@override List<WorkloadMember> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

 final  List<ReportDepartment> _coordinatorships;
@override List<ReportDepartment> get coordinatorships {
  if (_coordinatorships is EqualUnmodifiableListView) return _coordinatorships;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coordinatorships);
}

@override final  int total;
@override@JsonKey(name: 'generated_at') final  DateTime generatedAt;

/// Create a copy of WorkloadReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkloadReportCopyWith<_WorkloadReport> get copyWith => __$WorkloadReportCopyWithImpl<_WorkloadReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkloadReportToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkloadReport&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.programName, programName) || other.programName == programName)&&const DeepCollectionEquality().equals(other.members, _members)&&const DeepCollectionEquality().equals(other.coordinatorships, _coordinatorships)&&(identical(other.total, total) || other.total == total)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,programId,programName,const DeepCollectionEquality().hash(_members),const DeepCollectionEquality().hash(_coordinatorships),total,generatedAt);
}

@override
String toString() {
    return 'WorkloadReport(programId: $programId, programName: $programName, members: $members, coordinatorships: $coordinatorships, total: $total, generatedAt: $generatedAt)';
}


}

/// @nodoc
abstract mixin class _$WorkloadReportCopyWith<$Res> implements $WorkloadReportCopyWith<$Res> {
  factory _$WorkloadReportCopyWith(_WorkloadReport value, $Res Function(_WorkloadReport) _then) = __$WorkloadReportCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'program_name') String programName, List<WorkloadMember> members, List<ReportDepartment> coordinatorships, int total,@JsonKey(name: 'generated_at') DateTime generatedAt
});




}
/// @nodoc
class __$WorkloadReportCopyWithImpl<$Res>
    implements _$WorkloadReportCopyWith<$Res> {
  __$WorkloadReportCopyWithImpl(this._self, this._then);

  final _WorkloadReport _self;
  final $Res Function(_WorkloadReport) _then;

/// Create a copy of WorkloadReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? programId = null,Object? programName = null,Object? members = null,Object? coordinatorships = null,Object? total = null,Object? generatedAt = null,}) {
  return _then(_WorkloadReport(
programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,programName: null == programName ? _self.programName : programName // ignore: cast_nullable_to_non_nullable
as String,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<WorkloadMember>,coordinatorships: null == coordinatorships ? _self._coordinatorships : coordinatorships // ignore: cast_nullable_to_non_nullable
as List<ReportDepartment>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
