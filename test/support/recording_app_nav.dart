// Sayfa testleri için NzAppNav sahtesi: gezinme niyetlerini sırayla kaydeder.
import 'package:flutter/widgets.dart';
import 'package:nizamio/core/ui/page/nz_app_nav.dart';

class RecordingAppNav implements NzAppNav {
  final calls = <String>[];

  @override
  void openHome() => calls.add('home');

  @override
  void openHistory() => calls.add('history');

  @override
  void openTasks({NzTaskView? view, List<String> people = const []}) =>
      calls.add(
        [
          'tasks',
          if (view != null) view.name,
          if (people.isNotEmpty) people.join(','),
        ].join(':'),
      );

  @override
  void openTask(String code) => calls.add('task:$code');

  @override
  void openCalendar() => calls.add('calendar');

  @override
  void openTimeline({String? coordinatorship}) =>
      calls.add(['timeline', ?coordinatorship].join(':'));

  @override
  void openCoordinatorships() => calls.add('coordinatorships');

  @override
  void openCoordinatorship(String code) => calls.add('coord:$code');

  @override
  void openArchive() => calls.add('archive');

  @override
  void openArchiveFolder(String code) => calls.add('folder:$code');

  @override
  void openMessages() => calls.add('messages');

  @override
  void openChat(String id) => calls.add('chat:$id');

  @override
  void openProfile() => calls.add('profile');

  @override
  void openMenu(BuildContext context) => calls.add('menu');
}

/// [child]'ı sahte gezinmeyle sarar.
Widget withAppNav(Widget child, NzAppNav nav) =>
    NzAppNavScope(nav: nav, child: child);
