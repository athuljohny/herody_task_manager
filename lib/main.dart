import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/dependency_injection.dart';
import 'presentation/pages/splash_page.dart';

// IMPORTANT: You need to add your Firebase options here if you are not using flutterfire CLI
// For this example, we assume Firebase is initialized with default options or a google-services.json is present.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Allow google_fonts to fetch fonts over HTTP (avoids AssetManifest.json error)
  GoogleFonts.config.allowRuntimeFetching = true;

  bool firebaseInitialized = false;
  try {
    await Firebase.initializeApp();
    firebaseInitialized = true;
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  if (firebaseInitialized) {
    DependencyInjection.init();
  }

  runApp(MyApp(isFirebaseReady: firebaseInitialized));
}

class MyApp extends StatelessWidget {
  final bool isFirebaseReady;
  const MyApp({super.key, required this.isFirebaseReady});

  @override
  Widget build(BuildContext context) {
    if (!isFirebaseReady) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              "Configuration Error\nCheck your Firebase setup.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.red),
            ),
          ),
        ),
      );
    }
    return GetMaterialApp(
      title: 'Herody Task Manager',
      debugShowCheckedModeBanner: false,
      themeMode:
          ThemeMode.system, // Will be overridden by ThemeController if ready
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),
      home: const SplashPage(),
    );
  }
}
