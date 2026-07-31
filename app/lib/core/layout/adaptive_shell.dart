import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'breakpoints.dart';
import 'destinations.dart';

/// Каркас приложения, который перестраивается под ширину экрана.
///
/// Это один и тот же экранный поток в трёх раскладках, а не три разных
/// экрана: телефон получает нижние вкладки, планшет — узкую боковую
/// полосу, ноутбук и десктоп — боковую навигацию с подписями.
class AdaptiveShell extends StatelessWidget {
  const AdaptiveShell({
    required this.child,
    required this.currentDestination,
    required this.onDestinationSelected,
    super.key,
  });

  final Widget child;
  final AppDestination currentDestination;
  final ValueChanged<AppDestination> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final breakpoint = FluentaBreakpoint.of(context);

    if (breakpoint.hasSideNavigation) {
      return Scaffold(
        body: Row(
          children: [
            _SideNavigation(
              current: currentDestination,
              extended: breakpoint.showsNavigationLabels,
              onSelected: onDestinationSelected,
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: _BottomNavigation(
        current: currentDestination,
        onSelected: onDestinationSelected,
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({required this.current, required this.onSelected});

  final AppDestination current;
  final ValueChanged<AppDestination> onSelected;

  @override
  Widget build(BuildContext context) {
    final items = AppDestination.bottomBarItems;
    // Разделы вне таббара (Карьера, Профиль) не должны подсвечивать
    // случайную вкладку — в этом случае выделения просто нет.
    final index = items.indexOf(current);

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: FluentaColors.border)),
      ),
      child: NavigationBar(
        selectedIndex: index < 0 ? 0 : index,
        onDestinationSelected: (i) => onSelected(items[i]),
        destinations: [
          for (final d in items)
            NavigationDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selectedIcon),
              label: d.label,
              tooltip: d.label,
            ),
        ],
      ),
    );
  }
}

class _SideNavigation extends StatelessWidget {
  const _SideNavigation({
    required this.current,
    required this.extended,
    required this.onSelected,
  });

  final AppDestination current;
  final bool extended;
  final ValueChanged<AppDestination> onSelected;

  @override
  Widget build(BuildContext context) {
    const items = AppDestination.values;

    return NavigationRail(
      extended: extended,
      minWidth: 72,
      minExtendedWidth: 208,
      selectedIndex: items.indexOf(current),
      onDestinationSelected: (i) => onSelected(items[i]),
      leading: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 12, left: extended ? 4 : 0),
        child: _Wordmark(compact: !extended),
      ),
      destinations: [
        for (final d in items)
          NavigationRailDestination(
            icon: Icon(d.icon),
            selectedIcon: Icon(d.selectedIcon),
            label: Text(d.label),
          ),
      ],
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return const Text(
        'F',
        style: TextStyle(
          fontFamily: FluentaFonts.serif,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: FluentaColors.indigo,
        ),
      );
    }

    return const Text(
      'Fluenta',
      style: TextStyle(
        fontFamily: FluentaFonts.serif,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: FluentaColors.text,
      ),
    );
  }
}
