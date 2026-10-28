import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nz_shell_events.g.dart';

/// Kabukta etkin sekmeye, sekme kökündeyken yeniden dokunma olayı (README "Gezinme": etkin
/// öğeye tekrar dokunmak o sayfanın kısayol menüsünü açar). Her dokunuş yeni bir olaydır
/// ([seq] artar); sayfa `ref.listen` ile dinler ve kendi menüsünü açar.
@immutable
final class ShellReselect {
  const ShellReselect({required this.tab, required this.seq});

  final int tab;
  final int seq;
}

@Riverpod(keepAlive: true)
class ShellReselectEvents extends _$ShellReselectEvents {
  @override
  ShellReselect? build() => null;

  void fire(int tab) =>
      state = ShellReselect(tab: tab, seq: (state?.seq ?? 0) + 1);
}
