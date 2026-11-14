// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_project_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
TableProjectCommand _$TableProjectCommandFromJson(
  Map<String, dynamic> json
) {
        switch (json['kind']) {
                  case 'create_project':
          return TableProjectCommandCreateProject.fromJson(
            json
          );
                case 'rename_project':
          return TableProjectCommandRenameProject.fromJson(
            json
          );
                case 'delete_project':
          return TableProjectCommandDeleteProject.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'kind',
  'TableProjectCommand',
  'Invalid union type "${json['kind']}"!'
);
        }
      
}

/// @nodoc
mixin _$TableProjectCommand {

 Enum get kind;

  /// Serializes this TableProjectCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableProjectCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableProjectCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableProjectCommand;
  return Object.hash(runtimeType,_this.kind);
}

@override
String toString() {
  final _this = this as TableProjectCommand;
  return 'TableProjectCommand(kind: ${_this.kind})';
}


}

/// @nodoc
class $TableProjectCommandCopyWith<$Res>  {
$TableProjectCommandCopyWith(TableProjectCommand _, $Res Function(TableProjectCommand) __);
}


/// Adds pattern-matching-related methods to [TableProjectCommand].
extension TableProjectCommandPatterns on TableProjectCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TableProjectCommandCreateProject value)?  createProject,TResult Function( TableProjectCommandRenameProject value)?  renameProject,TResult Function( TableProjectCommandDeleteProject value)?  deleteProject,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TableProjectCommandCreateProject() when createProject != null:
return createProject(_that);case TableProjectCommandRenameProject() when renameProject != null:
return renameProject(_that);case TableProjectCommandDeleteProject() when deleteProject != null:
return deleteProject(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TableProjectCommandCreateProject value)  createProject,required TResult Function( TableProjectCommandRenameProject value)  renameProject,required TResult Function( TableProjectCommandDeleteProject value)  deleteProject,}){
final _that = this;
switch (_that) {
case TableProjectCommandCreateProject():
return createProject(_that);case TableProjectCommandRenameProject():
return renameProject(_that);case TableProjectCommandDeleteProject():
return deleteProject(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TableProjectCommandCreateProject value)?  createProject,TResult? Function( TableProjectCommandRenameProject value)?  renameProject,TResult? Function( TableProjectCommandDeleteProject value)?  deleteProject,}){
final _that = this;
switch (_that) {
case TableProjectCommandCreateProject() when createProject != null:
return createProject(_that);case TableProjectCommandRenameProject() when renameProject != null:
return renameProject(_that);case TableProjectCommandDeleteProject() when deleteProject != null:
return deleteProject(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( TableCreateProjectCommandKind kind,  String name)?  createProject,TResult Function( TableRenameProjectCommandKind kind,  String id,  String name)?  renameProject,TResult Function( TableDeleteProjectCommandKind kind,  String id)?  deleteProject,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TableProjectCommandCreateProject() when createProject != null:
return createProject(_that.kind,_that.name);case TableProjectCommandRenameProject() when renameProject != null:
return renameProject(_that.kind,_that.id,_that.name);case TableProjectCommandDeleteProject() when deleteProject != null:
return deleteProject(_that.kind,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( TableCreateProjectCommandKind kind,  String name)  createProject,required TResult Function( TableRenameProjectCommandKind kind,  String id,  String name)  renameProject,required TResult Function( TableDeleteProjectCommandKind kind,  String id)  deleteProject,}) {final _that = this;
switch (_that) {
case TableProjectCommandCreateProject():
return createProject(_that.kind,_that.name);case TableProjectCommandRenameProject():
return renameProject(_that.kind,_that.id,_that.name);case TableProjectCommandDeleteProject():
return deleteProject(_that.kind,_that.id);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( TableCreateProjectCommandKind kind,  String name)?  createProject,TResult? Function( TableRenameProjectCommandKind kind,  String id,  String name)?  renameProject,TResult? Function( TableDeleteProjectCommandKind kind,  String id)?  deleteProject,}) {final _that = this;
switch (_that) {
case TableProjectCommandCreateProject() when createProject != null:
return createProject(_that.kind,_that.name);case TableProjectCommandRenameProject() when renameProject != null:
return renameProject(_that.kind,_that.id,_that.name);case TableProjectCommandDeleteProject() when deleteProject != null:
return deleteProject(_that.kind,_that.id);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class TableProjectCommandCreateProject implements TableProjectCommand {
  const TableProjectCommandCreateProject({required this.kind, required this.name});
  factory TableProjectCommandCreateProject.fromJson(Map<String, dynamic> json) => _$TableProjectCommandCreateProjectFromJson(json);

@override final  TableCreateProjectCommandKind kind;
 final  String name;

/// Create a copy of TableProjectCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableProjectCommandCreateProjectCopyWith<TableProjectCommandCreateProject> get copyWith => _$TableProjectCommandCreateProjectCopyWithImpl<TableProjectCommandCreateProject>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableProjectCommandCreateProjectToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableProjectCommandCreateProject&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,name);
}

@override
String toString() {
    return 'TableProjectCommand.createProject(kind: $kind, name: $name)';
}


}

/// @nodoc
abstract mixin class $TableProjectCommandCreateProjectCopyWith<$Res> implements $TableProjectCommandCopyWith<$Res> {
  factory $TableProjectCommandCreateProjectCopyWith(TableProjectCommandCreateProject value, $Res Function(TableProjectCommandCreateProject) _then) = _$TableProjectCommandCreateProjectCopyWithImpl;
@useResult
$Res call({
 TableCreateProjectCommandKind kind, String name
});




}
/// @nodoc
class _$TableProjectCommandCreateProjectCopyWithImpl<$Res>
    implements $TableProjectCommandCreateProjectCopyWith<$Res> {
  _$TableProjectCommandCreateProjectCopyWithImpl(this._self, this._then);

  final TableProjectCommandCreateProject _self;
  final $Res Function(TableProjectCommandCreateProject) _then;

/// Create a copy of TableProjectCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? name = null,}) {
  return _then(TableProjectCommandCreateProject(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableCreateProjectCommandKind,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableProjectCommandRenameProject implements TableProjectCommand {
  const TableProjectCommandRenameProject({required this.kind, required this.id, required this.name});
  factory TableProjectCommandRenameProject.fromJson(Map<String, dynamic> json) => _$TableProjectCommandRenameProjectFromJson(json);

@override final  TableRenameProjectCommandKind kind;
 final  String id;
 final  String name;

/// Create a copy of TableProjectCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableProjectCommandRenameProjectCopyWith<TableProjectCommandRenameProject> get copyWith => _$TableProjectCommandRenameProjectCopyWithImpl<TableProjectCommandRenameProject>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableProjectCommandRenameProjectToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableProjectCommandRenameProject&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id,name);
}

@override
String toString() {
    return 'TableProjectCommand.renameProject(kind: $kind, id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $TableProjectCommandRenameProjectCopyWith<$Res> implements $TableProjectCommandCopyWith<$Res> {
  factory $TableProjectCommandRenameProjectCopyWith(TableProjectCommandRenameProject value, $Res Function(TableProjectCommandRenameProject) _then) = _$TableProjectCommandRenameProjectCopyWithImpl;
@useResult
$Res call({
 TableRenameProjectCommandKind kind, String id, String name
});




}
/// @nodoc
class _$TableProjectCommandRenameProjectCopyWithImpl<$Res>
    implements $TableProjectCommandRenameProjectCopyWith<$Res> {
  _$TableProjectCommandRenameProjectCopyWithImpl(this._self, this._then);

  final TableProjectCommandRenameProject _self;
  final $Res Function(TableProjectCommandRenameProject) _then;

/// Create a copy of TableProjectCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,Object? name = null,}) {
  return _then(TableProjectCommandRenameProject(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableRenameProjectCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableProjectCommandDeleteProject implements TableProjectCommand {
  const TableProjectCommandDeleteProject({required this.kind, required this.id});
  factory TableProjectCommandDeleteProject.fromJson(Map<String, dynamic> json) => _$TableProjectCommandDeleteProjectFromJson(json);

@override final  TableDeleteProjectCommandKind kind;
 final  String id;

/// Create a copy of TableProjectCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableProjectCommandDeleteProjectCopyWith<TableProjectCommandDeleteProject> get copyWith => _$TableProjectCommandDeleteProjectCopyWithImpl<TableProjectCommandDeleteProject>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableProjectCommandDeleteProjectToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TableProjectCommandDeleteProject&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id);
}

@override
String toString() {
    return 'TableProjectCommand.deleteProject(kind: $kind, id: $id)';
}


}

/// @nodoc
abstract mixin class $TableProjectCommandDeleteProjectCopyWith<$Res> implements $TableProjectCommandCopyWith<$Res> {
  factory $TableProjectCommandDeleteProjectCopyWith(TableProjectCommandDeleteProject value, $Res Function(TableProjectCommandDeleteProject) _then) = _$TableProjectCommandDeleteProjectCopyWithImpl;
@useResult
$Res call({
 TableDeleteProjectCommandKind kind, String id
});




}
/// @nodoc
class _$TableProjectCommandDeleteProjectCopyWithImpl<$Res>
    implements $TableProjectCommandDeleteProjectCopyWith<$Res> {
  _$TableProjectCommandDeleteProjectCopyWithImpl(this._self, this._then);

  final TableProjectCommandDeleteProject _self;
  final $Res Function(TableProjectCommandDeleteProject) _then;

/// Create a copy of TableProjectCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,}) {
  return _then(TableProjectCommandDeleteProject(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableDeleteProjectCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
