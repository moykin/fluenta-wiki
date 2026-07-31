import 'package:flutter/material.dart';

import '../../core/ui/screen_placeholder.dart';

class CareerScreen extends StatelessWidget {
  const CareerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Карьера',
      description:
          'Подготовка к собеседованию на языке: самопрезентация, термины профессии, разбор вакансии и тренировочное интервью.',
      stage: 'Э10',
    );
  }
}
