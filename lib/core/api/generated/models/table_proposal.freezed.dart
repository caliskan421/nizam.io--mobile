// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_proposal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableProposal {

 String get id; TableProposalKind get kind;@JsonKey(name: 'program_id') String get programId;@JsonKey(name: 'target_department_id') String get targetDepartmentId; String get title; List<Columns> get columns;@JsonKey(name: 'row_count') int get rowCount;@JsonKey(name: 'proposer_id') String get proposerId; TableProposalStatus get status;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'target_project_id') String? get targetProjectId;@JsonKey(name: 'team_role') TableProposalTeamRole? get teamRole;
/// Create a copy of TableProposal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableProposalCopyWith<TableProposal> get copyWith => _$TableProposalCopyWithImpl<TableProposal>(this as TableProposal, _$identity);

  /// Serializes this TableProposal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableProposal;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableProposal&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.targetDepartmentId, _this.targetDepartmentId) || other.targetDepartmentId == _this.targetDepartmentId)&&(identical(other.title, _this.title) || other.title == _this.title)&&const DeepCollectionEquality().equals(other.columns, _this.columns)&&(identical(other.rowCount, _this.rowCount) || other.rowCount == _this.rowCount)&&(identical(other.proposerId, _this.proposerId) || other.proposerId == _this.proposerId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.targetProjectId, _this.targetProjectId) || other.targetProjectId == _this.targetProjectId)&&(identical(other.teamRole, _this.teamRole) || other.teamRole == _this.teamRole));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableProposal;
  return Object.hash(runtimeType,_this.id,_this.kind,_this.programId,_this.targetDepartmentId,_this.title,const DeepCollectionEquality().hash(_this.columns),_this.rowCount,_this.proposerId,_this.status,_this.createdAt,_this.targetProjectId,_this.teamRole);
}

@override
String toString() {
  final _this = this as TableProposal;
  return 'TableProposal(id: ${_this.id}, kind: ${_this.kind}, programId: ${_this.programId}, targetDepartmentId: ${_this.targetDepartmentId}, title: ${_this.title}, columns: ${_this.columns}, rowCount: ${_this.rowCount}, proposerId: ${_this.proposerId}, status: ${_this.status}, createdAt: ${_this.createdAt}, targetProjectId: ${_this.targetProjectId}, teamRole: ${_this.teamRole})';
}


}

/// @nodoc
abstract mixin class $TableProposalCopyWith<$Res>  {
  factory $TableProposalCopyWith(TableProposal value, $Res Function(TableProposal) _then) = _$TableProposalCopyWithImpl;
@useResult
$Res call({
 String id, TableProposalKind kind,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'target_department_id') String targetDepartmentId, String title, List<Columns> columns,@JsonKey(name: 'row_count') int rowCount,@JsonKey(name: 'proposer_id') String proposerId, TableProposalStatus status,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'target_project_id') String? targetProjectId,@JsonKey(name: 'team_role') TableProposalTeamRole? teamRole
});




}
/// @nodoc
class _$TableProposalCopyWithImpl<$Res>
    implements $TableProposalCopyWith<$Res> {
  _$TableProposalCopyWithImpl(this._self, this._then);

  final TableProposal _self;
  final $Res Function(TableProposal) _then;

/// Create a copy of TableProposal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? programId = null,Object? targetDepartmentId = null,Object? title = null,Object? columns = null,Object? rowCount = null,Object? proposerId = null,Object? status = null,Object? createdAt = null,Object? targetProjectId = freezed,Object? teamRole = freezed,}) {
  return _then(TableProposal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableProposalKind,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,targetDepartmentId: null == targetDepartmentId ? _self.targetDepartmentId : targetDepartmentId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,columns: null == columns ? _self.columns : columns // ignore: cast_nullable_to_non_nullable
as List<Columns>,rowCount: null == rowCount ? _self.rowCount : rowCount // ignore: cast_nullable_to_non_nullable
as int,proposerId: null == proposerId ? _self.proposerId : proposerId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TableProposalStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,targetProjectId: freezed == targetProjectId ? _self.targetProjectId : targetProjectId // ignore: cast_nullable_to_non_nullable
as String?,teamRole: freezed == teamRole ? _self.teamRole : teamRole // ignore: cast_nullable_to_non_nullable
as TableProposalTeamRole?,
  ));
}

}


/// Adds pattern-matching-related methods to [TableProposal].
extension TableProposalPatterns on TableProposal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableProposal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableProposal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableProposal value)  $default,){
final _that = this;
switch (_that) {
case _TableProposal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableProposal value)?  $default,){
final _that = this;
switch (_that) {
case _TableProposal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  TableProposalKind kind, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'target_department_id')  String targetDepartmentId,  String title,  List<Columns> columns, @JsonKey(name: 'row_count')  int rowCount, @JsonKey(name: 'proposer_id')  String proposerId,  TableProposalStatus status, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'target_project_id')  String? targetProjectId, @JsonKey(name: 'team_role')  TableProposalTeamRole? teamRole)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableProposal() when $default != null:
return $default(_that.id,_that.kind,_that.programId,_that.targetDepartmentId,_that.title,_that.columns,_that.rowCount,_that.proposerId,_that.status,_that.createdAt,_that.targetProjectId,_that.teamRole);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  TableProposalKind kind, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'target_department_id')  String targetDepartmentId,  String title,  List<Columns> columns, @JsonKey(name: 'row_count')  int rowCount, @JsonKey(name: 'proposer_id')  String proposerId,  TableProposalStatus status, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'target_project_id')  String? targetProjectId, @JsonKey(name: 'team_role')  TableProposalTeamRole? teamRole)  $default,) {final _that = this;
switch (_that) {
case _TableProposal():
return $default(_that.id,_that.kind,_that.programId,_that.targetDepartmentId,_that.title,_that.columns,_that.rowCount,_that.proposerId,_that.status,_that.createdAt,_that.targetProjectId,_that.teamRole);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  TableProposalKind kind, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'target_department_id')  String targetDepartmentId,  String title,  List<Columns> columns, @JsonKey(name: 'row_count')  int rowCount, @JsonKey(name: 'proposer_id')  String proposerId,  TableProposalStatus status, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'target_project_id')  String? targetProjectId, @JsonKey(name: 'team_role')  TableProposalTeamRole? teamRole)?  $default,) {final _that = this;
switch (_that) {
case _TableProposal() when $default != null:
return $default(_that.id,_that.kind,_that.programId,_that.targetDepartmentId,_that.title,_that.columns,_that.rowCount,_that.proposerId,_that.status,_that.createdAt,_that.targetProjectId,_that.teamRole);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableProposal implements TableProposal {
  const _TableProposal({required this.id, required this.kind, @JsonKey(name: 'program_id') required this.programId, @JsonKey(name: 'target_department_id') required this.targetDepartmentId, required this.title, required  List<Columns> columns, @JsonKey(name: 'row_count') required this.rowCount, @JsonKey(name: 'proposer_id') required this.proposerId, required this.status, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'target_project_id') this.targetProjectId, @JsonKey(name: 'team_role') this.teamRole}): _columns = columns;
  factory _TableProposal.fromJson(Map<String, dynamic> json) => _$TableProposalFromJson(json);

@override final  String id;
@override final  TableProposalKind kind;
@override@JsonKey(name: 'program_id') final  String programId;
@override@JsonKey(name: 'target_department_id') final  String targetDepartmentId;
@override final  String title;
 final  List<Columns> _columns;
@override List<Columns> get columns {
  if (_columns is EqualUnmodifiableListView) return _columns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_columns);
}

@override@JsonKey(name: 'row_count') final  int rowCount;
@override@JsonKey(name: 'proposer_id') final  String proposerId;
@override final  TableProposalStatus status;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'target_project_id') final  String? targetProjectId;
@override@JsonKey(name: 'team_role') final  TableProposalTeamRole? teamRole;

/// Create a copy of TableProposal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableProposalCopyWith<_TableProposal> get copyWith => __$TableProposalCopyWithImpl<_TableProposal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableProposalToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableProposal&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.targetDepartmentId, targetDepartmentId) || other.targetDepartmentId == targetDepartmentId)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.columns, _columns)&&(identical(other.rowCount, rowCount) || other.rowCount == rowCount)&&(identical(other.proposerId, proposerId) || other.proposerId == proposerId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.targetProjectId, targetProjectId) || other.targetProjectId == targetProjectId)&&(identical(other.teamRole, teamRole) || other.teamRole == teamRole));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,kind,programId,targetDepartmentId,title,const DeepCollectionEquality().hash(_columns),rowCount,proposerId,status,createdAt,targetProjectId,teamRole);
}

@override
String toString() {
    return 'TableProposal(id: $id, kind: $kind, programId: $programId, targetDepartmentId: $targetDepartmentId, title: $title, columns: $columns, rowCount: $rowCount, proposerId: $proposerId, status: $status, createdAt: $createdAt, targetProjectId: $targetProjectId, teamRole: $teamRole)';
}


}

/// @nodoc
abstract mixin class _$TableProposalCopyWith<$Res> implements $TableProposalCopyWith<$Res> {
  factory _$TableProposalCopyWith(_TableProposal value, $Res Function(_TableProposal) _then) = __$TableProposalCopyWithImpl;
@override @useResult
$Res call({
 String id, TableProposalKind kind,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'target_department_id') String targetDepartmentId, String title, List<Columns> columns,@JsonKey(name: 'row_count') int rowCount,@JsonKey(name: 'proposer_id') String proposerId, TableProposalStatus status,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'target_project_id') String? targetProjectId,@JsonKey(name: 'team_role') TableProposalTeamRole? teamRole
});




}
/// @nodoc
class __$TableProposalCopyWithImpl<$Res>
    implements _$TableProposalCopyWith<$Res> {
  __$TableProposalCopyWithImpl(this._self, this._then);

  final _TableProposal _self;
  final $Res Function(_TableProposal) _then;

/// Create a copy of TableProposal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? programId = null,Object? targetDepartmentId = null,Object? title = null,Object? columns = null,Object? rowCount = null,Object? proposerId = null,Object? status = null,Object? createdAt = null,Object? targetProjectId = freezed,Object? teamRole = freezed,}) {
  return _then(_TableProposal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableProposalKind,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,targetDepartmentId: null == targetDepartmentId ? _self.targetDepartmentId : targetDepartmentId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,columns: null == columns ? _self._columns : columns // ignore: cast_nullable_to_non_nullable
as List<Columns>,rowCount: null == rowCount ? _self.rowCount : rowCount // ignore: cast_nullable_to_non_nullable
as int,proposerId: null == proposerId ? _self.proposerId : proposerId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TableProposalStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,targetProjectId: freezed == targetProjectId ? _self.targetProjectId : targetProjectId // ignore: cast_nullable_to_non_nullable
as String?,teamRole: freezed == teamRole ? _self.teamRole : teamRole // ignore: cast_nullable_to_non_nullable
as TableProposalTeamRole?,
  ));
}


}

// dart format on
