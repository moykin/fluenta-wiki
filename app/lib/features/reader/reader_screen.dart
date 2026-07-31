import 'package:flutter/material.dart';

import '../../core/ui/screen_placeholder.dart';

class ReaderScreen extends StatelessWidget {
  const ReaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenPlaceholder(
      title: 'Читалка',
      description:
          'Текст на изучаемом языке. Тап по слову даёт перевод мгновенно, выделение фрагмента — объяснение, почему перевод именно такой.',
      stage: 'Э5',
    );
  }
}
