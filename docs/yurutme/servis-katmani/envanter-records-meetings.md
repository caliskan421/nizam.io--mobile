# Servis katmanı envanteri — records + meetings

Pin: `v0.2.0-api` (e404139). Kapsam: `records_client.dart` (12 işlem) ve `collaboration_client.dart`
içindeki toplantı işlemleri (20 işlem). Mesaj uçları (`/v1/messages*`, 6 işlem) messaging parçasındadır,
burada sayılmaz. Toplam **32 işlem, 32 karşılık**.

Kapsam sınıfları `lib/core/api/generated/operations.gen.dart`'tan; başlıklar ara katmandan gelir
(üretilmiş imzalarda kapsam parametresi yok).

## records → `lib/features/archive/`

Arayüz `RecordsRepository` (`domain/records.dart`, `ArchiveRepository`'yi genişletir), uygulama
`ApiRecordsRepository` (`data/records_api_repository.dart`).

| operationId | yöntem yol | kapsam | Flutter karşılığı | domain tipi | not |
|---|---|---|---|---|---|
| attachFile | POST `/v1/work-items/{id}/files?tag=` (multipart `file`) | S3 | `RecordsRepository.attachFile(workItemId, tag, filePath)` | `RecordFile` | `tag` kapalı küme `RecordTag` (`ister/plan/girdi/analiz/cikti/sonuc`); `RecordTag.unknown` istek atılmadan `ArgumentError`. Dosya yolu alır, `File` data katmanında kurulur. CSRF yok (spec). Yanıt `FileRecord`'da yükleyen yok → `uploaderId: null`. |
| listWorkItemFiles | GET `/v1/work-items/{id}/files` | S3 | `RecordsRepository.listWorkItemFiles(workItemId)` | `List<RecordFile>` | Tek zarf, imleç/kesilme yok. |
| downloadFile | GET `/v1/files/{id}/download` | S3 | `RecordsRepository.downloadFile(fileId)` → `Uint8List`; bilet hedefi `RecordsDownloadTargets.file(id)` | bayt | Üretilmiş imza `Stream<String>` (UTF-8 çözer, ikili gövdeyi bozar/patlatır) → aynı yol + operationId extras ile `Dio.get(ResponseType.bytes)`. Gerçek akış bilet (identity/org parçası). |
| renameFile | PATCH `/v1/files/{id}/name` | S3 | `RecordsRepository.renameFile(fileId, displayName)` | `RecordFile` | |
| deleteFile | DELETE `/v1/files/{id}` | S3 | `RecordsRepository.deleteFile(fileId)` | — | Yalnız yükleyen; ikinci silme 404 `records.file_not_found`. |
| archiveAttachments | GET `/v1/records/archive/attachments` | S3 | `RecordsRepository.archiveAttachments(filter:, page:)` | `PageSlice<RecordFile>` | Süzgeç `ArchiveAttachmentFilter` (mime_category, tag, work_item_id, uploader_id, from/to UTC RFC 3339, search, sort). `sort` mevcut `ArchiveSort` ile: `recent` → gönderilmez (varsayılan), `name`, `size` (değerler yalnız backend kodunda, spec'te yok). İmleç eksene bağlı; eksen değişince 422 `records.invalid_cursor`. `next_cursor` yok/boş → son sayfa. |
| archiveFolders | GET `/v1/records/archive/folders` | S3 | `ArchiveRepository.loadFolders()` (RecordsRepository üzerinden) | `List<ArchiveFolder>` | Mevcut UI portu; örnek repo ile yer değiştirebilir. Üyeye tek sanal klasör (`isVirtual`). |
| archiveTasks | GET `/v1/records/archive/tasks` | S3 | `RecordsRepository.archiveTasks()` | `List<ArchiveTaskSummary>` | Klasöre göre süzgeç yok. |
| archiveUploaders | GET `/v1/records/archive/uploaders` | S3 | `RecordsRepository.archiveUploaders()` | `List<String>` | Yalnız kimlik; ad dizini sunucuda yok. |
| archiveFolderZip | GET `/v1/records/archive/folders/{id}/download-zip` | S3 | `RecordsRepository.downloadFolderZip(folderId)`; hedef `RecordsDownloadTargets.folderZip(id)` | bayt | downloadFile ile aynı ikili not. Dışa aktarım kotası. |
| archiveSelectionZip | GET `/v1/records/archive/files/download-zip?file_ids=` | S3 | `RecordsRepository.downloadSelectionZip(fileIds)`; hedef `RecordsDownloadTargets.selectionZip(ids)` | bayt | 1–100 kimlik, aksi istek atılmadan `ArgumentError`. Kimlikler tek tek kodlanır, ayraç virgül. |
| archiveFullZip | GET `/v1/records/archive/period/download-zip` | S3 | `RecordsRepository.downloadPeriodZip()`; hedef `RecordsDownloadTargets.periodZip` | bayt | Yalnız şirket yöneticisi. |

## toplantılar (collaboration) → `lib/features/meetings/` (yeni; yalnız `domain/` + `data/`)

Arayüz `MeetingsRepository` (`domain/meetings_repository.dart`), uygulama `ApiMeetingsRepository`
(`data/meetings_api_repository.dart`). Varlıklar `domain/meeting.dart`.

| operationId | yöntem yol | kapsam | Flutter karşılığı | domain tipi | not |
|---|---|---|---|---|---|
| createMeeting | POST `/v1/meetings` | S2 | `MeetingsRepository.createMeeting(MeetingDraft)` | `MeetingCreated` | `meeting_date`: UTC → RFC 3339 `Z`; yerel `DateTime` → saat dilimsiz `YYYY-MM-DDTHH:MM:SS` (sunucu kurulum saat diliminde yorumlar). `failed_participants: null` → boş liste. |
| listMeetings | GET `/v1/meetings` | S2 | `MeetingsRepository.listMeetings([PageRequest])` | `PageSlice<Meeting>` | `next_cursor` zorunlu dizge; `""` → son sayfa. Tarih aralığı süzgeci yok. |
| listDeletedMeetings | GET `/v1/meetings/deleted` | S2 | `MeetingsRepository.listDeletedMeetings([PageRequest])` | `PageSlice<Meeting>` | Yalnız yönetici. |
| adminListDeletedMeetings | GET `/v1/admin/deleted/meetings` | S2 | `MeetingsRepository.adminListDeletedMeetings([PageRequest])` | `PageSlice<Meeting>` | Aynı use-case, yönetici yaşam döngüsü yolu. |
| restoreMeeting | PATCH `/v1/admin/restore/meetings/{id}` | S2 | `MeetingsRepository.restoreMeeting(id)` | `MeetingLifecycleResult` | `status` bilinmeyen → `unknown`. |
| permanentDeleteMeeting | DELETE `/v1/admin/permanent/meetings/{id}` | S2 | `MeetingsRepository.permanentDeleteMeeting(id)` | `MeetingLifecycleResult` | |
| getMeeting | GET `/v1/meetings/{id}` | S2 | `MeetingsRepository.getMeeting(id)` | `MeetingDetail` | Katılımcı, gündem, notların ilk sayfası (`PageSlice<MeetingNote>`). `viewer_role` sunucudan. `conference_available` v0.2'de yok. |
| updateMeeting | PATCH `/v1/meetings/{id}` | S2 | `MeetingsRepository.updateMeeting(id, MeetingChanges)` | `MeetingRevised` | `null` alan gönderilmez. Departman seti yalnız yönetici yolunda. |
| deleteMeeting | DELETE `/v1/meetings/{id}` | S2 | `MeetingsRepository.deleteMeeting(id)` | — | Yumuşak silme. |
| addMeetingParticipant | POST `/v1/meetings/{id}/participants` | S2 | `MeetingsRepository.addParticipant(meetingId, userId)` | — | Yanıt (`ParticipantResult`) yalnız girdiyi yansıtır; dönülmez. |
| removeMeetingParticipant | DELETE `/v1/meetings/{id}/participants/{userId}` | S2 | `MeetingsRepository.removeParticipant(meetingId, userId)` | — | |
| addAgendaItem | POST `/v1/meetings/{id}/agenda` | S2 | `MeetingsRepository.addAgendaItem(meetingId, title)` | `AgendaItem` | En çok 50 (`collaboration.agenda_limit_reached`). |
| listAgenda | GET `/v1/meetings/{id}/agenda` | S2 | `MeetingsRepository.listAgenda(meetingId)` | `List<AgendaItem>` | Tek sayfa; `next_cursor` her zaman boş, yok sayılır. |
| updateAgendaItem | PATCH `/v1/meeting-agenda/{itemId}` | S2 | `MeetingsRepository.updateAgendaItem(itemId, title:, isChecked:)` | `AgendaItem` | |
| deleteAgendaItem | DELETE `/v1/meeting-agenda/{itemId}` | S2 | `MeetingsRepository.deleteAgendaItem(itemId)` | — | Kalıcı. |
| addMeetingNote | POST `/v1/meetings/{id}/notes` | S2 | `MeetingsRepository.addNote(meetingId, content)` | `MeetingNote` | Üyeye dakikada 20 not (429). |
| listMeetingNotes | GET `/v1/meetings/{id}/notes` | S2 | `MeetingsRepository.listNotes(meetingId, [PageRequest])` | `PageSlice<MeetingNote>` | `""` → son sayfa. |
| updateMeetingNote | PATCH `/v1/meeting-notes/{noteId}` | S2 | `MeetingsRepository.updateNote(noteId, content)` | `MeetingNote` | |
| deleteMeetingNote | DELETE `/v1/meeting-notes/{noteId}` | S2 | `MeetingsRepository.deleteNote(noteId)` | — | Yumuşak silme. |
| convertNoteToTask | POST `/v1/meeting-notes/{noteId}/convert-to-task` | S2 | `MeetingsRepository.convertNoteToTask(noteId, NoteTaskDraft)` | `NoteConversion` | **Açık sorun:** üretilmiş `ConvertNoteRequest` `format: date` alanlarını `DateTime.toIso8601String()` ile tam tarih-saat (`2026-11-03T00:00:00.000`) yazar; backend v0.2 `ParseTaskDay` yalnız `2006-01-02` kabul eder → 422 beklenir. Düzeltme üreticide (`tool/gen.dart`, `format: date` → gün dizgesi); D2 elle gövdeye izin vermez. Öncelik `MeetingTaskPriority` → `dusuk/orta/yuksek/acil`. |

### Konferans

`v0.2.0-api`'de konferans uçları yok (main'de 3 uç + `MeetingDetail.conference_available`). **v0.3.0-api ile gelecek**; o pinde bu repository'ye eklenir.

### Takvim örtüşmesi (`lib/features/calendar/domain/calendar.dart` `MeetingEntry`) — takvim entegrasyonunda kullanılacak

Calendar dosyalarına dokunulmadı. Eşleme takvim entegrasyonunda yapılacak:

| `MeetingEntry` alanı | meetings domain karşılığı | not |
|---|---|---|
| `date` + `hour` + `minute` | `Meeting.meetingDate` (UTC) | takvim entegrasyonunda kullanılacak; kurulum saat dilimiyle (`InstanceProfile.timezone`) yerel güne/saate çevrilmeli. |
| `title` | `Meeting.title` | takvim entegrasyonunda kullanılacak. |
| `coordinatorships` (boş = hepsi) | `Meeting.departments[].id` (ilki sahip) | takvim entegrasyonunda kullanılacak; "bütün koordinatörlükler" kavramı sunucuda yok. |
| `participants` (int) | `MeetingDetail.participants.length` | takvim entegrasyonunda kullanılacak; yalnız ayrıntıda (N+1) ya da ŞY rapor ucunda `participant_count`. |
| `agenda` (`List<String>`) | `MeetingDetail.agenda[].title` (+ `isChecked`) | takvim entegrasyonunda kullanılacak; yalnız ayrıntıda. |
| `place` | — | sunucuda yok. |
| `chatId` | — | sunucuda yok (toplantı sohbeti yok). |
| — | `Meeting.id`, `membersIncluded`, `createdByRole`, `ownerDepartmentId`, `MeetingDetail.viewerRole` | `MeetingEntry`'de yok; ayrıntıya gitmek için en az `id` gerekecek. |

## Domain değişiklikleri

- `lib/features/archive/domain/archive.dart`
  - `ArchiveFolder`: `isVirtual` eklendi (sunucu `is_virtual`, varsayılan `false`). Sunucuda olmayan `tasks`, `sizeMb`, `lastUploadDays`, `leads` zorunluluktan çıkarıldı (varsayılan `0`/`0`/`null`/`[]`; yorum "sunucuda yok — entegrasyonda karar"). `code` = sunucu `folder_id` (rota kimliği; örnek veride koordinatörlük kodu). `name`, `files` (`file_count`) birleşti.
  - `ArchiveTag`, `ArchiveSort` yorumları: sunucu karşılıkları yazıldı. `ArchiveTag` silinmedi.
- `lib/features/archive/domain/records.dart` (yeni)
  - `RecordTag` (sunucu kapalı kümesi + `unknown`). Mobil kanıt etiketleri (`tasks` `EvidenceTag {site,result,status}`) ve arşiv `ArchiveTag {field,result,data}` örtüşmüyor; ikisi de duruyor.
  - `ArchiveMimeCategory {belge,tablo,gorsel,arsiv,metin}`.
  - `RecordFile` (sunucu `FileRecord`/`FileListItem`). `ArchiveFile` genişletilemedi: zorunlu `tag` (`ArchiveTag`, UI'da exhaustive), `uploadedAt`, `taskTitle`, yükleyen adı sunucuda yok; doldurmak sahte veri olurdu. Köprü: `RecordFile.kind` (`ArchiveFileKind`, `content_type`'tan) ve `sizeMb`. UI'da olup sunucuda olmayan: `ArchiveFile.uploadedAt` (sunucu bu alana göre sıralıyor/süzüyor ama dönmüyor), `taskTitle` (`archiveTasks` ile birleştirilebilir), `uploadedBy` adı.
  - `ArchiveTaskSummary` (örnek `ArchiveTaskFolder` kaydının sunucu karşılığı).
  - `ArchiveAttachmentFilter`, `RecordsDownloadTargets` (bilet hedef yolları), `RecordsRepository`.
- `lib/features/meetings/domain/meeting.dart` (yeni): `MeetingRole`, `MeetingLifecycleStatus`, `MeetingTaskPriority`, `MeetingDepartment`, `Meeting`, `MeetingParticipant`, `AgendaItem`, `MeetingNote`, `MeetingDetail`, `MeetingSideEffects`, `MeetingCreated`, `MeetingRevised`, `MeetingLifecycleResult`, `NoteConversion`, girdi tipleri `MeetingDraft`, `MeetingChanges`, `NoteTaskDraft`.
- `lib/features/meetings/domain/meetings_repository.dart` (yeni): `MeetingsRepository`.
- Örnek repo'lar, UI, controller, modül dosyaları değişmedi.

## Ortaklaştırma adayları

- **İkili indirme yardımcısı** (`ApiRecordsRepository._bytes`): üretilmiş istemci `@DioResponseType(ResponseType.stream)` uçlarını `Stream<String>` (UTF-8) olarak üretiyor; ikili gövde için yanlış. Kalıcı çözüm üreticide (`tool/gen.dart`: stream uçları `HttpResponse<List<int>>`/`ResponseBody`); o zamana kadar yardımcı `core/api`'ye taşınabilir (identity `redeemDownloadTicket` aynı ihtiyaçta).
- **`format: date` serileştirmesi**: `ConvertNoteRequest.start_date/end_date` (ve aynı kalıptaki diğer `format: date` istek alanları — work parçasına bakılmalı) üreticide gün dizgesi olmalı.
- **`next_cursor: ""` → `null`** (`_cursor`): collaboration listelerinde zorunlu dizge; diğer modüllerde de varsa `PageSlice` yapıcısına ortak yardımcı.
- **`MeetingTaskPriority`** ↔ tasks `TaskPriority {low, medium, high}`: sunucu dört değerli (`acil` dahil); tasks domain'i genişletilince birleştirilmeli.
- **`MeetingRole`** ↔ identity rol enum'u: aynı üç değer; ortak rol tipi varsa ona bağlanmalı.

## Spec belirsizlikleri

- Arşiv uçları S3 ama README "kapsam sunucuda sabit" diyor: ŞY'nin hangi departman başlığını göndereceği ve başlığın sonucu daraltıp daraltmadığı belirsiz.
- Sanal klasörün `folder_id` biçimi tanımsız.
- `sort` değerleri spec'te yazmıyor (yalnız backend kodunda).
