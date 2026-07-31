import 'package:flutter/material.dart';

import '../../core/ui/screen_placeholder.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Повторение',
      description:
          'Карточки по предложениям из ваших текстов. Ошибки из пересказа возвращаются на следующее утро.',
      stage: 'Э7',
    );
  }
}
