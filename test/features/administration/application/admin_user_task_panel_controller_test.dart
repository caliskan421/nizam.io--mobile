import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/administration/application/admin_user_task_panel_controller.dart';
import 'package:nizamio/features/administration/domain/admin_user_tasks.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../connected_module_support.dart';

void main() {
  test(
    'çoklu filtre değişir ve temizle tüm durumlara dönerken görünüm korunur',
    () {
      final c = moduleContainer();
      addTearDown(c.dispose);
      final p = adminUserTaskPanelProvider('person');
      c.listen(p, (_, _) {});
      final ctl = c.read(p.notifier);
      ctl.toggleStatus(UserTaskStatus.review);
      ctl.togglePriority(TaskPriority.high);
      ctl.togglePriority(TaskPriority.low);
      ctl.show(UserTaskView.calendar);
      expect(c.read(p).statuses, {UserTaskStatus.review});
      expect(c.read(p).priorities, {TaskPriority.high, TaskPriority.low});
      ctl.clear();
      expect(c.read(p).defaultStatuses, isTrue);
      expect(c.read(p).priorities, isEmpty);
      expect(c.read(p).view, UserTaskView.calendar);
    },
  );
}
