// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'program_work_item_counts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProgramWorkItemCounts {

/// Görünür canlı görev sayısı (süzgeçlerle).
 int get total;@JsonKey(name: 'by_status') ByStatus get byStatus;/// Tamamlanmamış ve `end_on` < bugün (kurulum saat dilimi) olan görev sayısı.
 int get overdue;/// Bekleyen tarih talebi olan görünür görev sayısı (WORK-K82 satır kuralı; üyede 0).
@JsonKey(name: 'pending_date_requests') int get pendingDateRequests;
/// Create a copy of ProgramWorkItemCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgramWorkItemCountsCopyWith<ProgramWorkItemCounts> get copyWith => _$ProgramWorkItemCountsCopyWithImpl<ProgramWorkItemCounts>(this as ProgramWorkItemCounts, _$identity);

  /// Serializes this ProgramWorkItemCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProgramWorkItemCounts;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgramWorkItemCounts&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.byStatus, _this.byStatus) || other.byStatus == _this.byStatus)&&(identical(other.overdue, _this.overdue) || other.overdue == _this.overdue)&&(identical(other.pendingDateRequests, _this.pendingDateRequests) || other.pendingDateRequests == _this.pendingDateRequests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProgramWorkItemCounts;
  return Object.hash(runtimeType,_this.total,_this.byStatus,_this.overdue,_this.pendingDateRequests);
}

@override
String toString() {
  final _this = this as ProgramWorkItemCounts;
  return 'ProgramWorkItemCounts(total: ${_this.total}, byStatus: ${_this.byStatus}, overdue: ${_this.overdue}, pendingDateRequests: ${_this.pendingDateRequests})';
}


}

/// @nodoc
abstract mixin class $ProgramWorkItemCountsCopyWith<$Res>  {
  factory $ProgramWorkItemCountsCopyWith(ProgramWorkItemCounts value, $Res Function(ProgramWorkItemCounts) _then) = _$ProgramWorkItemCountsCopyWithImpl;
@useResult
$Res call({
 int total,@JsonKey(name: 'by_status') ByStatus byStatus, int overdue,@JsonKey(name: 'pending_date_requests') int pendingDateRequests
});


$ByStatusCopyWith<$Res> get byStatus;

}
/// @nodoc
class _$ProgramWorkItemCountsCopyWithImpl<$Res>
    implements $ProgramWorkItemCountsCopyWith<$Res> {
  _$ProgramWorkItemCountsCopyWithImpl(this._self, this._then);

  final ProgramWorkItemCounts _self;
  final $Res Function(ProgramWorkItemCounts) _then;

/// Create a copy of ProgramWorkItemCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? byStatus = null,Object? overdue = null,Object? pendingDateRequests = null,}) {
  return _then(ProgramWorkItemCounts(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,byStatus: null == byStatus ? _self.byStatus : byStatus // ignore: cast_nullable_to_non_nullable
as ByStatus,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as int,pendingDateRequests: null == pendingDateRequests ? _self.pendingDateRequests : pendingDateRequests // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ProgramWorkItemCounts
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ByStatusCopyWith<$Res> get byStatus {
  
  return $ByStatusCopyWith<$Res>(_self.byStatus, (value) {
    return _then(_self.copyWith(byStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProgramWorkItemCounts].
extension ProgramWorkItemCountsPatterns on ProgramWorkItemCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgramWorkItemCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgramWorkItemCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgramWorkItemCounts value)  $default,){
final _that = this;
switch (_that) {
case _ProgramWorkItemCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgramWorkItemCounts value)?  $default,){
final _that = this;
switch (_that) {
case _ProgramWorkItemCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total, @JsonKey(name: 'by_status')  ByStatus byStatus,  int overdue, @JsonKey(name: 'pending_date_requests')  int pendingDateRequests)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgramWorkItemCounts() when $default != null:
return $default(_that.total,_that.byStatus,_that.overdue,_that.pendingDateRequests);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total, @JsonKey(name: 'by_status')  ByStatus byStatus,  int overdue, @JsonKey(name: 'pending_date_requests')  int pendingDateRequests)  $default,) {final _that = this;
switch (_that) {
case _ProgramWorkItemCounts():
return $default(_that.total,_that.byStatus,_that.overdue,_that.pendingDateRequests);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total, @JsonKey(name: 'by_status')  ByStatus byStatus,  int overdue, @JsonKey(name: 'pending_date_requests')  int pendingDateRequests)?  $default,) {final _that = this;
switch (_that) {
case _ProgramWorkItemCounts() when $default != null:
return $default(_that.total,_that.byStatus,_that.overdue,_that.pendingDateRequests);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgramWorkItemCounts implements ProgramWorkItemCounts {
  const _ProgramWorkItemCounts({required this.total, @JsonKey(name: 'by_status') required this.byStatus, required this.overdue, @JsonKey(name: 'pending_date_requests') required this.pendingDateRequests});
  factory _ProgramWorkItemCounts.fromJson(Map<String, dynamic> json) => _$ProgramWorkItemCountsFromJson(json);

/// Görünür canlı görev sayısı (süzgeçlerle).
@override final  int total;
@override@JsonKey(name: 'by_status') final  ByStatus byStatus;
/// Tamamlanmamış ve `end_on` < bugün (kurulum saat dilimi) olan görev sayısı.
@override final  int overdue;
/// Bekleyen tarih talebi olan görünür görev sayısı (WORK-K82 satır kuralı; üyede 0).
@override@JsonKey(name: 'pending_date_requests') final  int pendingDateRequests;

/// Create a copy of ProgramWorkItemCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgramWorkItemCountsCopyWith<_ProgramWorkItemCounts> get copyWith => __$ProgramWorkItemCountsCopyWithImpl<_ProgramWorkItemCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgramWorkItemCountsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgramWorkItemCounts&&(identical(other.total, total) || other.total == total)&&(identical(other.byStatus, byStatus) || other.byStatus == byStatus)&&(identical(other.overdue, overdue) || other.overdue == overdue)&&(identical(other.pendingDateRequests, pendingDateRequests) || other.pendingDateRequests == pendingDateRequests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,byStatus,overdue,pendingDateRequests);
}

@override
String toString() {
    return 'ProgramWorkItemCounts(total: $total, byStatus: $byStatus, overdue: $overdue, pendingDateRequests: $pendingDateRequests)';
}


}

/// @nodoc
abstract mixin class _$ProgramWorkItemCountsCopyWith<$Res> implements $ProgramWorkItemCountsCopyWith<$Res> {
  factory _$ProgramWorkItemCountsCopyWith(_ProgramWorkItemCounts value, $Res Function(_ProgramWorkItemCounts) _then) = __$ProgramWorkItemCountsCopyWithImpl;
@override @useResult
$Res call({
 int total,@JsonKey(name: 'by_status') ByStatus byStatus, int overdue,@JsonKey(name: 'pending_date_requests') int pendingDateRequests
});


@override $ByStatusCopyWith<$Res> get byStatus;

}
/// @nodoc
class __$ProgramWorkItemCountsCopyWithImpl<$Res>
    implements _$ProgramWorkItemCountsCopyWith<$Res> {
  __$ProgramWorkItemCountsCopyWithImpl(this._self, this._then);

  final _ProgramWorkItemCounts _self;
  final $Res Function(_ProgramWorkItemCounts) _then;

/// Create a copy of ProgramWorkItemCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? byStatus = null,Object? overdue = null,Object? pendingDateRequests = null,}) {
  return _then(_ProgramWorkItemCounts(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,byStatus: null == byStatus ? _self.byStatus : byStatus // ignore: cast_nullable_to_non_nullable
as ByStatus,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as int,pendingDateRequests: null == pendingDateRequests ? _self.pendingDateRequests : pendingDateRequests // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ProgramWorkItemCounts
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ByStatusCopyWith<$Res> get byStatus {
  
  return $ByStatusCopyWith<$Res>(_self.byStatus, (value) {
    return _then(_self.copyWith(byStatus: value));
  });
}
}

// dart format on
