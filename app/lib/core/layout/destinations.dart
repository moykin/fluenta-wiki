import 'package:flutter/material.dart';

/// Разделы приложения.
///
/// На телефоне помещается пять вкладок — столько же, сколько в макете
/// (`fluenta-mobile.css`: `grid-template-columns: repeat(5, 1fr)`).
/// «Карьера» и «Профиль» на телефоне доступны из шапки, а не из таббара.
///
/// «Видео» в макетах есть, но до релиза этот раздел не развиваем, поэтому
/// пятой вкладкой стоит «Прогресс».
enum AppDestination {
  library(
    path: '/library',
    label: 'Библиотека',
    icon: Icons.menu_book_outlined,
    selectedIcon: Icons.menu_book,
    inBottomBar: true,
  ),
  reader(
    path: '/reader',
    label: 'Читалка',
    icon: Icons.article_outlined,
    selectedIcon: Icons.article,
    inBottomBar: true,
  ),
  tutor(
    path: '/tutor',
    label: 'Тьютор',
    icon: Icons.mic_none_outlined,
    selectedIcon: Icons.mic,
    inBottomBar: true,
  ),
  review(
    path: '/review',
    label: 'Повторение',
    icon: Icons.style_outlined,
    selectedIcon: Icons.style,
    inBottomBar: true,
  ),
  progress(
    path: '/progress',
    label: 'Прогресс',
    icon: Icons.insights_outlined,
    selectedIcon: Icons.insights,
    inBottomBar: true,
  ),
  career(
    path: '/career',
    label: 'Карьера',
    icon: Icons.work_outline,
    selectedIcon: Icons.work,
    inBottomBar: false,
  ),
  profile(
    path: '/profile',
    label: 'Профиль',
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    inBottomBar: false,
  );

  const AppDestination({
    required this.path,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.inBottomBar,
  });

  final String path;
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  /// Показывать ли раздел в нижнем таббаре на телефоне.
  final bool inBottomBar;

  static List<AppDestination> get bottomBarItems =>
      values.where((d) => d.inBottomBar).toList();
}
