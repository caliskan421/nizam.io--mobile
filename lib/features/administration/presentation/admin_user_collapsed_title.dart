import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/theme/nz_motion.dart';
import '../../../core/ui/widgets/surfaces/nz_avatar.dart';

/// Only this identity listens to the scroll progress. The page and task rows do
/// not rebuild on scroll; the key measures the actual shared top-bar title box.
class AdminUserCollapsedTitle extends StatelessWidget {
  const AdminUserCollapsedTitle({
    super.key,
    required this.name,
    required this.fill,
    required this.ink,
    required this.progress,
    required this.geometryKey,
  });
  final String name;
  final Color fill;
  final Color ink;
  final ValueListenable<double> progress;
  final GlobalKey geometryKey;
  @override
  Widget build(BuildContext context) => SizedBox.expand(
    key: geometryKey,
    child: ExcludeSemantics(
      child: ValueListenableBuilder<double>(
        valueListenable: progress,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NizamioSpacing.space1 + NizamioSpacing.space1 / 2,
          ),
          child: Row(
            children: [
              NzAvatar.initials(
                name: name,
                extent: NzAvatarSize.sm,
                fillColor: fill,
                foregroundColor: ink,
              ),
              const Gap(NizamioSpacing.space2),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.brand,
                ),
              ),
            ],
          ),
        ),
        builder: (context, value, child) => Opacity(
          key: const ValueKey('user-profile-collapsed-title'),
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              NzMotion.reduced(context)
                  ? 0
                  : (1 - value) * NizamioSpacing.space2,
            ),
            child: child,
          ),
        ),
      ),
    ),
  );
}
