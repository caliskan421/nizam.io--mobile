// work sunucu değerleri ↔ tasks domain enum'ları (DTO'suz; DTO eşleyicileri her repository'de
// özel — A2).
//
// Ortaklaştırma adayı: timeline/data/gantt_api_repository.dart aynı durum/öncelik eşlemesini
// kendi içinde tutar (B3: feature'lar birbirinin data katmanını import edemez).

import '../domain/task_catalog.dart';

/// Sunucu durum değeri → domain (tanımsız/`null` → [TaskStatus.unknown]; asla `throw` etmez).
TaskStatus taskStatusFromWire(String? wire) => switch (wire) {
  'baslanmadi' => TaskStatus.todo,
  'devam_ediyor' => TaskStatus.inProgress,
  'onaya_sunuldu' => TaskStatus.review,
  'iade_edildi' => TaskStatus.returned,
  'tamamlandi' => TaskStatus.done,
  _ => TaskStatus.unknown,
};

/// Domain durumu → sunucu değeri ([TaskStatus.unknown] gönderilemez).
String taskStatusToWire(TaskStatus s) => switch (s) {
  TaskStatus.todo => 'baslanmadi',
  TaskStatus.inProgress => 'devam_ediyor',
  TaskStatus.review => 'onaya_sunuldu',
  TaskStatus.returned => 'iade_edildi',
  TaskStatus.done => 'tamamlandi',
  TaskStatus.unknown => throw ArgumentError.value(
    s,
    'status',
    'tanımsız durum sunucuya gönderilemez',
  ),
};

/// Sunucu öncelik değeri → domain (tanımsız/`null` → [TaskPriority.unknown]).
TaskPriority taskPriorityFromWire(String? wire) => switch (wire) {
  'dusuk' => TaskPriority.low,
  'orta' => TaskPriority.medium,
  'yuksek' => TaskPriority.high,
  'acil' => TaskPriority.urgent,
  _ => TaskPriority.unknown,
};

/// Domain önceliği → sunucu değeri ([TaskPriority.unknown] gönderilemez).
String taskPriorityToWire(TaskPriority p) => switch (p) {
  TaskPriority.low => 'dusuk',
  TaskPriority.medium => 'orta',
  TaskPriority.high => 'yuksek',
  TaskPriority.urgent => 'acil',
  TaskPriority.unknown => throw ArgumentError.value(
    p,
    'priority',
    'tanımsız öncelik sunucuya gönderilemez',
  ),
};

/// Gün değeri: saat bileşeni atılır (sunucu alanları gün çözünürlüğündedir).
DateTime day(DateTime d) => DateTime(d.year, d.month, d.day);

DateRequestState dateRequestState(String? wire) => switch (wire) {
  'pending' => DateRequestState.pending,
  'approved' => DateRequestState.approved,
  'rejected' => DateRequestState.rejected,
  _ => DateRequestState.unknown,
};

/// Kanıt etiketi → sunucu değeri; sunucu kümesinde olmayan (prototip/tanımsız) → null.
String? evidenceTagToWire(EvidenceTag t) => switch (t) {
  EvidenceTag.requirement => 'ister',
  EvidenceTag.plan => 'plan',
  EvidenceTag.input => 'girdi',
  EvidenceTag.analysis => 'analiz',
  EvidenceTag.output => 'cikti',
  EvidenceTag.outcome => 'sonuc',
  _ => null,
};
