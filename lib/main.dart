import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme_provider.dart';
import 'notes_list.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeProvider>(
      builder: (context, themeProvider, _) => MaterialApp(
        title: 'Notes App',
        theme: themeProvider.themeData,
        home: NotesList(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
