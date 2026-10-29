// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipient_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecipientGroup {

 String get key; List<Recipient> get recipients;/// Grup tavanla kırpıldıysa `true`.
 bool get truncated;
/// Create a copy of RecipientGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipientGroupCopyWith<RecipientGroup> get copyWith => _$RecipientGroupCopyWithImpl<RecipientGroup>(this as RecipientGroup, _$identity);

  /// Serializes this RecipientGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RecipientGroup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipientGroup&&(identical(other.key, _this.key) || other.key == _this.key)&&const DeepCollectionEquality().equals(other.recipients, _this.recipients)&&(identical(other.truncated, _this.truncated) || other.truncated == _this.truncated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RecipientGroup;
  return Object.hash(runtimeType,_this.key,const DeepCollectionEquality().hash(_this.recipients),_this.truncated);
}

@override
String toString() {
  final _this = this as RecipientGroup;
  return 'RecipientGroup(key: ${_this.key}, recipients: ${_this.recipients}, truncated: ${_this.truncated})';
}


}

/// @nodoc
abstract mixin class $RecipientGroupCopyWith<$Res>  {
  factory $RecipientGroupCopyWith(RecipientGroup value, $Res Function(RecipientGroup) _then) = _$RecipientGroupCopyWithImpl;
@useResult
$Res call({
 String key, List<Recipient> recipients, bool truncated
});




}
/// @nodoc
class _$RecipientGroupCopyWithImpl<$Res>
    implements $RecipientGroupCopyWith<$Res> {
  _$RecipientGroupCopyWithImpl(this._self, this._then);

  final RecipientGroup _self;
  final $Res Function(RecipientGroup) _then;

/// Create a copy of RecipientGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? recipients = null,Object? truncated = null,}) {
  return _then(RecipientGroup(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,recipients: null == recipients ? _self.recipients : recipients // ignore: cast_nullable_to_non_nullable
as List<Recipient>,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RecipientGroup].
extension RecipientGroupPatterns on RecipientGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipientGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipientGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipientGroup value)  $default,){
final _that = this;
switch (_that) {
case _RecipientGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipientGroup value)?  $default,){
final _that = this;
switch (_that) {
case _RecipientGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  List<Recipient> recipients,  bool truncated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipientGroup() when $default != null:
return $default(_that.key,_that.recipients,_that.truncated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  List<Recipient> recipients,  bool truncated)  $default,) {final _that = this;
switch (_that) {
case _RecipientGroup():
return $default(_that.key,_that.recipients,_that.truncated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  List<Recipient> recipients,  bool truncated)?  $default,) {final _that = this;
switch (_that) {
case _RecipientGroup() when $default != null:
return $default(_that.key,_that.recipients,_that.truncated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecipientGroup implements RecipientGroup {
  const _RecipientGroup({required this.key, required  List<Recipient> recipients, required this.truncated}): _recipients = recipients;
  factory _RecipientGroup.fromJson(Map<String, dynamic> json) => _$RecipientGroupFromJson(json);

@override final  String key;
 final  List<Recipient> _recipients;
@override List<Recipient> get recipients {
  if (_recipients is EqualUnmodifiableListView) return _recipients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recipients);
}

/// Grup tavanla kırpıldıysa `true`.
@override final  bool truncated;

/// Create a copy of RecipientGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipientGroupCopyWith<_RecipientGroup> get copyWith => __$RecipientGroupCopyWithImpl<_RecipientGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipientGroupToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipientGroup&&(identical(other.key, key) || other.key == key)&&const DeepCollectionEquality().equals(other.recipients, _recipients)&&(identical(other.truncated, truncated) || other.truncated == truncated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,const DeepCollectionEquality().hash(_recipients),truncated);
}

@override
String toString() {
    return 'RecipientGroup(key: $key, recipients: $recipients, truncated: $truncated)';
}


}

/// @nodoc
abstract mixin class _$RecipientGroupCopyWith<$Res> implements $RecipientGroupCopyWith<$Res> {
  factory _$RecipientGroupCopyWith(_RecipientGroup value, $Res Function(_RecipientGroup) _then) = __$RecipientGroupCopyWithImpl;
@override @useResult
$Res call({
 String key, List<Recipient> recipients, bool truncated
});




}
/// @nodoc
class __$RecipientGroupCopyWithImpl<$Res>
    implements _$RecipientGroupCopyWith<$Res> {
  __$RecipientGroupCopyWithImpl(this._self, this._then);

  final _RecipientGroup _self;
  final $Res Function(_RecipientGroup) _then;

/// Create a copy of RecipientGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? recipients = null,Object? truncated = null,}) {
  return _then(_RecipientGroup(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,recipients: null == recipients ? _self._recipients : recipients // ignore: cast_nullable_to_non_nullable
as List<Recipient>,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
