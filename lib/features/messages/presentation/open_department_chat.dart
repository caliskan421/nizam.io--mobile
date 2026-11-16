import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../application/chats_controller.dart';

/// Koordinatörlüğün "Mesaj" eylemi: [departmentId]'nin kendiliğinden kurulan grubu
/// (`auto_department_id`) kutuda varsa o sohbet, yoksa mesajlar kutusu açılır. Beklerken oturum
/// veya program değişirse gezinme yapılmaz.
Future<void> openDepartmentChat(
  BuildContext context,
  String departmentId,
) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final session = container.read(sessionGenerationProvider);
  final program = container.read(scopeStateProvider).programId;
  String? chatId;
  try {
    final inbox = await container.read(chatsControllerProvider.future);
    chatId = inbox.departmentGroup(departmentId)?.id;
  } on Object catch (e, st) {
    // Kutu okunamadı: mesajlar kutusu kendi hata görünümünü gösterir.
    reportUnexpected(e, st, source: ReportSource.messages);
  }
  if (!context.mounted ||
      session != container.read(sessionGenerationProvider) ||
      program != container.read(scopeStateProvider).programId) {
    return;
  }
  final nav = context.appNav;
  if (chatId == null) {
    nav.openMessages();
  } else {
    nav.openChat(chatId);
  }
}
