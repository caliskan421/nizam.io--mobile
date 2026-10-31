// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransferResult {

@JsonKey(name: 'transfer_id') String get transferId;@JsonKey(name: 'moved_work_item_ids') List<String>? get movedWorkItemIds;@JsonKey(name: 'moved_file_count') int get movedFileCount;@JsonKey(name: 'cut_dependency_count') int get cutDependencyCount;@JsonKey(name: 'restored_dependency_count') int get restoredDependencyCount;@JsonKey(name: 'granted_links') List<String> get grantedLinks;@JsonKey(name: 'revoked_links') List<String> get revokedLinks;/// Ters aktarımda tersine çevrilen aktarımın kurduğu ama geri alınmayan bağların departman kimlikleri. Bağ, çiftte canlı görev kaldıysa ya da aktarımın eklediği satırlar silindikten sonra çiftin ekibinde aktarım dışı satır (elle eklenen, yeniden eklenen ya da artık `uye` olmayan) kaldıysa korunur (ADR-0023 kural 12).
@JsonKey(name: 'retained_links') List<String> get retainedLinks;/// Aktarımın hedef programın departman ekibine `uye` olarak eklediği (ön izlemede ekleyeceği) atanan kişiler (ADR-0023 kural 12).
@JsonKey(name: 'granted_memberships') List<GrantedMembership> get grantedMemberships; bool get replayed;@JsonKey(name: 'skipped_work_item_ids') List<String>? get skippedWorkItemIds;
/// Create a copy of TransferResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferResultCopyWith<TransferResult> get copyWith => _$TransferResultCopyWithImpl<TransferResult>(this as TransferResult, _$identity);

  /// Serializes this TransferResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransferResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferResult&&(identical(other.transferId, _this.transferId) || other.transferId == _this.transferId)&&const DeepCollectionEquality().equals(other.movedWorkItemIds, _this.movedWorkItemIds)&&(identical(other.movedFileCount, _this.movedFileCount) || other.movedFileCount == _this.movedFileCount)&&(identical(other.cutDependencyCount, _this.cutDependencyCount) || other.cutDependencyCount == _this.cutDependencyCount)&&(identical(other.restoredDependencyCount, _this.restoredDependencyCount) || other.restoredDependencyCount == _this.restoredDependencyCount)&&const DeepCollectionEquality().equals(other.grantedLinks, _this.grantedLinks)&&const DeepCollectionEquality().equals(other.revokedLinks, _this.revokedLinks)&&const DeepCollectionEquality().equals(other.retainedLinks, _this.retainedLinks)&&const DeepCollectionEquality().equals(other.grantedMemberships, _this.grantedMemberships)&&(identical(other.replayed, _this.replayed) || other.replayed == _this.replayed)&&const DeepCollectionEquality().equals(other.skippedWorkItemIds, _this.skippedWorkItemIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransferResult;
  return Object.hash(runtimeType,_this.transferId,const DeepCollectionEquality().hash(_this.movedWorkItemIds),_this.movedFileCount,_this.cutDependencyCount,_this.restoredDependencyCount,const DeepCollectionEquality().hash(_this.grantedLinks),const DeepCollectionEquality().hash(_this.revokedLinks),const DeepCollectionEquality().hash(_this.retainedLinks),const DeepCollectionEquality().hash(_this.grantedMemberships),_this.replayed,const DeepCollectionEquality().hash(_this.skippedWorkItemIds));
}

@override
String toString() {
  final _this = this as TransferResult;
  return 'TransferResult(transferId: ${_this.transferId}, movedWorkItemIds: ${_this.movedWorkItemIds}, movedFileCount: ${_this.movedFileCount}, cutDependencyCount: ${_this.cutDependencyCount}, restoredDependencyCount: ${_this.restoredDependencyCount}, grantedLinks: ${_this.grantedLinks}, revokedLinks: ${_this.revokedLinks}, retainedLinks: ${_this.retainedLinks}, grantedMemberships: ${_this.grantedMemberships}, replayed: ${_this.replayed}, skippedWorkItemIds: ${_this.skippedWorkItemIds})';
}


}

/// @nodoc
abstract mixin class $TransferResultCopyWith<$Res>  {
  factory $TransferResultCopyWith(TransferResult value, $Res Function(TransferResult) _then) = _$TransferResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'transfer_id') String transferId,@JsonKey(name: 'moved_work_item_ids') List<String>? movedWorkItemIds,@JsonKey(name: 'moved_file_count') int movedFileCount,@JsonKey(name: 'cut_dependency_count') int cutDependencyCount,@JsonKey(name: 'restored_dependency_count') int restoredDependencyCount,@JsonKey(name: 'granted_links') List<String> grantedLinks,@JsonKey(name: 'revoked_links') List<String> revokedLinks,@JsonKey(name: 'retained_links') List<String> retainedLinks,@JsonKey(name: 'granted_memberships') List<GrantedMembership> grantedMemberships, bool replayed,@JsonKey(name: 'skipped_work_item_ids') List<String>? skippedWorkItemIds
});




}
/// @nodoc
class _$TransferResultCopyWithImpl<$Res>
    implements $TransferResultCopyWith<$Res> {
  _$TransferResultCopyWithImpl(this._self, this._then);

  final TransferResult _self;
  final $Res Function(TransferResult) _then;

/// Create a copy of TransferResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transferId = null,Object? movedWorkItemIds = freezed,Object? movedFileCount = null,Object? cutDependencyCount = null,Object? restoredDependencyCount = null,Object? grantedLinks = null,Object? revokedLinks = null,Object? retainedLinks = null,Object? grantedMemberships = null,Object? replayed = null,Object? skippedWorkItemIds = freezed,}) {
  return _then(TransferResult(
transferId: null == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String,movedWorkItemIds: freezed == movedWorkItemIds ? _self.movedWorkItemIds : movedWorkItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,movedFileCount: null == movedFileCount ? _self.movedFileCount : movedFileCount // ignore: cast_nullable_to_non_nullable
as int,cutDependencyCount: null == cutDependencyCount ? _self.cutDependencyCount : cutDependencyCount // ignore: cast_nullable_to_non_nullable
as int,restoredDependencyCount: null == restoredDependencyCount ? _self.restoredDependencyCount : restoredDependencyCount // ignore: cast_nullable_to_non_nullable
as int,grantedLinks: null == grantedLinks ? _self.grantedLinks : grantedLinks // ignore: cast_nullable_to_non_nullable
as List<String>,revokedLinks: null == revokedLinks ? _self.revokedLinks : revokedLinks // ignore: cast_nullable_to_non_nullable
as List<String>,retainedLinks: null == retainedLinks ? _self.retainedLinks : retainedLinks // ignore: cast_nullable_to_non_nullable
as List<String>,grantedMemberships: null == grantedMemberships ? _self.grantedMemberships : grantedMemberships // ignore: cast_nullable_to_non_nullable
as List<GrantedMembership>,replayed: null == replayed ? _self.replayed : replayed // ignore: cast_nullable_to_non_nullable
as bool,skippedWorkItemIds: freezed == skippedWorkItemIds ? _self.skippedWorkItemIds : skippedWorkItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferResult].
extension TransferResultPatterns on TransferResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferResult value)  $default,){
final _that = this;
switch (_that) {
case _TransferResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferResult value)?  $default,){
final _that = this;
switch (_that) {
case _TransferResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'transfer_id')  String transferId, @JsonKey(name: 'moved_work_item_ids')  List<String>? movedWorkItemIds, @JsonKey(name: 'moved_file_count')  int movedFileCount, @JsonKey(name: 'cut_dependency_count')  int cutDependencyCount, @JsonKey(name: 'restored_dependency_count')  int restoredDependencyCount, @JsonKey(name: 'granted_links')  List<String> grantedLinks, @JsonKey(name: 'revoked_links')  List<String> revokedLinks, @JsonKey(name: 'retained_links')  List<String> retainedLinks, @JsonKey(name: 'granted_memberships')  List<GrantedMembership> grantedMemberships,  bool replayed, @JsonKey(name: 'skipped_work_item_ids')  List<String>? skippedWorkItemIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferResult() when $default != null:
return $default(_that.transferId,_that.movedWorkItemIds,_that.movedFileCount,_that.cutDependencyCount,_that.restoredDependencyCount,_that.grantedLinks,_that.revokedLinks,_that.retainedLinks,_that.grantedMemberships,_that.replayed,_that.skippedWorkItemIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'transfer_id')  String transferId, @JsonKey(name: 'moved_work_item_ids')  List<String>? movedWorkItemIds, @JsonKey(name: 'moved_file_count')  int movedFileCount, @JsonKey(name: 'cut_dependency_count')  int cutDependencyCount, @JsonKey(name: 'restored_dependency_count')  int restoredDependencyCount, @JsonKey(name: 'granted_links')  List<String> grantedLinks, @JsonKey(name: 'revoked_links')  List<String> revokedLinks, @JsonKey(name: 'retained_links')  List<String> retainedLinks, @JsonKey(name: 'granted_memberships')  List<GrantedMembership> grantedMemberships,  bool replayed, @JsonKey(name: 'skipped_work_item_ids')  List<String>? skippedWorkItemIds)  $default,) {final _that = this;
switch (_that) {
case _TransferResult():
return $default(_that.transferId,_that.movedWorkItemIds,_that.movedFileCount,_that.cutDependencyCount,_that.restoredDependencyCount,_that.grantedLinks,_that.revokedLinks,_that.retainedLinks,_that.grantedMemberships,_that.replayed,_that.skippedWorkItemIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'transfer_id')  String transferId, @JsonKey(name: 'moved_work_item_ids')  List<String>? movedWorkItemIds, @JsonKey(name: 'moved_file_count')  int movedFileCount, @JsonKey(name: 'cut_dependency_count')  int cutDependencyCount, @JsonKey(name: 'restored_dependency_count')  int restoredDependencyCount, @JsonKey(name: 'granted_links')  List<String> grantedLinks, @JsonKey(name: 'revoked_links')  List<String> revokedLinks, @JsonKey(name: 'retained_links')  List<String> retainedLinks, @JsonKey(name: 'granted_memberships')  List<GrantedMembership> grantedMemberships,  bool replayed, @JsonKey(name: 'skipped_work_item_ids')  List<String>? skippedWorkItemIds)?  $default,) {final _that = this;
switch (_that) {
case _TransferResult() when $default != null:
return $default(_that.transferId,_that.movedWorkItemIds,_that.movedFileCount,_that.cutDependencyCount,_that.restoredDependencyCount,_that.grantedLinks,_that.revokedLinks,_that.retainedLinks,_that.grantedMemberships,_that.replayed,_that.skippedWorkItemIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransferResult implements TransferResult {
  const _TransferResult({@JsonKey(name: 'transfer_id') required this.transferId, @JsonKey(name: 'moved_work_item_ids') required  List<String>? movedWorkItemIds, @JsonKey(name: 'moved_file_count') required this.movedFileCount, @JsonKey(name: 'cut_dependency_count') required this.cutDependencyCount, @JsonKey(name: 'restored_dependency_count') required this.restoredDependencyCount, @JsonKey(name: 'granted_links') required  List<String> grantedLinks, @JsonKey(name: 'revoked_links') required  List<String> revokedLinks, @JsonKey(name: 'retained_links') required  List<String> retainedLinks, @JsonKey(name: 'granted_memberships') required  List<GrantedMembership> grantedMemberships, required this.replayed, @JsonKey(name: 'skipped_work_item_ids')  List<String>? skippedWorkItemIds}): _movedWorkItemIds = movedWorkItemIds,_grantedLinks = grantedLinks,_revokedLinks = revokedLinks,_retainedLinks = retainedLinks,_grantedMemberships = grantedMemberships,_skippedWorkItemIds = skippedWorkItemIds;
  factory _TransferResult.fromJson(Map<String, dynamic> json) => _$TransferResultFromJson(json);

@override@JsonKey(name: 'transfer_id') final  String transferId;
 final  List<String>? _movedWorkItemIds;
@override@JsonKey(name: 'moved_work_item_ids') List<String>? get movedWorkItemIds {
  final value = _movedWorkItemIds;
  if (value == null) return null;
  if (_movedWorkItemIds is EqualUnmodifiableListView) return _movedWorkItemIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'moved_file_count') final  int movedFileCount;
@override@JsonKey(name: 'cut_dependency_count') final  int cutDependencyCount;
@override@JsonKey(name: 'restored_dependency_count') final  int restoredDependencyCount;
 final  List<String> _grantedLinks;
@override@JsonKey(name: 'granted_links') List<String> get grantedLinks {
  if (_grantedLinks is EqualUnmodifiableListView) return _grantedLinks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_grantedLinks);
}

 final  List<String> _revokedLinks;
@override@JsonKey(name: 'revoked_links') List<String> get revokedLinks {
  if (_revokedLinks is EqualUnmodifiableListView) return _revokedLinks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_revokedLinks);
}

/// Ters aktarımda tersine çevrilen aktarımın kurduğu ama geri alınmayan bağların departman kimlikleri. Bağ, çiftte canlı görev kaldıysa ya da aktarımın eklediği satırlar silindikten sonra çiftin ekibinde aktarım dışı satır (elle eklenen, yeniden eklenen ya da artık `uye` olmayan) kaldıysa korunur (ADR-0023 kural 12).
 final  List<String> _retainedLinks;
/// Ters aktarımda tersine çevrilen aktarımın kurduğu ama geri alınmayan bağların departman kimlikleri. Bağ, çiftte canlı görev kaldıysa ya da aktarımın eklediği satırlar silindikten sonra çiftin ekibinde aktarım dışı satır (elle eklenen, yeniden eklenen ya da artık `uye` olmayan) kaldıysa korunur (ADR-0023 kural 12).
@override@JsonKey(name: 'retained_links') List<String> get retainedLinks {
  if (_retainedLinks is EqualUnmodifiableListView) return _retainedLinks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_retainedLinks);
}

/// Aktarımın hedef programın departman ekibine `uye` olarak eklediği (ön izlemede ekleyeceği) atanan kişiler (ADR-0023 kural 12).
 final  List<GrantedMembership> _grantedMemberships;
/// Aktarımın hedef programın departman ekibine `uye` olarak eklediği (ön izlemede ekleyeceği) atanan kişiler (ADR-0023 kural 12).
@override@JsonKey(name: 'granted_memberships') List<GrantedMembership> get grantedMemberships {
  if (_grantedMemberships is EqualUnmodifiableListView) return _grantedMemberships;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_grantedMemberships);
}

@override final  bool replayed;
 final  List<String>? _skippedWorkItemIds;
@override@JsonKey(name: 'skipped_work_item_ids') List<String>? get skippedWorkItemIds {
  final value = _skippedWorkItemIds;
  if (value == null) return null;
  if (_skippedWorkItemIds is EqualUnmodifiableListView) return _skippedWorkItemIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of TransferResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferResultCopyWith<_TransferResult> get copyWith => __$TransferResultCopyWithImpl<_TransferResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferResult&&(identical(other.transferId, transferId) || other.transferId == transferId)&&const DeepCollectionEquality().equals(other.movedWorkItemIds, _movedWorkItemIds)&&(identical(other.movedFileCount, movedFileCount) || other.movedFileCount == movedFileCount)&&(identical(other.cutDependencyCount, cutDependencyCount) || other.cutDependencyCount == cutDependencyCount)&&(identical(other.restoredDependencyCount, restoredDependencyCount) || other.restoredDependencyCount == restoredDependencyCount)&&const DeepCollectionEquality().equals(other.grantedLinks, _grantedLinks)&&const DeepCollectionEquality().equals(other.revokedLinks, _revokedLinks)&&const DeepCollectionEquality().equals(other.retainedLinks, _retainedLinks)&&const DeepCollectionEquality().equals(other.grantedMemberships, _grantedMemberships)&&(identical(other.replayed, replayed) || other.replayed == replayed)&&const DeepCollectionEquality().equals(other.skippedWorkItemIds, _skippedWorkItemIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,transferId,const DeepCollectionEquality().hash(_movedWorkItemIds),movedFileCount,cutDependencyCount,restoredDependencyCount,const DeepCollectionEquality().hash(_grantedLinks),const DeepCollectionEquality().hash(_revokedLinks),const DeepCollectionEquality().hash(_retainedLinks),const DeepCollectionEquality().hash(_grantedMemberships),replayed,const DeepCollectionEquality().hash(_skippedWorkItemIds));
}

@override
String toString() {
    return 'TransferResult(transferId: $transferId, movedWorkItemIds: $movedWorkItemIds, movedFileCount: $movedFileCount, cutDependencyCount: $cutDependencyCount, restoredDependencyCount: $restoredDependencyCount, grantedLinks: $grantedLinks, revokedLinks: $revokedLinks, retainedLinks: $retainedLinks, grantedMemberships: $grantedMemberships, replayed: $replayed, skippedWorkItemIds: $skippedWorkItemIds)';
}


}

/// @nodoc
abstract mixin class _$TransferResultCopyWith<$Res> implements $TransferResultCopyWith<$Res> {
  factory _$TransferResultCopyWith(_TransferResult value, $Res Function(_TransferResult) _then) = __$TransferResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'transfer_id') String transferId,@JsonKey(name: 'moved_work_item_ids') List<String>? movedWorkItemIds,@JsonKey(name: 'moved_file_count') int movedFileCount,@JsonKey(name: 'cut_dependency_count') int cutDependencyCount,@JsonKey(name: 'restored_dependency_count') int restoredDependencyCount,@JsonKey(name: 'granted_links') List<String> grantedLinks,@JsonKey(name: 'revoked_links') List<String> revokedLinks,@JsonKey(name: 'retained_links') List<String> retainedLinks,@JsonKey(name: 'granted_memberships') List<GrantedMembership> grantedMemberships, bool replayed,@JsonKey(name: 'skipped_work_item_ids') List<String>? skippedWorkItemIds
});




}
/// @nodoc
class __$TransferResultCopyWithImpl<$Res>
    implements _$TransferResultCopyWith<$Res> {
  __$TransferResultCopyWithImpl(this._self, this._then);

  final _TransferResult _self;
  final $Res Function(_TransferResult) _then;

/// Create a copy of TransferResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transferId = null,Object? movedWorkItemIds = freezed,Object? movedFileCount = null,Object? cutDependencyCount = null,Object? restoredDependencyCount = null,Object? grantedLinks = null,Object? revokedLinks = null,Object? retainedLinks = null,Object? grantedMemberships = null,Object? replayed = null,Object? skippedWorkItemIds = freezed,}) {
  return _then(_TransferResult(
transferId: null == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String,movedWorkItemIds: freezed == movedWorkItemIds ? _self._movedWorkItemIds : movedWorkItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,movedFileCount: null == movedFileCount ? _self.movedFileCount : movedFileCount // ignore: cast_nullable_to_non_nullable
as int,cutDependencyCount: null == cutDependencyCount ? _self.cutDependencyCount : cutDependencyCount // ignore: cast_nullable_to_non_nullable
as int,restoredDependencyCount: null == restoredDependencyCount ? _self.restoredDependencyCount : restoredDependencyCount // ignore: cast_nullable_to_non_nullable
as int,grantedLinks: null == grantedLinks ? _self._grantedLinks : grantedLinks // ignore: cast_nullable_to_non_nullable
as List<String>,revokedLinks: null == revokedLinks ? _self._revokedLinks : revokedLinks // ignore: cast_nullable_to_non_nullable
as List<String>,retainedLinks: null == retainedLinks ? _self._retainedLinks : retainedLinks // ignore: cast_nullable_to_non_nullable
as List<String>,grantedMemberships: null == grantedMemberships ? _self._grantedMemberships : grantedMemberships // ignore: cast_nullable_to_non_nullable
as List<GrantedMembership>,replayed: null == replayed ? _self.replayed : replayed // ignore: cast_nullable_to_non_nullable
as bool,skippedWorkItemIds: freezed == skippedWorkItemIds ? _self._skippedWorkItemIds : skippedWorkItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
