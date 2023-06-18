import 'package:course_asset_management/pages/user/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.purple,
        ),
        scaffoldBackgroundColor: Colors.purple[50],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            padding: const MaterialStatePropertyAll(
              EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 25,
              ),
            ),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            backgroundColor: const MaterialStatePropertyAll(Colors.purple),
          ),
        ),
      ),
      home: LoginPage(),
    );
  }
}
