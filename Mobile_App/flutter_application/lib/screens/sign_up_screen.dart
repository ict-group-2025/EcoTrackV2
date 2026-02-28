import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application/utils/input_field.dart';
import 'package:flutter_application/utils/primary_button.dart';
import 'package:flutter_application/controller/auth_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: Color(0xFF1A2340),
                ),
              ),
              const SizedBox(height: 28),

              // Title
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A2340),
                  letterSpacing: -0.5,
                ),
              ),
          
              const SizedBox(height: 32),

              // Username
              InputField(
                label: 'USERNAME',
                hint: 'username',
                prefixIcon: Icons.alternate_email,
                controller: _usernameCtrl,
              ),
              const SizedBox(height: 20),

              // Full name
              InputField(
                label: 'FULL NAME',
                hint: 'John Doe',
                prefixIcon: Icons.person_outline,
                controller: _fullNameCtrl,
              ),
              const SizedBox(height: 20),

              // Email
              InputField(
                label: 'EMAIL ADDRESS',
                hint: 'john@example.com',
                prefixIcon: Icons.email_outlined,
                controller: _emailCtrl,
              ),
              const SizedBox(height: 20),

              // Password
              InputField(
                label: 'PASSWORD',
                hint: '••••••••',
                prefixIcon: Icons.lock_outline,
                obscure: true,
                controller: _passwordCtrl,
              ),
              const SizedBox(height: 28),

              // Sign Up button
              Consumer<AuthController>(
                builder: (context, authController, child) {
                  return Column(
                    children: [
                      if (authController.errorMessage != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5252).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFFF5252).withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Color(0xFFFF5252),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authController.errorMessage!,
                                  style: const TextStyle(
                                    color: Color(0xFFFF5252),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => authController.clearError(),
                                child: const Icon(
                                  Icons.close,
                                  color: Color(0xFFFF5252),
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      PrimaryButton(
                        text: authController.isLoading ? 'Creating Account...' : 'Sign Up',
                        onTap: authController.isLoading
                            ? () {}
                            : () async {
                                if (_usernameCtrl.text.trim().isEmpty ||
                                    _fullNameCtrl.text.trim().isEmpty ||
                                    _emailCtrl.text.trim().isEmpty ||
                                    _passwordCtrl.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please fill in all fields'),
                                      backgroundColor: Color(0xFFFF5252),
                                    ),
                                  );
                                  return;
                                }

                                if (!_emailCtrl.text.contains('@')) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter a valid email address'),
                                      backgroundColor: Color(0xFFFF5252),
                                    ),
                                  );
                                  return;
                                }

                                if (_passwordCtrl.text.length < 6) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Password must be at least 6 characters'),
                                      backgroundColor: Color(0xFFFF5252),
                                    ),
                                  );
                                  return;
                                }

                                await authController.register(
                                  _usernameCtrl.text.trim(),
                                  _fullNameCtrl.text.trim(),
                                  _emailCtrl.text.trim(),
                                  _passwordCtrl.text,
                                );

                                if (mounted) {
                                  if (authController.isAuthenticated) {
                                    // Registration successful and user is logged in
                                  
                                    // Navigate back to login screen (user can login again if needed)
                                    Navigator.pop(context);
                                  } else if (!authController.isLoading && authController.errorMessage == null) {
                                    // Registration successful but no auto-login
                                  
                                    // Navigate back to login screen
                                    Navigator.pop(context);
                                  }
                                }
                              },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

          
              Center(
                child: GestureDetector(
                  onTap: () =>
                      Navigator.pop(context),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(fontSize: 13, color: Color(0xFF8A94A6)),
                      children: [
                        TextSpan(
                          text: 'Log In',
                          style: TextStyle(
                            color: Color(0xFF2196F3),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
