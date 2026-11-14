// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'department_permanent_blockers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DepartmentPermanentBlockers {

 int get tables; int get projects;@JsonKey(name: 'pending_proposals') int get pendingProposals;
/// Create a copy of DepartmentPermanentBlockers
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartmentPermanentBlockersCopyWith<DepartmentPermanentBlockers> get copyWith => _$DepartmentPermanentBlockersCopyWithImpl<DepartmentPermanentBlockers>(this as DepartmentPermanentBlockers, _$identity);

  /// Serializes this DepartmentPermanentBlockers to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DepartmentPermanentBlockers;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartmentPermanentBlockers&&(identical(other.tables, _this.tables) || other.tables == _this.tables)&&(identical(other.projects, _this.projects) || other.projects == _this.projects)&&(identical(other.pendingProposals, _this.pendingProposals) || other.pendingProposals == _this.pendingProposals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DepartmentPermanentBlockers;
  return Object.hash(runtimeType,_this.tables,_this.projects,_this.pendingProposals);
}

@override
String toString() {
  final _this = this as DepartmentPermanentBlockers;
  return 'DepartmentPermanentBlockers(tables: ${_this.tables}, projects: ${_this.projects}, pendingProposals: ${_this.pendingProposals})';
}


}

/// @nodoc
abstract mixin class $DepartmentPermanentBlockersCopyWith<$Res>  {
  factory $DepartmentPermanentBlockersCopyWith(DepartmentPermanentBlockers value, $Res Function(DepartmentPermanentBlockers) _then) = _$DepartmentPermanentBlockersCopyWithImpl;
@useResult
$Res call({
 int tables, int projects,@JsonKey(name: 'pending_proposals') int pendingProposals
});




}
/// @nodoc
class _$DepartmentPermanentBlockersCopyWithImpl<$Res>
    implements $DepartmentPermanentBlockersCopyWith<$Res> {
  _$DepartmentPermanentBlockersCopyWithImpl(this._self, this._then);

  final DepartmentPermanentBlockers _self;
  final $Res Function(DepartmentPermanentBlockers) _then;

/// Create a copy of DepartmentPermanentBlockers
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tables = null,Object? projects = null,Object? pendingProposals = null,}) {
  return _then(DepartmentPermanentBlockers(
tables: null == tables ? _self.tables : tables // ignore: cast_nullable_to_non_nullable
as int,projects: null == projects ? _self.projects : projects // ignore: cast_nullable_to_non_nullable
as int,pendingProposals: null == pendingProposals ? _self.pendingProposals : pendingProposals // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DepartmentPermanentBlockers].
extension DepartmentPermanentBlockersPatterns on DepartmentPermanentBlockers {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DepartmentPermanentBlockers value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DepartmentPermanentBlockers() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DepartmentPermanentBlockers value)  $default,){
final _that = this;
switch (_that) {
case _DepartmentPermanentBlockers():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DepartmentPermanentBlockers value)?  $default,){
final _that = this;
switch (_that) {
case _DepartmentPermanentBlockers() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int tables,  int projects, @JsonKey(name: 'pending_proposals')  int pendingProposals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DepartmentPermanentBlockers() when $default != null:
return $default(_that.tables,_that.projects,_that.pendingProposals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int tables,  int projects, @JsonKey(name: 'pending_proposals')  int pendingProposals)  $default,) {final _that = this;
switch (_that) {
case _DepartmentPermanentBlockers():
return $default(_that.tables,_that.projects,_that.pendingProposals);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int tables,  int projects, @JsonKey(name: 'pending_proposals')  int pendingProposals)?  $default,) {final _that = this;
switch (_that) {
case _DepartmentPermanentBlockers() when $default != null:
return $default(_that.tables,_that.projects,_that.pendingProposals);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DepartmentPermanentBlockers implements DepartmentPermanentBlockers {
  const _DepartmentPermanentBlockers({required this.tables, required this.projects, @JsonKey(name: 'pending_proposals') required this.pendingProposals});
  factory _DepartmentPermanentBlockers.fromJson(Map<String, dynamic> json) => _$DepartmentPermanentBlockersFromJson(json);

@override final  int tables;
@override final  int projects;
@override@JsonKey(name: 'pending_proposals') final  int pendingProposals;

/// Create a copy of DepartmentPermanentBlockers
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DepartmentPermanentBlockersCopyWith<_DepartmentPermanentBlockers> get copyWith => __$DepartmentPermanentBlockersCopyWithImpl<_DepartmentPermanentBlockers>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DepartmentPermanentBlockersToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DepartmentPermanentBlockers&&(identical(other.tables, tables) || other.tables == tables)&&(identical(other.projects, projects) || other.projects == projects)&&(identical(other.pendingProposals, pendingProposals) || other.pendingProposals == pendingProposals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tables,projects,pendingProposals);
}

@override
String toString() {
    return 'DepartmentPermanentBlockers(tables: $tables, projects: $projects, pendingProposals: $pendingProposals)';
}


}

/// @nodoc
abstract mixin class _$DepartmentPermanentBlockersCopyWith<$Res> implements $DepartmentPermanentBlockersCopyWith<$Res> {
  factory _$DepartmentPermanentBlockersCopyWith(_DepartmentPermanentBlockers value, $Res Function(_DepartmentPermanentBlockers) _then) = __$DepartmentPermanentBlockersCopyWithImpl;
@override @useResult
$Res call({
 int tables, int projects,@JsonKey(name: 'pending_proposals') int pendingProposals
});




}
/// @nodoc
class __$DepartmentPermanentBlockersCopyWithImpl<$Res>
    implements _$DepartmentPermanentBlockersCopyWith<$Res> {
  __$DepartmentPermanentBlockersCopyWithImpl(this._self, this._then);

  final _DepartmentPermanentBlockers _self;
  final $Res Function(_DepartmentPermanentBlockers) _then;

/// Create a copy of DepartmentPermanentBlockers
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tables = null,Object? projects = null,Object? pendingProposals = null,}) {
  return _then(_DepartmentPermanentBlockers(
tables: null == tables ? _self.tables : tables // ignore: cast_nullable_to_non_nullable
as int,projects: null == projects ? _self.projects : projects // ignore: cast_nullable_to_non_nullable
as int,pendingProposals: null == pendingProposals ? _self.pendingProposals : pendingProposals // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
