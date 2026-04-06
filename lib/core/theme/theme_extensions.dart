import 'package:flutter/material.dart';

import 'app_palette.dart';

extension AppThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  AppPalette get appPalette => theme.extension<AppPalette>()!;
  bool get isDarkMode => theme.brightness == Brightness.dark;
}
