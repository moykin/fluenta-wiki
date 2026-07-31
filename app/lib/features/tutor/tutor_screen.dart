import 'package:flutter/material.dart';

import '../../core/ui/screen_placeholder.dart';

class TutorScreen extends StatelessWidget {
  const TutorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Тьютор',
      description:
          'Пересказ прочитанного вслух. Тьютор проверяет, что вы запомнили, и даёт ровно одну правку.',
      stage: 'Э6',
    );
  }
}
