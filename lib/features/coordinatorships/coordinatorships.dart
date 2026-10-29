/// coordinatorships özelliğinin açık yüzü: koordinatörlük listesi ve ayrıntısı. Başka feature'lar ve `app/` yalnız bu dosyayı
/// import eder (sınır kuralı B3).
library;

export 'application/coordinatorships_nav_caption.dart'
    show coordinatorshipsNavCaptionProvider;
export 'application/coordinatorships_providers.dart'
    show coordinatorshipProfileRepositoryProvider;
export 'domain/department.dart'
    show
        AssignableAccount,
        Department,
        DepartmentKind,
        DepartmentTaskSummary,
        MemberStatus,
        Membership,
        MembershipChange;
export 'domain/department_repository.dart' show DepartmentRepository;
export 'presentation/coordinatorship_page.dart' show CoordinatorshipPage;
export 'presentation/coordinatorships_page.dart' show CoordinatorshipsPage;
