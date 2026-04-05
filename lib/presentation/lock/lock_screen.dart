import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/security/biometric_service.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authenticate();
    });
  }

  Future<void> _authenticate() async {
    final success = await BiometricService.authenticate();
    if (success && mounted) {
      context.go('/home');
    } else if (mounted) {
      setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/app_icon.png', width: 64, height: 64),
              const SizedBox(height: 16),
              const Text(
                'Flo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 48),
              GestureDetector(
                onTap: _authenticate,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF64F9BC).withValues(alpha: 0.1),
                    border: Border.all(
                      color: const Color(0xFF64F9BC).withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.fingerprint,
                    size: 60,
                    color: Color(0xFF64F9BC),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Tap to unlock',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Flo Finance',
                style: TextStyle(color: Colors.white38, fontSize: 13),
              ),
              if (_failed) ...[
                const SizedBox(height: 32),
                TextButton(
                  onPressed: _authenticate,
                  child: const Text(
                    'Try again',
                    style: TextStyle(
                      color: Color(0xFF64F9BC),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
