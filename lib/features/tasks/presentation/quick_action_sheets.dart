import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../application/quick_forms_controller.dart';
import '../application/task_catalog_controller.dart';
import 'quick/invite_form.dart';
import 'quick/meeting_form.dart';
import 'quick/new_task_form.dart';
import 'task_texts.dart';
import 'task_widgets.dart';

/// Hızlı işlem alt sayfaları (prototip `markup_shared_overlays` "Yeni görev", "Toplantı
/// oluştur", "Kullanıcı davet et"). Ana sayfa, kısayol menüleri ve koordinatörlük ayrıntısı
/// çağırır. Taslak sayfa kapanınca korunur; başarılı gönderimde sayfa kapanır ve sonuç
/// bildirimi çıkar. Sayfa tutamakla büyür/küçülür; tarih, davetli, gündem ve koordinatörlük
/// satırı açılınca kendiliğinden büyür.
///
/// Yeni görev: [coordinatorship] verilirse ya da [resetTarget] true ise hedef sıfırlanır
/// (koordinatörlük o kod / seçilmemiş, atanan yok; görev listesi ve kısayolu
/// `resetTarget: true` ile açar). İkisi de yoksa (ana sayfa hızlı işlemi) taslak
/// koordinatörlük ve atananlarıyla korunur. [title] başlık alanını önceden doldurur
/// (sohbette "Göreve dönüştür": mesaj metninin ilk 120 karakteri; kırpma burada yapılır).
/// Seçili kapsamda görev açma yetkisi yoksa ([canCreateTaskProvider]) sayfa açılmaz.
Future<void> showNewTaskSheet(
  BuildContext context, {
  String? coordinatorship,
  bool resetTarget = false,
  String? title,
}) {
  final container = ProviderScope.containerOf(context, listen: false);
  if (!container.read(canCreateTaskProvider)) return Future.value();
  container
      .read(newTaskFormControllerProvider.notifier)
      .prepare(
        coordinatorship: coordinatorship,
        reset: resetTarget || coordinatorship != null,
        title: title == null
            ? null
            : String.fromCharCodes(title.trim().runes.take(120)),
      );
  final l = context.l10n;
  return _show(
    context,
    title: l.uiTasksNewTask,
    description: l.uiTasksNtDesc,
    ok: l.uiTasksCreate,
    onOk: (sheet) async {
      final r = await container
          .read(newTaskFormControllerProvider.notifier)
          .submit();
      if (r == null) return null;
      return '${r.code} ${l.uiTasksTCreatedTail} · '
          '${r.notified} ${l.uiTasksTNotifiedTail}';
    },
    body: (expansion) => NewTaskFormBody(expansion: expansion),
  );
}

Future<void> showMeetingSheet(
  BuildContext context, {
  String? coordinatorship,
  DateTime? date,
}) {
  final container = ProviderScope.containerOf(context, listen: false);
  container
      .read(meetingFormControllerProvider.notifier)
      .prepare(coordinatorship: coordinatorship, date: date);
  final l = context.l10n;
  return _show(
    context,
    title: l.uiTasksMtTitle,
    description: l.uiTasksMtDesc,
    ok: l.uiTasksCreate,
    onOk: (sheet) {
      final f = container.read(meetingFormControllerProvider.notifier).submit();
      if (f == null) return null;
      final when =
          '${TaskDates.short(f.date)} '
          '${f.hour.toString().padLeft(2, '0')}:'
          '${f.minute.toString().padLeft(2, '0')}';
      final who = f.mode == MeetingMode.coordinatorships
          ? '${f.coordinatorships.length} ${l.uiTasksTCoordsInvited}'
          : '${f.people.length} ${l.uiTasksTPeopleInvited}';
      return '${l.uiTasksTMeeting} · $when · $who';
    },
    body: (expansion) => MeetingFormBody(expansion: expansion),
  );
}

/// [coordinatorship] verilirse o koordinatörlük seçili, rol Üye açılır (koordinatörlük
/// ayrıntısı "Üye ekle").
Future<void> showInviteSheet(BuildContext context, {String? coordinatorship}) {
  final container = ProviderScope.containerOf(context, listen: false);
  container
      .read(inviteFormControllerProvider.notifier)
      .prepare(coordinatorship: coordinatorship);
  final l = context.l10n;
  return _show(
    context,
    title: l.uiTasksIvTitle,
    description: l.uiTasksIvDesc,
    ok: l.uiTasksIvSend,
    onOk: (sheet) {
      final f = container.read(inviteFormControllerProvider.notifier).submit();
      if (f == null) return null;
      return '${l.uiTasksTInvited} ${f.email}';
    },
    body: (expansion) => InviteFormBody(expansion: expansion),
  );
}

/// Ortak alt sayfa: [onOk] başarıda bildirim metnini döner (sayfa kapanır, bildirim çıkar),
/// doğrulama ya da sunucu hatasında null (hata formda görünür). Sunucu yazması beklenir.
Future<void> _show(
  BuildContext context, {
  required String title,
  required String description,
  required String ok,
  required FutureOr<String?> Function(BuildContext sheet) onOk,
  required Widget Function(ValueNotifier<bool> expansion) body,
}) async {
  // Sayfa içeriği kapanış canlandırması bitince bırakır; burada elle kapatılmaz.
  final expansion = ValueNotifier(false);
  String? toast;
  await NzBottomSheet.show<void>(
    context,
    title: title,
    description: description,
    expandable: true,
    expansion: expansion,
    actions: (sheet) => sheetActions(
      sheet,
      cancel: context.l10n.uiTasksCancel,
      ok: ok,
      onOk: () async {
        final msg = await onOk(sheet);
        if (msg == null || !sheet.mounted) return;
        toast = msg;
        Navigator.of(sheet).pop();
      },
    ),
    builder: (_) => body(expansion),
  );
  final msg = toast;
  if (msg != null && context.mounted) {
    // Prototip sonuç tostu onay işaretlidir (ayrıntı tostları bilgi işaretli).
    NzToast.show(context, msg, tone: NzToastTone.success);
  }
}
