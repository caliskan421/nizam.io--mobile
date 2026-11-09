// Arşiv testlerinin ortak fikstürü (yalnız test): bellek içi ArchiveRepository, indirme kaydı,
// sahte dosya seçici, sağlayıcı kapsayıcısı ve gerçek bileşim köküne (Harness) bağlama.
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/archive/application/archive_providers.dart';
import 'package:nizamio/features/archive/domain/archive.dart';
import 'package:nizamio/features/archive/domain/records.dart';
import 'package:nizamio/features/tasks/domain/task_writes.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../support/harness.dart';
import '../pilot_support.dart';

/// Sunucu satırına benzer dosya.
RecordFile archiveFile(
  String id, {
  String task = 'w1',
  RecordTag tag = RecordTag.plan,
  String uploader = 'acc-1',
  String type = 'application/pdf',
  int size = 2048,
}) => RecordFile(
  id: id,
  workItemId: task,
  displayName: '$id.pdf',
  contentType: type,
  sizeBytes: size,
  tag: tag,
  uploaderId: uploader,
);

/// Kaydedilen arşiv çağrısı (yöntem, departman başlığı, ek bağımsız değişken).
typedef ArchiveCall = (String, String, Object?);

/// Bellek içi arşiv deposu. Dosya listesi [pages] imleç → dilim; [error] doluysa her çağrı o
/// hatayla düşer.
class FakeArchiveRepository implements ArchiveRepository {
  List<ArchiveFolder> folders = const [
    ArchiveFolder(code: 'd1', name: 'Altyapı', files: 3),
    ArchiveFolder(code: 'd2', name: 'Bilişim', files: 0),
  ];
  List<ArchiveTaskSummary> tasks = const [
    ArchiveTaskSummary(workItemId: 'w1', title: 'Saha keşfi', fileCount: 2),
    ArchiveTaskSummary(workItemId: 'w2', title: 'Rapor', fileCount: 1),
  ];
  List<String> uploaders = const ['acc-1', 'acc-9'];

  /// İmleç (null = ilk sayfa) → dilim.
  Map<String?, PageSlice<RecordFile>> pages = {
    null: PageSlice(
      items: [
        archiveFile('f1'),
        archiveFile('f2', tag: RecordTag.sonuc, uploader: 'acc-9'),
        archiveFile('f3', task: 'w2', type: 'image/png'),
      ],
    ),
  };
  ApiError? error;
  final List<ArchiveCall> calls = [];

  /// Yükleme çağrılarının işlem anahtarları (sırayla).
  final List<String> attachKeys = [];

  /// Sıradaki yükleme çağrılarının hataları (FIFO; boşsa [error] geçerli).
  final List<Object> attachErrors = [];
  final List<ArchiveAttachmentFilter> filters = [];

  Future<T> _do<T>(String op, String department, T value, [Object? arg]) {
    calls.add((op, department, arg));
    final e = error;
    if (e != null) return Future.error(e);
    return Future.value(value);
  }

  Stream<List<int>> _bytes() => Stream.value(const [1, 2, 3]);

  @override
  Future<List<ArchiveFolder>> loadFolders({required String department}) =>
      _do('folders', department, folders);

  @override
  Future<List<ArchiveTaskSummary>> archiveTasks({required String department}) =>
      _do('tasks', department, tasks);

  @override
  Future<List<String>> archiveUploaders({required String department}) =>
      _do('uploaders', department, uploaders);

  @override
  Future<PageSlice<RecordFile>> archiveAttachments({
    required String department,
    ArchiveAttachmentFilter filter = const ArchiveAttachmentFilter(),
    PageRequest page = const PageRequest(),
  }) {
    filters.add(filter);
    return _do(
      'files',
      department,
      pages[page.cursor] ?? PageSlice.empty(),
      page.cursor,
    );
  }

  @override
  Future<RecordFile> attachFile({
    required String department,
    required String workItemId,
    required RecordTag tag,
    required String filePath,
    required String filename,
    required String requestKey,
  }) {
    attachKeys.add(requestKey);
    if (attachErrors.isNotEmpty) {
      calls.add(('attach', department, (workItemId, tag, filename)));
      return Future.error(attachErrors.removeAt(0));
    }
    return _do(
      'attach',
      department,
      archiveFile('new', task: workItemId, tag: tag),
      (workItemId, tag, filename),
    );
  }

  @override
  Future<void> deleteFile(String fileId, {required String department}) =>
      _do('delete', department, null, fileId);

  @override
  Future<Stream<List<int>>> downloadFile(
    String fileId, {
    required String department,
  }) => _do('file', department, _bytes(), fileId);

  @override
  Future<Stream<List<int>>> downloadFolderZip(
    String folderId, {
    required String department,
  }) => _do('folderZip', department, _bytes(), folderId);

  @override
  Future<Stream<List<int>>> downloadSelectionZip(
    List<String> fileIds, {
    required String department,
  }) => _do('selectionZip', department, _bytes(), fileIds);

  @override
  Future<Stream<List<int>>> downloadPeriodZip({required String department}) =>
      _do('periodZip', department, _bytes());
}

/// Kaydedilen indirmeler (ad → bayt).
class RecordingSink implements DownloadSink {
  final Map<String, List<int>> saved = {};

  @override
  Future<String> save(String name, Stream<List<int>> bytes) async {
    saved[name] = await bytes.expand((c) => c).toList();
    return '/indirilenler/$name';
  }
}

/// Önceden belirlenmiş seçim döndüren seçici (null → vazgeçme).
class FakePicker implements UploadPicker {
  FakePicker([this.next]);

  UploadSource? next;
  final origins = <UploadOrigin>[];

  @override
  bool get available => true;

  @override
  Future<UploadSource?> pick(UploadOrigin origin) async {
    origins.add(origin);
    return next;
  }
}

/// Pilot backend'de koordinatör ekip satırı (`prog-1` / `d1`): arşiv kapsamı `d1`, yönetici değil.
PilotBackend archiveBackend({bool admin = false}) => PilotBackend()
  ..companyAdmin = admin
  ..seats = [
    {
      'program_id': 'prog-1',
      'program_name': 'Program Bir',
      'department_id': 'd1',
      'display_name': 'Altyapı',
      'role': 'koordinator',
    },
  ];

/// Gerçek bileşim kökünün arşiv, indirme ve seçici portlarını fakelerle değiştirir (portlar
/// get_it kaydından tembel okunur; ilk okumadan önce çağrılır).
void useArchiveFakes(
  Harness h,
  FakeArchiveRepository repo, {
  DownloadSink? sink,
  UploadPicker? picker,
}) {
  final l = h.composition.locator
    ..unregister<ArchiveRepository>()
    ..registerSingleton<ArchiveRepository>(repo);
  if (sink != null) {
    l
      ..unregister<DownloadSink>()
      ..registerSingleton<DownloadSink>(sink);
  }
  if (picker != null) {
    l
      ..unregister<UploadPicker>()
      ..registerSingleton<UploadPicker>(picker);
  }
}

/// Görev kataloğu: [admin] bayrağı, `p1` programındaki ekip satırları ([seats]: departman →
/// koordinatör mü), programın departmanları ve görevler (kimlik → departman).
TaskCatalog archiveCatalog({
  bool admin = false,
  Map<String, bool> seats = const {'d1': true},
  List<String> departments = const ['d1', 'd2'],
  Map<String, String> tasks = const {},
}) {
  final today = DateTime(2026, 11, 8);
  return TaskCatalog(
    today: today,
    me: 'acc-1',
    people: const [
      Person(id: 'acc-9', name: 'Ali Veli', role: PersonRole.member),
    ],
    coordinatorships: const [],
    access: TaskAccess(
      accountId: 'acc-1',
      companyAdmin: admin,
      seats: [
        for (final MapEntry(key: d, value: coord) in seats.entries)
          TeamSeat(
            programId: 'p1',
            departmentId: d,
            departmentName: 'Ad $d',
            role: coord ? SeatRole.coordinator : SeatRole.member,
          ),
      ],
    ),
    departments: [
      for (final d in departments) TaskDepartment(id: d, name: 'Ad $d'),
    ],
    tasks: [
      for (final MapEntry(key: id, value: d) in tasks.entries)
        TaskItem(
          code: id,
          title: 'Görev $id',
          coordinatorship: d,
          departmentId: d,
          programId: 'p1',
          status: TaskStatus.inProgress,
          priority: TaskPriority.medium,
          start: today,
          due: today,
          assignees: const [],
        ),
    ],
  );
}

class _Catalog extends TaskCatalogController {
  _Catalog(this.value);

  final TaskCatalog value;

  @override
  Future<TaskCatalog> build() => Future.value(value);
}

/// Arşiv sağlayıcılarının kapsayıcısı (seçili program `p1`); test sonunda kapanır.
ProviderContainer archiveContainer(
  FakeArchiveRepository repo, {
  TaskCatalog? catalog,
  DownloadSink? sink,
  UploadPicker? picker,
}) {
  final c = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      scopeStateProvider.overrideWithValue(
        const ScopeSelection(programId: 'p1'),
      ),
      localeProvider.overrideWithValue(const Locale('tr')),
      taskCatalogControllerProvider.overrideWith(
        () => _Catalog(catalog ?? archiveCatalog()),
      ),
      archiveRepositoryProvider.overrideWithValue(repo),
      downloadSinkProvider.overrideWithValue(sink ?? RecordingSink()),
      uploadPickerProvider.overrideWithValue(picker ?? FakePicker()),
    ],
  );
  addTearDown(c.dispose);
  return c;
}
