import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:task/core/config/firebase_options.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform,
  );

  runApp(const BazarApp());
}

class BazarApp extends StatelessWidget {
  const BazarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bazar',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor:
            AppColors.background,
        colorScheme:
            ColorScheme.fromSeed(
              seedColor:
                  AppColors.primary,
            ),
      ),
      home: const SplashScreen(),
    );
  }
}
