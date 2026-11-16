// Eylem kodunun görünen adı (istemci sözlüğü): konu + eylem; bilinmeyen → ham kod; başarısız eki.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/features/activity/domain/activity_log.dart';
import 'package:nizamio/features/activity/presentation/activity_action_label.dart';

ActivityEntry _e(String? code, {bool failed = false}) => ActivityEntry(
  at: DateTime(2026, 11, 14),
  kind: ActivityKind.task,
  action: code ?? 'Hazır metin',
  detail: '',
  target: '',
  actorId: 'u1',
  actorName: 'Ayşe',
  actionCode: code,
  failed: failed,
);

void main() {
  final l = AppLocalizationsTr();
  test('sözlükteki kod konu + eylem olur', () {
    expect(l.activityAction(_e('work.item.created')), 'Görev oluşturuldu');
    expect(
      l.activityAction(_e('records.file.tag_changed')),
      'Dosya etiketi değiştirildi',
    );
  });

  test('bilinmeyen kod ham kalır; kodsuz kayıt hazır metin; başarısız eki', () {
    expect(l.activityAction(_e('work.gantt.admin')), 'work.gantt.admin');
    expect(l.activityAction(_e(null)), 'Hazır metin');
    expect(
      l.activityAction(_e('identity.login.denied', failed: true)),
      'Giriş reddedildi · başarısız',
    );
  });

  test('tür eylem kodu önekinden', () {
    expect(activityKindOf('collaboration.note.added'), ActivityKind.meeting);
    expect(activityKindOf('messaging.message.sent'), ActivityKind.message);
    expect(
      activityKindOf('organization.account.created'),
      ActivityKind.account,
    );
  });
}
