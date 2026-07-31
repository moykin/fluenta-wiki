import 'package:flutter/material.dart';

import '../../core/ui/screen_placeholder.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Прогресс',
      description:
          'Слова, сессии, минуты речи и уровень со шкалой соответствия международным тестам.',
      stage: 'Э8',
    );
  }
}
