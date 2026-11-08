// Q3 kayıt denetiminin port tablosu (composition_test.dart): ad → sağlayıcı nesnesi.
import 'package:flutter_riverpod/misc.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/activity/activity.dart';
import 'package:nizamio/features/archive/application/archive_providers.dart';
import 'package:nizamio/features/coordinatorships/coordinatorships.dart';
import 'package:nizamio/features/identity/identity.dart';
import 'package:nizamio/features/meetings/meetings.dart';
import 'package:nizamio/features/messages/application/messages_providers.dart';
import 'package:nizamio/features/notifications/application/notifications_providers.dart';
import 'package:nizamio/features/scope/scope.dart';
import 'package:nizamio/features/tasks/tasks.dart';

/// Q3 — kayıt denetimi (ADR-0003 karar 13). Port listesi KODDAN toplanır: `_unbound('<ad>')`
/// (core) ya da `throw UnimplementedError('<ad> …')` (feature) ile bileşim kökünde bağlanmayı
/// bekleyen her sağlayıcı porttur. Ada göre nesne çözülemediğinden eşleme [portProviders]
/// tablosundadır; tablo koddan toplanan listeyle birebir (yeni port yazılmazsa test kırılır).
final portProviders = <String, ProviderBase<Object?>>{
  'flavorProvider': flavorProvider,
  'httpAdapterProvider': httpAdapterProvider,
  'scopeControllerProvider': scopeControllerProvider,
  'serverBindingProvider': serverBindingProvider,
  'sessionControllerProvider': sessionControllerProvider,
  'themeModeControllerProvider': themeModeControllerProvider,
  'connectivityMonitorProvider': connectivityMonitorProvider,
  'localeControllerProvider': localeControllerProvider,
  'identityServiceProvider': identityServiceProvider,
  'scopeServiceProvider': scopeServiceProvider,
  'homeDashboardRepositoryProvider': homeDashboardRepositoryProvider,
  'taskCatalogRepositoryProvider': taskCatalogRepositoryProvider,
  'taskListRepositoryProvider': taskListRepositoryProvider,
  'taskDetailsRepositoryProvider': taskDetailsRepositoryProvider,
  'taskWriteRepositoryProvider': taskWriteRepositoryProvider,
  'downloadSinkProvider': downloadSinkProvider,
  'meetingPlannerProvider': meetingPlannerProvider,
  'chatTaskPlannerProvider': chatTaskPlannerProvider,
  'meetingsRepositoryProvider': meetingsRepositoryProvider,
  'coordinatorshipProfileRepositoryProvider':
      coordinatorshipProfileRepositoryProvider,
  'coordinatorshipActivityRepositoryProvider':
      coordinatorshipActivityRepositoryProvider,
  'activityLogRepositoryProvider': activityLogRepositoryProvider,
  'archiveRepositoryProvider': archiveRepositoryProvider,
  'chatRepositoryProvider': chatRepositoryProvider,
  'notificationRepositoryProvider': notificationRepositoryProvider,
};
