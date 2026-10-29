// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant_event_view.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssistantEventView {

/// Katalogdaki görünüm adı; istemci rotaya çevirir ve veriyi normal API'den çeker.
 String get gorunum;/// Çözümlenmiş tipli süzgeç.
 dynamic get filtre;
/// Create a copy of AssistantEventView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssistantEventViewCopyWith<AssistantEventView> get copyWith => _$AssistantEventViewCopyWithImpl<AssistantEventView>(this as AssistantEventView, _$identity);

  /// Serializes this AssistantEventView to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AssistantEventView;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssistantEventView&&(identical(other.gorunum, _this.gorunum) || other.gorunum == _this.gorunum)&&const DeepCollectionEquality().equals(other.filtre, _this.filtre));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AssistantEventView;
  return Object.hash(runtimeType,_this.gorunum,const DeepCollectionEquality().hash(_this.filtre));
}

@override
String toString() {
  final _this = this as AssistantEventView;
  return 'AssistantEventView(gorunum: ${_this.gorunum}, filtre: ${_this.filtre})';
}


}

/// @nodoc
abstract mixin class $AssistantEventViewCopyWith<$Res>  {
  factory $AssistantEventViewCopyWith(AssistantEventView value, $Res Function(AssistantEventView) _then) = _$AssistantEventViewCopyWithImpl;
@useResult
$Res call({
 String gorunum, dynamic filtre
});




}
/// @nodoc
class _$AssistantEventViewCopyWithImpl<$Res>
    implements $AssistantEventViewCopyWith<$Res> {
  _$AssistantEventViewCopyWithImpl(this._self, this._then);

  final AssistantEventView _self;
  final $Res Function(AssistantEventView) _then;

/// Create a copy of AssistantEventView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gorunum = null,Object? filtre = freezed,}) {
  return _then(AssistantEventView(
gorunum: null == gorunum ? _self.gorunum : gorunum // ignore: cast_nullable_to_non_nullable
as String,filtre: freezed == filtre ? _self.filtre : filtre // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// Adds pattern-matching-related methods to [AssistantEventView].
extension AssistantEventViewPatterns on AssistantEventView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssistantEventView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssistantEventView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssistantEventView value)  $default,){
final _that = this;
switch (_that) {
case _AssistantEventView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssistantEventView value)?  $default,){
final _that = this;
switch (_that) {
case _AssistantEventView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String gorunum,  dynamic filtre)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssistantEventView() when $default != null:
return $default(_that.gorunum,_that.filtre);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String gorunum,  dynamic filtre)  $default,) {final _that = this;
switch (_that) {
case _AssistantEventView():
return $default(_that.gorunum,_that.filtre);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String gorunum,  dynamic filtre)?  $default,) {final _that = this;
switch (_that) {
case _AssistantEventView() when $default != null:
return $default(_that.gorunum,_that.filtre);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssistantEventView implements AssistantEventView {
  const _AssistantEventView({required this.gorunum, required this.filtre});
  factory _AssistantEventView.fromJson(Map<String, dynamic> json) => _$AssistantEventViewFromJson(json);

/// Katalogdaki görünüm adı; istemci rotaya çevirir ve veriyi normal API'den çeker.
@override final  String gorunum;
/// Çözümlenmiş tipli süzgeç.
@override final  dynamic filtre;

/// Create a copy of AssistantEventView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssistantEventViewCopyWith<_AssistantEventView> get copyWith => __$AssistantEventViewCopyWithImpl<_AssistantEventView>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssistantEventViewToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssistantEventView&&(identical(other.gorunum, gorunum) || other.gorunum == gorunum)&&const DeepCollectionEquality().equals(other.filtre, filtre));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,gorunum,const DeepCollectionEquality().hash(filtre));
}

@override
String toString() {
    return 'AssistantEventView(gorunum: $gorunum, filtre: $filtre)';
}


}

/// @nodoc
abstract mixin class _$AssistantEventViewCopyWith<$Res> implements $AssistantEventViewCopyWith<$Res> {
  factory _$AssistantEventViewCopyWith(_AssistantEventView value, $Res Function(_AssistantEventView) _then) = __$AssistantEventViewCopyWithImpl;
@override @useResult
$Res call({
 String gorunum, dynamic filtre
});




}
/// @nodoc
class __$AssistantEventViewCopyWithImpl<$Res>
    implements _$AssistantEventViewCopyWith<$Res> {
  __$AssistantEventViewCopyWithImpl(this._self, this._then);

  final _AssistantEventView _self;
  final $Res Function(_AssistantEventView) _then;

/// Create a copy of AssistantEventView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gorunum = null,Object? filtre = freezed,}) {
  return _then(_AssistantEventView(
gorunum: null == gorunum ? _self.gorunum : gorunum // ignore: cast_nullable_to_non_nullable
as String,filtre: freezed == filtre ? _self.filtre : filtre // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

// dart format on
