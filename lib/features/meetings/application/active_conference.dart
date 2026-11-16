import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_conference.g.dart';

/// Uygulamadaki etkin görüşme: hangi toplantının odasındayız ve görüşme ekranı şu an açık mı.
/// Aynı anda tek oda vardır. Ekran kapalıyken oda sürer ve yüzen mini pencere görünür.
@immutable
final class ActiveConference {
  const ActiveConference({this.inCall, this.onScreen});

  /// Odasında bulunulan toplantı (bağlı ya da yeniden bağlanıyor).
  final String? inCall;

  /// Görüşme ekranı açık olan toplantı.
  final String? onScreen;

  /// Mini pencere gösterilir mi (odadayız, ekran kapalı).
  String? get docked => inCall != null && onScreen != inCall ? inCall : null;

  @override
  bool operator ==(Object other) =>
      other is ActiveConference &&
      other.inCall == inCall &&
      other.onScreen == onScreen;

  @override
  int get hashCode => Object.hash(inCall, onScreen);
}

@Riverpod(keepAlive: true)
class ActiveConferenceController extends _$ActiveConferenceController {
  @override
  ActiveConference build() => const ActiveConference();

  void enter(String meetingId) =>
      state = ActiveConference(inCall: meetingId, onScreen: state.onScreen);

  void exit(String meetingId) {
    if (state.inCall != meetingId) return;
    state = ActiveConference(onScreen: state.onScreen);
  }

  void screen(String meetingId, {required bool open}) {
    // Ekran kapanışı kap atıldıktan sonra gelebilir (oturum kapanışı, test sonu).
    if (!ref.mounted) return;
    if (open) {
      state = ActiveConference(inCall: state.inCall, onScreen: meetingId);
    } else if (state.onScreen == meetingId) {
      state = ActiveConference(inCall: state.inCall);
    }
  }
}
