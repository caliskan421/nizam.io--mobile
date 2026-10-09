// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SystemInfo {

@JsonKey(name: 'product_id') String get productId;/// Aktivasyon tamamlanmadıysa boş.
@JsonKey(name: 'instance_id') String get instanceId;@JsonKey(name: 'company_display_name') String get companyDisplayName;@JsonKey(name: 'server_version') String get serverVersion;@JsonKey(name: 'api_version') String get apiVersion;@JsonKey(name: 'minimum_mobile_version') String get minimumMobileVersion; List<String>? get capabilities;
/// Create a copy of SystemInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SystemInfoCopyWith<SystemInfo> get copyWith => _$SystemInfoCopyWithImpl<SystemInfo>(this as SystemInfo, _$identity);

  /// Serializes this SystemInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SystemInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SystemInfo&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.instanceId, _this.instanceId) || other.instanceId == _this.instanceId)&&(identical(other.companyDisplayName, _this.companyDisplayName) || other.companyDisplayName == _this.companyDisplayName)&&(identical(other.serverVersion, _this.serverVersion) || other.serverVersion == _this.serverVersion)&&(identical(other.apiVersion, _this.apiVersion) || other.apiVersion == _this.apiVersion)&&(identical(other.minimumMobileVersion, _this.minimumMobileVersion) || other.minimumMobileVersion == _this.minimumMobileVersion)&&const DeepCollectionEquality().equals(other.capabilities, _this.capabilities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SystemInfo;
  return Object.hash(runtimeType,_this.productId,_this.instanceId,_this.companyDisplayName,_this.serverVersion,_this.apiVersion,_this.minimumMobileVersion,const DeepCollectionEquality().hash(_this.capabilities));
}

@override
String toString() {
  final _this = this as SystemInfo;
  return 'SystemInfo(productId: ${_this.productId}, instanceId: ${_this.instanceId}, companyDisplayName: ${_this.companyDisplayName}, serverVersion: ${_this.serverVersion}, apiVersion: ${_this.apiVersion}, minimumMobileVersion: ${_this.minimumMobileVersion}, capabilities: ${_this.capabilities})';
}


}

/// @nodoc
abstract mixin class $SystemInfoCopyWith<$Res>  {
  factory $SystemInfoCopyWith(SystemInfo value, $Res Function(SystemInfo) _then) = _$SystemInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'instance_id') String instanceId,@JsonKey(name: 'company_display_name') String companyDisplayName,@JsonKey(name: 'server_version') String serverVersion,@JsonKey(name: 'api_version') String apiVersion,@JsonKey(name: 'minimum_mobile_version') String minimumMobileVersion, List<String>? capabilities
});




}
/// @nodoc
class _$SystemInfoCopyWithImpl<$Res>
    implements $SystemInfoCopyWith<$Res> {
  _$SystemInfoCopyWithImpl(this._self, this._then);

  final SystemInfo _self;
  final $Res Function(SystemInfo) _then;

/// Create a copy of SystemInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? instanceId = null,Object? companyDisplayName = null,Object? serverVersion = null,Object? apiVersion = null,Object? minimumMobileVersion = null,Object? capabilities = freezed,}) {
  return _then(SystemInfo(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,instanceId: null == instanceId ? _self.instanceId : instanceId // ignore: cast_nullable_to_non_nullable
as String,companyDisplayName: null == companyDisplayName ? _self.companyDisplayName : companyDisplayName // ignore: cast_nullable_to_non_nullable
as String,serverVersion: null == serverVersion ? _self.serverVersion : serverVersion // ignore: cast_nullable_to_non_nullable
as String,apiVersion: null == apiVersion ? _self.apiVersion : apiVersion // ignore: cast_nullable_to_non_nullable
as String,minimumMobileVersion: null == minimumMobileVersion ? _self.minimumMobileVersion : minimumMobileVersion // ignore: cast_nullable_to_non_nullable
as String,capabilities: freezed == capabilities ? _self.capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SystemInfo].
extension SystemInfoPatterns on SystemInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SystemInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SystemInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SystemInfo value)  $default,){
final _that = this;
switch (_that) {
case _SystemInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SystemInfo value)?  $default,){
final _that = this;
switch (_that) {
case _SystemInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'instance_id')  String instanceId, @JsonKey(name: 'company_display_name')  String companyDisplayName, @JsonKey(name: 'server_version')  String serverVersion, @JsonKey(name: 'api_version')  String apiVersion, @JsonKey(name: 'minimum_mobile_version')  String minimumMobileVersion,  List<String>? capabilities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SystemInfo() when $default != null:
return $default(_that.productId,_that.instanceId,_that.companyDisplayName,_that.serverVersion,_that.apiVersion,_that.minimumMobileVersion,_that.capabilities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'instance_id')  String instanceId, @JsonKey(name: 'company_display_name')  String companyDisplayName, @JsonKey(name: 'server_version')  String serverVersion, @JsonKey(name: 'api_version')  String apiVersion, @JsonKey(name: 'minimum_mobile_version')  String minimumMobileVersion,  List<String>? capabilities)  $default,) {final _that = this;
switch (_that) {
case _SystemInfo():
return $default(_that.productId,_that.instanceId,_that.companyDisplayName,_that.serverVersion,_that.apiVersion,_that.minimumMobileVersion,_that.capabilities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'instance_id')  String instanceId, @JsonKey(name: 'company_display_name')  String companyDisplayName, @JsonKey(name: 'server_version')  String serverVersion, @JsonKey(name: 'api_version')  String apiVersion, @JsonKey(name: 'minimum_mobile_version')  String minimumMobileVersion,  List<String>? capabilities)?  $default,) {final _that = this;
switch (_that) {
case _SystemInfo() when $default != null:
return $default(_that.productId,_that.instanceId,_that.companyDisplayName,_that.serverVersion,_that.apiVersion,_that.minimumMobileVersion,_that.capabilities);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SystemInfo implements SystemInfo {
  const _SystemInfo({@JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'instance_id') required this.instanceId, @JsonKey(name: 'company_display_name') required this.companyDisplayName, @JsonKey(name: 'server_version') required this.serverVersion, @JsonKey(name: 'api_version') required this.apiVersion, @JsonKey(name: 'minimum_mobile_version') required this.minimumMobileVersion, required  List<String>? capabilities}): _capabilities = capabilities;
  factory _SystemInfo.fromJson(Map<String, dynamic> json) => _$SystemInfoFromJson(json);

@override@JsonKey(name: 'product_id') final  String productId;
/// Aktivasyon tamamlanmadıysa boş.
@override@JsonKey(name: 'instance_id') final  String instanceId;
@override@JsonKey(name: 'company_display_name') final  String companyDisplayName;
@override@JsonKey(name: 'server_version') final  String serverVersion;
@override@JsonKey(name: 'api_version') final  String apiVersion;
@override@JsonKey(name: 'minimum_mobile_version') final  String minimumMobileVersion;
 final  List<String>? _capabilities;
@override List<String>? get capabilities {
  final value = _capabilities;
  if (value == null) return null;
  if (_capabilities is EqualUnmodifiableListView) return _capabilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of SystemInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SystemInfoCopyWith<_SystemInfo> get copyWith => __$SystemInfoCopyWithImpl<_SystemInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SystemInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SystemInfo&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.instanceId, instanceId) || other.instanceId == instanceId)&&(identical(other.companyDisplayName, companyDisplayName) || other.companyDisplayName == companyDisplayName)&&(identical(other.serverVersion, serverVersion) || other.serverVersion == serverVersion)&&(identical(other.apiVersion, apiVersion) || other.apiVersion == apiVersion)&&(identical(other.minimumMobileVersion, minimumMobileVersion) || other.minimumMobileVersion == minimumMobileVersion)&&const DeepCollectionEquality().equals(other.capabilities, _capabilities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,productId,instanceId,companyDisplayName,serverVersion,apiVersion,minimumMobileVersion,const DeepCollectionEquality().hash(_capabilities));
}

@override
String toString() {
    return 'SystemInfo(productId: $productId, instanceId: $instanceId, companyDisplayName: $companyDisplayName, serverVersion: $serverVersion, apiVersion: $apiVersion, minimumMobileVersion: $minimumMobileVersion, capabilities: $capabilities)';
}


}

/// @nodoc
abstract mixin class _$SystemInfoCopyWith<$Res> implements $SystemInfoCopyWith<$Res> {
  factory _$SystemInfoCopyWith(_SystemInfo value, $Res Function(_SystemInfo) _then) = __$SystemInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'instance_id') String instanceId,@JsonKey(name: 'company_display_name') String companyDisplayName,@JsonKey(name: 'server_version') String serverVersion,@JsonKey(name: 'api_version') String apiVersion,@JsonKey(name: 'minimum_mobile_version') String minimumMobileVersion, List<String>? capabilities
});




}
/// @nodoc
class __$SystemInfoCopyWithImpl<$Res>
    implements _$SystemInfoCopyWith<$Res> {
  __$SystemInfoCopyWithImpl(this._self, this._then);

  final _SystemInfo _self;
  final $Res Function(_SystemInfo) _then;

/// Create a copy of SystemInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? instanceId = null,Object? companyDisplayName = null,Object? serverVersion = null,Object? apiVersion = null,Object? minimumMobileVersion = null,Object? capabilities = freezed,}) {
  return _then(_SystemInfo(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,instanceId: null == instanceId ? _self.instanceId : instanceId // ignore: cast_nullable_to_non_nullable
as String,companyDisplayName: null == companyDisplayName ? _self.companyDisplayName : companyDisplayName // ignore: cast_nullable_to_non_nullable
as String,serverVersion: null == serverVersion ? _self.serverVersion : serverVersion // ignore: cast_nullable_to_non_nullable
as String,apiVersion: null == apiVersion ? _self.apiVersion : apiVersion // ignore: cast_nullable_to_non_nullable
as String,minimumMobileVersion: null == minimumMobileVersion ? _self.minimumMobileVersion : minimumMobileVersion // ignore: cast_nullable_to_non_nullable
as String,capabilities: freezed == capabilities ? _self._capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
