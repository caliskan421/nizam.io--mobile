import '../../domain/task_catalog.dart';

part 'sample_task_data.dart';

/// GELİŞTİRME ÖRNEĞİ — gerçek servis değildir. Prototipteki görev kümesini döner; ağ isteği
/// atmaz. Bütün kişi adları kurmacadır. Bileşim kökünde (`tasks_module.dart`) tek yerde
/// bağlanır; backend bağlanınca yalnız o kayıt değişir.
final class SampleTaskCatalogRepository implements TaskCatalogRepository {
  @override
  Future<TaskCatalog> load() async => TaskCatalog(
    today: _today,
    me: 'ma',
    tasks: [for (final t in _tasks) _withDetails(t)],
    people: _people,
    coordinatorships: _coordinatorships,
  );
}

// Prototip `SUBS` (biten/toplam alt görev) ve `REQ` (bekleyen tarih talebi) tabloları.
(int, int)? _subtaskCounts(String code) => switch (code) {
  'MEK-6' => (2, 3),
  'İDA-5' => (1, 2),
  'ULA-1' => (1, 3),
  'İDA-2' => (2, 2),
  _ => null,
};
const _subtaskTitles = ['Hazırlık ve keşif', 'Uygulama', 'Kontrol ve teslim'];
DateTime? _requests(String code) => switch (code) {
  'ULA-1' => DateTime(2026, 11, 15),
  'EĞİ-1' => DateTime(2026, 10, 27),
  _ => null,
};

/// Ayrıntı ekranının alt görev, talep, dosya ve not listelerini örnek sayılardan kurar
/// (prototip `S_detail.load`); ALT-7 prototipteki elle yazılmış örnektir.
TaskItem _withDetails(TaskItem t) {
  final by = t.assignees.isEmpty ? 'ma' : t.assignees.first;
  if (t.code == 'ALT-7') {
    return t.copyWith(
      subtasks: const [
        Subtask(id: 's1', title: 'Pompa tedarikçisinden teyit al', done: true),
        Subtask(
          id: 's2',
          title: 'Montaj ekibini planla',
          assigneeRequired: true,
        ),
        Subtask(id: 's3', title: 'Basınç testi', evidenceRequired: true),
      ],
      dateRequest: () => DateChangeRequest(
        by: 'ko',
        at: DateTime(2026, 10, 19, 10, 12),
        oldDue: t.due,
        start: t.start,
        due: DateTime(2026, 10, 31),
        reason: 'Hidrofor pompası tedariki gecikti',
      ),
      fileEntries: const [
        TaskFile(
          id: 'f1',
          kind: TaskFileKind.image,
          name: 'WhatsApp Image 2026-09-02 at 21.24.20.jpeg',
          tag: EvidenceTag.site,
          by: 'ko',
          sizeKb: 256,
        ),
      ],
      noteEntries: [
        TaskNote(
          by: 'ko',
          at: DateTime(2026, 10, 19, 11, 20),
          text: 'Pompa tedarikçisi teslimi bir hafta erteledi. Yedek tedarikçi olmadığı için alternatifimiz yoktu.',
          inMemory: true,
        ),
      ],
    );
  }
  final sub = _subtaskCounts(t.code);
  final req = _requests(t.code);
  return t.copyWith(
    subtasks: sub == null
        ? const []
        : [
            for (var k = 0; k < sub.$2; k++)
              Subtask(
                id: 's${k + 1}',
                title: k < _subtaskTitles.length
                    ? _subtaskTitles[k]
                    : 'Adım ${k + 1}',
                done: k < sub.$1,
              ),
          ],
    dateRequest: () => req == null
        ? null
        : DateChangeRequest(
            by: by,
            at: DateTime(2026, 10, 18, 9, 40),
            oldDue: t.due,
            start: t.start,
            due: req,
            reason: 'Tedarik ve saha koşulları nedeniyle ek süre gerekiyor',
          ),
    fileEntries: [
      for (var k = 0; k < t.files; k++)
        TaskFile(
          id: 'f${k + 1}',
          kind: k.isOdd ? TaskFileKind.pdf : TaskFileKind.image,
          name: '${t.code}-kanit-${k + 1}${k.isOdd ? '.pdf' : '.jpg'}',
          tag: k.isOdd ? EvidenceTag.result : EvidenceTag.site,
          by: by,
          sizeKb: 180 + k * 90,
        ),
    ],
    noteEntries: [
      for (var k = 0; k < t.notes; k++)
        TaskNote(
          by: by,
          at: DateTime(2026, 10, 12 + k * 3, 10, 10 + k * 7),
          text: k == 0
              ? 'Saha durumu kontrol edildi; ilerleme beklenen düzeyde.'
              : 'Ekip planlaması güncellendi, bir sonraki adım bu hafta başlayacak.',
        ),
    ],
  );
}
