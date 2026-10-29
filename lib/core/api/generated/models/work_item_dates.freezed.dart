// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_item_dates.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkItemDates {

@JsonKey(name: 'start_on') DateTime get startOn;@JsonKey(name: 'end_on') DateTime get endOn;@JsonKey(name: 'planned_end_on') DateTime? get plannedEndOn;@JsonKey(name: 'completed_on') DateTime? get completedOn;@JsonKey(name: 'original_completed_on') DateTime? get originalCompletedOn;@JsonKey(name: 'submitted_on') DateTime? get submittedOn;
/// Create a copy of WorkItemDates
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkItemDatesCopyWith<WorkItemDates> get copyWith => _$WorkItemDatesCopyWithImpl<WorkItemDates>(this as WorkItemDates, _$identity);

  /// Serializes this WorkItemDates to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkItemDates;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkItemDates&&(identical(other.startOn, _this.startOn) || other.startOn == _this.startOn)&&(identical(other.endOn, _this.endOn) || other.endOn == _this.endOn)&&(identical(other.plannedEndOn, _this.plannedEndOn) || other.plannedEndOn == _this.plannedEndOn)&&(identical(other.completedOn, _this.completedOn) || other.completedOn == _this.completedOn)&&(identical(other.originalCompletedOn, _this.originalCompletedOn) || other.originalCompletedOn == _this.originalCompletedOn)&&(identical(other.submittedOn, _this.submittedOn) || other.submittedOn == _this.submittedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkItemDates;
  return Object.hash(runtimeType,_this.startOn,_this.endOn,_this.plannedEndOn,_this.completedOn,_this.originalCompletedOn,_this.submittedOn);
}

@override
String toString() {
  final _this = this as WorkItemDates;
  return 'WorkItemDates(startOn: ${_this.startOn}, endOn: ${_this.endOn}, plannedEndOn: ${_this.plannedEndOn}, completedOn: ${_this.completedOn}, originalCompletedOn: ${_this.originalCompletedOn}, submittedOn: ${_this.submittedOn})';
}


}

/// @nodoc
abstract mixin class $WorkItemDatesCopyWith<$Res>  {
  factory $WorkItemDatesCopyWith(WorkItemDates value, $Res Function(WorkItemDates) _then) = _$WorkItemDatesCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'start_on') DateTime startOn,@JsonKey(name: 'end_on') DateTime endOn,@JsonKey(name: 'planned_end_on') DateTime? plannedEndOn,@JsonKey(name: 'completed_on') DateTime? completedOn,@JsonKey(name: 'original_completed_on') DateTime? originalCompletedOn,@JsonKey(name: 'submitted_on') DateTime? submittedOn
});




}
/// @nodoc
class _$WorkItemDatesCopyWithImpl<$Res>
    implements $WorkItemDatesCopyWith<$Res> {
  _$WorkItemDatesCopyWithImpl(this._self, this._then);

  final WorkItemDates _self;
  final $Res Function(WorkItemDates) _then;

/// Create a copy of WorkItemDates
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startOn = null,Object? endOn = null,Object? plannedEndOn = freezed,Object? completedOn = freezed,Object? originalCompletedOn = freezed,Object? submittedOn = freezed,}) {
  return _then(WorkItemDates(
startOn: null == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as DateTime,endOn: null == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as DateTime,plannedEndOn: freezed == plannedEndOn ? _self.plannedEndOn : plannedEndOn // ignore: cast_nullable_to_non_nullable
as DateTime?,completedOn: freezed == completedOn ? _self.completedOn : completedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,originalCompletedOn: freezed == originalCompletedOn ? _self.originalCompletedOn : originalCompletedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,submittedOn: freezed == submittedOn ? _self.submittedOn : submittedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkItemDates].
extension WorkItemDatesPatterns on WorkItemDates {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkItemDates value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkItemDates() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkItemDates value)  $default,){
final _that = this;
switch (_that) {
case _WorkItemDates():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkItemDates value)?  $default,){
final _that = this;
switch (_that) {
case _WorkItemDates() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'start_on')  DateTime startOn, @JsonKey(name: 'end_on')  DateTime endOn, @JsonKey(name: 'planned_end_on')  DateTime? plannedEndOn, @JsonKey(name: 'completed_on')  DateTime? completedOn, @JsonKey(name: 'original_completed_on')  DateTime? originalCompletedOn, @JsonKey(name: 'submitted_on')  DateTime? submittedOn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkItemDates() when $default != null:
return $default(_that.startOn,_that.endOn,_that.plannedEndOn,_that.completedOn,_that.originalCompletedOn,_that.submittedOn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'start_on')  DateTime startOn, @JsonKey(name: 'end_on')  DateTime endOn, @JsonKey(name: 'planned_end_on')  DateTime? plannedEndOn, @JsonKey(name: 'completed_on')  DateTime? completedOn, @JsonKey(name: 'original_completed_on')  DateTime? originalCompletedOn, @JsonKey(name: 'submitted_on')  DateTime? submittedOn)  $default,) {final _that = this;
switch (_that) {
case _WorkItemDates():
return $default(_that.startOn,_that.endOn,_that.plannedEndOn,_that.completedOn,_that.originalCompletedOn,_that.submittedOn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'start_on')  DateTime startOn, @JsonKey(name: 'end_on')  DateTime endOn, @JsonKey(name: 'planned_end_on')  DateTime? plannedEndOn, @JsonKey(name: 'completed_on')  DateTime? completedOn, @JsonKey(name: 'original_completed_on')  DateTime? originalCompletedOn, @JsonKey(name: 'submitted_on')  DateTime? submittedOn)?  $default,) {final _that = this;
switch (_that) {
case _WorkItemDates() when $default != null:
return $default(_that.startOn,_that.endOn,_that.plannedEndOn,_that.completedOn,_that.originalCompletedOn,_that.submittedOn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkItemDates implements WorkItemDates {
  const _WorkItemDates({@JsonKey(name: 'start_on') required this.startOn, @JsonKey(name: 'end_on') required this.endOn, @JsonKey(name: 'planned_end_on') this.plannedEndOn, @JsonKey(name: 'completed_on') this.completedOn, @JsonKey(name: 'original_completed_on') this.originalCompletedOn, @JsonKey(name: 'submitted_on') this.submittedOn});
  factory _WorkItemDates.fromJson(Map<String, dynamic> json) => _$WorkItemDatesFromJson(json);

@override@JsonKey(name: 'start_on') final  DateTime startOn;
@override@JsonKey(name: 'end_on') final  DateTime endOn;
@override@JsonKey(name: 'planned_end_on') final  DateTime? plannedEndOn;
@override@JsonKey(name: 'completed_on') final  DateTime? completedOn;
@override@JsonKey(name: 'original_completed_on') final  DateTime? originalCompletedOn;
@override@JsonKey(name: 'submitted_on') final  DateTime? submittedOn;

/// Create a copy of WorkItemDates
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkItemDatesCopyWith<_WorkItemDates> get copyWith => __$WorkItemDatesCopyWithImpl<_WorkItemDates>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkItemDatesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkItemDates&&(identical(other.startOn, startOn) || other.startOn == startOn)&&(identical(other.endOn, endOn) || other.endOn == endOn)&&(identical(other.plannedEndOn, plannedEndOn) || other.plannedEndOn == plannedEndOn)&&(identical(other.completedOn, completedOn) || other.completedOn == completedOn)&&(identical(other.originalCompletedOn, originalCompletedOn) || other.originalCompletedOn == originalCompletedOn)&&(identical(other.submittedOn, submittedOn) || other.submittedOn == submittedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,startOn,endOn,plannedEndOn,completedOn,originalCompletedOn,submittedOn);
}

@override
String toString() {
    return 'WorkItemDates(startOn: $startOn, endOn: $endOn, plannedEndOn: $plannedEndOn, completedOn: $completedOn, originalCompletedOn: $originalCompletedOn, submittedOn: $submittedOn)';
}


}

/// @nodoc
abstract mixin class _$WorkItemDatesCopyWith<$Res> implements $WorkItemDatesCopyWith<$Res> {
  factory _$WorkItemDatesCopyWith(_WorkItemDates value, $Res Function(_WorkItemDates) _then) = __$WorkItemDatesCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'start_on') DateTime startOn,@JsonKey(name: 'end_on') DateTime endOn,@JsonKey(name: 'planned_end_on') DateTime? plannedEndOn,@JsonKey(name: 'completed_on') DateTime? completedOn,@JsonKey(name: 'original_completed_on') DateTime? originalCompletedOn,@JsonKey(name: 'submitted_on') DateTime? submittedOn
});




}
/// @nodoc
class __$WorkItemDatesCopyWithImpl<$Res>
    implements _$WorkItemDatesCopyWith<$Res> {
  __$WorkItemDatesCopyWithImpl(this._self, this._then);

  final _WorkItemDates _self;
  final $Res Function(_WorkItemDates) _then;

/// Create a copy of WorkItemDates
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startOn = null,Object? endOn = null,Object? plannedEndOn = freezed,Object? completedOn = freezed,Object? originalCompletedOn = freezed,Object? submittedOn = freezed,}) {
  return _then(_WorkItemDates(
startOn: null == startOn ? _self.startOn : startOn // ignore: cast_nullable_to_non_nullable
as DateTime,endOn: null == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as DateTime,plannedEndOn: freezed == plannedEndOn ? _self.plannedEndOn : plannedEndOn // ignore: cast_nullable_to_non_nullable
as DateTime?,completedOn: freezed == completedOn ? _self.completedOn : completedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,originalCompletedOn: freezed == originalCompletedOn ? _self.originalCompletedOn : originalCompletedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,submittedOn: freezed == submittedOn ? _self.submittedOn : submittedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
