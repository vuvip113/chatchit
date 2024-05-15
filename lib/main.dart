import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatchit/ui/views/login/login.dart';
import 'package:chatchit/ui/common/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'We Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: kcVeryLightGrey),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 1,
          iconTheme: IconThemeData(color: kcVeryLightGrey),
          titleTextStyle: TextStyle(
              color: kcVeryLightGrey,
              fontWeight: FontWeight.normal,
              fontSize: 19),
          backgroundColor: orangeNormal,
        ),
      ),
      home: const Login(),
    );
  }
}
