import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chatchit/firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chatchit/ui/common/app_colors.dart';
import 'package:chatchit/ui/views/splash/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then(
    (value) {
      _initializeFirebase();
      runApp(const MyApp());
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'We Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        colorScheme: const ColorScheme.light(
          // surface: orangeNormal,
          primary: orangeLight,
          // onPrimary: orangeLight,
        ),
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
      home: const Splash(),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
