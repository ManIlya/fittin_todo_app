import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/page/todo_edit_page.dart';
import 'package:todo_app/page/todo_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF9900),
          primary: const Color(0xFFFF9900),
          background: const Color(0xFFEDEDED),
          onBackground: const Color(0xFF000000),
          error: const Color(0xFFF85535),
          secondary: const Color(0xFF45B443),
          surface: Colors.white,
        ),
        textTheme: TextTheme(
          headlineSmall: GoogleFonts.montserrat(
            fontSize: 24,
            height: 32 / 24,
            fontWeight: FontWeight.bold,
          ),
          titleSmall: GoogleFonts.montserrat(
            fontSize: 16,
            height: 20 / 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      routes: {
        '/': (context) => const TodoListPage(),
        '/add': (context) => const TodoEditPage(),
      },
      initialRoute: '/',
    );
  }
}
