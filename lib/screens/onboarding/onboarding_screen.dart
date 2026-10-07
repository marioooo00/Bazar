import 'package:flutter/material.dart';

import 'package:task/core/constants/app_colors.dart';
import 'package:task/screens/auth/login_screen.dart';

class OnboardingScreen
    extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen>
  createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends State<OnboardingScreen> {
  final PageController pageController =
      PageController();

  int currentPage = 0;

  final List<Map<String, String>>
  pages = [
    {
      'image': 'assets/images/onboarding1.png',
      'title': 'Now reading books\nwill be easier',
      'description': 'Discover new worlds and start your reading adventure effortlessly.',
    },
    {
      'image': 'assets/images/onboarding2.png',
      'title': 'Your Bookish Soulmate\nAwaits',
      'description': 'Discover books tailored to your tastes for a truly rewarding experience.',
    },
    {
      'image': 'assets/images/onboarding3.png',
      'title': 'Start Your Adventure',
      'description': 'Ready to discover something new? Your adventure begins now.',
    },
  ];

  void nextPage() {
    if (currentPage <
        pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(
          milliseconds: 350,
        ),
        curve: Curves.easeInOut,
      );
    } else {
      goToLogin();
    }
  }

  void goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment:
                  Alignment.centerRight,
              child: TextButton(
                onPressed: goToLogin,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: AppColors
                        .primary,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller:
                    pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(
                          horizontal:
                              24,
                        ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      children: [
                        Image.asset(
                          pages[index]['image']!,
                          height: 240,
                          fit: BoxFit
                              .contain,
                        ),

                        const SizedBox(
                          height: 35,
                        ),

                        Text(
                          pages[index]['title']!,
                          textAlign:
                              TextAlign
                                  .center,
                          style: const TextStyle(
                            fontSize:
                                23,
                            fontWeight:
                                FontWeight
                                    .bold,
                            color: AppColors
                                .textDark,
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        Text(
                          pages[index]['description']!,
                          textAlign:
                              TextAlign
                                  .center,
                          style: const TextStyle(
                            fontSize:
                                14,
                            height: 1.5,
                            color: AppColors
                                .textMuted,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicator
            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .center,
              children: List.generate(
                pages.length,
                (index) {
                  return AnimatedContainer(
                    duration:
                        const Duration(
                          milliseconds:
                              250,
                        ),
                    margin:
                        const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                    width:
                        index ==
                            currentPage
                        ? 22
                        : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color:
                          index ==
                              currentPage
                          ? AppColors
                                .primary
                          : const Color(
                              0xFFE6E4EB,
                            ),
                      borderRadius:
                          BorderRadius.circular(
                            10,
                          ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 28),

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors
                            .primary,
                    foregroundColor:
                        Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                            16,
                          ),
                    ),
                  ),
                  child: Text(
                    currentPage ==
                            pages.length -
                                1
                        ? 'Get Started'
                        : 'Next',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: goToLogin,
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        AppColors
                            .primary,
                    side: const BorderSide(
                      color: AppColors
                          .border,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                            16,
                          ),
                    ),
                  ),
                  child: const Text(
                    'Sign in',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
