import 'package:flutter/material.dart';

/// Дизайн-токены Fluenta.
///
/// Значения взяты из `design/README.md` и должны совпадать с макетами
/// один в один. Менять их здесь, а не по месту использования: цвет,
/// заданный прямо в виджете, рано или поздно разъезжается с дизайном.
abstract final class FluentaColors {
  // Поверхности
  static const background = Color(0xFFFAFAF8);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFE5E7EB);
  static const borderWarm = Color(0xFFECECE8);

  // Текст
  static const text = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF6B7280);
  static const textMuted = Color(0xFF9CA3AF);

  // Акцент
  static const indigo = Color(0xFF4F46E5);
  static const indigoHover = Color(0xFF4338CA);
  static const indigo50 = Color(0xFFEEF2FF);
  static const indigo100 = Color(0xFFE0E7FF);
  static const indigo200 = Color(0xFFC7D2FE);
  static const indigo300 = Color(0xFFA5B4FC);

  // Янтарный — только сохранённые слова и выделение фразы
  static const amber = Color(0xFFFBBF24);
  static const amberStrong = Color(0xFFF59E0B);
  static const amberDeep = Color(0xFFB45309);
  static const amberBg = Color(0xFFFFFBEB);

  /// Подсветка выделенного фрагмента: rgba(251,191,36,.34)
  static const phraseHighlight = Color(0x57FBBF24);

  // Успех
  static const success = Color(0xFF10B981);
  static const successDeep = Color(0xFF047857);
  static const successBg = Color(0xFFECFDF5);
  static const successBorder = Color(0xFFA7F3D0);

  // Ошибка
  static const error = Color(0xFFEF4444);
  static const errorDeep = Color(0xFFB91C1C);
  static const errorBg = Color(0xFFFEF2F2);
  static const errorBorder = Color(0xFFFECACA);
}

abstract final class FluentaRadius {
  /// Кнопки и поля ввода
  static const control = 10.0;

  /// Карточки
  static const card = 16.0;

  /// Пилюли и чипы
  static const pill = 999.0;
}

abstract final class FluentaShadows {
  /// Обычная карточка: 0 1px 2px rgba(26,26,26,.04)
  static const card = <BoxShadow>[
    BoxShadow(color: Color(0x0A1A1A1A), blurRadius: 2, offset: Offset(0, 1)),
  ];

  /// Поднятый элемент (попапы, bottom sheet): 0 10px 28px rgba(79,70,229,.10)
  static const raised = <BoxShadow>[
    BoxShadow(color: Color(0x1A4F46E5), blurRadius: 28, offset: Offset(0, 10)),
  ];
}

abstract final class FluentaFonts {
  /// Текст для чтения, заголовки и всё «на языке»
  static const serif = 'SourceSerif4';

  /// Интерфейс
  static const sans = 'Inter';
}

/// Минимальный размер интерактивного элемента на тач-устройствах.
const double kMinTouchTarget = 44;

/// Типографика читалки. Вынесена отдельно, потому что это ядро продукта:
/// кегль и межстрочное расстояние здесь подобраны под длительное чтение.
abstract final class FluentaReaderType {
  static const fontSize = 18.0;
  static const height = 1.72;

  /// Комфортная длина строки — около 68 символов.
  static const maxWidth = 680.0;
}
