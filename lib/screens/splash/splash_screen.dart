import 'dart:async';

import 'package:flutter/material.dart';

import 'package:task/core/constants/app_colors.dart';
import 'package:task/screens/onboarding/onboarding_screen.dart';

class SplashScreen
    extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen>
    with
        SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1200,
      ),
    );

    fadeAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );

    scaleAnimation =
        Tween<double>(
          begin: 0.8,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeOutBack,
          ),
        );

    controller.forward();

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const OnboardingScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: const Text(
              'Bazar.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
