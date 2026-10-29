import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../errors/api_error.dart';
import '../../../errors/error_text.dart';
import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_icon.dart';

/// Hata görünümü. Metin yalnız `errorText(context.l10n, error)`.
///
/// `error.retryAfter` varsa "Yeniden dene" düğmesi süre dolana dek devre dışıdır ve kalan saniye
/// ayrı `Text` ile gösterilir. Süre dolunca düğme yalnız ETKİNLEŞİR; [onRetry] kendiliğinden
/// ÇAĞRILMAZ (otomatik yeniden deneme yok). [onRetry] null → düğme (ve geri sayım) yok.
class NzErrorState extends StatefulWidget {
  /// Sayfa/bölüm ortası (ikon + başlık + metin + düğme).
  const NzErrorState({super.key, required this.error, this.onRetry})
    : _inline = false;

  /// Liste içi / kart içi tek satırlık biçim.
  const NzErrorState.inline({super.key, required this.error, this.onRetry})
    : _inline = true;

  final ApiError error;
  final VoidCallback? onRetry;
  final bool _inline;

  @override
  State<NzErrorState> createState() => _NzErrorStateState();
}

class _NzErrorStateState extends State<NzErrorState> {
  Timer? _timer;
  int _remaining = 0;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void didUpdateWidget(NzErrorState old) {
    super.didUpdateWidget(old);
    if (!identical(old.error, widget.error)) _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    final wait = widget.error.retryAfter;
    // Salt saniyeye yukarı yuvarlanır; sıfır ya da negatif süre geri sayım başlatmaz.
    _remaining = wait == null || wait <= Duration.zero
        ? 0
        : (wait.inMilliseconds / Duration.millisecondsPerSecond).ceil();
    if (_remaining > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), _tick);
    }
  }

  void _tick(Timer timer) {
    setState(() => _remaining--);
    if (_remaining <= 0) timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final waiting = widget.onRetry != null && _remaining > 0;
    final onPressed = widget.onRetry == null || waiting ? null : widget.onRetry;
    final countdown = waiting
        ? _RetryCountdown(remaining: _remaining, inline: widget._inline)
        : null;
    final message = errorText(l, widget.error);

    return widget._inline
        ? _InlineErrorBody(
            message: message,
            countdown: countdown,
            showRetry: widget.onRetry != null,
            onPressed: onPressed,
          )
        : _PageErrorBody(
            message: message,
            countdown: countdown,
            showRetry: widget.onRetry != null,
            onPressed: onPressed,
          );
  }
}

/// Geri sayım satırı ("Yeniden deneme: N sn"); tek anlamsal öğe.
class _RetryCountdown extends StatelessWidget {
  const _RetryCountdown({required this.remaining, required this.inline});

  final int remaining;
  final bool inline;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final text = context.text;
    return MergeSemantics(
      child: Wrap(
        alignment: inline ? WrapAlignment.start : WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: NizamioSpacing.space1,
        children: [
          Text(
            l.uiFeedbackRetryWait,
            style: text.bodySm.copyWith(color: colors.textMuted),
          ),
          Text(
            '$remaining',
            style: text.labelMd.copyWith(color: colors.textMuted),
          ),
          Text(
            l.uiFeedbackSecondsUnit,
            style: text.bodySm.copyWith(color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}

/// Liste içi / kart içi tek satırlık biçim.
class _InlineErrorBody extends StatelessWidget {
  const _InlineErrorBody({
    required this.message,
    required this.countdown,
    required this.showRetry,
    required this.onPressed,
  });

  final String message;
  final Widget? countdown;
  final bool showRetry;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final text = context.text;
    return Semantics(
      container: true,
      liveRegion: true,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: NizamioSpacing.space3,
        runSpacing: NizamioSpacing.space2,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: NzIcon(
                  Icons.error_outline,
                  color: colors.danger,
                  size: NizamioSpacing.space6,
                ),
              ),
              const Gap(NizamioSpacing.space2),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(message, style: text.bodyMd),
                    ?countdown,
                  ],
                ),
              ),
            ],
          ),
          if (showRetry)
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(0, NizamioSpacing.space12),
              ),
              onPressed: onPressed,
              child: Text(l.uiCommonRetry),
            ),
        ],
      ),
    );
  }
}

/// Sayfa/bölüm ortası biçimi (ikon + başlık + metin + düğme).
class _PageErrorBody extends StatelessWidget {
  const _PageErrorBody({
    required this.message,
    required this.countdown,
    required this.showRetry,
    required this.onPressed,
  });

  final String message;
  final Widget? countdown;
  final bool showRetry;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final text = context.text;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(NizamioSpacing.space6),
        child: Semantics(
          container: true,
          liveRegion: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: NzIcon(
                  Icons.error_outline,
                  size: NizamioSpacing.space12,
                  color: colors.danger,
                ),
              ),
              const Gap(NizamioSpacing.space4),
              Semantics(
                header: true,
                child: Text(
                  l.uiFeedbackErrorTitle,
                  textAlign: TextAlign.center,
                  style: text.titleSm,
                ),
              ),
              const Gap(NizamioSpacing.space2),
              Text(
                message,
                textAlign: TextAlign.center,
                style: text.bodyMd.copyWith(color: colors.textMuted),
              ),
              if (countdown != null)
                Padding(
                  padding: const EdgeInsets.only(top: NizamioSpacing.space2),
                  child: countdown,
                ),
              if (showRetry) ...[
                const Gap(NizamioSpacing.space6),
                FilledButton(
                  onPressed: onPressed,
                  child: Text(l.uiCommonRetry),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
