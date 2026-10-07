import 'package:flutter/material.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/screens/home/home_screen.dart';

class CongratulationsScreen
    extends StatelessWidget {
  const CongratulationsScreen({
    super.key,
  });

  void _openHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const HomeScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
                horizontal: 24,
              ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment
                    .center,
            children: [
              const Spacer(),
              Container(
                width: 128,
                height: 128,
                decoration:
                    BoxDecoration(
                      color:
                          const Color(
                            0xffF5F1FA,
                          ),
                      shape: BoxShape
                          .circle,
                    ),
                child: const Icon(
                  Icons
                      .celebration_outlined,
                  size: 66,
                  color:
                      AppColors.primary,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Congratulations!',
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight:
                      FontWeight.w700,
                  color: Color(
                    0xff222222,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Your account is ready. Discover your next favorite book.',
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(
                    0xff999999,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () =>
                      _openHome(
                        context,
                      ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors
                            .primary,
                    foregroundColor:
                        Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                            25,
                          ),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
