// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'instance_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InstanceProfile {

@JsonKey(name: 'display_name') String get displayName;@JsonKey(name: 'brand_color') String get brandColor;/// IANA saat dilimi adı.
 String get timezone;@JsonKey(name: 'api_version') String get apiVersion;/// `0.0.0` = asgari yok. Karşılaştırmayı istemci yapar.
@JsonKey(name: 'minimum_mobile_version') String get minimumMobileVersion;
/// Create a copy of InstanceProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstanceProfileCopyWith<InstanceProfile> get copyWith => _$InstanceProfileCopyWithImpl<InstanceProfile>(this as InstanceProfile, _$identity);

  /// Serializes this InstanceProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InstanceProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstanceProfile&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.brandColor, _this.brandColor) || other.brandColor == _this.brandColor)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&(identical(other.apiVersion, _this.apiVersion) || other.apiVersion == _this.apiVersion)&&(identical(other.minimumMobileVersion, _this.minimumMobileVersion) || other.minimumMobileVersion == _this.minimumMobileVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InstanceProfile;
  return Object.hash(runtimeType,_this.displayName,_this.brandColor,_this.timezone,_this.apiVersion,_this.minimumMobileVersion);
}

@override
String toString() {
  final _this = this as InstanceProfile;
  return 'InstanceProfile(displayName: ${_this.displayName}, brandColor: ${_this.brandColor}, timezone: ${_this.timezone}, apiVersion: ${_this.apiVersion}, minimumMobileVersion: ${_this.minimumMobileVersion})';
}


}

/// @nodoc
abstract mixin class $InstanceProfileCopyWith<$Res>  {
  factory $InstanceProfileCopyWith(InstanceProfile value, $Res Function(InstanceProfile) _then) = _$InstanceProfileCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'brand_color') String brandColor, String timezone,@JsonKey(name: 'api_version') String apiVersion,@JsonKey(name: 'minimum_mobile_version') String minimumMobileVersion
});




}
/// @nodoc
class _$InstanceProfileCopyWithImpl<$Res>
    implements $InstanceProfileCopyWith<$Res> {
  _$InstanceProfileCopyWithImpl(this._self, this._then);

  final InstanceProfile _self;
  final $Res Function(InstanceProfile) _then;

/// Create a copy of InstanceProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = null,Object? brandColor = null,Object? timezone = null,Object? apiVersion = null,Object? minimumMobileVersion = null,}) {
  return _then(InstanceProfile(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,brandColor: null == brandColor ? _self.brandColor : brandColor // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,apiVersion: null == apiVersion ? _self.apiVersion : apiVersion // ignore: cast_nullable_to_non_nullable
as String,minimumMobileVersion: null == minimumMobileVersion ? _self.minimumMobileVersion : minimumMobileVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InstanceProfile].
extension InstanceProfilePatterns on InstanceProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstanceProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstanceProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstanceProfile value)  $default,){
final _that = this;
switch (_that) {
case _InstanceProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstanceProfile value)?  $default,){
final _that = this;
switch (_that) {
case _InstanceProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'brand_color')  String brandColor,  String timezone, @JsonKey(name: 'api_version')  String apiVersion, @JsonKey(name: 'minimum_mobile_version')  String minimumMobileVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstanceProfile() when $default != null:
return $default(_that.displayName,_that.brandColor,_that.timezone,_that.apiVersion,_that.minimumMobileVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'brand_color')  String brandColor,  String timezone, @JsonKey(name: 'api_version')  String apiVersion, @JsonKey(name: 'minimum_mobile_version')  String minimumMobileVersion)  $default,) {final _that = this;
switch (_that) {
case _InstanceProfile():
return $default(_that.displayName,_that.brandColor,_that.timezone,_that.apiVersion,_that.minimumMobileVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'brand_color')  String brandColor,  String timezone, @JsonKey(name: 'api_version')  String apiVersion, @JsonKey(name: 'minimum_mobile_version')  String minimumMobileVersion)?  $default,) {final _that = this;
switch (_that) {
case _InstanceProfile() when $default != null:
return $default(_that.displayName,_that.brandColor,_that.timezone,_that.apiVersion,_that.minimumMobileVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InstanceProfile implements InstanceProfile {
  const _InstanceProfile({@JsonKey(name: 'display_name') required this.displayName, @JsonKey(name: 'brand_color') required this.brandColor, required this.timezone, @JsonKey(name: 'api_version') required this.apiVersion, @JsonKey(name: 'minimum_mobile_version') required this.minimumMobileVersion});
  factory _InstanceProfile.fromJson(Map<String, dynamic> json) => _$InstanceProfileFromJson(json);

@override@JsonKey(name: 'display_name') final  String displayName;
@override@JsonKey(name: 'brand_color') final  String brandColor;
/// IANA saat dilimi adı.
@override final  String timezone;
@override@JsonKey(name: 'api_version') final  String apiVersion;
/// `0.0.0` = asgari yok. Karşılaştırmayı istemci yapar.
@override@JsonKey(name: 'minimum_mobile_version') final  String minimumMobileVersion;

/// Create a copy of InstanceProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstanceProfileCopyWith<_InstanceProfile> get copyWith => __$InstanceProfileCopyWithImpl<_InstanceProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InstanceProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstanceProfile&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.brandColor, brandColor) || other.brandColor == brandColor)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.apiVersion, apiVersion) || other.apiVersion == apiVersion)&&(identical(other.minimumMobileVersion, minimumMobileVersion) || other.minimumMobileVersion == minimumMobileVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,displayName,brandColor,timezone,apiVersion,minimumMobileVersion);
}

@override
String toString() {
    return 'InstanceProfile(displayName: $displayName, brandColor: $brandColor, timezone: $timezone, apiVersion: $apiVersion, minimumMobileVersion: $minimumMobileVersion)';
}


}

/// @nodoc
abstract mixin class _$InstanceProfileCopyWith<$Res> implements $InstanceProfileCopyWith<$Res> {
  factory _$InstanceProfileCopyWith(_InstanceProfile value, $Res Function(_InstanceProfile) _then) = __$InstanceProfileCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'brand_color') String brandColor, String timezone,@JsonKey(name: 'api_version') String apiVersion,@JsonKey(name: 'minimum_mobile_version') String minimumMobileVersion
});




}
/// @nodoc
class __$InstanceProfileCopyWithImpl<$Res>
    implements _$InstanceProfileCopyWith<$Res> {
  __$InstanceProfileCopyWithImpl(this._self, this._then);

  final _InstanceProfile _self;
  final $Res Function(_InstanceProfile) _then;

/// Create a copy of InstanceProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = null,Object? brandColor = null,Object? timezone = null,Object? apiVersion = null,Object? minimumMobileVersion = null,}) {
  return _then(_InstanceProfile(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,brandColor: null == brandColor ? _self.brandColor : brandColor // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,apiVersion: null == apiVersion ? _self.apiVersion : apiVersion // ignore: cast_nullable_to_non_nullable
as String,minimumMobileVersion: null == minimumMobileVersion ? _self.minimumMobileVersion : minimumMobileVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
