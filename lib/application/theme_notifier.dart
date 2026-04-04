import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_notifier.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  late Box _settingsBox;

  @override
  ThemeMode build() {
    _settingsBox = Hive.box('settingsBox');
    final isDark = _settingsBox.get('themeMode', defaultValue: false) as bool;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme(bool isDark) {
    _settingsBox.put('themeMode', isDark);
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}
