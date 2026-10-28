import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/chat_logic.dart';

part 'messages_controller.g.dart';

/// Mesajlar listesinin durumu: süzgeç ve arama.
@immutable
final class MessagesViewState {
  const MessagesViewState({
    this.filter = ChatFilter.all,
    this.searchOpen = false,
    this.query = '',
  });

  final ChatFilter filter;
  final bool searchOpen;
  final String query;
}

@Riverpod(keepAlive: true)
class MessagesController extends _$MessagesController {
  @override
  MessagesViewState build() => const MessagesViewState();

  void setFilter(ChatFilter f) => state = MessagesViewState(
    filter: f,
    searchOpen: state.searchOpen,
    query: state.query,
  );

  /// Arama kutusunu açar/kapatır; kapanınca sorgu temizlenir.
  void toggleSearch() => state = MessagesViewState(
    filter: state.filter,
    searchOpen: !state.searchOpen,
    query: state.searchOpen ? '' : state.query,
  );

  void setQuery(String q) => state = MessagesViewState(
    filter: state.filter,
    searchOpen: state.searchOpen,
    query: q,
  );
}
