// ChatController: yanıt/düzenleme bağlamı ve sabit şeridi sırası; açma koşulsuz sıfırlar.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/messages/application/chat_controller.dart';

void main() {
  test('bağlam ve sabit sırası; open sıfırlar', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final p = chatControllerProvider('c1');
    c.listen(p, (_, _) {});
    final ctrl = c.read(p.notifier)..reply('m1');
    expect(c.read(p).reply, 'm1');
    ctrl.edit('m2', revision: 3);
    expect(
      (c.read(p).reply, c.read(p).edit, c.read(p).editRevision),
      (null, 'm2', 3),
      reason: 'taslağın tabanı açılıştaki sürüm',
    );
    ctrl
      ..clearContext()
      ..nextPin()
      ..nextPin();
    expect(
      (c.read(p).edit, c.read(p).editRevision, c.read(p).pin),
      (null, null, 2),
    );
    ctrl
      ..reply('m3')
      ..open();
    expect((c.read(p).reply, c.read(p).pin), (null, 0));
  });
}
