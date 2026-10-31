// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_preview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransferPreview {

@JsonKey(name: 'resolved_work_item_ids') List<String>? get resolvedWorkItemIds;@JsonKey(name: 'file_count') int get fileCount;@JsonKey(name: 'file_total_bytes') int get fileTotalBytes;@JsonKey(name: 'preserved_dependency_count') int get preservedDependencyCount;@JsonKey(name: 'missing_access') bool get missingAccess;/// Aktarımın hedef programın departman ekibine `uye` olarak eklediği (ön izlemede ekleyeceği) atanan kişiler (ADR-0023 kural 12).
@JsonKey(name: 'granted_memberships') List<GrantedMembership> get grantedMemberships; List<String> get blockers; List<String> get warnings;@JsonKey(name: 'can_execute') bool get canExecute;@JsonKey(name: 'preview_fingerprint') String get previewFingerprint;@JsonKey(name: 'unresolved_work_item_ids') List<String>? get unresolvedWorkItemIds;@JsonKey(name: 'missing_file_ids') List<String>? get missingFileIds;@JsonKey(name: 'cut_dependency_ids') List<String>? get cutDependencyIds;@JsonKey(name: 'cycle_work_item_ids') List<String>? get cycleWorkItemIds;
/// Create a copy of TransferPreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferPreviewCopyWith<TransferPreview> get copyWith => _$TransferPreviewCopyWithImpl<TransferPreview>(this as TransferPreview, _$identity);

  /// Serializes this TransferPreview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransferPreview;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferPreview&&const DeepCollectionEquality().equals(other.resolvedWorkItemIds, _this.resolvedWorkItemIds)&&(identical(other.fileCount, _this.fileCount) || other.fileCount == _this.fileCount)&&(identical(other.fileTotalBytes, _this.fileTotalBytes) || other.fileTotalBytes == _this.fileTotalBytes)&&(identical(other.preservedDependencyCount, _this.preservedDependencyCount) || other.preservedDependencyCount == _this.preservedDependencyCount)&&(identical(other.missingAccess, _this.missingAccess) || other.missingAccess == _this.missingAccess)&&const DeepCollectionEquality().equals(other.grantedMemberships, _this.grantedMemberships)&&const DeepCollectionEquality().equals(other.blockers, _this.blockers)&&const DeepCollectionEquality().equals(other.warnings, _this.warnings)&&(identical(other.canExecute, _this.canExecute) || other.canExecute == _this.canExecute)&&(identical(other.previewFingerprint, _this.previewFingerprint) || other.previewFingerprint == _this.previewFingerprint)&&const DeepCollectionEquality().equals(other.unresolvedWorkItemIds, _this.unresolvedWorkItemIds)&&const DeepCollectionEquality().equals(other.missingFileIds, _this.missingFileIds)&&const DeepCollectionEquality().equals(other.cutDependencyIds, _this.cutDependencyIds)&&const DeepCollectionEquality().equals(other.cycleWorkItemIds, _this.cycleWorkItemIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransferPreview;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.resolvedWorkItemIds),_this.fileCount,_this.fileTotalBytes,_this.preservedDependencyCount,_this.missingAccess,const DeepCollectionEquality().hash(_this.grantedMemberships),const DeepCollectionEquality().hash(_this.blockers),const DeepCollectionEquality().hash(_this.warnings),_this.canExecute,_this.previewFingerprint,const DeepCollectionEquality().hash(_this.unresolvedWorkItemIds),const DeepCollectionEquality().hash(_this.missingFileIds),const DeepCollectionEquality().hash(_this.cutDependencyIds),const DeepCollectionEquality().hash(_this.cycleWorkItemIds));
}

@override
String toString() {
  final _this = this as TransferPreview;
  return 'TransferPreview(resolvedWorkItemIds: ${_this.resolvedWorkItemIds}, fileCount: ${_this.fileCount}, fileTotalBytes: ${_this.fileTotalBytes}, preservedDependencyCount: ${_this.preservedDependencyCount}, missingAccess: ${_this.missingAccess}, grantedMemberships: ${_this.grantedMemberships}, blockers: ${_this.blockers}, warnings: ${_this.warnings}, canExecute: ${_this.canExecute}, previewFingerprint: ${_this.previewFingerprint}, unresolvedWorkItemIds: ${_this.unresolvedWorkItemIds}, missingFileIds: ${_this.missingFileIds}, cutDependencyIds: ${_this.cutDependencyIds}, cycleWorkItemIds: ${_this.cycleWorkItemIds})';
}


}

/// @nodoc
abstract mixin class $TransferPreviewCopyWith<$Res>  {
  factory $TransferPreviewCopyWith(TransferPreview value, $Res Function(TransferPreview) _then) = _$TransferPreviewCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'resolved_work_item_ids') List<String>? resolvedWorkItemIds,@JsonKey(name: 'file_count') int fileCount,@JsonKey(name: 'file_total_bytes') int fileTotalBytes,@JsonKey(name: 'preserved_dependency_count') int preservedDependencyCount,@JsonKey(name: 'missing_access') bool missingAccess,@JsonKey(name: 'granted_memberships') List<GrantedMembership> grantedMemberships, List<String> blockers, List<String> warnings,@JsonKey(name: 'can_execute') bool canExecute,@JsonKey(name: 'preview_fingerprint') String previewFingerprint,@JsonKey(name: 'unresolved_work_item_ids') List<String>? unresolvedWorkItemIds,@JsonKey(name: 'missing_file_ids') List<String>? missingFileIds,@JsonKey(name: 'cut_dependency_ids') List<String>? cutDependencyIds,@JsonKey(name: 'cycle_work_item_ids') List<String>? cycleWorkItemIds
});




}
/// @nodoc
class _$TransferPreviewCopyWithImpl<$Res>
    implements $TransferPreviewCopyWith<$Res> {
  _$TransferPreviewCopyWithImpl(this._self, this._then);

  final TransferPreview _self;
  final $Res Function(TransferPreview) _then;

/// Create a copy of TransferPreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? resolvedWorkItemIds = freezed,Object? fileCount = null,Object? fileTotalBytes = null,Object? preservedDependencyCount = null,Object? missingAccess = null,Object? grantedMemberships = null,Object? blockers = null,Object? warnings = null,Object? canExecute = null,Object? previewFingerprint = null,Object? unresolvedWorkItemIds = freezed,Object? missingFileIds = freezed,Object? cutDependencyIds = freezed,Object? cycleWorkItemIds = freezed,}) {
  return _then(TransferPreview(
resolvedWorkItemIds: freezed == resolvedWorkItemIds ? _self.resolvedWorkItemIds : resolvedWorkItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,fileCount: null == fileCount ? _self.fileCount : fileCount // ignore: cast_nullable_to_non_nullable
as int,fileTotalBytes: null == fileTotalBytes ? _self.fileTotalBytes : fileTotalBytes // ignore: cast_nullable_to_non_nullable
as int,preservedDependencyCount: null == preservedDependencyCount ? _self.preservedDependencyCount : preservedDependencyCount // ignore: cast_nullable_to_non_nullable
as int,missingAccess: null == missingAccess ? _self.missingAccess : missingAccess // ignore: cast_nullable_to_non_nullable
as bool,grantedMemberships: null == grantedMemberships ? _self.grantedMemberships : grantedMemberships // ignore: cast_nullable_to_non_nullable
as List<GrantedMembership>,blockers: null == blockers ? _self.blockers : blockers // ignore: cast_nullable_to_non_nullable
as List<String>,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,canExecute: null == canExecute ? _self.canExecute : canExecute // ignore: cast_nullable_to_non_nullable
as bool,previewFingerprint: null == previewFingerprint ? _self.previewFingerprint : previewFingerprint // ignore: cast_nullable_to_non_nullable
as String,unresolvedWorkItemIds: freezed == unresolvedWorkItemIds ? _self.unresolvedWorkItemIds : unresolvedWorkItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,missingFileIds: freezed == missingFileIds ? _self.missingFileIds : missingFileIds // ignore: cast_nullable_to_non_nullable
as List<String>?,cutDependencyIds: freezed == cutDependencyIds ? _self.cutDependencyIds : cutDependencyIds // ignore: cast_nullable_to_non_nullable
as List<String>?,cycleWorkItemIds: freezed == cycleWorkItemIds ? _self.cycleWorkItemIds : cycleWorkItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferPreview].
extension TransferPreviewPatterns on TransferPreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferPreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferPreview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferPreview value)  $default,){
final _that = this;
switch (_that) {
case _TransferPreview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferPreview value)?  $default,){
final _that = this;
switch (_that) {
case _TransferPreview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'resolved_work_item_ids')  List<String>? resolvedWorkItemIds, @JsonKey(name: 'file_count')  int fileCount, @JsonKey(name: 'file_total_bytes')  int fileTotalBytes, @JsonKey(name: 'preserved_dependency_count')  int preservedDependencyCount, @JsonKey(name: 'missing_access')  bool missingAccess, @JsonKey(name: 'granted_memberships')  List<GrantedMembership> grantedMemberships,  List<String> blockers,  List<String> warnings, @JsonKey(name: 'can_execute')  bool canExecute, @JsonKey(name: 'preview_fingerprint')  String previewFingerprint, @JsonKey(name: 'unresolved_work_item_ids')  List<String>? unresolvedWorkItemIds, @JsonKey(name: 'missing_file_ids')  List<String>? missingFileIds, @JsonKey(name: 'cut_dependency_ids')  List<String>? cutDependencyIds, @JsonKey(name: 'cycle_work_item_ids')  List<String>? cycleWorkItemIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferPreview() when $default != null:
return $default(_that.resolvedWorkItemIds,_that.fileCount,_that.fileTotalBytes,_that.preservedDependencyCount,_that.missingAccess,_that.grantedMemberships,_that.blockers,_that.warnings,_that.canExecute,_that.previewFingerprint,_that.unresolvedWorkItemIds,_that.missingFileIds,_that.cutDependencyIds,_that.cycleWorkItemIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'resolved_work_item_ids')  List<String>? resolvedWorkItemIds, @JsonKey(name: 'file_count')  int fileCount, @JsonKey(name: 'file_total_bytes')  int fileTotalBytes, @JsonKey(name: 'preserved_dependency_count')  int preservedDependencyCount, @JsonKey(name: 'missing_access')  bool missingAccess, @JsonKey(name: 'granted_memberships')  List<GrantedMembership> grantedMemberships,  List<String> blockers,  List<String> warnings, @JsonKey(name: 'can_execute')  bool canExecute, @JsonKey(name: 'preview_fingerprint')  String previewFingerprint, @JsonKey(name: 'unresolved_work_item_ids')  List<String>? unresolvedWorkItemIds, @JsonKey(name: 'missing_file_ids')  List<String>? missingFileIds, @JsonKey(name: 'cut_dependency_ids')  List<String>? cutDependencyIds, @JsonKey(name: 'cycle_work_item_ids')  List<String>? cycleWorkItemIds)  $default,) {final _that = this;
switch (_that) {
case _TransferPreview():
return $default(_that.resolvedWorkItemIds,_that.fileCount,_that.fileTotalBytes,_that.preservedDependencyCount,_that.missingAccess,_that.grantedMemberships,_that.blockers,_that.warnings,_that.canExecute,_that.previewFingerprint,_that.unresolvedWorkItemIds,_that.missingFileIds,_that.cutDependencyIds,_that.cycleWorkItemIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'resolved_work_item_ids')  List<String>? resolvedWorkItemIds, @JsonKey(name: 'file_count')  int fileCount, @JsonKey(name: 'file_total_bytes')  int fileTotalBytes, @JsonKey(name: 'preserved_dependency_count')  int preservedDependencyCount, @JsonKey(name: 'missing_access')  bool missingAccess, @JsonKey(name: 'granted_memberships')  List<GrantedMembership> grantedMemberships,  List<String> blockers,  List<String> warnings, @JsonKey(name: 'can_execute')  bool canExecute, @JsonKey(name: 'preview_fingerprint')  String previewFingerprint, @JsonKey(name: 'unresolved_work_item_ids')  List<String>? unresolvedWorkItemIds, @JsonKey(name: 'missing_file_ids')  List<String>? missingFileIds, @JsonKey(name: 'cut_dependency_ids')  List<String>? cutDependencyIds, @JsonKey(name: 'cycle_work_item_ids')  List<String>? cycleWorkItemIds)?  $default,) {final _that = this;
switch (_that) {
case _TransferPreview() when $default != null:
return $default(_that.resolvedWorkItemIds,_that.fileCount,_that.fileTotalBytes,_that.preservedDependencyCount,_that.missingAccess,_that.grantedMemberships,_that.blockers,_that.warnings,_that.canExecute,_that.previewFingerprint,_that.unresolvedWorkItemIds,_that.missingFileIds,_that.cutDependencyIds,_that.cycleWorkItemIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransferPreview implements TransferPreview {
  const _TransferPreview({@JsonKey(name: 'resolved_work_item_ids') required  List<String>? resolvedWorkItemIds, @JsonKey(name: 'file_count') required this.fileCount, @JsonKey(name: 'file_total_bytes') required this.fileTotalBytes, @JsonKey(name: 'preserved_dependency_count') required this.preservedDependencyCount, @JsonKey(name: 'missing_access') required this.missingAccess, @JsonKey(name: 'granted_memberships') required  List<GrantedMembership> grantedMemberships, required  List<String> blockers, required  List<String> warnings, @JsonKey(name: 'can_execute') required this.canExecute, @JsonKey(name: 'preview_fingerprint') required this.previewFingerprint, @JsonKey(name: 'unresolved_work_item_ids')  List<String>? unresolvedWorkItemIds, @JsonKey(name: 'missing_file_ids')  List<String>? missingFileIds, @JsonKey(name: 'cut_dependency_ids')  List<String>? cutDependencyIds, @JsonKey(name: 'cycle_work_item_ids')  List<String>? cycleWorkItemIds}): _resolvedWorkItemIds = resolvedWorkItemIds,_grantedMemberships = grantedMemberships,_blockers = blockers,_warnings = warnings,_unresolvedWorkItemIds = unresolvedWorkItemIds,_missingFileIds = missingFileIds,_cutDependencyIds = cutDependencyIds,_cycleWorkItemIds = cycleWorkItemIds;
  factory _TransferPreview.fromJson(Map<String, dynamic> json) => _$TransferPreviewFromJson(json);

 final  List<String>? _resolvedWorkItemIds;
@override@JsonKey(name: 'resolved_work_item_ids') List<String>? get resolvedWorkItemIds {
  final value = _resolvedWorkItemIds;
  if (value == null) return null;
  if (_resolvedWorkItemIds is EqualUnmodifiableListView) return _resolvedWorkItemIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'file_count') final  int fileCount;
@override@JsonKey(name: 'file_total_bytes') final  int fileTotalBytes;
@override@JsonKey(name: 'preserved_dependency_count') final  int preservedDependencyCount;
@override@JsonKey(name: 'missing_access') final  bool missingAccess;
/// Aktarımın hedef programın departman ekibine `uye` olarak eklediği (ön izlemede ekleyeceği) atanan kişiler (ADR-0023 kural 12).
 final  List<GrantedMembership> _grantedMemberships;
/// Aktarımın hedef programın departman ekibine `uye` olarak eklediği (ön izlemede ekleyeceği) atanan kişiler (ADR-0023 kural 12).
@override@JsonKey(name: 'granted_memberships') List<GrantedMembership> get grantedMemberships {
  if (_grantedMemberships is EqualUnmodifiableListView) return _grantedMemberships;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_grantedMemberships);
}

 final  List<String> _blockers;
@override List<String> get blockers {
  if (_blockers is EqualUnmodifiableListView) return _blockers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_blockers);
}

 final  List<String> _warnings;
@override List<String> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}

@override@JsonKey(name: 'can_execute') final  bool canExecute;
@override@JsonKey(name: 'preview_fingerprint') final  String previewFingerprint;
 final  List<String>? _unresolvedWorkItemIds;
@override@JsonKey(name: 'unresolved_work_item_ids') List<String>? get unresolvedWorkItemIds {
  final value = _unresolvedWorkItemIds;
  if (value == null) return null;
  if (_unresolvedWorkItemIds is EqualUnmodifiableListView) return _unresolvedWorkItemIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _missingFileIds;
@override@JsonKey(name: 'missing_file_ids') List<String>? get missingFileIds {
  final value = _missingFileIds;
  if (value == null) return null;
  if (_missingFileIds is EqualUnmodifiableListView) return _missingFileIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _cutDependencyIds;
@override@JsonKey(name: 'cut_dependency_ids') List<String>? get cutDependencyIds {
  final value = _cutDependencyIds;
  if (value == null) return null;
  if (_cutDependencyIds is EqualUnmodifiableListView) return _cutDependencyIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _cycleWorkItemIds;
@override@JsonKey(name: 'cycle_work_item_ids') List<String>? get cycleWorkItemIds {
  final value = _cycleWorkItemIds;
  if (value == null) return null;
  if (_cycleWorkItemIds is EqualUnmodifiableListView) return _cycleWorkItemIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of TransferPreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferPreviewCopyWith<_TransferPreview> get copyWith => __$TransferPreviewCopyWithImpl<_TransferPreview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferPreviewToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferPreview&&const DeepCollectionEquality().equals(other.resolvedWorkItemIds, _resolvedWorkItemIds)&&(identical(other.fileCount, fileCount) || other.fileCount == fileCount)&&(identical(other.fileTotalBytes, fileTotalBytes) || other.fileTotalBytes == fileTotalBytes)&&(identical(other.preservedDependencyCount, preservedDependencyCount) || other.preservedDependencyCount == preservedDependencyCount)&&(identical(other.missingAccess, missingAccess) || other.missingAccess == missingAccess)&&const DeepCollectionEquality().equals(other.grantedMemberships, _grantedMemberships)&&const DeepCollectionEquality().equals(other.blockers, _blockers)&&const DeepCollectionEquality().equals(other.warnings, _warnings)&&(identical(other.canExecute, canExecute) || other.canExecute == canExecute)&&(identical(other.previewFingerprint, previewFingerprint) || other.previewFingerprint == previewFingerprint)&&const DeepCollectionEquality().equals(other.unresolvedWorkItemIds, _unresolvedWorkItemIds)&&const DeepCollectionEquality().equals(other.missingFileIds, _missingFileIds)&&const DeepCollectionEquality().equals(other.cutDependencyIds, _cutDependencyIds)&&const DeepCollectionEquality().equals(other.cycleWorkItemIds, _cycleWorkItemIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_resolvedWorkItemIds),fileCount,fileTotalBytes,preservedDependencyCount,missingAccess,const DeepCollectionEquality().hash(_grantedMemberships),const DeepCollectionEquality().hash(_blockers),const DeepCollectionEquality().hash(_warnings),canExecute,previewFingerprint,const DeepCollectionEquality().hash(_unresolvedWorkItemIds),const DeepCollectionEquality().hash(_missingFileIds),const DeepCollectionEquality().hash(_cutDependencyIds),const DeepCollectionEquality().hash(_cycleWorkItemIds));
}

@override
String toString() {
    return 'TransferPreview(resolvedWorkItemIds: $resolvedWorkItemIds, fileCount: $fileCount, fileTotalBytes: $fileTotalBytes, preservedDependencyCount: $preservedDependencyCount, missingAccess: $missingAccess, grantedMemberships: $grantedMemberships, blockers: $blockers, warnings: $warnings, canExecute: $canExecute, previewFingerprint: $previewFingerprint, unresolvedWorkItemIds: $unresolvedWorkItemIds, missingFileIds: $missingFileIds, cutDependencyIds: $cutDependencyIds, cycleWorkItemIds: $cycleWorkItemIds)';
}


}

/// @nodoc
abstract mixin class _$TransferPreviewCopyWith<$Res> implements $TransferPreviewCopyWith<$Res> {
  factory _$TransferPreviewCopyWith(_TransferPreview value, $Res Function(_TransferPreview) _then) = __$TransferPreviewCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'resolved_work_item_ids') List<String>? resolvedWorkItemIds,@JsonKey(name: 'file_count') int fileCount,@JsonKey(name: 'file_total_bytes') int fileTotalBytes,@JsonKey(name: 'preserved_dependency_count') int preservedDependencyCount,@JsonKey(name: 'missing_access') bool missingAccess,@JsonKey(name: 'granted_memberships') List<GrantedMembership> grantedMemberships, List<String> blockers, List<String> warnings,@JsonKey(name: 'can_execute') bool canExecute,@JsonKey(name: 'preview_fingerprint') String previewFingerprint,@JsonKey(name: 'unresolved_work_item_ids') List<String>? unresolvedWorkItemIds,@JsonKey(name: 'missing_file_ids') List<String>? missingFileIds,@JsonKey(name: 'cut_dependency_ids') List<String>? cutDependencyIds,@JsonKey(name: 'cycle_work_item_ids') List<String>? cycleWorkItemIds
});




}
/// @nodoc
class __$TransferPreviewCopyWithImpl<$Res>
    implements _$TransferPreviewCopyWith<$Res> {
  __$TransferPreviewCopyWithImpl(this._self, this._then);

  final _TransferPreview _self;
  final $Res Function(_TransferPreview) _then;

/// Create a copy of TransferPreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? resolvedWorkItemIds = freezed,Object? fileCount = null,Object? fileTotalBytes = null,Object? preservedDependencyCount = null,Object? missingAccess = null,Object? grantedMemberships = null,Object? blockers = null,Object? warnings = null,Object? canExecute = null,Object? previewFingerprint = null,Object? unresolvedWorkItemIds = freezed,Object? missingFileIds = freezed,Object? cutDependencyIds = freezed,Object? cycleWorkItemIds = freezed,}) {
  return _then(_TransferPreview(
resolvedWorkItemIds: freezed == resolvedWorkItemIds ? _self._resolvedWorkItemIds : resolvedWorkItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,fileCount: null == fileCount ? _self.fileCount : fileCount // ignore: cast_nullable_to_non_nullable
as int,fileTotalBytes: null == fileTotalBytes ? _self.fileTotalBytes : fileTotalBytes // ignore: cast_nullable_to_non_nullable
as int,preservedDependencyCount: null == preservedDependencyCount ? _self.preservedDependencyCount : preservedDependencyCount // ignore: cast_nullable_to_non_nullable
as int,missingAccess: null == missingAccess ? _self.missingAccess : missingAccess // ignore: cast_nullable_to_non_nullable
as bool,grantedMemberships: null == grantedMemberships ? _self._grantedMemberships : grantedMemberships // ignore: cast_nullable_to_non_nullable
as List<GrantedMembership>,blockers: null == blockers ? _self._blockers : blockers // ignore: cast_nullable_to_non_nullable
as List<String>,warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,canExecute: null == canExecute ? _self.canExecute : canExecute // ignore: cast_nullable_to_non_nullable
as bool,previewFingerprint: null == previewFingerprint ? _self.previewFingerprint : previewFingerprint // ignore: cast_nullable_to_non_nullable
as String,unresolvedWorkItemIds: freezed == unresolvedWorkItemIds ? _self._unresolvedWorkItemIds : unresolvedWorkItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,missingFileIds: freezed == missingFileIds ? _self._missingFileIds : missingFileIds // ignore: cast_nullable_to_non_nullable
as List<String>?,cutDependencyIds: freezed == cutDependencyIds ? _self._cutDependencyIds : cutDependencyIds // ignore: cast_nullable_to_non_nullable
as List<String>?,cycleWorkItemIds: freezed == cycleWorkItemIds ? _self._cycleWorkItemIds : cycleWorkItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
