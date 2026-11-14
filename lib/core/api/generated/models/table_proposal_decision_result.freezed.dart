// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_proposal_decision_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableProposalDecisionResult {

/// Öneri kimliği.
 String get id; TableProposalDecisionResultStatus get status; bool get replayed;/// Yalnız onayda; taşınan tablo ya da yeni kopya.
@JsonKey(name: 'table_id') String? get tableId;
/// Create a copy of TableProposalDecisionResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableProposalDecisionResultCopyWith<TableProposalDecisionResult> get copyWith => _$TableProposalDecisionResultCopyWithImpl<TableProposalDecisionResult>(this as TableProposalDecisionResult, _$identity);

  /// Serializes this TableProposalDecisionResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableProposalDecisionResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableProposalDecisionResult&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.replayed, _this.replayed) || other.replayed == _this.replayed)&&(identical(other.tableId, _this.tableId) || other.tableId == _this.tableId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableProposalDecisionResult;
  return Object.hash(runtimeType,_this.id,_this.status,_this.replayed,_this.tableId);
}

@override
String toString() {
  final _this = this as TableProposalDecisionResult;
  return 'TableProposalDecisionResult(id: ${_this.id}, status: ${_this.status}, replayed: ${_this.replayed}, tableId: ${_this.tableId})';
}


}

/// @nodoc
abstract mixin class $TableProposalDecisionResultCopyWith<$Res>  {
  factory $TableProposalDecisionResultCopyWith(TableProposalDecisionResult value, $Res Function(TableProposalDecisionResult) _then) = _$TableProposalDecisionResultCopyWithImpl;
@useResult
$Res call({
 String id, TableProposalDecisionResultStatus status, bool replayed,@JsonKey(name: 'table_id') String? tableId
});




}
/// @nodoc
class _$TableProposalDecisionResultCopyWithImpl<$Res>
    implements $TableProposalDecisionResultCopyWith<$Res> {
  _$TableProposalDecisionResultCopyWithImpl(this._self, this._then);

  final TableProposalDecisionResult _self;
  final $Res Function(TableProposalDecisionResult) _then;

/// Create a copy of TableProposalDecisionResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? replayed = null,Object? tableId = freezed,}) {
  return _then(TableProposalDecisionResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TableProposalDecisionResultStatus,replayed: null == replayed ? _self.replayed : replayed // ignore: cast_nullable_to_non_nullable
as bool,tableId: freezed == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TableProposalDecisionResult].
extension TableProposalDecisionResultPatterns on TableProposalDecisionResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableProposalDecisionResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableProposalDecisionResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableProposalDecisionResult value)  $default,){
final _that = this;
switch (_that) {
case _TableProposalDecisionResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableProposalDecisionResult value)?  $default,){
final _that = this;
switch (_that) {
case _TableProposalDecisionResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  TableProposalDecisionResultStatus status,  bool replayed, @JsonKey(name: 'table_id')  String? tableId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableProposalDecisionResult() when $default != null:
return $default(_that.id,_that.status,_that.replayed,_that.tableId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  TableProposalDecisionResultStatus status,  bool replayed, @JsonKey(name: 'table_id')  String? tableId)  $default,) {final _that = this;
switch (_that) {
case _TableProposalDecisionResult():
return $default(_that.id,_that.status,_that.replayed,_that.tableId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  TableProposalDecisionResultStatus status,  bool replayed, @JsonKey(name: 'table_id')  String? tableId)?  $default,) {final _that = this;
switch (_that) {
case _TableProposalDecisionResult() when $default != null:
return $default(_that.id,_that.status,_that.replayed,_that.tableId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableProposalDecisionResult implements TableProposalDecisionResult {
  const _TableProposalDecisionResult({required this.id, required this.status, required this.replayed, @JsonKey(name: 'table_id') this.tableId});
  factory _TableProposalDecisionResult.fromJson(Map<String, dynamic> json) => _$TableProposalDecisionResultFromJson(json);

/// Öneri kimliği.
@override final  String id;
@override final  TableProposalDecisionResultStatus status;
@override final  bool replayed;
/// Yalnız onayda; taşınan tablo ya da yeni kopya.
@override@JsonKey(name: 'table_id') final  String? tableId;

/// Create a copy of TableProposalDecisionResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableProposalDecisionResultCopyWith<_TableProposalDecisionResult> get copyWith => __$TableProposalDecisionResultCopyWithImpl<_TableProposalDecisionResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableProposalDecisionResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableProposalDecisionResult&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.replayed, replayed) || other.replayed == replayed)&&(identical(other.tableId, tableId) || other.tableId == tableId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,status,replayed,tableId);
}

@override
String toString() {
    return 'TableProposalDecisionResult(id: $id, status: $status, replayed: $replayed, tableId: $tableId)';
}


}

/// @nodoc
abstract mixin class _$TableProposalDecisionResultCopyWith<$Res> implements $TableProposalDecisionResultCopyWith<$Res> {
  factory _$TableProposalDecisionResultCopyWith(_TableProposalDecisionResult value, $Res Function(_TableProposalDecisionResult) _then) = __$TableProposalDecisionResultCopyWithImpl;
@override @useResult
$Res call({
 String id, TableProposalDecisionResultStatus status, bool replayed,@JsonKey(name: 'table_id') String? tableId
});




}
/// @nodoc
class __$TableProposalDecisionResultCopyWithImpl<$Res>
    implements _$TableProposalDecisionResultCopyWith<$Res> {
  __$TableProposalDecisionResultCopyWithImpl(this._self, this._then);

  final _TableProposalDecisionResult _self;
  final $Res Function(_TableProposalDecisionResult) _then;

/// Create a copy of TableProposalDecisionResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? replayed = null,Object? tableId = freezed,}) {
  return _then(_TableProposalDecisionResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TableProposalDecisionResultStatus,replayed: null == replayed ? _self.replayed : replayed // ignore: cast_nullable_to_non_nullable
as bool,tableId: freezed == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
