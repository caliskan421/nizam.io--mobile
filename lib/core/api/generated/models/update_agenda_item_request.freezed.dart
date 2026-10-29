// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_agenda_item_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateAgendaItemRequest {

 String? get title;@JsonKey(name: 'is_checked') bool? get isChecked;
/// Create a copy of UpdateAgendaItemRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateAgendaItemRequestCopyWith<UpdateAgendaItemRequest> get copyWith => _$UpdateAgendaItemRequestCopyWithImpl<UpdateAgendaItemRequest>(this as UpdateAgendaItemRequest, _$identity);

  /// Serializes this UpdateAgendaItemRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateAgendaItemRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateAgendaItemRequest&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.isChecked, _this.isChecked) || other.isChecked == _this.isChecked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateAgendaItemRequest;
  return Object.hash(runtimeType,_this.title,_this.isChecked);
}

@override
String toString() {
  final _this = this as UpdateAgendaItemRequest;
  return 'UpdateAgendaItemRequest(title: ${_this.title}, isChecked: ${_this.isChecked})';
}


}

/// @nodoc
abstract mixin class $UpdateAgendaItemRequestCopyWith<$Res>  {
  factory $UpdateAgendaItemRequestCopyWith(UpdateAgendaItemRequest value, $Res Function(UpdateAgendaItemRequest) _then) = _$UpdateAgendaItemRequestCopyWithImpl;
@useResult
$Res call({
 String? title,@JsonKey(name: 'is_checked') bool? isChecked
});




}
/// @nodoc
class _$UpdateAgendaItemRequestCopyWithImpl<$Res>
    implements $UpdateAgendaItemRequestCopyWith<$Res> {
  _$UpdateAgendaItemRequestCopyWithImpl(this._self, this._then);

  final UpdateAgendaItemRequest _self;
  final $Res Function(UpdateAgendaItemRequest) _then;

/// Create a copy of UpdateAgendaItemRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? isChecked = freezed,}) {
  return _then(UpdateAgendaItemRequest(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,isChecked: freezed == isChecked ? _self.isChecked : isChecked // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateAgendaItemRequest].
extension UpdateAgendaItemRequestPatterns on UpdateAgendaItemRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateAgendaItemRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateAgendaItemRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateAgendaItemRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateAgendaItemRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateAgendaItemRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateAgendaItemRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title, @JsonKey(name: 'is_checked')  bool? isChecked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateAgendaItemRequest() when $default != null:
return $default(_that.title,_that.isChecked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title, @JsonKey(name: 'is_checked')  bool? isChecked)  $default,) {final _that = this;
switch (_that) {
case _UpdateAgendaItemRequest():
return $default(_that.title,_that.isChecked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title, @JsonKey(name: 'is_checked')  bool? isChecked)?  $default,) {final _that = this;
switch (_that) {
case _UpdateAgendaItemRequest() when $default != null:
return $default(_that.title,_that.isChecked);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateAgendaItemRequest implements UpdateAgendaItemRequest {
  const _UpdateAgendaItemRequest({this.title, @JsonKey(name: 'is_checked') this.isChecked});
  factory _UpdateAgendaItemRequest.fromJson(Map<String, dynamic> json) => _$UpdateAgendaItemRequestFromJson(json);

@override final  String? title;
@override@JsonKey(name: 'is_checked') final  bool? isChecked;

/// Create a copy of UpdateAgendaItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateAgendaItemRequestCopyWith<_UpdateAgendaItemRequest> get copyWith => __$UpdateAgendaItemRequestCopyWithImpl<_UpdateAgendaItemRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateAgendaItemRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateAgendaItemRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.isChecked, isChecked) || other.isChecked == isChecked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,isChecked);
}

@override
String toString() {
    return 'UpdateAgendaItemRequest(title: $title, isChecked: $isChecked)';
}


}

/// @nodoc
abstract mixin class _$UpdateAgendaItemRequestCopyWith<$Res> implements $UpdateAgendaItemRequestCopyWith<$Res> {
  factory _$UpdateAgendaItemRequestCopyWith(_UpdateAgendaItemRequest value, $Res Function(_UpdateAgendaItemRequest) _then) = __$UpdateAgendaItemRequestCopyWithImpl;
@override @useResult
$Res call({
 String? title,@JsonKey(name: 'is_checked') bool? isChecked
});




}
/// @nodoc
class __$UpdateAgendaItemRequestCopyWithImpl<$Res>
    implements _$UpdateAgendaItemRequestCopyWith<$Res> {
  __$UpdateAgendaItemRequestCopyWithImpl(this._self, this._then);

  final _UpdateAgendaItemRequest _self;
  final $Res Function(_UpdateAgendaItemRequest) _then;

/// Create a copy of UpdateAgendaItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? isChecked = freezed,}) {
  return _then(_UpdateAgendaItemRequest(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,isChecked: freezed == isChecked ? _self.isChecked : isChecked // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
