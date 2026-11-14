// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuditEntry {

@JsonKey(name: 'entry_id') String get entryId;@JsonKey(name: 'occurred_at') DateTime get occurredAt;/// Kurulum aracı/sistem işlemlerinde `null`.
@JsonKey(name: 'actor_account_id') String? get actorAccountId;@JsonKey(name: 'actor_full_name') String? get actorFullName;@JsonKey(name: 'subject_kind') String get subjectKind;@JsonKey(name: 'subject_id') String get subjectId;/// Kararlı eylem kodu (ör. `work.item.transitioned`); görünen ad istemci sözlüğündedir.
@JsonKey(name: 'action_code') String get actionCode; AuditEntryOutcome get outcome;@JsonKey(name: 'program_id') String? get programId;@JsonKey(name: 'department_id') String? get departmentId;/// Kararlı ayrıntı (ör. dosya adı, `acting_as=company_admin`); serbest metin taşımaz.
 String? get details;
/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditEntryCopyWith<AuditEntry> get copyWith => _$AuditEntryCopyWithImpl<AuditEntry>(this as AuditEntry, _$identity);

  /// Serializes this AuditEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AuditEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditEntry&&(identical(other.entryId, _this.entryId) || other.entryId == _this.entryId)&&(identical(other.occurredAt, _this.occurredAt) || other.occurredAt == _this.occurredAt)&&(identical(other.actorAccountId, _this.actorAccountId) || other.actorAccountId == _this.actorAccountId)&&(identical(other.actorFullName, _this.actorFullName) || other.actorFullName == _this.actorFullName)&&(identical(other.subjectKind, _this.subjectKind) || other.subjectKind == _this.subjectKind)&&(identical(other.subjectId, _this.subjectId) || other.subjectId == _this.subjectId)&&(identical(other.actionCode, _this.actionCode) || other.actionCode == _this.actionCode)&&(identical(other.outcome, _this.outcome) || other.outcome == _this.outcome)&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.details, _this.details) || other.details == _this.details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AuditEntry;
  return Object.hash(runtimeType,_this.entryId,_this.occurredAt,_this.actorAccountId,_this.actorFullName,_this.subjectKind,_this.subjectId,_this.actionCode,_this.outcome,_this.programId,_this.departmentId,_this.details);
}

@override
String toString() {
  final _this = this as AuditEntry;
  return 'AuditEntry(entryId: ${_this.entryId}, occurredAt: ${_this.occurredAt}, actorAccountId: ${_this.actorAccountId}, actorFullName: ${_this.actorFullName}, subjectKind: ${_this.subjectKind}, subjectId: ${_this.subjectId}, actionCode: ${_this.actionCode}, outcome: ${_this.outcome}, programId: ${_this.programId}, departmentId: ${_this.departmentId}, details: ${_this.details})';
}


}

/// @nodoc
abstract mixin class $AuditEntryCopyWith<$Res>  {
  factory $AuditEntryCopyWith(AuditEntry value, $Res Function(AuditEntry) _then) = _$AuditEntryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'entry_id') String entryId,@JsonKey(name: 'occurred_at') DateTime occurredAt,@JsonKey(name: 'actor_account_id') String? actorAccountId,@JsonKey(name: 'actor_full_name') String? actorFullName,@JsonKey(name: 'subject_kind') String subjectKind,@JsonKey(name: 'subject_id') String subjectId,@JsonKey(name: 'action_code') String actionCode, AuditEntryOutcome outcome,@JsonKey(name: 'program_id') String? programId,@JsonKey(name: 'department_id') String? departmentId, String? details
});




}
/// @nodoc
class _$AuditEntryCopyWithImpl<$Res>
    implements $AuditEntryCopyWith<$Res> {
  _$AuditEntryCopyWithImpl(this._self, this._then);

  final AuditEntry _self;
  final $Res Function(AuditEntry) _then;

/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entryId = null,Object? occurredAt = null,Object? actorAccountId = freezed,Object? actorFullName = freezed,Object? subjectKind = null,Object? subjectId = null,Object? actionCode = null,Object? outcome = null,Object? programId = freezed,Object? departmentId = freezed,Object? details = freezed,}) {
  return _then(AuditEntry(
entryId: null == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,actorAccountId: freezed == actorAccountId ? _self.actorAccountId : actorAccountId // ignore: cast_nullable_to_non_nullable
as String?,actorFullName: freezed == actorFullName ? _self.actorFullName : actorFullName // ignore: cast_nullable_to_non_nullable
as String?,subjectKind: null == subjectKind ? _self.subjectKind : subjectKind // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,actionCode: null == actionCode ? _self.actionCode : actionCode // ignore: cast_nullable_to_non_nullable
as String,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as AuditEntryOutcome,programId: freezed == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditEntry].
extension AuditEntryPatterns on AuditEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditEntry value)  $default,){
final _that = this;
switch (_that) {
case _AuditEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditEntry value)?  $default,){
final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'entry_id')  String entryId, @JsonKey(name: 'occurred_at')  DateTime occurredAt, @JsonKey(name: 'actor_account_id')  String? actorAccountId, @JsonKey(name: 'actor_full_name')  String? actorFullName, @JsonKey(name: 'subject_kind')  String subjectKind, @JsonKey(name: 'subject_id')  String subjectId, @JsonKey(name: 'action_code')  String actionCode,  AuditEntryOutcome outcome, @JsonKey(name: 'program_id')  String? programId, @JsonKey(name: 'department_id')  String? departmentId,  String? details)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
return $default(_that.entryId,_that.occurredAt,_that.actorAccountId,_that.actorFullName,_that.subjectKind,_that.subjectId,_that.actionCode,_that.outcome,_that.programId,_that.departmentId,_that.details);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'entry_id')  String entryId, @JsonKey(name: 'occurred_at')  DateTime occurredAt, @JsonKey(name: 'actor_account_id')  String? actorAccountId, @JsonKey(name: 'actor_full_name')  String? actorFullName, @JsonKey(name: 'subject_kind')  String subjectKind, @JsonKey(name: 'subject_id')  String subjectId, @JsonKey(name: 'action_code')  String actionCode,  AuditEntryOutcome outcome, @JsonKey(name: 'program_id')  String? programId, @JsonKey(name: 'department_id')  String? departmentId,  String? details)  $default,) {final _that = this;
switch (_that) {
case _AuditEntry():
return $default(_that.entryId,_that.occurredAt,_that.actorAccountId,_that.actorFullName,_that.subjectKind,_that.subjectId,_that.actionCode,_that.outcome,_that.programId,_that.departmentId,_that.details);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'entry_id')  String entryId, @JsonKey(name: 'occurred_at')  DateTime occurredAt, @JsonKey(name: 'actor_account_id')  String? actorAccountId, @JsonKey(name: 'actor_full_name')  String? actorFullName, @JsonKey(name: 'subject_kind')  String subjectKind, @JsonKey(name: 'subject_id')  String subjectId, @JsonKey(name: 'action_code')  String actionCode,  AuditEntryOutcome outcome, @JsonKey(name: 'program_id')  String? programId, @JsonKey(name: 'department_id')  String? departmentId,  String? details)?  $default,) {final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
return $default(_that.entryId,_that.occurredAt,_that.actorAccountId,_that.actorFullName,_that.subjectKind,_that.subjectId,_that.actionCode,_that.outcome,_that.programId,_that.departmentId,_that.details);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditEntry implements AuditEntry {
  const _AuditEntry({@JsonKey(name: 'entry_id') required this.entryId, @JsonKey(name: 'occurred_at') required this.occurredAt, @JsonKey(name: 'actor_account_id') required this.actorAccountId, @JsonKey(name: 'actor_full_name') required this.actorFullName, @JsonKey(name: 'subject_kind') required this.subjectKind, @JsonKey(name: 'subject_id') required this.subjectId, @JsonKey(name: 'action_code') required this.actionCode, required this.outcome, @JsonKey(name: 'program_id') required this.programId, @JsonKey(name: 'department_id') required this.departmentId, required this.details});
  factory _AuditEntry.fromJson(Map<String, dynamic> json) => _$AuditEntryFromJson(json);

@override@JsonKey(name: 'entry_id') final  String entryId;
@override@JsonKey(name: 'occurred_at') final  DateTime occurredAt;
/// Kurulum aracı/sistem işlemlerinde `null`.
@override@JsonKey(name: 'actor_account_id') final  String? actorAccountId;
@override@JsonKey(name: 'actor_full_name') final  String? actorFullName;
@override@JsonKey(name: 'subject_kind') final  String subjectKind;
@override@JsonKey(name: 'subject_id') final  String subjectId;
/// Kararlı eylem kodu (ör. `work.item.transitioned`); görünen ad istemci sözlüğündedir.
@override@JsonKey(name: 'action_code') final  String actionCode;
@override final  AuditEntryOutcome outcome;
@override@JsonKey(name: 'program_id') final  String? programId;
@override@JsonKey(name: 'department_id') final  String? departmentId;
/// Kararlı ayrıntı (ör. dosya adı, `acting_as=company_admin`); serbest metin taşımaz.
@override final  String? details;

/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditEntryCopyWith<_AuditEntry> get copyWith => __$AuditEntryCopyWithImpl<_AuditEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditEntry&&(identical(other.entryId, entryId) || other.entryId == entryId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.actorAccountId, actorAccountId) || other.actorAccountId == actorAccountId)&&(identical(other.actorFullName, actorFullName) || other.actorFullName == actorFullName)&&(identical(other.subjectKind, subjectKind) || other.subjectKind == subjectKind)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.actionCode, actionCode) || other.actionCode == actionCode)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.details, details) || other.details == details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,entryId,occurredAt,actorAccountId,actorFullName,subjectKind,subjectId,actionCode,outcome,programId,departmentId,details);
}

@override
String toString() {
    return 'AuditEntry(entryId: $entryId, occurredAt: $occurredAt, actorAccountId: $actorAccountId, actorFullName: $actorFullName, subjectKind: $subjectKind, subjectId: $subjectId, actionCode: $actionCode, outcome: $outcome, programId: $programId, departmentId: $departmentId, details: $details)';
}


}

/// @nodoc
abstract mixin class _$AuditEntryCopyWith<$Res> implements $AuditEntryCopyWith<$Res> {
  factory _$AuditEntryCopyWith(_AuditEntry value, $Res Function(_AuditEntry) _then) = __$AuditEntryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'entry_id') String entryId,@JsonKey(name: 'occurred_at') DateTime occurredAt,@JsonKey(name: 'actor_account_id') String? actorAccountId,@JsonKey(name: 'actor_full_name') String? actorFullName,@JsonKey(name: 'subject_kind') String subjectKind,@JsonKey(name: 'subject_id') String subjectId,@JsonKey(name: 'action_code') String actionCode, AuditEntryOutcome outcome,@JsonKey(name: 'program_id') String? programId,@JsonKey(name: 'department_id') String? departmentId, String? details
});




}
/// @nodoc
class __$AuditEntryCopyWithImpl<$Res>
    implements _$AuditEntryCopyWith<$Res> {
  __$AuditEntryCopyWithImpl(this._self, this._then);

  final _AuditEntry _self;
  final $Res Function(_AuditEntry) _then;

/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entryId = null,Object? occurredAt = null,Object? actorAccountId = freezed,Object? actorFullName = freezed,Object? subjectKind = null,Object? subjectId = null,Object? actionCode = null,Object? outcome = null,Object? programId = freezed,Object? departmentId = freezed,Object? details = freezed,}) {
  return _then(_AuditEntry(
entryId: null == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,actorAccountId: freezed == actorAccountId ? _self.actorAccountId : actorAccountId // ignore: cast_nullable_to_non_nullable
as String?,actorFullName: freezed == actorFullName ? _self.actorFullName : actorFullName // ignore: cast_nullable_to_non_nullable
as String?,subjectKind: null == subjectKind ? _self.subjectKind : subjectKind // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,actionCode: null == actionCode ? _self.actionCode : actionCode // ignore: cast_nullable_to_non_nullable
as String,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as AuditEntryOutcome,programId: freezed == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
