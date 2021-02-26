import 'package:flutter/material.dart';
import 'package:movie_list/ui/home.dart';

import 'ui/movieslist.dart';

void main() {
  runApp(new MaterialApp(
    home: moviehome(),
    theme: ThemeData(
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
        backgroundColor:Colors.grey.shade600,
      )
    ),
  ));
}

