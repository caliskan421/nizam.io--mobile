import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/mobile_release_policy.dart';
import '../../core/config/release_policy_provider.dart';
import '../../core/config/running_release.dart';
import '../../core/providers.dart';
import '../../core/server/server_binding.dart';
import '../../core/ui/extensions/context_ext.dart';
import '../../core/ui/page/nz_update_page.dart';

/// A mandatory gate replaces the whole navigator, including deep links/dialogs.
/// The optional panel lives in the same tree and cannot obscure a mandatory gate.
class ReleasePolicyHost extends ConsumerStatefulWidget {
  const ReleasePolicyHost({super.key, required this.child});
  final Widget child;
  @override
  ConsumerState<ReleasePolicyHost> createState() => _ReleasePolicyHostState();
}

class _ReleasePolicyHostState extends ConsumerState<ReleasePolicyHost> {
  late final AppLifecycleListener _listener;
  DateTime? _lastRefresh;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(onResume: _resume);
  }

  void _resume() {
    final now = DateTime.now();
    if (_lastRefresh != null &&
        now.difference(_lastRefresh!) < const Duration(minutes: 5)) {
      return;
    }
    _refresh();
  }

  void _refresh() {
    _lastRefresh = DateTime.now();
    ref.invalidate(mobileReleasePolicyProvider);
    unawaited(
      ref
          .read(mobileReleasePolicyProvider.future)
          .then<void>((_) {}, onError: (Object _, StackTrace _) {}),
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final release = ref.watch(runningReleaseProvider);
    if (release.platform == null) return widget.child;
    final policy = ref.watch(mobileReleasePolicyProvider);
    // While the local validated cache is loading, do not expose protected routes.
    if (policy.value == null && policy.hasError) {
      return NzUpdatePage(
        title: context.l10n.uiFeedbackErrorTitle,
        message: context.l10n.uiServerUpdatePolicyUnavailable,
        onRecheck: _refresh,
      );
    }
    if (policy.value == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final requirement = policy.value!.evaluate(
      platform: release.platform!,
      runningVersion: release.version,
      runningBuild: release.build,
    );
    if (requirement == MobileUpdateRequirement.required ||
        requirement == MobileUpdateRequirement.incompatible) {
      return PopScope(
        canPop: false,
        child: NzUpdatePage(
          title: context.l10n.uiServerUpdateTitle,
          message: requirement == MobileUpdateRequirement.incompatible
              ? context.l10n.uiServerUpdateInvalidVersion
              : context.l10n.uiServerUpdateRemoteMessage,
          onRecheck: _refresh,
        ),
      );
    }
    final binding = ref.watch(bindingStateProvider);
    final showOptional =
        requirement == MobileUpdateRequirement.optional &&
        !_dismissed &&
        binding is BindingVerified;
    return Stack(
      fit: StackFit.expand,
      children: [
        Offstage(
          offstage: showOptional,
          child: ExcludeFocus(
            excluding: showOptional,
            child: TickerMode(enabled: !showOptional, child: widget.child),
          ),
        ),
        if (showOptional)
          NzUpdatePage(
            title: context.l10n.uiServerUpdateOptionalTitle,
            message: context.l10n.uiServerUpdateOptionalMessage,
            onRecheck: _refresh,
            onDismiss: () => setState(() => _dismissed = true),
          ),
      ],
    );
  }
}
