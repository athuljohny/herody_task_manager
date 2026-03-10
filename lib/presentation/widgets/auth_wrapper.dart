import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';

class AuthWrapper extends GetView<AuthController> {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading while Firebase checks auth state on app start
      if (controller.user == null && controller.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      if (controller.user != null) {
        return const HomePage();
      } else {
        return const LoginPage();
      }
    });
  }
}
