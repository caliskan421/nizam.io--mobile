// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_copy_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableCopyRequest {

@JsonKey(name: 'source_table_id') String get sourceTableId;@JsonKey(name: 'source_space') TableCopyRequestSourceSpace get sourceSpace; TableCopyRequestMode get mode;/// Verilmezse rotanın programı; verilmişse boş olmayan metin (null/boş 422).
@JsonKey(name: 'source_program_id') String? get sourceProgramId;/// Yalnız `coordinatorship` kaynağında zorunlu.
@JsonKey(name: 'source_department_id') String? get sourceDepartmentId;/// Verilmezse kaynağın adı; verilmişse geçerli ad (null/boş 422).
 String? get name;/// Verilmezse kopya projesizdir; verilmişse hedef kapsamdaki silinmemiş proje (kişisel alanda kopyalayanın), null/boş 422.
@JsonKey(name: 'project_id') String? get projectId;
/// Create a copy of TableCopyRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCopyRequestCopyWith<TableCopyRequest> get copyWith => _$TableCopyRequestCopyWithImpl<TableCopyRequest>(this as TableCopyRequest, _$identity);

  /// Serializes this TableCopyRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableCopyRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCopyRequest&&(identical(other.sourceTableId, _this.sourceTableId) || other.sourceTableId == _this.sourceTableId)&&(identical(other.sourceSpace, _this.sourceSpace) || other.sourceSpace == _this.sourceSpace)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.sourceProgramId, _this.sourceProgramId) || other.sourceProgramId == _this.sourceProgramId)&&(identical(other.sourceDepartmentId, _this.sourceDepartmentId) || other.sourceDepartmentId == _this.sourceDepartmentId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.projectId, _this.projectId) || other.projectId == _this.projectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableCopyRequest;
  return Object.hash(runtimeType,_this.sourceTableId,_this.sourceSpace,_this.mode,_this.sourceProgramId,_this.sourceDepartmentId,_this.name,_this.projectId);
}

@override
String toString() {
  final _this = this as TableCopyRequest;
  return 'TableCopyRequest(sourceTableId: ${_this.sourceTableId}, sourceSpace: ${_this.sourceSpace}, mode: ${_this.mode}, sourceProgramId: ${_this.sourceProgramId}, sourceDepartmentId: ${_this.sourceDepartmentId}, name: ${_this.name}, projectId: ${_this.projectId})';
}


}

/// @nodoc
abstract mixin class $TableCopyRequestCopyWith<$Res>  {
  factory $TableCopyRequestCopyWith(TableCopyRequest value, $Res Function(TableCopyRequest) _then) = _$TableCopyRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'source_table_id') String sourceTableId,@JsonKey(name: 'source_space') TableCopyRequestSourceSpace sourceSpace, TableCopyRequestMode mode,@JsonKey(name: 'source_program_id') String? sourceProgramId,@JsonKey(name: 'source_department_id') String? sourceDepartmentId, String? name,@JsonKey(name: 'project_id') String? projectId
});




}
/// @nodoc
class _$TableCopyRequestCopyWithImpl<$Res>
    implements $TableCopyRequestCopyWith<$Res> {
  _$TableCopyRequestCopyWithImpl(this._self, this._then);

  final TableCopyRequest _self;
  final $Res Function(TableCopyRequest) _then;

/// Create a copy of TableCopyRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceTableId = null,Object? sourceSpace = null,Object? mode = null,Object? sourceProgramId = freezed,Object? sourceDepartmentId = freezed,Object? name = freezed,Object? projectId = freezed,}) {
  return _then(TableCopyRequest(
sourceTableId: null == sourceTableId ? _self.sourceTableId : sourceTableId // ignore: cast_nullable_to_non_nullable
as String,sourceSpace: null == sourceSpace ? _self.sourceSpace : sourceSpace // ignore: cast_nullable_to_non_nullable
as TableCopyRequestSourceSpace,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TableCopyRequestMode,sourceProgramId: freezed == sourceProgramId ? _self.sourceProgramId : sourceProgramId // ignore: cast_nullable_to_non_nullable
as String?,sourceDepartmentId: freezed == sourceDepartmentId ? _self.sourceDepartmentId : sourceDepartmentId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TableCopyRequest].
extension TableCopyRequestPatterns on TableCopyRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableCopyRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableCopyRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableCopyRequest value)  $default,){
final _that = this;
switch (_that) {
case _TableCopyRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableCopyRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TableCopyRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'source_table_id')  String sourceTableId, @JsonKey(name: 'source_space')  TableCopyRequestSourceSpace sourceSpace,  TableCopyRequestMode mode, @JsonKey(name: 'source_program_id')  String? sourceProgramId, @JsonKey(name: 'source_department_id')  String? sourceDepartmentId,  String? name, @JsonKey(name: 'project_id')  String? projectId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableCopyRequest() when $default != null:
return $default(_that.sourceTableId,_that.sourceSpace,_that.mode,_that.sourceProgramId,_that.sourceDepartmentId,_that.name,_that.projectId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'source_table_id')  String sourceTableId, @JsonKey(name: 'source_space')  TableCopyRequestSourceSpace sourceSpace,  TableCopyRequestMode mode, @JsonKey(name: 'source_program_id')  String? sourceProgramId, @JsonKey(name: 'source_department_id')  String? sourceDepartmentId,  String? name, @JsonKey(name: 'project_id')  String? projectId)  $default,) {final _that = this;
switch (_that) {
case _TableCopyRequest():
return $default(_that.sourceTableId,_that.sourceSpace,_that.mode,_that.sourceProgramId,_that.sourceDepartmentId,_that.name,_that.projectId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'source_table_id')  String sourceTableId, @JsonKey(name: 'source_space')  TableCopyRequestSourceSpace sourceSpace,  TableCopyRequestMode mode, @JsonKey(name: 'source_program_id')  String? sourceProgramId, @JsonKey(name: 'source_department_id')  String? sourceDepartmentId,  String? name, @JsonKey(name: 'project_id')  String? projectId)?  $default,) {final _that = this;
switch (_that) {
case _TableCopyRequest() when $default != null:
return $default(_that.sourceTableId,_that.sourceSpace,_that.mode,_that.sourceProgramId,_that.sourceDepartmentId,_that.name,_that.projectId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableCopyRequest implements TableCopyRequest {
  const _TableCopyRequest({@JsonKey(name: 'source_table_id') required this.sourceTableId, @JsonKey(name: 'source_space') required this.sourceSpace, required this.mode, @JsonKey(name: 'source_program_id') this.sourceProgramId, @JsonKey(name: 'source_department_id') this.sourceDepartmentId, this.name, @JsonKey(name: 'project_id') this.projectId});
  factory _TableCopyRequest.fromJson(Map<String, dynamic> json) => _$TableCopyRequestFromJson(json);

@override@JsonKey(name: 'source_table_id') final  String sourceTableId;
@override@JsonKey(name: 'source_space') final  TableCopyRequestSourceSpace sourceSpace;
@override final  TableCopyRequestMode mode;
/// Verilmezse rotanın programı; verilmişse boş olmayan metin (null/boş 422).
@override@JsonKey(name: 'source_program_id') final  String? sourceProgramId;
/// Yalnız `coordinatorship` kaynağında zorunlu.
@override@JsonKey(name: 'source_department_id') final  String? sourceDepartmentId;
/// Verilmezse kaynağın adı; verilmişse geçerli ad (null/boş 422).
@override final  String? name;
/// Verilmezse kopya projesizdir; verilmişse hedef kapsamdaki silinmemiş proje (kişisel alanda kopyalayanın), null/boş 422.
@override@JsonKey(name: 'project_id') final  String? projectId;

/// Create a copy of TableCopyRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableCopyRequestCopyWith<_TableCopyRequest> get copyWith => __$TableCopyRequestCopyWithImpl<_TableCopyRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCopyRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableCopyRequest&&(identical(other.sourceTableId, sourceTableId) || other.sourceTableId == sourceTableId)&&(identical(other.sourceSpace, sourceSpace) || other.sourceSpace == sourceSpace)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.sourceProgramId, sourceProgramId) || other.sourceProgramId == sourceProgramId)&&(identical(other.sourceDepartmentId, sourceDepartmentId) || other.sourceDepartmentId == sourceDepartmentId)&&(identical(other.name, name) || other.name == name)&&(identical(other.projectId, projectId) || other.projectId == projectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,sourceTableId,sourceSpace,mode,sourceProgramId,sourceDepartmentId,name,projectId);
}

@override
String toString() {
    return 'TableCopyRequest(sourceTableId: $sourceTableId, sourceSpace: $sourceSpace, mode: $mode, sourceProgramId: $sourceProgramId, sourceDepartmentId: $sourceDepartmentId, name: $name, projectId: $projectId)';
}


}

/// @nodoc
abstract mixin class _$TableCopyRequestCopyWith<$Res> implements $TableCopyRequestCopyWith<$Res> {
  factory _$TableCopyRequestCopyWith(_TableCopyRequest value, $Res Function(_TableCopyRequest) _then) = __$TableCopyRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'source_table_id') String sourceTableId,@JsonKey(name: 'source_space') TableCopyRequestSourceSpace sourceSpace, TableCopyRequestMode mode,@JsonKey(name: 'source_program_id') String? sourceProgramId,@JsonKey(name: 'source_department_id') String? sourceDepartmentId, String? name,@JsonKey(name: 'project_id') String? projectId
});




}
/// @nodoc
class __$TableCopyRequestCopyWithImpl<$Res>
    implements _$TableCopyRequestCopyWith<$Res> {
  __$TableCopyRequestCopyWithImpl(this._self, this._then);

  final _TableCopyRequest _self;
  final $Res Function(_TableCopyRequest) _then;

/// Create a copy of TableCopyRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceTableId = null,Object? sourceSpace = null,Object? mode = null,Object? sourceProgramId = freezed,Object? sourceDepartmentId = freezed,Object? name = freezed,Object? projectId = freezed,}) {
  return _then(_TableCopyRequest(
sourceTableId: null == sourceTableId ? _self.sourceTableId : sourceTableId // ignore: cast_nullable_to_non_nullable
as String,sourceSpace: null == sourceSpace ? _self.sourceSpace : sourceSpace // ignore: cast_nullable_to_non_nullable
as TableCopyRequestSourceSpace,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TableCopyRequestMode,sourceProgramId: freezed == sourceProgramId ? _self.sourceProgramId : sourceProgramId // ignore: cast_nullable_to_non_nullable
as String?,sourceDepartmentId: freezed == sourceDepartmentId ? _self.sourceDepartmentId : sourceDepartmentId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
