// ChatController: yanıt/düzenleme bağlamı, ek paneli, atıflar, cihaz dosyası, sabit sırası.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/messages/application/chat_controller.dart';
import 'package:nizamio/features/messages/domain/chat.dart';

void main() {
  test('bağlam, panel, atıflar ve gönderim sonrası temizlik', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final p = chatControllerProvider('gen');
    c.listen(p, (_, _) {});
    final ctrl = c.read(p.notifier)..reply('m1');
    expect(c.read(p).reply, 'm1');
    ctrl.edit('m6');
    expect((c.read(p).reply, c.read(p).edit), (null, 'm6'));
    ctrl.clearContext();
    expect(c.read(p).edit, isNull);

    ctrl.toggleAttach();
    expect(c.read(p).attach, ChatAttachTab.task);
    ctrl
      ..setAttachQuery('hid')
      ..setAttachTab(ChatAttachTab.archive);
    expect(
      (c.read(p).attach, c.read(p).attachQuery),
      (ChatAttachTab.archive, ''),
    );
    const r = ChatRef(ChatRefKind.task, 'ALT-7');
    ctrl.toggleRef(r);
    expect(c.read(p).refs, [r]);
    ctrl.toggleRef(r);
    expect(c.read(p).refs, isEmpty);
    ctrl.addDevice(photo: true);
    expect(c.read(p).refs.single.id, 'IMG_2042.jpeg');
    expect(c.read(p).attach, isNull);
    ctrl
      ..addDevice(photo: false)
      ..removeRefAt(0);
    expect(c.read(p).refs.single.id, 'Belge_2.pdf');
    ctrl
      ..nextPin()
      ..nextPin();
    expect(c.read(p).pin, 2);
    ctrl.resetPin();
    expect(c.read(p).pin, 0);
    ctrl
      ..reply('m2')
      ..sent();
    expect(c.read(p).reply, isNull);
    expect(c.read(p).refs, isEmpty);
  });

  test(
    'open: aynı kimlikte de yazma bağlamını koşulsuz sıfırlar (S_chat.load)',
    () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final p = chatControllerProvider('gen');
      c.listen(p, (_, _) {});
      c.read(p.notifier)
        ..reply('m1')
        ..toggleRef(const ChatRef(ChatRefKind.task, 'ALT-7'))
        ..toggleAttach()
        ..setAttachQuery('hid')
        ..nextPin()
        ..addDevice(photo: true)
        ..edit('m6')
        ..open();
      final v = c.read(p);
      expect(
        (v.reply, v.edit, v.attach, v.attachQuery),
        (null, null, null, ''),
      );
      expect(v.refs, isEmpty);
      expect((v.pin, v.devices), (0, 0));
    },
  );
}
