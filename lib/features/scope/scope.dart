/// scope özelliğinin açık yüzü: program (kapsam) seçimi ve ana sayfa. Başka feature'lar ve
/// `app/` yalnız bu dosyayı import eder (sınır kuralı B3).
library;

export 'application/current_program_controller.dart'
    show currentProgramControllerProvider;
export 'application/home_dashboard_controller.dart'
    show homeDashboardControllerProvider;
export 'application/scope_providers.dart'
    show homeDashboardRepositoryProvider, scopeServiceProvider;
export 'application/scope_selection_controller.dart'
    show scopeSelectionControllerProvider;
export 'application/scope_service.dart' show ScopeService;
export 'domain/home_dashboard.dart' show HomeDashboard;
export 'domain/my_department.dart' show DepartmentRole, MyDepartment;
export 'domain/program.dart' show Program, ProgramDepartmentLink;
export 'presentation/home/home_menus.dart' show HomeModule, showHomeDrawer;
export 'presentation/home_page.dart' show HomePage;
export 'presentation/root_top_bar.dart' show RootTopBar, watchNotificationBell;
export 'presentation/scope_page.dart' show ScopePage;
