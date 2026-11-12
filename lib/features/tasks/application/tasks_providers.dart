import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../domain/chat_task_planner.dart';
import '../domain/meeting_invitees.dart';
import '../domain/meeting_planner.dart';
import '../domain/task_access.dart';
import '../domain/task_catalog.dart';
import '../domain/task_details.dart';
import '../domain/task_writes.dart';
import 'task_catalog_controller.dart';

part 'tasks_providers.g.dart';

/// PORT: görev kataloğunun kaynağı (`tasks_module.dart`'ta bağlanır: sunucu ya da örnek).
@Riverpod(keepAlive: true)
TaskCatalogRepository taskCatalogRepository(Ref ref) =>
    throw UnimplementedError(
      'taskCatalogRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
    );

/// PORT: görevler ekranının departman süzgeçli okuması (`tasks_module.dart`'ta bağlanır).
@Riverpod(keepAlive: true)
TaskListRepository taskListRepository(Ref ref) => throw UnimplementedError(
  'taskListRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
);

/// PORT: görev ayrıntısının kaynağı (`tasks_module.dart`'ta bağlanır).
@Riverpod(keepAlive: true)
TaskDetailsRepository taskDetailsRepository(Ref ref) =>
    throw UnimplementedError(
      'taskDetailsRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
    );

/// PORT: görev yazmalarının kaynağı (`tasks_module.dart`'ta bağlanır; yalnız sunucu).
@Riverpod(keepAlive: true)
TaskWriteRepository taskWriteRepository(Ref ref) => throw UnimplementedError(
  'taskWriteRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
);

/// PORT: toplantı yazmaları (hızlı toplantı formu, nottan görev). Gerçekleştirme meetings
/// feature'ındadır; bileşim kökünde bağlanır.
@Riverpod(keepAlive: true)
MeetingPlanner meetingPlanner(Ref ref) => throw UnimplementedError(
  'meetingPlannerProvider bileşim kökünde (lib/app/di) bağlanır',
);

/// PORT: kişi kipindeki toplantının program havuzu (`tasks_module.dart`'ta bağlanır).
@Riverpod(keepAlive: true)
MeetingInviteeRepository meetingInviteeRepository(Ref ref) =>
    throw UnimplementedError(
      'meetingInviteeRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
    );

/// PORT: mesajdan görev ("mesajdan görev" kipindeki yeni görev formu). Gerçekleştirme messages
/// feature'ındadır; bileşim kökünde bağlanır.
@Riverpod(keepAlive: true)
ChatTaskPlanner chatTaskPlanner(Ref ref) => throw UnimplementedError(
  'chatTaskPlannerProvider bileşim kökünde (lib/app/di) bağlanır',
);

/// PORT: sistem dosya seçicisi (`tasks_module.dart`'ta `FileUploadPicker` bağlanır).
/// Bağlanmamışsa (testler) "yok" gerçekleştirmesi: form dosya seçtiremez, istek gönderilmez.
@Riverpod(keepAlive: true)
UploadPicker uploadPicker(Ref ref) => const UnavailableUploadPicker();

/// PORT: yükleme içerik özeti (`tasks_module.dart`'ta `uploadDigest` bağlanır). Yalnız görev
/// ve arşiv yükleme gönderiminde, tür/boyut ön denetiminden sonra okunur.
@Riverpod(keepAlive: true)
UploadDigest uploadDigester(Ref ref) => throw UnimplementedError(
  'uploadDigesterProvider bileşim kökünde (lib/app/di) bağlanır',
);

/// PORT: indirilen dosyanın kaydı (`tasks_module.dart`'ta bağlanır).
@Riverpod(keepAlive: true)
DownloadSink downloadSink(Ref ref) => throw UnimplementedError(
  'downloadSinkProvider bileşim kökünde (lib/app/di) bağlanır',
);

/// Departman ekibi ([departmentId]; görev ataması adayları). Yalnız yönetici ya da o
/// departmanın koordinatörü okur ([TaskAccess.canReadTeamIn]); sunucu kataloğunda yetkisiz
/// hesapta `listMembers` ÇAĞRILMAZ, `work.not_authorized` döner (üye 403 alırdı).
@riverpod
Future<List<TeamMember>> taskTeam(Ref ref, String departmentId) async {
  final catalog = await ref.read(taskCatalogControllerProvider.future);
  final access = catalog.access;
  if (access != null) {
    final program = ref.read(scopeStateProvider).programId;
    if (program == null || !access.canReadTeamIn(program, departmentId)) {
      throw ApiError('work.not_authorized');
    }
  }
  return ref.read(taskWriteRepositoryProvider).listTeam(departmentId);
}

/// Kişi kipindeki toplantının davet havuzu (toplantı formu ve ayrıntıdaki "katılımcı ekle").
/// Şirket yöneticisi: kataloğun bütün ekipleri (programın departmanları okunur). Koordinatör:
/// kendi ekipleri (katalog) + programın geri kalanı ([MeetingInviteeRepository], koordinatörü
/// olunan ilk departman üzerinden). Havuz okunamazsa ya da koordinatörlük yoksa yalnız
/// katalogdaki ekipler, [MeetingInvitees.partial] ile (ekran kısıtı açıkça yazar).
@riverpod
Future<MeetingInvitees> meetingInvitees(Ref ref) async {
  final catalog = await ref.watch(taskCatalogControllerProvider.future);
  final own = catalog.coordinatorships;
  final access = catalog.access;
  if (access == null || access.companyAdmin) {
    return MeetingInvitees(groups: own, partial: catalog.departmentsTruncated);
  }
  final program = ref.read(scopeStateProvider).programId;
  final anchor = program == null
      ? null
      : access
            .seatsIn(program)
            .where((s) => s.role == SeatRole.coordinator)
            .firstOrNull;
  if (anchor == null) return MeetingInvitees(groups: own, partial: true);
  try {
    final pool = await ref
        .read(meetingInviteeRepositoryProvider)
        .programPeople(anchor.departmentId);
    return pool.withTeams(own);
  } on Object catch (e, st) {
    reportUnexpected(e, st, source: ReportSource.tasks);
    // Havuz ek bilgidir: okunamazsa kendi ekipler kalır, eksiklik ekranda yazılır.
    return MeetingInvitees(groups: own, partial: true);
  }
}
