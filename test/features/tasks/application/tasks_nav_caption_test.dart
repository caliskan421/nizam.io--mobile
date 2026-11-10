import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../connected_module_support.dart';

void main() {
  test('kesik katalog alt menü sayısını alt sınır olarak gösterir', () async {
    final base = moduleCatalog();
    TaskCatalog catalog(bool truncated) => TaskCatalog(
      today: base.today,
      me: base.me,
      tasks: base.tasks,
      people: base.people,
      coordinatorships: base.coordinatorships,
      access: base.access,
      truncated: truncated,
    );
    final full = moduleContainer(catalog: catalog(false));
    final partial = moduleContainer(catalog: catalog(true));
    addTearDown(full.dispose);
    addTearDown(partial.dispose);
    full.listen(tasksNavCaptionProvider, (_, _) {});
    partial.listen(tasksNavCaptionProvider, (_, _) {});
    await full.read(taskCatalogControllerProvider.future);
    await partial.read(taskCatalogControllerProvider.future);
    expect(full.read(tasksNavCaptionProvider), '1 görev');
    expect(partial.read(tasksNavCaptionProvider), '≥1 görev');
  });
}
