import 'package:flutter/material.dart';

import '../layout/breakpoints.dart';
import '../theme/tokens.dart';

/// Временная заглушка раздела.
///
/// Каркас приложения готов раньше содержимого, поэтому разделы пока
/// показывают своё название и то, на каком этапе появятся. Заглушка
/// оформлена по дизайн-системе, чтобы уже сейчас было видно типографику
/// и поведение раскладки на разных ширинах.
class ScreenPlaceholder extends StatelessWidget {
  const ScreenPlaceholder({
    required this.title,
    required this.description,
    required this.stage,
    super.key,
  });

  final String title;
  final String description;

  /// Этап из `docs/ROADMAP.md`, на котором раздел будет сделан.
  final String stage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPhone = FluentaBreakpoint.of(context).isPhone;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isPhone ? 20 : 40,
            vertical: 32,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: FluentaReaderType.maxWidth,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.headlineMedium),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: FluentaColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: FluentaColors.indigo50,
                    border: Border.all(color: FluentaColors.indigo100),
                    borderRadius: BorderRadius.circular(FluentaRadius.pill),
                  ),
                  child: Text(
                    'Появится на этапе $stage',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: FluentaColors.indigoHover,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const _Purpose(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Тихая строка с целью продукта — она должна быть внутри приложения
/// именно такой: неброской, 12.5px, приглушённым цветом.
class _Purpose extends StatelessWidget {
  const _Purpose();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Цель — превратить то, что вы читаете, в то, что вы можете сказать',
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: FluentaColors.textMuted,
        fontSize: 12.5,
      ),
    );
  }
}
