import 'package:ambientese/main_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: TextStyle(color: Colors.grey[800]),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF0D47A1)),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFF0D47A1),
          selectionColor: Colors.blue[100],
          selectionHandleColor: Color(0xFF0D47A1),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0D47A1),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.blue[50]),
            foregroundColor: WidgetStateProperty.all(Color(0xFF0D47A1)),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          checkColor: WidgetStateProperty.all(Colors.white),
          fillColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return Color(0xFF0D47A1);
              }
              return Colors.white;
            },
          ),
        ),
      ),
      home: LoginScreen(),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale('pt', 'BR'),
    );
  }
}
