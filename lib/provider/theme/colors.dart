import 'package:flutter/material.dart';

enum ColorValue {
  ocean(name: 'Ocean', canvas: Color(0xFF4CB6EE)),
  midnight(name: 'Midnight', canvas: Color(0xFF7C5DE2)),
  cherry(name: 'Cherry', canvas: Color(0xFFF63322)),
  // sun(name: 'Sun', canvas: Color(0xFFF97B0C)),
  garden(name: 'Garden', canvas: Color(0xFF9ACF5C)),
  pine(name: 'Pine', canvas: Color(0xFF29B898));

  const ColorValue({
    required this.name,
    required this.canvas,
  });

  final String name;
  final Color canvas;

  Color get primary => HSLColor.fromColor(canvas).withLightness(.1).withSaturation(.1).toColor();
}

ColorValue findThemeColor(final String c) => ColorValue.values.where((final v) => v.name == c).firstOrNull ?? ColorValue.midnight;

String matchingImage(final ColorValue color, final ThemeMode mode) {
  String url;
  switch (color) {
    case ColorValue.ocean:
      url = mode == ThemeMode.light ? 'photo-1541617219835-3689726fa8e7' : 'photo-1441829266145-6d4bfbd38eb4';
    case ColorValue.midnight:
      url = mode == ThemeMode.light ? 'photo-1486046866764-e426b5b93d98' : 'photo-1519758747502-84b7b18a6160';
    case ColorValue.cherry:
      url = mode == ThemeMode.light ? 'photo-1563306206-900cc99112fc' : 'photo-1593073932946-fe6f4b260648';
    // case ColorValue.sun:
    //   url = mode == ThemeMode.light ? 'photo-1488462237308-ecaa28b729d7' : 'photo-1609171712489-45b6ba7051a4';
    case ColorValue.garden:
      url = mode == ThemeMode.light ? 'photo-1510274460854-4b7ad642d3a9' : 'photo-1574002332972-fd2e0f7f1ea9';
    case ColorValue.pine:
      url = mode == ThemeMode.light ? 'photo-1557456170-0cf4f4d0d362' : 'photo-1531951665218-b8b598959072';
  }

  return 'https://images.unsplash.com/$url?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=900&h=1200&q=80';
}
