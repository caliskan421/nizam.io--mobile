import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gap/gap.dart';

import '../../../errors/api_error.dart';
import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../feedback/nz_banner.dart';
import 'nz_field_errors.dart';

/// Girdi alanlarını toplayan form. İş mantığı yoktur: doğrulamayı yürütür, geçerliyse
/// [onSubmit]'i çağırır, sunucu hatasını alanlara dağıtır.
///
/// Sunucu `ApiError.fields[]` hataları alana `name` ile (= `ApiFieldError.field`) eşlenir
/// ([NzFieldErrors]); hiçbir alana uymayan alan hatası formun üstünde `NzBanner.danger` olarak
/// gösterilir (yutulmaz). Alan düzenlenince o alanın sunucu hatası gizlenir.
///
/// Gönderim: `NzForm.of(context).submit()` (ör. düğmenin `onPressed`'inde). Odak sırası
/// okuma sırasıdır.
class NzForm extends StatefulWidget {
  const NzForm({
    super.key,
    required this.child,
    this.onSubmit,
    this.serverError,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final Widget child;

  /// Doğrulama geçtiğinde [NzFormState.submit] tarafından çağrılır.
  final VoidCallback? onSubmit;

  /// Son gönderimin hatası; `fields[]` alanlara dağıtılır.
  final ApiError? serverError;
  final AutovalidateMode autovalidateMode;

  /// En yakın form durumu; yoksa assert.
  static NzFormState of(BuildContext context) {
    final state = maybeOf(context);
    assert(state != null, 'NzForm.of: bağlam bir NzForm içinde değil');
    return state!;
  }

  static NzFormState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<NzFormState>();

  @override
  State<NzForm> createState() => NzFormState();
}

class NzFormState extends State<NzForm> implements NzFormRegistry {
  final _formKey = GlobalKey<FormState>();
  final _names = <String, int>{};
  bool _settled = false;
  bool _rebuildScheduled = false;

  @override
  void initState() {
    super.initState();
    // İlk karede alanlar henüz kayıtlı değildir; eşlenmemiş hata ancak kayıtlar oturunca
    // (bir sonraki karede) form düzeyinde gösterilir.
    _scheduleRebuild();
  }

  /// Bütün alanları doğrular (hata metinlerini gösterir); hepsi geçerliyse `true`.
  bool validate() => _formKey.currentState?.validate() ?? true;

  /// Doğrular; geçerliyse [NzForm.onSubmit]'i çağırır. Döndürdüğü: gönderim yapıldı mı.
  bool submit() {
    if (!validate()) return false;
    widget.onSubmit?.call();
    return true;
  }

  /// Alanları ilk değerlerine döndürür.
  void reset() => _formKey.currentState?.reset();

  @override
  void registerField(String name) {
    final n = _names[name] ?? 0;
    _names[name] = n + 1;
    if (n == 0) _scheduleRebuild();
  }

  @override
  void unregisterField(String name) {
    final n = _names[name] ?? 0;
    if (n <= 1) {
      _names.remove(name);
      _scheduleRebuild();
    } else {
      _names[name] = n - 1;
    }
  }

  void _scheduleRebuild() {
    if (_rebuildScheduled) return;
    _rebuildScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _rebuildScheduled = false;
      if (!mounted) return;
      setState(() => _settled = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final errors = NzFieldErrors.resolve(
      widget.serverError,
      _names.keys.toSet(),
    );
    final l = context.l10n;
    return NzFormScope(
      registry: this,
      errors: errors,
      child: FocusTraversalGroup(
        policy: ReadingOrderTraversalPolicy(),
        child: Form(
          key: _formKey,
          autovalidateMode: widget.autovalidateMode,
          // Otomatik doldurma ipuçları (e-posta, parola…) aynı grupta işlenir.
          child: AutofillGroup(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_settled)
                  for (final e in errors.unmatched) ...[
                    NzBanner.danger(message: NzFieldErrors.text(l, e)),
                    const Gap(NizamioSpacing.space3),
                  ],
                widget.child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
