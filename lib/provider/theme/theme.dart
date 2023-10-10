import 'package:dependencecoping/provider/theme/colors.dart';
import 'package:dependencecoping/provider/theme/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeState {
  ThemeState({
    required this.mode,
    required this.data,
    required this.color,
  });

  ThemeMode mode;
  ThemeData data;
  ColorValue color;

  void resetThemeData() {
    data = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: color.primary,
        brightness: isLightMode() ? Brightness.light : Brightness.dark,
      ),
      useMaterial3: true,
      brightness: isLightMode() ? Brightness.light : Brightness.dark,
    );

    final bc = data.colorScheme.background;
    final pc = data.colorScheme.surfaceTint;

    const shadow = Colors.transparent;

    data = data.copyWith(
      textTheme: fBodyTextTheme(data.textTheme),
      iconTheme: data.iconTheme.copyWith(
        color: data.colorScheme.onPrimaryContainer,
      ),
      scaffoldBackgroundColor: isLightMode() ? Colors.white : ElevationOverlay.applySurfaceTint(bc, pc, .5),
      appBarTheme: data.appBarTheme.copyWith(
        color: ElevationOverlay.applySurfaceTint(bc, pc, 4),
        shadowColor: shadow,
      ),
      shadowColor: shadow,
      cardTheme: data.cardTheme.copyWith(
        shadowColor: shadow,
      ),
    );
  }

  bool isLightMode() => mode == ThemeMode.light;

  @override
  bool operator ==(final Object other) => false; // ignore: hash_and_equals
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(ThemeState(
          mode: ThemeMode.system,
          color: ColorValue.midnight,
          data: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: ColorValue.midnight.primary,
              brightness: ThemeMode.system == ThemeMode.light ? Brightness.light : Brightness.dark,
            ),
            useMaterial3: true,
            brightness: ThemeMode.system == ThemeMode.light ? Brightness.light : Brightness.dark,
          ),
        ));

  Future<void> flipBrightness() async {
    if (state.isLightMode()) {
      state.mode = ThemeMode.dark;
    } else {
      state.mode = ThemeMode.light;
    }

    state.resetThemeData();

    emit(state);
  }

  void setBrightness(final ThemeMode mode) {
    state.mode = mode;
    state.resetThemeData();
    emit(state);
  }

  void setColor(final ColorValue c) {
    state.color = c;

    state.resetThemeData();

    emit(state);
  }
}
