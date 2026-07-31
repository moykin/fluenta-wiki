import 'package:flutter/widgets.dart';

/// Брейкпоинты из дизайн-системы: 640 / 1024 / 1440.
///
/// Макеты сделаны fluid-вёрсткой, поэтому ломаться может и между этими
/// значениями — проверять экраны нужно не только на трёх ширинах.
enum FluentaBreakpoint {
  /// До 640 — телефон. Навигация внизу, контент в одну колонку.
  phone,

  /// 640–1024 — планшет. Навигация сбоку узкой полосой.
  tablet,

  /// 1024–1440 — ноутбук. Навигация сбоку с подписями.
  laptop,

  /// От 1440 — большой экран. Ограничиваем ширину контента.
  desktop;

  static FluentaBreakpoint of(BuildContext context) {
    return fromWidth(MediaQuery.sizeOf(context).width);
  }

  static FluentaBreakpoint fromWidth(double width) {
    if (width < 640) return FluentaBreakpoint.phone;
    if (width < 1024) return FluentaBreakpoint.tablet;
    if (width < 1440) return FluentaBreakpoint.laptop;
    return FluentaBreakpoint.desktop;
  }

  bool get isPhone => this == FluentaBreakpoint.phone;

  /// На планшете и шире навигация уезжает вбок.
  bool get hasSideNavigation => !isPhone;

  /// Подписи у боковой навигации показываем начиная с ноутбука.
  bool get showsNavigationLabels =>
      this == FluentaBreakpoint.laptop || this == FluentaBreakpoint.desktop;
}
