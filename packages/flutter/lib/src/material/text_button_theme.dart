// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart = 2.8

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'button_style.dart';
import 'theme.dart';

/// A [ButtonStyle] that overrides the default appearance of
/// [TextButton]s when it's used with [TextButtonTheme] or with the
/// overall [Theme]'s [ThemeData.textButtonTheme].
///
/// The [style]'s properties override [TextButton]'s default style,
/// i.e.  the [ButtonStyle] returned by [TextButton.defaultStyleOf]. Only
/// the style's non-null property values or resolved non-null
/// [MaterialStateProperty] values are used.
///
/// See also:
///
///  * [TextButtonTheme], the theme which is configured with this class.
///  * [TextButton.defaultStyleOf], which returns the default [ButtonStyle]
///    for text buttons.
///  * [TextButton.styleOf], which converts simple values into a
///    [ButtonStyle] that's consistent with [TextButton]'s defaults.
///  * [MaterialStateProperty.resolve], "resolve" a material state property
///    to a simple value based on a set of [MaterialState]s.
///  * [ThemeData.textButtonTheme], which can be used to override the default
///    [ButtonStyle] for [TextButton]s below the overall [Theme].
@immutable
class TextButtonThemeData with Diagnosticable {
  /// Creates a [TextButtonThemeData].
  ///
  /// The [style] may be null.
  const TextButtonThemeData({ this.style });

  /// Overrides for [TextButton]'s default style.
  ///
  /// Non-null properties or non-null resolved [MaterialStateProperty]
  /// values override the [ButtonStyle] returned by
  /// [TextButton.defaultStyleOf].
  ///
  /// If [style] is null, then this theme doesn't override anything.
  final ButtonStyle style;

  /// Linearly interpolate between two text button themes.
  static TextButtonThemeData lerp(TextButtonThemeData a, TextButtonThemeData b, double t) {
    assert (t != null);
    if (a == null && b == null)
      return null;
    return TextButtonThemeData(
      style: ButtonStyle.lerp(a?.style, b?.style, t),
    );
  }

  @override
  int get hashCode {
    return style.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other))
      return true;
    if (other.runtimeType != runtimeType)
      return false;
    return other is TextButtonThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ButtonStyle>('style', style, defaultValue: null));
  }
}

/// Overrides the default [ButtonStyle] of its [TextButton] descendants.
///
/// See also:
///
///  * [TextButtonThemeData], which is used to configure this theme.
///  * [TextButton.defaultStyleOf], which returns the default [ButtonStyle]
///    for text buttons.
///  * [TextButton.styleOf], which converts simple values into a
///    [ButtonStyle] that's consistent with [TextButton]'s defaults.
///  * [ThemeData.textButtonTheme], which can be used to override the default
///    [ButtonStyle] for [TextButton]s below the overall [Theme].
class TextButtonTheme extends InheritedTheme {
  /// Create a [TextButtonTheme].
  ///
  /// The [data] parameter must not be null.
  const TextButtonTheme({
    Key key,
    @required this.data,
    Widget child,
  }) : assert(data != null), super(key: key, child: child);

  /// The configuration of this theme.
  final TextButtonThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [TextButtonsTheme] widget, then
  /// [ThemeData.textButtonTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// TextButtonTheme theme = TextButtonTheme.of(context);
  /// ```
  static TextButtonThemeData of(BuildContext context) {
    final TextButtonTheme buttonTheme = context.dependOnInheritedWidgetOfExactType<TextButtonTheme>();
    return buttonTheme?.data ?? Theme.of(context).textButtonTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    final TextButtonTheme ancestorTheme = context.findAncestorWidgetOfExactType<TextButtonTheme>();
    return identical(this, ancestorTheme) ? child : TextButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(TextButtonTheme oldWidget) => data != oldWidget.data;
}