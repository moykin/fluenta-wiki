import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/career/career_screen.dart';
import '../../features/library/library_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/progress/progress_screen.dart';
import '../../features/reader/reader_screen.dart';
import '../../features/review/review_screen.dart';
import '../../features/tutor/tutor_screen.dart';
import '../layout/adaptive_shell.dart';
import '../layout/destinations.dart';

/// Маршруты приложения.
///
/// Все разделы живут внутри общего каркаса: при переходе перерисовывается
/// только содержимое, а навигация остаётся на месте.
GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppDestination.library.path,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AdaptiveShell(
            currentDestination: _destinationOf(state.uri.path),
            onDestinationSelected: (d) => context.go(d.path),
            child: child,
          );
        },
        routes: [
          for (final entry in _screens.entries)
            GoRoute(
              path: entry.key.path,
              name: entry.key.name,
              // Без анимации перехода: разделы верхнего уровня меняются
              // мгновенно, как вкладки, а не как переход вглубь.
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: entry.value()),
            ),
        ],
      ),
    ],
  );
}

typedef _ScreenBuilder = Widget Function();

final Map<AppDestination, _ScreenBuilder> _screens = {
  AppDestination.library: LibraryScreen.new,
  AppDestination.reader: ReaderScreen.new,
  AppDestination.tutor: TutorScreen.new,
  AppDestination.review: ReviewScreen.new,
  AppDestination.progress: ProgressScreen.new,
  AppDestination.career: CareerScreen.new,
  AppDestination.profile: ProfileScreen.new,
};

AppDestination _destinationOf(String path) {
  for (final destination in AppDestination.values) {
    if (path.startsWith(destination.path)) return destination;
  }
  return AppDestination.library;
}
