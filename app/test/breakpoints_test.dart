import 'package:fluenta/core/layout/breakpoints.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Брейкпоинты', () {
    test('границы совпадают с дизайн-системой: 640 / 1024 / 1440', () {
      expect(FluentaBreakpoint.fromWidth(390), FluentaBreakpoint.phone);
      expect(FluentaBreakpoint.fromWidth(639), FluentaBreakpoint.phone);
      expect(FluentaBreakpoint.fromWidth(640), FluentaBreakpoint.tablet);
      expect(FluentaBreakpoint.fromWidth(834), FluentaBreakpoint.tablet);
      expect(FluentaBreakpoint.fromWidth(1024), FluentaBreakpoint.laptop);
      expect(FluentaBreakpoint.fromWidth(1280), FluentaBreakpoint.laptop);
      expect(FluentaBreakpoint.fromWidth(1440), FluentaBreakpoint.desktop);
    });

    test('боковая навигация появляется начиная с планшета', () {
      expect(FluentaBreakpoint.phone.hasSideNavigation, isFalse);
      expect(FluentaBreakpoint.tablet.hasSideNavigation, isTrue);
      expect(FluentaBreakpoint.desktop.hasSideNavigation, isTrue);
    });

    test('подписи у боковой навигации — только от ноутбука и шире', () {
      expect(FluentaBreakpoint.tablet.showsNavigationLabels, isFalse);
      expect(FluentaBreakpoint.laptop.showsNavigationLabels, isTrue);
      expect(FluentaBreakpoint.desktop.showsNavigationLabels, isTrue);
    });
  });
}
