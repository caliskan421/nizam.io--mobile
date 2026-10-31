import '../../domain/home_dashboard.dart';
import '../../domain/home_dashboard_repository.dart';

/// GELİŞTİRME ÖRNEĞİ — gerçek servis değildir. Ana sayfa arayüzü backend özeti hazır olmadan
/// kurulsun diye prototipteki yoğunlukta sabit veri döner; ağ isteği atmaz. Kişi adları ve e-posta
/// tasarım prototipinin örnek kişileri (12-Tablet `RP_PEOPLE`; gerçek hesap kaydı değildir). Sayılar ve durumlar iş kuralı değildir (sunucu hesaplar). Bileşim kökünde
/// (`scope_module.dart`) tek yerde bağlanır; backend bağlanınca yalnız o kayıt değişir.
final class SampleHomeDashboardRepository implements HomeDashboardRepository {
  /// [now] verilmezse prototip çapası (`RP_TODAY` 2026-10-21; görev kataloğu örneğiyle aynı
  /// gün): "son işlem bugün 14:27" örnek kataloğun bugünüyle tutarlı kalır.
  SampleHomeDashboardRepository({DateTime Function()? now})
    : _now = now ?? _prototypeToday;

  static DateTime _prototypeToday() => DateTime(2026, 10, 21);

  final DateTime Function() _now;

  @override
  Future<HomeDashboard> load() async {
    final now = _now();
    final today = DateTime(now.year, now.month, now.day);
    return HomeDashboard(
      greetingName: 'Muhammet Ali Çalışkan',
      greetingRole: TeamRole.admin,
      greetingEmail: 'macaliskan@gmail.com',
      // Prototip çekmece sezon kartı.
      demoProgramName: 'Şanlıurfa Teknofest',
      demoProgramYear: 2026,
      tasks: const TaskTotals(
        total: 79,
        done: 39,
        inProgress: 40,
        inProgressOnTime: 25,
        late: 15,
        awaitingApproval: 3,
      ),
      // Prototip ekip satırı "18 kullanıcı" (rol kutuları 2 · 15 · 3).
      team: const TeamTotals(
        admins: 2,
        coordinators: 15,
        members: 3,
        userCount: 18,
      ),
      lastActivity: LastActivity(
        at: today.add(const Duration(hours: 14, minutes: 27)),
        actorName: 'Abdullah Ateş',
      ),
      coordinatorships: const [
        CoordinatorshipSummary(
          code: 'İDA',
          name: 'İdari işler',
          leads: [],
          todo: 2,
          inProgress: 6,
          inReview: 2,
          done: 1,
          late: 4,
        ),
        CoordinatorshipSummary(
          code: 'ALT',
          name: 'Altyapı ve tesisat',
          leads: ['Abdullah Ateş', 'Ali Avcı'],
          todo: 2,
          inProgress: 3,
          inReview: 0,
          done: 9,
          late: 3,
        ),
        CoordinatorshipSummary(
          code: 'ULA',
          name: 'Ulaşım planlama',
          leads: ['Salih Özer'],
          todo: 0,
          inProgress: 3,
          inReview: 0,
          done: 1,
          late: 3,
        ),
        CoordinatorshipSummary(
          code: 'EĞİ',
          name: 'Eğitim ve Arge',
          leads: ['Merve Koçoğlu'],
          todo: 3,
          inProgress: 2,
          inReview: 0,
          done: 2,
          late: 2,
        ),
        CoordinatorshipSummary(
          code: 'ELE',
          name: 'Elektrik ve enerji',
          leads: ['Reha Koçak'],
          todo: 2,
          inProgress: 0,
          inReview: 1,
          done: 4,
          late: 1,
        ),
        CoordinatorshipSummary(
          code: 'FUA',
          name: 'Fuar',
          leads: ['Salim Sağlık'],
          todo: 1,
          inProgress: 0,
          inReview: 1,
          done: 2,
          late: 1,
        ),
        CoordinatorshipSummary(
          code: 'MEK',
          name: 'Mekanik sistemler',
          leads: ['Mevlüt Yunus Kayacan', 'Osman Hansu'],
          todo: 0,
          inProgress: 1,
          inReview: 0,
          done: 7,
          late: 1,
        ),
        CoordinatorshipSummary(
          code: 'OPE',
          name: 'Operasyon',
          leads: ['Yunus Çiftçioğlu'],
          todo: 2,
          inProgress: 2,
          inReview: 0,
          done: 4,
          late: 0,
        ),
        CoordinatorshipSummary(
          code: 'SAT',
          name: 'Satış ve pazarlama',
          leads: ['Büşra Çiftçioğlu'],
          todo: 3,
          inProgress: 0,
          inReview: 0,
          done: 4,
          late: 0,
        ),
        CoordinatorshipSummary(
          code: 'MİM',
          name: 'Mimari tasarım',
          leads: ['Esra Özkafa'],
          todo: 1,
          inProgress: 1,
          inReview: 0,
          done: 3,
          late: 0,
        ),
        CoordinatorshipSummary(
          code: 'SİS',
          name: 'Sistem koordinatörlüğü',
          leads: ['Muhammet Ali Çalışkan', 'Mevlüt Yunus Kayacan'],
          todo: 1,
          inProgress: 1,
          inReview: 0,
          done: 2,
          late: 0,
        ),
      ],
      pending: [
        PendingItem(
          taskCode: 'ALT-7',
          title: 'Hidrofor sistemi kurulumu',
          kind: PendingKind.dateChange,
          requestedDate: today.add(const Duration(days: 51)),
          requestedShiftDays: 51,
        ),
        PendingItem(
          taskCode: 'ULA-1',
          title: 'Otopark zemin düzenlemesi',
          kind: PendingKind.dateChange,
          requestedDate: today.add(const Duration(days: 25)),
        ),
        PendingItem(
          taskCode: 'EĞİ-1',
          title: 'Atölye içerik planı',
          kind: PendingKind.dateChange,
          requestedDate: today.add(const Duration(days: 6)),
        ),
        const PendingItem(
          taskCode: 'İDA-2',
          title: 'Talep toplama',
          kind: PendingKind.approval,
        ),
        const PendingItem(
          taskCode: 'İDA-4',
          title: 'Biletleme',
          kind: PendingKind.approval,
        ),
        const PendingItem(
          taskCode: 'FUA-3',
          title: 'Stant yerleşim ataması',
          kind: PendingKind.approval,
        ),
      ],
      counts: const ModuleCounts(
        lateTasks: 15,
        tasksAwaitingApproval: 3,
        unreadMessages: 2,
        pendingRequests: 3,
      ),
    );
  }

  /// Örnek kapsamda rol yoktur; yönetici olmayan yol kullanılmaz.
  @override
  Future<TeamDashboardExtras> loadTeamExtras({
    required String? departmentId,
    required bool coordinator,
  }) async => const TeamDashboardExtras(unreadMessages: 0);
}
