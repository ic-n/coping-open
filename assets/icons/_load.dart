// ignore_for_file: avoid_print

import 'dart:io';

// dart run ./_load.dart

Future<void> main() async {
  const style = 'wght500';
  print('starting');

  final Directory dir = Directory('.');
  await dir.list().forEach((final f) {
    if (f.path.endsWith('.svg')) {
      final t = f.path.substring(2, f.path.length - 4);
      print('loading $t');
      loadIcon(t, style);
    }
  });
}

Future<void> loadIcon(final String icon, final String style) async {
  final url = 'https://fonts.gstatic.com/s/i/short-term/release/materialsymbolsoutlined/$icon/$style/40px.svg';

  final request = await HttpClient().getUrl(Uri.parse(url));
  final response = await request.close();
  await response.pipe(File('$icon.svg').openWrite());
}
