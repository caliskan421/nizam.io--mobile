// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transition_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransitionResult {

@JsonKey(name: 'work_item_id') String get workItemId; String get from; String get to; TransitionResultActor get actor;@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime? get endOn;
/// Create a copy of TransitionResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransitionResultCopyWith<TransitionResult> get copyWith => _$TransitionResultCopyWithImpl<TransitionResult>(this as TransitionResult, _$identity);

  /// Serializes this TransitionResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransitionResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransitionResult&&(identical(other.workItemId, _this.workItemId) || other.workItemId == _this.workItemId)&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.to, _this.to) || other.to == _this.to)&&(identical(other.actor, _this.actor) || other.actor == _this.actor)&&(identical(other.endOn, _this.endOn) || other.endOn == _this.endOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransitionResult;
  return Object.hash(runtimeType,_this.workItemId,_this.from,_this.to,_this.actor,_this.endOn);
}

@override
String toString() {
  final _this = this as TransitionResult;
  return 'TransitionResult(workItemId: ${_this.workItemId}, from: ${_this.from}, to: ${_this.to}, actor: ${_this.actor}, endOn: ${_this.endOn})';
}


}

/// @nodoc
abstract mixin class $TransitionResultCopyWith<$Res>  {
  factory $TransitionResultCopyWith(TransitionResult value, $Res Function(TransitionResult) _then) = _$TransitionResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, String from, String to, TransitionResultActor actor,@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime? endOn
});




}
/// @nodoc
class _$TransitionResultCopyWithImpl<$Res>
    implements $TransitionResultCopyWith<$Res> {
  _$TransitionResultCopyWithImpl(this._self, this._then);

  final TransitionResult _self;
  final $Res Function(TransitionResult) _then;

/// Create a copy of TransitionResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workItemId = null,Object? from = null,Object? to = null,Object? actor = null,Object? endOn = freezed,}) {
  return _then(TransitionResult(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,actor: null == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as TransitionResultActor,endOn: freezed == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransitionResult].
extension TransitionResultPatterns on TransitionResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransitionResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransitionResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransitionResult value)  $default,){
final _that = this;
switch (_that) {
case _TransitionResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransitionResult value)?  $default,){
final _that = this;
switch (_that) {
case _TransitionResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  String from,  String to,  TransitionResultActor actor, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime? endOn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransitionResult() when $default != null:
return $default(_that.workItemId,_that.from,_that.to,_that.actor,_that.endOn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'work_item_id')  String workItemId,  String from,  String to,  TransitionResultActor actor, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime? endOn)  $default,) {final _that = this;
switch (_that) {
case _TransitionResult():
return $default(_that.workItemId,_that.from,_that.to,_that.actor,_that.endOn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'work_item_id')  String workItemId,  String from,  String to,  TransitionResultActor actor, @DateOnlyConverter()@JsonKey(name: 'end_on')  DateTime? endOn)?  $default,) {final _that = this;
switch (_that) {
case _TransitionResult() when $default != null:
return $default(_that.workItemId,_that.from,_that.to,_that.actor,_that.endOn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransitionResult implements TransitionResult {
  const _TransitionResult({@JsonKey(name: 'work_item_id') required this.workItemId, required this.from, required this.to, required this.actor, @DateOnlyConverter()@JsonKey(name: 'end_on') this.endOn});
  factory _TransitionResult.fromJson(Map<String, dynamic> json) => _$TransitionResultFromJson(json);

@override@JsonKey(name: 'work_item_id') final  String workItemId;
@override final  String from;
@override final  String to;
@override final  TransitionResultActor actor;
@override@DateOnlyConverter()@JsonKey(name: 'end_on') final  DateTime? endOn;

/// Create a copy of TransitionResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransitionResultCopyWith<_TransitionResult> get copyWith => __$TransitionResultCopyWithImpl<_TransitionResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransitionResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransitionResult&&(identical(other.workItemId, workItemId) || other.workItemId == workItemId)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.actor, actor) || other.actor == actor)&&(identical(other.endOn, endOn) || other.endOn == endOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,workItemId,from,to,actor,endOn);
}

@override
String toString() {
    return 'TransitionResult(workItemId: $workItemId, from: $from, to: $to, actor: $actor, endOn: $endOn)';
}


}

/// @nodoc
abstract mixin class _$TransitionResultCopyWith<$Res> implements $TransitionResultCopyWith<$Res> {
  factory _$TransitionResultCopyWith(_TransitionResult value, $Res Function(_TransitionResult) _then) = __$TransitionResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'work_item_id') String workItemId, String from, String to, TransitionResultActor actor,@DateOnlyConverter()@JsonKey(name: 'end_on') DateTime? endOn
});




}
/// @nodoc
class __$TransitionResultCopyWithImpl<$Res>
    implements _$TransitionResultCopyWith<$Res> {
  __$TransitionResultCopyWithImpl(this._self, this._then);

  final _TransitionResult _self;
  final $Res Function(_TransitionResult) _then;

/// Create a copy of TransitionResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workItemId = null,Object? from = null,Object? to = null,Object? actor = null,Object? endOn = freezed,}) {
  return _then(_TransitionResult(
workItemId: null == workItemId ? _self.workItemId : workItemId // ignore: cast_nullable_to_non_nullable
as String,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,actor: null == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as TransitionResultActor,endOn: freezed == endOn ? _self.endOn : endOn // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
