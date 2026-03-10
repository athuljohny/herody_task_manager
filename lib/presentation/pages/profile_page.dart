import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/auth_controller.dart';
import '../controllers/theme_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController _authController = Get.find<AuthController>();
  final ThemeController _themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Title
              Text(
                "Profile & Settings",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 40),

              // Avatar
              Obx(() {
                final user = _authController.user;
                final name =
                    user?.email?.split('@')[0] ?? user?.displayName ?? 'User';
                final email = user?.email ?? '';
                final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';

                return Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? Colors.grey[800]! : Colors.white,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initials,
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.edit,
                          color: Colors.blueAccent,
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      email,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 40),

              // Divider
              Divider(color: isDark ? Colors.grey[800] : Colors.grey[300]),
              const SizedBox(height: 20),

              // Theme Mode Setting
              Row(
                children: [
                  Icon(
                    Icons.dark_mode_outlined,
                    color: isDark ? Colors.grey[400] : Colors.black87,
                    size: 24,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "Theme Mode",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.grey[300] : Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Obx(
                    () => DropdownButton<String>(
                      value: _themeController.isDarkMode ? 'Dark' : 'Light',
                      underline: const SizedBox(),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      items: ['Light', 'Dark'].map((String mode) {
                        return DropdownMenuItem<String>(
                          value: mode,
                          child: Text(
                            mode,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue == 'Dark' &&
                            !_themeController.isDarkMode) {
                          _themeController.toggleTheme();
                        } else if (newValue == 'Light' &&
                            _themeController.isDarkMode) {
                          _themeController.toggleTheme();
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Divider(color: isDark ? Colors.grey[800] : Colors.grey[300]),
              const SizedBox(height: 20),

              // Logout Button
              InkWell(
                onTap: () => _authController.signOut(),
                splashColor: Colors.redAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.logout,
                        color: Colors.redAccent,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Logout",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
