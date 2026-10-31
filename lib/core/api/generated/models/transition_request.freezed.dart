// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transition_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransitionRequest {

/// Hedef durum.
 TransitionRequestTo get to;/// Geri alma geçişlerinde zorunlu gerekçe.
 String? get reason;@JsonKey(name: 'pull_end_date') bool? get pullEndDate;/// Yalnız `tamamlandi` hedefinde: açık alt görevleri aynı işlemde kapatır (ADR-0024); başka hedefte 422 `work.input_invalid`. Verilmezse açık alt görev 409 `work.subtasks_open` üretir.
@JsonKey(name: 'close_subtasks') bool? get closeSubtasks;
/// Create a copy of TransitionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransitionRequestCopyWith<TransitionRequest> get copyWith => _$TransitionRequestCopyWithImpl<TransitionRequest>(this as TransitionRequest, _$identity);

  /// Serializes this TransitionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransitionRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransitionRequest&&(identical(other.to, _this.to) || other.to == _this.to)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.pullEndDate, _this.pullEndDate) || other.pullEndDate == _this.pullEndDate)&&(identical(other.closeSubtasks, _this.closeSubtasks) || other.closeSubtasks == _this.closeSubtasks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransitionRequest;
  return Object.hash(runtimeType,_this.to,_this.reason,_this.pullEndDate,_this.closeSubtasks);
}

@override
String toString() {
  final _this = this as TransitionRequest;
  return 'TransitionRequest(to: ${_this.to}, reason: ${_this.reason}, pullEndDate: ${_this.pullEndDate}, closeSubtasks: ${_this.closeSubtasks})';
}


}

/// @nodoc
abstract mixin class $TransitionRequestCopyWith<$Res>  {
  factory $TransitionRequestCopyWith(TransitionRequest value, $Res Function(TransitionRequest) _then) = _$TransitionRequestCopyWithImpl;
@useResult
$Res call({
 TransitionRequestTo to, String? reason,@JsonKey(name: 'pull_end_date') bool? pullEndDate,@JsonKey(name: 'close_subtasks') bool? closeSubtasks
});




}
/// @nodoc
class _$TransitionRequestCopyWithImpl<$Res>
    implements $TransitionRequestCopyWith<$Res> {
  _$TransitionRequestCopyWithImpl(this._self, this._then);

  final TransitionRequest _self;
  final $Res Function(TransitionRequest) _then;

/// Create a copy of TransitionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? to = null,Object? reason = freezed,Object? pullEndDate = freezed,Object? closeSubtasks = freezed,}) {
  return _then(TransitionRequest(
to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as TransitionRequestTo,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,pullEndDate: freezed == pullEndDate ? _self.pullEndDate : pullEndDate // ignore: cast_nullable_to_non_nullable
as bool?,closeSubtasks: freezed == closeSubtasks ? _self.closeSubtasks : closeSubtasks // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransitionRequest].
extension TransitionRequestPatterns on TransitionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransitionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransitionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransitionRequest value)  $default,){
final _that = this;
switch (_that) {
case _TransitionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransitionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TransitionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TransitionRequestTo to,  String? reason, @JsonKey(name: 'pull_end_date')  bool? pullEndDate, @JsonKey(name: 'close_subtasks')  bool? closeSubtasks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransitionRequest() when $default != null:
return $default(_that.to,_that.reason,_that.pullEndDate,_that.closeSubtasks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TransitionRequestTo to,  String? reason, @JsonKey(name: 'pull_end_date')  bool? pullEndDate, @JsonKey(name: 'close_subtasks')  bool? closeSubtasks)  $default,) {final _that = this;
switch (_that) {
case _TransitionRequest():
return $default(_that.to,_that.reason,_that.pullEndDate,_that.closeSubtasks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TransitionRequestTo to,  String? reason, @JsonKey(name: 'pull_end_date')  bool? pullEndDate, @JsonKey(name: 'close_subtasks')  bool? closeSubtasks)?  $default,) {final _that = this;
switch (_that) {
case _TransitionRequest() when $default != null:
return $default(_that.to,_that.reason,_that.pullEndDate,_that.closeSubtasks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransitionRequest implements TransitionRequest {
  const _TransitionRequest({required this.to, this.reason, @JsonKey(name: 'pull_end_date') this.pullEndDate, @JsonKey(name: 'close_subtasks') this.closeSubtasks});
  factory _TransitionRequest.fromJson(Map<String, dynamic> json) => _$TransitionRequestFromJson(json);

/// Hedef durum.
@override final  TransitionRequestTo to;
/// Geri alma geçişlerinde zorunlu gerekçe.
@override final  String? reason;
@override@JsonKey(name: 'pull_end_date') final  bool? pullEndDate;
/// Yalnız `tamamlandi` hedefinde: açık alt görevleri aynı işlemde kapatır (ADR-0024); başka hedefte 422 `work.input_invalid`. Verilmezse açık alt görev 409 `work.subtasks_open` üretir.
@override@JsonKey(name: 'close_subtasks') final  bool? closeSubtasks;

/// Create a copy of TransitionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransitionRequestCopyWith<_TransitionRequest> get copyWith => __$TransitionRequestCopyWithImpl<_TransitionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransitionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransitionRequest&&(identical(other.to, to) || other.to == to)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.pullEndDate, pullEndDate) || other.pullEndDate == pullEndDate)&&(identical(other.closeSubtasks, closeSubtasks) || other.closeSubtasks == closeSubtasks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,to,reason,pullEndDate,closeSubtasks);
}

@override
String toString() {
    return 'TransitionRequest(to: $to, reason: $reason, pullEndDate: $pullEndDate, closeSubtasks: $closeSubtasks)';
}


}

/// @nodoc
abstract mixin class _$TransitionRequestCopyWith<$Res> implements $TransitionRequestCopyWith<$Res> {
  factory _$TransitionRequestCopyWith(_TransitionRequest value, $Res Function(_TransitionRequest) _then) = __$TransitionRequestCopyWithImpl;
@override @useResult
$Res call({
 TransitionRequestTo to, String? reason,@JsonKey(name: 'pull_end_date') bool? pullEndDate,@JsonKey(name: 'close_subtasks') bool? closeSubtasks
});




}
/// @nodoc
class __$TransitionRequestCopyWithImpl<$Res>
    implements _$TransitionRequestCopyWith<$Res> {
  __$TransitionRequestCopyWithImpl(this._self, this._then);

  final _TransitionRequest _self;
  final $Res Function(_TransitionRequest) _then;

/// Create a copy of TransitionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? to = null,Object? reason = freezed,Object? pullEndDate = freezed,Object? closeSubtasks = freezed,}) {
  return _then(_TransitionRequest(
to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as TransitionRequestTo,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,pullEndDate: freezed == pullEndDate ? _self.pullEndDate : pullEndDate // ignore: cast_nullable_to_non_nullable
as bool?,closeSubtasks: freezed == closeSubtasks ? _self.closeSubtasks : closeSubtasks // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
