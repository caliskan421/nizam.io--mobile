// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_preference.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationPreference {

/// Olay türü önekinden türeyen push grubu (work → gorev, collaboration/meetings → toplanti, mesaj olayları → mesaj, diğer → sistem).
 NotificationPreferenceGroup get group;@JsonKey(name: 'push_muted') bool get pushMuted;
/// Create a copy of NotificationPreference
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPreferenceCopyWith<NotificationPreference> get copyWith => _$NotificationPreferenceCopyWithImpl<NotificationPreference>(this as NotificationPreference, _$identity);

  /// Serializes this NotificationPreference to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NotificationPreference;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPreference&&(identical(other.group, _this.group) || other.group == _this.group)&&(identical(other.pushMuted, _this.pushMuted) || other.pushMuted == _this.pushMuted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NotificationPreference;
  return Object.hash(runtimeType,_this.group,_this.pushMuted);
}

@override
String toString() {
  final _this = this as NotificationPreference;
  return 'NotificationPreference(group: ${_this.group}, pushMuted: ${_this.pushMuted})';
}


}

/// @nodoc
abstract mixin class $NotificationPreferenceCopyWith<$Res>  {
  factory $NotificationPreferenceCopyWith(NotificationPreference value, $Res Function(NotificationPreference) _then) = _$NotificationPreferenceCopyWithImpl;
@useResult
$Res call({
 NotificationPreferenceGroup group,@JsonKey(name: 'push_muted') bool pushMuted
});




}
/// @nodoc
class _$NotificationPreferenceCopyWithImpl<$Res>
    implements $NotificationPreferenceCopyWith<$Res> {
  _$NotificationPreferenceCopyWithImpl(this._self, this._then);

  final NotificationPreference _self;
  final $Res Function(NotificationPreference) _then;

/// Create a copy of NotificationPreference
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? group = null,Object? pushMuted = null,}) {
  return _then(NotificationPreference(
group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as NotificationPreferenceGroup,pushMuted: null == pushMuted ? _self.pushMuted : pushMuted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationPreference].
extension NotificationPreferencePatterns on NotificationPreference {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPreference value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPreference() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPreference value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPreference():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPreference value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPreference() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NotificationPreferenceGroup group, @JsonKey(name: 'push_muted')  bool pushMuted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPreference() when $default != null:
return $default(_that.group,_that.pushMuted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NotificationPreferenceGroup group, @JsonKey(name: 'push_muted')  bool pushMuted)  $default,) {final _that = this;
switch (_that) {
case _NotificationPreference():
return $default(_that.group,_that.pushMuted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NotificationPreferenceGroup group, @JsonKey(name: 'push_muted')  bool pushMuted)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPreference() when $default != null:
return $default(_that.group,_that.pushMuted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationPreference implements NotificationPreference {
  const _NotificationPreference({required this.group, @JsonKey(name: 'push_muted') required this.pushMuted});
  factory _NotificationPreference.fromJson(Map<String, dynamic> json) => _$NotificationPreferenceFromJson(json);

/// Olay türü önekinden türeyen push grubu (work → gorev, collaboration/meetings → toplanti, mesaj olayları → mesaj, diğer → sistem).
@override final  NotificationPreferenceGroup group;
@override@JsonKey(name: 'push_muted') final  bool pushMuted;

/// Create a copy of NotificationPreference
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPreferenceCopyWith<_NotificationPreference> get copyWith => __$NotificationPreferenceCopyWithImpl<_NotificationPreference>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationPreferenceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPreference&&(identical(other.group, group) || other.group == group)&&(identical(other.pushMuted, pushMuted) || other.pushMuted == pushMuted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,group,pushMuted);
}

@override
String toString() {
    return 'NotificationPreference(group: $group, pushMuted: $pushMuted)';
}


}

/// @nodoc
abstract mixin class _$NotificationPreferenceCopyWith<$Res> implements $NotificationPreferenceCopyWith<$Res> {
  factory _$NotificationPreferenceCopyWith(_NotificationPreference value, $Res Function(_NotificationPreference) _then) = __$NotificationPreferenceCopyWithImpl;
@override @useResult
$Res call({
 NotificationPreferenceGroup group,@JsonKey(name: 'push_muted') bool pushMuted
});




}
/// @nodoc
class __$NotificationPreferenceCopyWithImpl<$Res>
    implements _$NotificationPreferenceCopyWith<$Res> {
  __$NotificationPreferenceCopyWithImpl(this._self, this._then);

  final _NotificationPreference _self;
  final $Res Function(_NotificationPreference) _then;

/// Create a copy of NotificationPreference
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? group = null,Object? pushMuted = null,}) {
  return _then(_NotificationPreference(
group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as NotificationPreferenceGroup,pushMuted: null == pushMuted ? _self.pushMuted : pushMuted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
