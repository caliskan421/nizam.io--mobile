// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'by_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ByStatus {

 int get baslanmadi;@JsonKey(name: 'devam_ediyor') int get devamEdiyor;@JsonKey(name: 'onaya_sunuldu') int get onayaSunuldu;@JsonKey(name: 'iade_edildi') int get iadeEdildi; int get tamamlandi;
/// Create a copy of ByStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ByStatusCopyWith<ByStatus> get copyWith => _$ByStatusCopyWithImpl<ByStatus>(this as ByStatus, _$identity);

  /// Serializes this ByStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ByStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ByStatus&&(identical(other.baslanmadi, _this.baslanmadi) || other.baslanmadi == _this.baslanmadi)&&(identical(other.devamEdiyor, _this.devamEdiyor) || other.devamEdiyor == _this.devamEdiyor)&&(identical(other.onayaSunuldu, _this.onayaSunuldu) || other.onayaSunuldu == _this.onayaSunuldu)&&(identical(other.iadeEdildi, _this.iadeEdildi) || other.iadeEdildi == _this.iadeEdildi)&&(identical(other.tamamlandi, _this.tamamlandi) || other.tamamlandi == _this.tamamlandi));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ByStatus;
  return Object.hash(runtimeType,_this.baslanmadi,_this.devamEdiyor,_this.onayaSunuldu,_this.iadeEdildi,_this.tamamlandi);
}

@override
String toString() {
  final _this = this as ByStatus;
  return 'ByStatus(baslanmadi: ${_this.baslanmadi}, devamEdiyor: ${_this.devamEdiyor}, onayaSunuldu: ${_this.onayaSunuldu}, iadeEdildi: ${_this.iadeEdildi}, tamamlandi: ${_this.tamamlandi})';
}


}

/// @nodoc
abstract mixin class $ByStatusCopyWith<$Res>  {
  factory $ByStatusCopyWith(ByStatus value, $Res Function(ByStatus) _then) = _$ByStatusCopyWithImpl;
@useResult
$Res call({
 int baslanmadi,@JsonKey(name: 'devam_ediyor') int devamEdiyor,@JsonKey(name: 'onaya_sunuldu') int onayaSunuldu,@JsonKey(name: 'iade_edildi') int iadeEdildi, int tamamlandi
});




}
/// @nodoc
class _$ByStatusCopyWithImpl<$Res>
    implements $ByStatusCopyWith<$Res> {
  _$ByStatusCopyWithImpl(this._self, this._then);

  final ByStatus _self;
  final $Res Function(ByStatus) _then;

/// Create a copy of ByStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? baslanmadi = null,Object? devamEdiyor = null,Object? onayaSunuldu = null,Object? iadeEdildi = null,Object? tamamlandi = null,}) {
  return _then(ByStatus(
baslanmadi: null == baslanmadi ? _self.baslanmadi : baslanmadi // ignore: cast_nullable_to_non_nullable
as int,devamEdiyor: null == devamEdiyor ? _self.devamEdiyor : devamEdiyor // ignore: cast_nullable_to_non_nullable
as int,onayaSunuldu: null == onayaSunuldu ? _self.onayaSunuldu : onayaSunuldu // ignore: cast_nullable_to_non_nullable
as int,iadeEdildi: null == iadeEdildi ? _self.iadeEdildi : iadeEdildi // ignore: cast_nullable_to_non_nullable
as int,tamamlandi: null == tamamlandi ? _self.tamamlandi : tamamlandi // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ByStatus].
extension ByStatusPatterns on ByStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ByStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ByStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ByStatus value)  $default,){
final _that = this;
switch (_that) {
case _ByStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ByStatus value)?  $default,){
final _that = this;
switch (_that) {
case _ByStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int baslanmadi, @JsonKey(name: 'devam_ediyor')  int devamEdiyor, @JsonKey(name: 'onaya_sunuldu')  int onayaSunuldu, @JsonKey(name: 'iade_edildi')  int iadeEdildi,  int tamamlandi)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ByStatus() when $default != null:
return $default(_that.baslanmadi,_that.devamEdiyor,_that.onayaSunuldu,_that.iadeEdildi,_that.tamamlandi);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int baslanmadi, @JsonKey(name: 'devam_ediyor')  int devamEdiyor, @JsonKey(name: 'onaya_sunuldu')  int onayaSunuldu, @JsonKey(name: 'iade_edildi')  int iadeEdildi,  int tamamlandi)  $default,) {final _that = this;
switch (_that) {
case _ByStatus():
return $default(_that.baslanmadi,_that.devamEdiyor,_that.onayaSunuldu,_that.iadeEdildi,_that.tamamlandi);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int baslanmadi, @JsonKey(name: 'devam_ediyor')  int devamEdiyor, @JsonKey(name: 'onaya_sunuldu')  int onayaSunuldu, @JsonKey(name: 'iade_edildi')  int iadeEdildi,  int tamamlandi)?  $default,) {final _that = this;
switch (_that) {
case _ByStatus() when $default != null:
return $default(_that.baslanmadi,_that.devamEdiyor,_that.onayaSunuldu,_that.iadeEdildi,_that.tamamlandi);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ByStatus implements ByStatus {
  const _ByStatus({required this.baslanmadi, @JsonKey(name: 'devam_ediyor') required this.devamEdiyor, @JsonKey(name: 'onaya_sunuldu') required this.onayaSunuldu, @JsonKey(name: 'iade_edildi') required this.iadeEdildi, required this.tamamlandi});
  factory _ByStatus.fromJson(Map<String, dynamic> json) => _$ByStatusFromJson(json);

@override final  int baslanmadi;
@override@JsonKey(name: 'devam_ediyor') final  int devamEdiyor;
@override@JsonKey(name: 'onaya_sunuldu') final  int onayaSunuldu;
@override@JsonKey(name: 'iade_edildi') final  int iadeEdildi;
@override final  int tamamlandi;

/// Create a copy of ByStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ByStatusCopyWith<_ByStatus> get copyWith => __$ByStatusCopyWithImpl<_ByStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ByStatusToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ByStatus&&(identical(other.baslanmadi, baslanmadi) || other.baslanmadi == baslanmadi)&&(identical(other.devamEdiyor, devamEdiyor) || other.devamEdiyor == devamEdiyor)&&(identical(other.onayaSunuldu, onayaSunuldu) || other.onayaSunuldu == onayaSunuldu)&&(identical(other.iadeEdildi, iadeEdildi) || other.iadeEdildi == iadeEdildi)&&(identical(other.tamamlandi, tamamlandi) || other.tamamlandi == tamamlandi));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,baslanmadi,devamEdiyor,onayaSunuldu,iadeEdildi,tamamlandi);
}

@override
String toString() {
    return 'ByStatus(baslanmadi: $baslanmadi, devamEdiyor: $devamEdiyor, onayaSunuldu: $onayaSunuldu, iadeEdildi: $iadeEdildi, tamamlandi: $tamamlandi)';
}


}

/// @nodoc
abstract mixin class _$ByStatusCopyWith<$Res> implements $ByStatusCopyWith<$Res> {
  factory _$ByStatusCopyWith(_ByStatus value, $Res Function(_ByStatus) _then) = __$ByStatusCopyWithImpl;
@override @useResult
$Res call({
 int baslanmadi,@JsonKey(name: 'devam_ediyor') int devamEdiyor,@JsonKey(name: 'onaya_sunuldu') int onayaSunuldu,@JsonKey(name: 'iade_edildi') int iadeEdildi, int tamamlandi
});




}
/// @nodoc
class __$ByStatusCopyWithImpl<$Res>
    implements _$ByStatusCopyWith<$Res> {
  __$ByStatusCopyWithImpl(this._self, this._then);

  final _ByStatus _self;
  final $Res Function(_ByStatus) _then;

/// Create a copy of ByStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? baslanmadi = null,Object? devamEdiyor = null,Object? onayaSunuldu = null,Object? iadeEdildi = null,Object? tamamlandi = null,}) {
  return _then(_ByStatus(
baslanmadi: null == baslanmadi ? _self.baslanmadi : baslanmadi // ignore: cast_nullable_to_non_nullable
as int,devamEdiyor: null == devamEdiyor ? _self.devamEdiyor : devamEdiyor // ignore: cast_nullable_to_non_nullable
as int,onayaSunuldu: null == onayaSunuldu ? _self.onayaSunuldu : onayaSunuldu // ignore: cast_nullable_to_non_nullable
as int,iadeEdildi: null == iadeEdildi ? _self.iadeEdildi : iadeEdildi // ignore: cast_nullable_to_non_nullable
as int,tamamlandi: null == tamamlandi ? _self.tamamlandi : tamamlandi // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
