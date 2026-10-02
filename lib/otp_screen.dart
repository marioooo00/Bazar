import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'home_screen.dart';

class OtpScreen extends StatefulWidget {
  final bool isPhone;
  final String? email;

  const OtpScreen({
    super.key,
    required this.isPhone,
    this.email,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpController = TextEditingController();
  final phoneController = TextEditingController();

  String? verificationId;

  bool loading = false;
  bool codeSent = false;

  Future<void> sendPhoneCode() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      showMessage('Enter your phone number');
      return;
    }

    setState(() => loading = true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(
          credential,
        );

        goHome();
      },
      verificationFailed: (FirebaseAuthException e) {
        showMessage(e.message ?? 'Verification failed');

        if (mounted) {
          setState(() => loading = false);
        }
      },
      codeSent: (String id, int? resendToken) {
        verificationId = id;

        if (mounted) {
          setState(() {
            codeSent = true;
            loading = false;
          });
        }
      },
      codeAutoRetrievalTimeout: (String id) {
        verificationId = id;
      },
    );
  }

  Future<void> verifyPhoneCode() async {
    if (verificationId == null) {
      showMessage('Please request a code first');
      return;
    }

    final code = otpController.text.trim();

    if (code.length != 6) {
      showMessage('Enter the 6-digit code');
      return;
    }

    setState(() => loading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: code,
      );

      await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      goHome();
    } on FirebaseAuthException catch (e) {
      showMessage(e.message ?? 'Invalid code');
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Future<void> checkEmailVerification() async {
    setState(() => loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        showMessage('User not found');
        return;
      }

      await user.reload();

      final updatedUser = FirebaseAuth.instance.currentUser;

      if (updatedUser?.emailVerified == true) {
        goHome();
      } else {
        showMessage(
          'Please verify your email first',
        );
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Future<void> resendEmail() async {
    try {
      await FirebaseAuth.instance.currentUser
          ?.sendEmailVerification();

      showMessage('Verification email sent');
    } catch (e) {
      showMessage('Could not send email');
    }
  }

  void goHome() {
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  void dispose() {
    otpController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: widget.isPhone
              ? phoneContent()
              : emailContent(),
        ),
      ),
    );
  }

  Widget phoneContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 35),

        const Icon(
          Icons.phone_android,
          size: 70,
          color: AppColors.primary,
        ),

        const SizedBox(height: 25),

        const Text(
          'Phone Verification',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          codeSent
              ? 'Enter the code sent to your phone'
              : 'Enter your phone number',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textMuted,
          ),
        ),

        const SizedBox(height: 30),

        if (!codeSent)
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: '+20 100 000 0000',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),

        if (codeSent)
          TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              letterSpacing: 8,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: '------',
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),

        const Spacer(),

        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: loading
                ? null
                : codeSent
                    ? verifyPhoneCode
                    : sendPhoneCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: loading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    codeSent ? 'Verify Code' : 'Send Code',
                  ),
          ),
        ),
      ],
    );
  }

  Widget emailContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 35),

        const Icon(
          Icons.mark_email_read_outlined,
          size: 75,
          color: AppColors.primary,
        ),

        const SizedBox(height: 25),

        const Text(
          'Verify Your Email',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          'We sent a verification link to:',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textMuted,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          widget.email ?? '',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Open your email and click the verification link, then return here.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textMuted,
            height: 1.5,
          ),
        ),

        const Spacer(),

        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: loading
                ? null
                : checkEmailVerification,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: loading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text('I Verified My Email'),
          ),
        ),

        TextButton(
          onPressed: loading ? null : resendEmail,
          child: const Text(
            'Resend Verification Email',
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}