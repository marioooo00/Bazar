import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:task/core/constants/app_colors.dart';
import 'package:task/screens/auth/otp_screen.dart';

class SignupScreen
    extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() =>
      _SignupScreenState();
}

class _SignupScreenState
    extends State<SignupScreen> {
  final nameController =
      TextEditingController();
  final emailController =
      TextEditingController();
  final passwordController =
      TextEditingController();
  final confirmPasswordController =
      TextEditingController();

  bool loading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  Future<void> signup() async {
    final name = nameController.text
        .trim();
    final email = emailController.text
        .trim();
    final password = passwordController
        .text
        .trim();
    final confirmPassword =
        confirmPasswordController.text
            .trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showMessage(
        'Please fill all fields',
      );
      return;
    }

    if (password != confirmPassword) {
      showMessage(
        'Passwords do not match',
      );
      return;
    }

    if (password.length < 6) {
      showMessage(
        'Password must be at least 6 characters',
      );
      return;
    }

    setState(() => loading = true);

    try {
      final credential = await FirebaseAuth
          .instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

      await credential.user
          ?.updateDisplayName(name);

      await credential.user
          ?.sendEmailVerification();

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpScreen(
            isPhone: false,
            email: email,
          ),
        ),
      );
    } on FirebaseAuthException catch (
      e
    ) {
      showMessage(
        e.message ??
            'Registration failed',
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor:
                AppColors.primary,
          ),
        );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,
      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(
                horizontal: 24,
              ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                  color: AppColors
                      .textDark,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Create your account to get started',
                style: TextStyle(
                  color: AppColors
                      .textMuted,
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              field(
                'Name',
                'Your name',
                nameController,
              ),

              const SizedBox(
                height: 18,
              ),

              field(
                'Email',
                'Your email',
                emailController,
                keyboardType:
                    TextInputType
                        .emailAddress,
              ),

              const SizedBox(
                height: 18,
              ),

              field(
                'Password',
                'Your password',
                passwordController,
                obscure:
                    obscurePassword,
                onVisibility: () {
                  setState(() {
                    obscurePassword =
                        !obscurePassword;
                  });
                },
              ),

              const SizedBox(
                height: 18,
              ),

              field(
                'Confirm Password',
                'Confirm your password',
                confirmPasswordController,
                obscure:
                    obscureConfirmPassword,
                onVisibility: () {
                  setState(() {
                    obscureConfirmPassword =
                        !obscureConfirmPassword;
                  });
                },
              ),

              const SizedBox(
                height: 28,
              ),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: loading
                      ? null
                      : signup,
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
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Colors
                              .white,
                        )
                      : const Text(
                          'Create Account',
                        ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Center(
                child: TextButton(
                  onPressed: () =>
                      Navigator.pop(
                        context,
                      ),
                  child: const Text(
                    'Already have an account? Sign In',
                  ),
                ),
              ),

              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget field(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType =
        TextInputType.text,
    bool obscure = false,
    VoidCallback? onVisibility,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                    14,
                  ),
            ),
            suffixIcon:
                onVisibility == null
                ? null
                : IconButton(
                    onPressed:
                        onVisibility,
                    icon: Icon(
                      obscure
                          ? Icons
                                .visibility_off
                          : Icons
                                .visibility,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
