// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_proposal_decision_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableProposalDecisionRequest {

 TableProposalDecisionRequestDecision get decision;
/// Create a copy of TableProposalDecisionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableProposalDecisionRequestCopyWith<TableProposalDecisionRequest> get copyWith => _$TableProposalDecisionRequestCopyWithImpl<TableProposalDecisionRequest>(this as TableProposalDecisionRequest, _$identity);

  /// Serializes this TableProposalDecisionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableProposalDecisionRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableProposalDecisionRequest&&(identical(other.decision, _this.decision) || other.decision == _this.decision));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableProposalDecisionRequest;
  return Object.hash(runtimeType,_this.decision);
}

@override
String toString() {
  final _this = this as TableProposalDecisionRequest;
  return 'TableProposalDecisionRequest(decision: ${_this.decision})';
}


}

/// @nodoc
abstract mixin class $TableProposalDecisionRequestCopyWith<$Res>  {
  factory $TableProposalDecisionRequestCopyWith(TableProposalDecisionRequest value, $Res Function(TableProposalDecisionRequest) _then) = _$TableProposalDecisionRequestCopyWithImpl;
@useResult
$Res call({
 TableProposalDecisionRequestDecision decision
});




}
/// @nodoc
class _$TableProposalDecisionRequestCopyWithImpl<$Res>
    implements $TableProposalDecisionRequestCopyWith<$Res> {
  _$TableProposalDecisionRequestCopyWithImpl(this._self, this._then);

  final TableProposalDecisionRequest _self;
  final $Res Function(TableProposalDecisionRequest) _then;

/// Create a copy of TableProposalDecisionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? decision = null,}) {
  return _then(TableProposalDecisionRequest(
decision: null == decision ? _self.decision : decision // ignore: cast_nullable_to_non_nullable
as TableProposalDecisionRequestDecision,
  ));
}

}


/// Adds pattern-matching-related methods to [TableProposalDecisionRequest].
extension TableProposalDecisionRequestPatterns on TableProposalDecisionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableProposalDecisionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableProposalDecisionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableProposalDecisionRequest value)  $default,){
final _that = this;
switch (_that) {
case _TableProposalDecisionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableProposalDecisionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TableProposalDecisionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableProposalDecisionRequestDecision decision)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableProposalDecisionRequest() when $default != null:
return $default(_that.decision);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableProposalDecisionRequestDecision decision)  $default,) {final _that = this;
switch (_that) {
case _TableProposalDecisionRequest():
return $default(_that.decision);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableProposalDecisionRequestDecision decision)?  $default,) {final _that = this;
switch (_that) {
case _TableProposalDecisionRequest() when $default != null:
return $default(_that.decision);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableProposalDecisionRequest implements TableProposalDecisionRequest {
  const _TableProposalDecisionRequest({required this.decision});
  factory _TableProposalDecisionRequest.fromJson(Map<String, dynamic> json) => _$TableProposalDecisionRequestFromJson(json);

@override final  TableProposalDecisionRequestDecision decision;

/// Create a copy of TableProposalDecisionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableProposalDecisionRequestCopyWith<_TableProposalDecisionRequest> get copyWith => __$TableProposalDecisionRequestCopyWithImpl<_TableProposalDecisionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableProposalDecisionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableProposalDecisionRequest&&(identical(other.decision, decision) || other.decision == decision));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,decision);
}

@override
String toString() {
    return 'TableProposalDecisionRequest(decision: $decision)';
}


}

/// @nodoc
abstract mixin class _$TableProposalDecisionRequestCopyWith<$Res> implements $TableProposalDecisionRequestCopyWith<$Res> {
  factory _$TableProposalDecisionRequestCopyWith(_TableProposalDecisionRequest value, $Res Function(_TableProposalDecisionRequest) _then) = __$TableProposalDecisionRequestCopyWithImpl;
@override @useResult
$Res call({
 TableProposalDecisionRequestDecision decision
});




}
/// @nodoc
class __$TableProposalDecisionRequestCopyWithImpl<$Res>
    implements _$TableProposalDecisionRequestCopyWith<$Res> {
  __$TableProposalDecisionRequestCopyWithImpl(this._self, this._then);

  final _TableProposalDecisionRequest _self;
  final $Res Function(_TableProposalDecisionRequest) _then;

/// Create a copy of TableProposalDecisionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? decision = null,}) {
  return _then(_TableProposalDecisionRequest(
decision: null == decision ? _self.decision : decision // ignore: cast_nullable_to_non_nullable
as TableProposalDecisionRequestDecision,
  ));
}


}

// dart format on
