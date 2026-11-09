import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../application/invite_form_controller.dart';
import '../application/meeting_form_controller.dart';
import '../application/quick_forms_controller.dart';
import '../application/task_catalog_controller.dart';
import '../domain/chat_task_planner.dart';
import 'quick/invite_form.dart';
import 'quick/meeting_form.dart';
import 'quick/new_task_form.dart';
import 'task_texts.dart';

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
/// [note] verilirse görev o toplantı notundan açılır (`convertNoteToTask`; not göreve bağlanır,
/// kanıt satırı yoktur). [chatMessage] verilirse görev o sohbet mesajından açılır
/// (`createTaskFromChatMessage`; açıklama mesaj gövdesi, kanıt satırı yok). Seçili kapsamda görev açma yetkisi yoksa ([canCreateTaskProvider])
/// sayfa açılmaz. Görev açıldıysa true döner.
Future<bool> showNewTaskSheet(
  BuildContext context, {
  String? coordinatorship,
  bool resetTarget = false,
  String? title,
  String? note,
  ChatTaskSource? chatMessage,
}) async {
  final container = ProviderScope.containerOf(context, listen: false);
  if (!container.read(canCreateTaskProvider)) return false;
  container
      .read(newTaskFormControllerProvider.notifier)
      .prepare(
        coordinatorship: coordinatorship,
        reset:
            resetTarget ||
            coordinatorship != null ||
            note != null ||
            chatMessage != null,
        title: title == null
            ? null
            : String.fromCharCodes(title.trim().runes.take(120)),
        note: note,
        chatMessage: chatMessage,
      );
  final l = context.l10n;
  return _show(
    context,
    title: chatMessage != null
        ? l.uiTasksMessageTaskTitle
        : note == null
        ? l.uiTasksNewTask
        : l.uiTasksNoteTaskTitle,
    description: chatMessage != null
        ? l.uiTasksMessageTaskDesc
        : note == null
        ? l.uiTasksNtDesc
        : l.uiTasksNoteTaskDesc,
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

/// Toplantı oluştur; [edit] verilirse o toplantıyı düzenler (gündem ve kip seçimi yok).
/// Toplantı yazıldıysa true döner.
Future<bool> showMeetingSheet(
  BuildContext context, {
  String? coordinatorship,
  DateTime? date,
  MeetingSeed? edit,
}) {
  final container = ProviderScope.containerOf(context, listen: false);
  final form = container.read(meetingFormControllerProvider.notifier);
  if (edit != null) {
    form.prepareEdit(edit);
  } else {
    form.prepare(coordinatorship: coordinatorship, date: date);
  }
  final l = context.l10n;
  return _show(
    context,
    title: edit == null ? l.uiTasksMtTitle : l.uiTasksMtEditTitle,
    description: edit == null ? l.uiTasksMtDesc : l.uiTasksMtEditDesc,
    ok: edit == null ? l.uiTasksCreate : l.uiTasksSave,
    onOk: (sheet) async {
      final f = await form.submit();
      if (f == null) return null;
      if (f.editing != null) return l.uiTasksTMeetingSaved;
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

/// Kullanıcı ekle (`createUser`): hesap açılır ya da var olan hesap (aktarım teklifi) seçilen
/// koordinatörlüğün ekibine eklenir; e-posta gönderilmez. Bildirim yalnız sunucu yazmasından
/// sonra çıkar. [coordinatorship] verilirse o koordinatörlük seçili, rol Üye açılır
/// (koordinatörlük ayrıntısı "Üye ekle").
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
    onOk: (sheet) async {
      final f = await container
          .read(inviteFormControllerProvider.notifier)
          .submit();
      if (f == null) return null;
      return '${l.uiTasksTInvited} ${f.email.trim()}';
    },
    body: (expansion) => InviteFormBody(expansion: expansion),
  );
}

/// Ortak alt sayfa: [onOk] başarıda bildirim metnini döner (sayfa kapanır, bildirim çıkar),
/// doğrulama ya da sunucu hatasında null (hata formda görünür). Sunucu yazması beklenir.
/// Başarıyla kapandıysa true döner.
Future<bool> _show(
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
    actions: (sheet) => nzSheetActions(
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
  return msg != null;
}
