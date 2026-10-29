// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_agenda_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportAgendaItem {

 String get title;@JsonKey(name: 'is_checked') bool get isChecked;
/// Create a copy of ReportAgendaItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportAgendaItemCopyWith<ReportAgendaItem> get copyWith => _$ReportAgendaItemCopyWithImpl<ReportAgendaItem>(this as ReportAgendaItem, _$identity);

  /// Serializes this ReportAgendaItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportAgendaItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportAgendaItem&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.isChecked, _this.isChecked) || other.isChecked == _this.isChecked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportAgendaItem;
  return Object.hash(runtimeType,_this.title,_this.isChecked);
}

@override
String toString() {
  final _this = this as ReportAgendaItem;
  return 'ReportAgendaItem(title: ${_this.title}, isChecked: ${_this.isChecked})';
}


}

/// @nodoc
abstract mixin class $ReportAgendaItemCopyWith<$Res>  {
  factory $ReportAgendaItemCopyWith(ReportAgendaItem value, $Res Function(ReportAgendaItem) _then) = _$ReportAgendaItemCopyWithImpl;
@useResult
$Res call({
 String title,@JsonKey(name: 'is_checked') bool isChecked
});




}
/// @nodoc
class _$ReportAgendaItemCopyWithImpl<$Res>
    implements $ReportAgendaItemCopyWith<$Res> {
  _$ReportAgendaItemCopyWithImpl(this._self, this._then);

  final ReportAgendaItem _self;
  final $Res Function(ReportAgendaItem) _then;

/// Create a copy of ReportAgendaItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? isChecked = null,}) {
  return _then(ReportAgendaItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isChecked: null == isChecked ? _self.isChecked : isChecked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportAgendaItem].
extension ReportAgendaItemPatterns on ReportAgendaItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportAgendaItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportAgendaItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportAgendaItem value)  $default,){
final _that = this;
switch (_that) {
case _ReportAgendaItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportAgendaItem value)?  $default,){
final _that = this;
switch (_that) {
case _ReportAgendaItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title, @JsonKey(name: 'is_checked')  bool isChecked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportAgendaItem() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title, @JsonKey(name: 'is_checked')  bool isChecked)  $default,) {final _that = this;
switch (_that) {
case _ReportAgendaItem():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title, @JsonKey(name: 'is_checked')  bool isChecked)?  $default,) {final _that = this;
switch (_that) {
case _ReportAgendaItem() when $default != null:
return $default(_that.title,_that.isChecked);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportAgendaItem implements ReportAgendaItem {
  const _ReportAgendaItem({required this.title, @JsonKey(name: 'is_checked') required this.isChecked});
  factory _ReportAgendaItem.fromJson(Map<String, dynamic> json) => _$ReportAgendaItemFromJson(json);

@override final  String title;
@override@JsonKey(name: 'is_checked') final  bool isChecked;

/// Create a copy of ReportAgendaItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportAgendaItemCopyWith<_ReportAgendaItem> get copyWith => __$ReportAgendaItemCopyWithImpl<_ReportAgendaItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportAgendaItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportAgendaItem&&(identical(other.title, title) || other.title == title)&&(identical(other.isChecked, isChecked) || other.isChecked == isChecked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,isChecked);
}

@override
String toString() {
    return 'ReportAgendaItem(title: $title, isChecked: $isChecked)';
}


}

/// @nodoc
abstract mixin class _$ReportAgendaItemCopyWith<$Res> implements $ReportAgendaItemCopyWith<$Res> {
  factory _$ReportAgendaItemCopyWith(_ReportAgendaItem value, $Res Function(_ReportAgendaItem) _then) = __$ReportAgendaItemCopyWithImpl;
@override @useResult
$Res call({
 String title,@JsonKey(name: 'is_checked') bool isChecked
});




}
/// @nodoc
class __$ReportAgendaItemCopyWithImpl<$Res>
    implements _$ReportAgendaItemCopyWith<$Res> {
  __$ReportAgendaItemCopyWithImpl(this._self, this._then);

  final _ReportAgendaItem _self;
  final $Res Function(_ReportAgendaItem) _then;

/// Create a copy of ReportAgendaItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? isChecked = null,}) {
  return _then(_ReportAgendaItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isChecked: null == isChecked ? _self.isChecked : isChecked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
