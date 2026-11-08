// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'results.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Results {

@JsonKey(name: 'option_index') int get optionIndex; String get label; int get count; List<Voters> get voters;
/// Create a copy of Results
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResultsCopyWith<Results> get copyWith => _$ResultsCopyWithImpl<Results>(this as Results, _$identity);

  /// Serializes this Results to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Results;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Results&&(identical(other.optionIndex, _this.optionIndex) || other.optionIndex == _this.optionIndex)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.count, _this.count) || other.count == _this.count)&&const DeepCollectionEquality().equals(other.voters, _this.voters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Results;
  return Object.hash(runtimeType,_this.optionIndex,_this.label,_this.count,const DeepCollectionEquality().hash(_this.voters));
}

@override
String toString() {
  final _this = this as Results;
  return 'Results(optionIndex: ${_this.optionIndex}, label: ${_this.label}, count: ${_this.count}, voters: ${_this.voters})';
}


}

/// @nodoc
abstract mixin class $ResultsCopyWith<$Res>  {
  factory $ResultsCopyWith(Results value, $Res Function(Results) _then) = _$ResultsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'option_index') int optionIndex, String label, int count, List<Voters> voters
});




}
/// @nodoc
class _$ResultsCopyWithImpl<$Res>
    implements $ResultsCopyWith<$Res> {
  _$ResultsCopyWithImpl(this._self, this._then);

  final Results _self;
  final $Res Function(Results) _then;

/// Create a copy of Results
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? optionIndex = null,Object? label = null,Object? count = null,Object? voters = null,}) {
  return _then(Results(
optionIndex: null == optionIndex ? _self.optionIndex : optionIndex // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,voters: null == voters ? _self.voters : voters // ignore: cast_nullable_to_non_nullable
as List<Voters>,
  ));
}

}


/// Adds pattern-matching-related methods to [Results].
extension ResultsPatterns on Results {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Results value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Results() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Results value)  $default,){
final _that = this;
switch (_that) {
case _Results():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Results value)?  $default,){
final _that = this;
switch (_that) {
case _Results() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'option_index')  int optionIndex,  String label,  int count,  List<Voters> voters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Results() when $default != null:
return $default(_that.optionIndex,_that.label,_that.count,_that.voters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'option_index')  int optionIndex,  String label,  int count,  List<Voters> voters)  $default,) {final _that = this;
switch (_that) {
case _Results():
return $default(_that.optionIndex,_that.label,_that.count,_that.voters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'option_index')  int optionIndex,  String label,  int count,  List<Voters> voters)?  $default,) {final _that = this;
switch (_that) {
case _Results() when $default != null:
return $default(_that.optionIndex,_that.label,_that.count,_that.voters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Results implements Results {
  const _Results({@JsonKey(name: 'option_index') required this.optionIndex, required this.label, required this.count, required  List<Voters> voters}): _voters = voters;
  factory _Results.fromJson(Map<String, dynamic> json) => _$ResultsFromJson(json);

@override@JsonKey(name: 'option_index') final  int optionIndex;
@override final  String label;
@override final  int count;
 final  List<Voters> _voters;
@override List<Voters> get voters {
  if (_voters is EqualUnmodifiableListView) return _voters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_voters);
}


/// Create a copy of Results
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResultsCopyWith<_Results> get copyWith => __$ResultsCopyWithImpl<_Results>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResultsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Results&&(identical(other.optionIndex, optionIndex) || other.optionIndex == optionIndex)&&(identical(other.label, label) || other.label == label)&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other.voters, _voters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,optionIndex,label,count,const DeepCollectionEquality().hash(_voters));
}

@override
String toString() {
    return 'Results(optionIndex: $optionIndex, label: $label, count: $count, voters: $voters)';
}


}

/// @nodoc
abstract mixin class _$ResultsCopyWith<$Res> implements $ResultsCopyWith<$Res> {
  factory _$ResultsCopyWith(_Results value, $Res Function(_Results) _then) = __$ResultsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'option_index') int optionIndex, String label, int count, List<Voters> voters
});




}
/// @nodoc
class __$ResultsCopyWithImpl<$Res>
    implements _$ResultsCopyWith<$Res> {
  __$ResultsCopyWithImpl(this._self, this._then);

  final _Results _self;
  final $Res Function(_Results) _then;

/// Create a copy of Results
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? optionIndex = null,Object? label = null,Object? count = null,Object? voters = null,}) {
  return _then(_Results(
optionIndex: null == optionIndex ? _self.optionIndex : optionIndex // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,voters: null == voters ? _self._voters : voters // ignore: cast_nullable_to_non_nullable
as List<Voters>,
  ));
}


}

// dart format on
