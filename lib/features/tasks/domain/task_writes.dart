import 'package:meta/meta.dart';

import '../../../core/domain/upload_types.dart';

import 'task_catalog.dart';
import 'task_permissions.dart';

export '../../../core/domain/upload_types.dart'
    show normalizeUploadName, uploadContentType, uploadExtensions;

/// Alt görev değişikliği (`PATCH …/subtasks/{id}`). null alan değişmez. [assignee] verilirse
/// `id` null → atamayı kaldır; [dates] verilirse ikisi birlikte gider (ikisi null → kaldır).
/// [expectedRevision]: okunan alt görev `edit_revision`'ı; başlık, atanan ya da tarih
/// verilince zorunlu, yalnız [done]'da gerekmez (ADR-0027). [evidenceRequired]: kanıt bayrağı
/// (yönetim alanı; sürüm ister).
@immutable
final class SubtaskPatch {
  const SubtaskPatch({
    this.title,
    this.assignee,
    this.dates,
    this.done,
    this.evidenceRequired,
    this.expectedRevision,
  });

  final bool? evidenceRequired;

  final int? expectedRevision;
  final String? title;
  final ({String? id})? assignee;
  final ({DateTime? start, DateTime? end})? dates;
  final bool? done;
}

/// Yeni görev (`POST /v1/work-items`). Kapsam gövdede değil başlıktadır: [programId] +
/// [departmentId] isteğin açık kapsamı olur (S3). Sunucu tek atanan alır (`assignee_account_id`); null →
/// atamasız görev. [evidenceRequired] varsayılan açık (WORK-K75).
@immutable
final class WorkItemDraft {
  const WorkItemDraft({
    required this.programId,
    required this.departmentId,
    required this.title,
    required this.start,
    required this.end,
    this.description,
    this.priority,
    this.assignee,
    this.evidenceRequired = true,
  });

  final String programId;
  final String departmentId;
  final String title;
  final DateTime start;
  final DateTime end;
  final String? description;
  final TaskPriority? priority;
  final String? assignee;
  final bool evidenceRequired;

  /// Gövde imzası: işlem anahtarı defterinde aynı gövdenin tekrarını tanır (aynı imza → aynı
  /// anahtar; değişen alan → yeni eylem).
  String get signature => [
    programId,
    departmentId,
    title,
    start.toIso8601String(),
    end.toIso8601String(),
    description,
    priority?.name,
    assignee,
    evidenceRequired,
  ].join('|');
}

/// Görev değişikliği (`PATCH /v1/work-items/{id}`): YALNIZ değişen alanlar (null → gönderilmez)
/// ve değişen grubun okunan sürümü (ADR-0027): alanlar (başlık, öncelik, kanıt bayrağı) →
/// [expectedRevision], tarihler → [expectedDatesRevision]. Sürüm bayatsa sunucu 409
/// `work.edit_conflict` döner (sessiz ezme yok); değişmeyen alan gönderilmez.
@immutable
final class WorkItemPatch {
  const WorkItemPatch({
    this.title,
    this.priority,
    this.start,
    this.end,
    this.evidenceRequired,
    this.expectedRevision,
    this.expectedDatesRevision,
  });

  /// [before] ile (formun AÇILIŞ tabanı; canlı katalog değil) karşılaştırıp yalnız farkı
  /// taşıyan yama (tarihler gün çözünürlüğünde); sürümler [before]'dan, yalnız grubunda alan
  /// varsa.
  factory WorkItemPatch.diff(
    TaskItem before, {
    String? title,
    TaskPriority? priority,
    DateTime? start,
    DateTime? end,
    bool? evidenceRequired,
  }) {
    bool sameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;
    final t = title == null || title == before.title ? null : title;
    final p = priority == null || priority == before.priority ? null : priority;
    final s = start == null || sameDay(start, before.start) ? null : start;
    final e = end == null || sameDay(end, before.due) ? null : end;
    final ev =
        evidenceRequired == null || evidenceRequired == before.evidenceRequired
        ? null
        : evidenceRequired;
    final fields = t != null || p != null || ev != null;
    final dates = s != null || e != null;
    return WorkItemPatch(
      title: t,
      priority: p,
      start: s,
      end: e,
      evidenceRequired: ev,
      expectedRevision: fields ? before.editRevision : null,
      expectedDatesRevision: dates ? before.datesRevision : null,
    );
  }

  final String? title;
  final TaskPriority? priority;
  final DateTime? start;
  final DateTime? end;
  final bool? evidenceRequired;
  final int? expectedRevision;
  final int? expectedDatesRevision;

  bool get isEmpty =>
      title == null &&
      priority == null &&
      start == null &&
      end == null &&
      evidenceRequired == null;
}

/// Yüklenecek yerel dosya (seçiciden): [path] okunur, [name] görünen ad olur. Seçim içeriği
/// okumaz; içerik özeti ([UploadDigest]) görev/arşiv gönderiminde ön denetimden sonra alınır.
@immutable
final class UploadSource {
  const UploadSource({
    required this.path,
    required this.name,
    required this.sizeBytes,
  });

  final String path;
  final String name;
  final int sizeBytes;

  /// Küçük harf uzantı (noktasız); yoksa ''.
  String get extension {
    final i = name.lastIndexOf('.');
    return i < 0 || i == name.length - 1
        ? ''
        : name.substring(i + 1).toLowerCase();
  }

  /// Bildirilecek tür (RECORDS-K03); izinli kümede yoksa null (istek gönderilmez).
  String? get contentType => uploadContentType(extension);

  /// Sunucu sınırına ulaşıyor mu (tam sınır da reddedilir).
  bool get tooLarge => sizeBytes >= uploadMaxBytes;
}

/// Tek dosya sınırı: bu boyuta ULAŞAN dosya 422 `records.too_large` (RECORDS-K05, 90 MiB).
const uploadMaxBytes = 90 * 1024 * 1024;

/// Görev başına dosya tavanı (sonraki yükleme 422 `records.too_many_files`).
const uploadMaxFilesPerTask = 30;

/// Sunucunun kapalı etiket kümesi (`tag` zorunlu sorgu parametresi).
const uploadTags = [
  EvidenceTag.requirement,
  EvidenceTag.plan,
  EvidenceTag.input,
  EvidenceTag.analysis,
  EvidenceTag.output,
  EvidenceTag.outcome,
];

/// Departman ekibinden kişi (`GET /v1/departments/{id}/members`). Görev ataması yalnız bu
/// ekibe yapılabilir (WORK-K09; dışı 422 `work.assignee_not_member`).
@immutable
final class TeamMember {
  const TeamMember({
    required this.accountId,
    required this.name,
    required this.coordinator,
  });

  final String accountId;
  final String name;
  final bool coordinator;
}

/// Seçicinin kaynağı: cihaz dosyaları (Dosyalar / SAF), fotoğraflar (galeri) ya da kamerayla
/// o an çekilen fotoğraf.
enum UploadOrigin { files, photos, camera }

/// Sistem dosya seçicisi portu. [pick] null → kullanıcı vazgeçti.
abstract interface class UploadPicker {
  /// Seçici bu kurulumda var mı (yoksa yükleme formu dosya seçtiremez).
  bool get available;

  Future<UploadSource?> pick(UploadOrigin origin);
}

/// Yükleme içerik özeti portu (SHA-256, akışla; gerçekleştirme `data/upload_digest.dart`).
/// Görev ve arşiv yükleme niyeti imzasında ad/boyutla birlikte durur: aynı ad/boyutlu farklı
/// içerik yeni niyettir (istemci akışları §8). YALNIZ tür/boyut ön denetimi geçtikten sonra
/// çağrılır. [cancelled] true olunca okuma durur ve null döner; okunamayan dosya
/// `client.file_unreadable` hatasıdır.
typedef UploadDigest = Future<String?> Function(
  String path, {
  required bool Function() cancelled,
});

/// Seçici bağlı olmayan kurulumda (testler, örnek) kullanılan gerçekleştirme; gerçek seçici
/// `data/file_upload_picker.dart` (ADR-0002).
final class UnavailableUploadPicker implements UploadPicker {
  const UnavailableUploadPicker();

  @override
  bool get available => false;

  @override
  Future<UploadSource?> pick(UploadOrigin origin) async => null;
}

/// İndirilen dosyanın yazıldığı yer (portu; gerçekleştirme `data/`). [bytes] akışı parça
/// parça diske yazılır (dosya belleğe toplanmaz); kaydedilen yolu döner. Akış hatasında yarım
/// dosya bırakılmaz, hata fırlar.
abstract interface class DownloadSink {
  Future<String> save(String name, Stream<List<int>> bytes);
}

/// Ekibe kişi ekleme ("Kullanıcı ekle" formu; `createUser`). [transferAccountId] yoksa hesap
/// açılır ([fullName] zorunlu); varsa o var olan hesap ekibe eklenir (aktarım: hesabın
/// nitelikleri değişmez, ad gönderilmez). Rol [coordinator] (`koordinator`) ya da üye
/// (`uye`); [companyAdmin] şirket yöneticiliği de verir. Koordinatör çağıranın rolünü sunucu
/// `uye`'ye zorlar, yöneticilik isteğini 403 ile reddeder.
@immutable
final class MemberEnrollment {
  const MemberEnrollment({
    required this.programId,
    required this.departmentId,
    required this.email,
    this.fullName = '',
    this.coordinator = false,
    this.companyAdmin = false,
    this.transferAccountId,
  });

  final String programId;
  final String departmentId;
  final String email;
  final String fullName;
  final bool coordinator;
  final bool companyAdmin;
  final String? transferAccountId;
}

/// Görev ayrıntısının sunucu yazmaları (domain portu; gerçekleştirme `data/`). Görev
/// kapsamlı her çağrı görevin KENDİ (program, departman) kapsamıyla gider (S3). Yanıt gövdesi
/// yerel durumu değiştirmek için kullanılmaz (iyimser güncelleme yok; çağıran yeniden okur).
/// Hatalar `ApiError` olarak fırlar.
abstract interface class TaskWriteRepository {
  /// [via] ucuyla durum geçişi; [closeSubtasks] yalnız `tamamlandi` hedefinde. [pullEndDate]:
  /// erken onayda bitişi bugüne çek (`pull_end_date`; geç onayda sunucu kendisi iter).
  Future<void> changeStatus(
    TaskItem task,
    StatusEndpoint via,
    TaskStatus to, {
    String? reason,
    bool closeSubtasks = false,
    bool pullEndDate = false,
  });

  /// [requestKey]: işlem anahtarı (`Idempotency-Key`, ADR-0027); aynı eylemin tekrarı aynı
  /// anahtarla gider.
  Future<void> addNote(
    TaskItem task,
    String text, {
    required String requestKey,
  });

  /// [expectedRevision]: notun okunan `edit_revision`'ı; bayatsa 409 `work.edit_conflict`.
  Future<void> updateNote(
    TaskItem task,
    String noteId,
    String text, {
    required int expectedRevision,
  });

  Future<void> deleteNote(TaskItem task, String noteId);

  /// [evidenceRequired]: alt görev bağlı dosya olmadan kapatılamaz (WORK-K70).
  Future<void> createSubtask(
    TaskItem task,
    String title, {
    required String requestKey,
    bool evidenceRequired = false,
  });

  Future<void> updateSubtask(
    TaskItem task,
    String subtaskId,
    SubtaskPatch patch,
  );

  Future<void> deleteSubtask(TaskItem task, String subtaskId);

  // ---- görev ---------------------------------------------------------------------------

  /// Görevi açar; sunucunun verdiği görev kimliği döner (yerel kod üretilmez). Aynı
  /// [requestKey] ile tekrar ilk görevi döner (200), ikinci görev açılmaz.
  Future<String> createWorkItem(
    WorkItemDraft draft, {
    required String requestKey,
  });

  /// Yalnız [patch]'teki alanlar gönderilir.
  Future<void> updateWorkItem(TaskItem task, WorkItemPatch patch);

  /// Yumuşak siler.
  Future<void> deleteWorkItem(TaskItem task);

  // ---- atama (yalnız kapsam koordinatörü) ----------------------------------------------

  Future<void> addAssignments(TaskItem task, List<String> accountIds);

  Future<void> removeAssignment(TaskItem task, String accountId);

  /// Atamasız görevi üstlenir.
  Future<void> claim(TaskItem task);

  /// Kendi atamasını bırakır.
  Future<void> unclaim(TaskItem task);

  /// [departmentId] ekibi (S2; yönetici ya da o departmanın koordinatörü).
  Future<List<TeamMember>> listTeam(String departmentId);

  /// `POST /v1/admin/users` (S1; yönetici ya da hedef departmanın koordinatörü). Yeni
  /// hesabın ilk parolası sunucuda üretilir ve yanıtta dönmez; e-posta gönderilmez. E-posta
  /// başka hesaptaysa 409 `identity.account_exists` (yöneticiye aktarım teklifi alanlarda).
  Future<void> enrollMember(MemberEnrollment enrollment);

  // ---- tarih talebi --------------------------------------------------------------------

  /// Koordinatör talebi (S3, görevin departmanı).
  Future<void> requestDateChange(
    TaskItem task,
    DateTime start,
    DateTime end, {
    required String requestKey,
    String? reason,
  });

  /// Şirket yöneticisi kararı (S1); [reason] karar gerekçesi (`review_reason` olarak döner).
  Future<void> reviewDateChange(
    String requestId, {
    required bool approve,
    String? reason,
  });

  /// Atananlara anlık hatırlatma (`POST …/remind`, S3); kuyruğa alınan alıcı sayısı döner.
  Future<int> remind(TaskItem task);

  /// İncelenmiş talebi siler (şirket yöneticisi, S1).
  Future<void> deleteDateChange(String requestId);

  /// Çağıranın [departmentId] departmanındaki tarih talepleri (`GET …/mine`, S3; koordinatör).
  Future<List<DateChangeRequest>> listMyDateRequests(
    String programId,
    String departmentId,
  );

  /// Bitişi [days] gün uzatır (`POST …/extend`, S3; koordinatör ya da yönetici); okunan tarih
  /// sürümü `expected_dates_revision`, [requestKey] işlem anahtarı. Bağımlılar zincirle ötelenir.
  Future<void> extend(TaskItem task, int days, {required String requestKey});

  // ---- dosya (records, S3, görevin departmanı) -----------------------------------------

  /// Multipart tek `file` parçası (bildirilen tür [UploadSource.contentType]); `tag` zorunlu,
  /// [subtaskId] isteğe bağlı.
  Future<void> attachFile(
    TaskItem task,
    UploadSource file,
    EvidenceTag tag, {
    String? subtaskId,
    required String requestKey,
  });

  Future<void> renameFile(TaskItem task, String fileId, String name);

  Future<void> deleteFile(TaskItem task, String fileId);

  /// Dosya içeriği akış olarak (Bearer'lı doğrudan indirme; belleğe toplanmaz).
  Future<Stream<List<int>>> downloadFile(TaskItem task, String fileId);
}
