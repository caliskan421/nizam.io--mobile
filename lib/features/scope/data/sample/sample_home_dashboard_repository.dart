import '../../domain/home_dashboard.dart';
import '../../domain/home_dashboard_repository.dart';

/// GELİŞTİRME ÖRNEĞİ — gerçek servis değildir. Ana sayfa arayüzü backend özeti hazır olmadan
/// kurulsun diye prototipteki yoğunlukta sabit veri döner; ağ isteği atmaz. Bütün kişi adları
/// kurmacadır. Sayılar ve durumlar iş kuralı değildir (sunucu hesaplar). Bileşim kökünde
/// (`scope_module.dart`) tek yerde bağlanır; backend bağlanınca yalnız o kayıt değişir.
final class SampleHomeDashboardRepository implements HomeDashboardRepository {
  SampleHomeDashboardRepository({DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final DateTime Function() _now;

  @override
  Future<HomeDashboard> load() async {
    final now = _now();
    final today = DateTime(now.year, now.month, now.day);
    return HomeDashboard(
      greetingName: 'Elif Nur Karaağaçlı',
      greetingRole: TeamRole.admin,
      greetingEmail: 'elif.karaagacli@ornek.test',
      tasks: const TaskTotals(
        total: 79,
        done: 39,
        inProgress: 40,
        inProgressOnTime: 25,
        late: 15,
        awaitingApproval: 3,
      ),
      team: const TeamTotals(admins: 2, coordinators: 15, members: 3),
      lastActivity: LastActivity(
        at: today.add(const Duration(hours: 14, minutes: 27)),
        actorName: 'Deniz Aydemir',
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
          leads: ['Deniz Aydemir', 'Kaan Erol'],
          todo: 2,
          inProgress: 3,
          inReview: 0,
          done: 9,
          late: 3,
        ),
        CoordinatorshipSummary(
          code: 'ULA',
          name: 'Ulaşım planlama',
          leads: ['Selim Ergin'],
          todo: 0,
          inProgress: 3,
          inReview: 0,
          done: 1,
          late: 3,
        ),
        CoordinatorshipSummary(
          code: 'EĞİ',
          name: 'Eğitim ve Arge',
          leads: ['Melis Koçer'],
          todo: 3,
          inProgress: 2,
          inReview: 0,
          done: 2,
          late: 2,
        ),
        CoordinatorshipSummary(
          code: 'ELE',
          name: 'Elektrik ve enerji',
          leads: ['Rıza Karaca'],
          todo: 2,
          inProgress: 0,
          inReview: 1,
          done: 4,
          late: 1,
        ),
        CoordinatorshipSummary(
          code: 'FUA',
          name: 'Fuar',
          leads: ['Sinan Sağır'],
          todo: 1,
          inProgress: 0,
          inReview: 1,
          done: 2,
          late: 1,
        ),
        CoordinatorshipSummary(
          code: 'MEK',
          name: 'Mekanik sistemler',
          leads: ['Mert Yavuz Kaynak', 'Okan Haspolat'],
          todo: 0,
          inProgress: 1,
          inReview: 0,
          done: 7,
          late: 1,
        ),
        CoordinatorshipSummary(
          code: 'OPE',
          name: 'Operasyon',
          leads: ['Yusuf Çevik'],
          todo: 2,
          inProgress: 2,
          inReview: 0,
          done: 4,
          late: 0,
        ),
        CoordinatorshipSummary(
          code: 'SAT',
          name: 'Satış ve pazarlama',
          leads: ['Ceren Çetinkaya'],
          todo: 3,
          inProgress: 0,
          inReview: 0,
          done: 4,
          late: 0,
        ),
        CoordinatorshipSummary(
          code: 'MİM',
          name: 'Mimari tasarım',
          leads: ['Nazlı Özkan'],
          todo: 1,
          inProgress: 1,
          inReview: 0,
          done: 3,
          late: 0,
        ),
        CoordinatorshipSummary(
          code: 'SİS',
          name: 'Sistem koordinatörlüğü',
          leads: ['Elif Nur Karaağaçlı', 'Mert Yavuz Kaynak'],
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
}
