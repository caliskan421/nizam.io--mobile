import 'package:flutter/widgets.dart';

/// Navigator'ın sonuç Future'ı kapanış animasyonundan önce tamamlanır. Form kaynakları
/// rota ağacı kaldırılana kadar yaşar; alttaki eylemler de aynı kaynakları dinleyebilir.
class ChatComposeLifetime extends StatefulWidget {
  const ChatComposeLifetime({
    super.key,
    required this.child,
    required this.onDispose,
  });

  final Widget child;
  final VoidCallback onDispose;

  @override
  State<ChatComposeLifetime> createState() => _ChatComposeLifetimeState();
}

class _ChatComposeLifetimeState extends State<ChatComposeLifetime> {
  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
