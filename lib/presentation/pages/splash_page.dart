import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/auth_wrapper.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    // Show splash for 2 seconds for branding
    await Future.delayed(const Duration(seconds: 2));
    Get.offAll(() => const AuthWrapper());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB1D8F4), // Light blue top
              Color(0xFFFBFDFF), // Fades to white
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Color(0xFF2D6AA1),
            ),
            const SizedBox(height: 20),
            Text(
              "Herody Task Manager",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0B1426),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Organize your work, easily.",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color(0xFF4A6B8C),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 50),
            const SpinKitFadingCube(color: Color(0xFF2D6AA1), size: 30.0),
          ],
        ),
      ),
    );
  }
}
