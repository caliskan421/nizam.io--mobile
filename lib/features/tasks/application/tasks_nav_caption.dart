import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasks_nav_caption.g.dart';

/// Alt menüde bu modül etkinken görünen mono alt yazı (ör. "76 görev"); null → yok.
@riverpod
String? tasksNavCaption(Ref ref) => null;
