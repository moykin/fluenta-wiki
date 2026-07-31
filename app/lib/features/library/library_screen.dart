import 'package:flutter/material.dart';

import '../../core/ui/screen_placeholder.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Библиотека',
      description:
          'Тексты по уровням, процент знакомых слов и импорт своих материалов — PDF, EPUB или ссылка.',
      stage: 'Э7',
    );
  }
}
