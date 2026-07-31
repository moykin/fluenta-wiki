import 'package:flutter/material.dart';

import '../../core/ui/screen_placeholder.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Профиль',
      description: 'Тариф, остаток голосовых минут и журнал их расхода.',
      stage: 'Э8',
    );
  }
}
