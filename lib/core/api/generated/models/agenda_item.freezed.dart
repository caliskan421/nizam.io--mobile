// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agenda_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AgendaItem {

@JsonKey(name: 'agenda_item_id') String get agendaItemId;@JsonKey(name: 'meeting_id') String get meetingId; String get title;@JsonKey(name: 'sort_order') int get sortOrder;@JsonKey(name: 'is_checked') bool get isChecked;@JsonKey(name: 'checked_at') DateTime? get checkedAt;@JsonKey(name: 'checked_by_account_id') String? get checkedByAccountId;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of AgendaItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgendaItemCopyWith<AgendaItem> get copyWith => _$AgendaItemCopyWithImpl<AgendaItem>(this as AgendaItem, _$identity);

  /// Serializes this AgendaItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AgendaItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgendaItem&&(identical(other.agendaItemId, _this.agendaItemId) || other.agendaItemId == _this.agendaItemId)&&(identical(other.meetingId, _this.meetingId) || other.meetingId == _this.meetingId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder)&&(identical(other.isChecked, _this.isChecked) || other.isChecked == _this.isChecked)&&(identical(other.checkedAt, _this.checkedAt) || other.checkedAt == _this.checkedAt)&&(identical(other.checkedByAccountId, _this.checkedByAccountId) || other.checkedByAccountId == _this.checkedByAccountId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AgendaItem;
  return Object.hash(runtimeType,_this.agendaItemId,_this.meetingId,_this.title,_this.sortOrder,_this.isChecked,_this.checkedAt,_this.checkedByAccountId,_this.createdAt);
}

@override
String toString() {
  final _this = this as AgendaItem;
  return 'AgendaItem(agendaItemId: ${_this.agendaItemId}, meetingId: ${_this.meetingId}, title: ${_this.title}, sortOrder: ${_this.sortOrder}, isChecked: ${_this.isChecked}, checkedAt: ${_this.checkedAt}, checkedByAccountId: ${_this.checkedByAccountId}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $AgendaItemCopyWith<$Res>  {
  factory $AgendaItemCopyWith(AgendaItem value, $Res Function(AgendaItem) _then) = _$AgendaItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'agenda_item_id') String agendaItemId,@JsonKey(name: 'meeting_id') String meetingId, String title,@JsonKey(name: 'sort_order') int sortOrder,@JsonKey(name: 'is_checked') bool isChecked,@JsonKey(name: 'checked_at') DateTime? checkedAt,@JsonKey(name: 'checked_by_account_id') String? checkedByAccountId,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$AgendaItemCopyWithImpl<$Res>
    implements $AgendaItemCopyWith<$Res> {
  _$AgendaItemCopyWithImpl(this._self, this._then);

  final AgendaItem _self;
  final $Res Function(AgendaItem) _then;

/// Create a copy of AgendaItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? agendaItemId = null,Object? meetingId = null,Object? title = null,Object? sortOrder = null,Object? isChecked = null,Object? checkedAt = freezed,Object? checkedByAccountId = freezed,Object? createdAt = null,}) {
  return _then(AgendaItem(
agendaItemId: null == agendaItemId ? _self.agendaItemId : agendaItemId // ignore: cast_nullable_to_non_nullable
as String,meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isChecked: null == isChecked ? _self.isChecked : isChecked // ignore: cast_nullable_to_non_nullable
as bool,checkedAt: freezed == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkedByAccountId: freezed == checkedByAccountId ? _self.checkedByAccountId : checkedByAccountId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AgendaItem].
extension AgendaItemPatterns on AgendaItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgendaItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgendaItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgendaItem value)  $default,){
final _that = this;
switch (_that) {
case _AgendaItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgendaItem value)?  $default,){
final _that = this;
switch (_that) {
case _AgendaItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'agenda_item_id')  String agendaItemId, @JsonKey(name: 'meeting_id')  String meetingId,  String title, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_checked')  bool isChecked, @JsonKey(name: 'checked_at')  DateTime? checkedAt, @JsonKey(name: 'checked_by_account_id')  String? checkedByAccountId, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgendaItem() when $default != null:
return $default(_that.agendaItemId,_that.meetingId,_that.title,_that.sortOrder,_that.isChecked,_that.checkedAt,_that.checkedByAccountId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'agenda_item_id')  String agendaItemId, @JsonKey(name: 'meeting_id')  String meetingId,  String title, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_checked')  bool isChecked, @JsonKey(name: 'checked_at')  DateTime? checkedAt, @JsonKey(name: 'checked_by_account_id')  String? checkedByAccountId, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AgendaItem():
return $default(_that.agendaItemId,_that.meetingId,_that.title,_that.sortOrder,_that.isChecked,_that.checkedAt,_that.checkedByAccountId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'agenda_item_id')  String agendaItemId, @JsonKey(name: 'meeting_id')  String meetingId,  String title, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_checked')  bool isChecked, @JsonKey(name: 'checked_at')  DateTime? checkedAt, @JsonKey(name: 'checked_by_account_id')  String? checkedByAccountId, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AgendaItem() when $default != null:
return $default(_that.agendaItemId,_that.meetingId,_that.title,_that.sortOrder,_that.isChecked,_that.checkedAt,_that.checkedByAccountId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgendaItem implements AgendaItem {
  const _AgendaItem({@JsonKey(name: 'agenda_item_id') required this.agendaItemId, @JsonKey(name: 'meeting_id') required this.meetingId, required this.title, @JsonKey(name: 'sort_order') required this.sortOrder, @JsonKey(name: 'is_checked') required this.isChecked, @JsonKey(name: 'checked_at') required this.checkedAt, @JsonKey(name: 'checked_by_account_id') required this.checkedByAccountId, @JsonKey(name: 'created_at') required this.createdAt});
  factory _AgendaItem.fromJson(Map<String, dynamic> json) => _$AgendaItemFromJson(json);

@override@JsonKey(name: 'agenda_item_id') final  String agendaItemId;
@override@JsonKey(name: 'meeting_id') final  String meetingId;
@override final  String title;
@override@JsonKey(name: 'sort_order') final  int sortOrder;
@override@JsonKey(name: 'is_checked') final  bool isChecked;
@override@JsonKey(name: 'checked_at') final  DateTime? checkedAt;
@override@JsonKey(name: 'checked_by_account_id') final  String? checkedByAccountId;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of AgendaItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgendaItemCopyWith<_AgendaItem> get copyWith => __$AgendaItemCopyWithImpl<_AgendaItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgendaItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgendaItem&&(identical(other.agendaItemId, agendaItemId) || other.agendaItemId == agendaItemId)&&(identical(other.meetingId, meetingId) || other.meetingId == meetingId)&&(identical(other.title, title) || other.title == title)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isChecked, isChecked) || other.isChecked == isChecked)&&(identical(other.checkedAt, checkedAt) || other.checkedAt == checkedAt)&&(identical(other.checkedByAccountId, checkedByAccountId) || other.checkedByAccountId == checkedByAccountId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,agendaItemId,meetingId,title,sortOrder,isChecked,checkedAt,checkedByAccountId,createdAt);
}

@override
String toString() {
    return 'AgendaItem(agendaItemId: $agendaItemId, meetingId: $meetingId, title: $title, sortOrder: $sortOrder, isChecked: $isChecked, checkedAt: $checkedAt, checkedByAccountId: $checkedByAccountId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AgendaItemCopyWith<$Res> implements $AgendaItemCopyWith<$Res> {
  factory _$AgendaItemCopyWith(_AgendaItem value, $Res Function(_AgendaItem) _then) = __$AgendaItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'agenda_item_id') String agendaItemId,@JsonKey(name: 'meeting_id') String meetingId, String title,@JsonKey(name: 'sort_order') int sortOrder,@JsonKey(name: 'is_checked') bool isChecked,@JsonKey(name: 'checked_at') DateTime? checkedAt,@JsonKey(name: 'checked_by_account_id') String? checkedByAccountId,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$AgendaItemCopyWithImpl<$Res>
    implements _$AgendaItemCopyWith<$Res> {
  __$AgendaItemCopyWithImpl(this._self, this._then);

  final _AgendaItem _self;
  final $Res Function(_AgendaItem) _then;

/// Create a copy of AgendaItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? agendaItemId = null,Object? meetingId = null,Object? title = null,Object? sortOrder = null,Object? isChecked = null,Object? checkedAt = freezed,Object? checkedByAccountId = freezed,Object? createdAt = null,}) {
  return _then(_AgendaItem(
agendaItemId: null == agendaItemId ? _self.agendaItemId : agendaItemId // ignore: cast_nullable_to_non_nullable
as String,meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isChecked: null == isChecked ? _self.isChecked : isChecked // ignore: cast_nullable_to_non_nullable
as bool,checkedAt: freezed == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkedByAccountId: freezed == checkedByAccountId ? _self.checkedByAccountId : checkedByAccountId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
