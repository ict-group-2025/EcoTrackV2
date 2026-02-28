import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application/screens/sign_up_screen.dart';
import 'package:flutter_application/utils/input_field.dart';
import 'package:flutter_application/utils/primary_button.dart';
import 'package:flutter_application/controller/auth_controller.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFDFEEFD), Color(0xFFF5F7FA)],
            stops: [0.0, 0.45],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App logo + name
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF2196F3,
                              ).withValues(alpha: 0.15),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo_app_removebg.png',
                          width: 38,
                          height: 38,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'EcoTrack',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A2340),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                // Title
                const Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A2340),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Welcome back! Please enter your details.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF8A94A6)),
                ),
                const SizedBox(height: 28),

                // Username
                InputField(
                  label: 'USERNAME',
                  hint: 'Enter your username',
                  prefixIcon: Icons.person_outline,
                  controller: _usernameCtrl,
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
                const SizedBox(height: 10),

                // Forgot password
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: GestureDetector(
                //     onTap: () {},
                //     child: const Text(
                //       'Forgot Password?',
                //       style: TextStyle(
                //         fontSize: 13,
                //         color: Color(0xFF2196F3),
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 28),

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
                          text: authController.isLoading ? 'Logging In...' : 'Log In',
                          onTap: authController.isLoading
                              ? () {}
                              : () async {
                                  if (_usernameCtrl.text.trim().isEmpty ||
                                      _passwordCtrl.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please fill in all fields'),
                                        backgroundColor: Color(0xFFFF5252),
                                      ),
                                    );
                                    return;
                                  }

                                  await authController.login(
                                    _usernameCtrl.text.trim(),
                                    _passwordCtrl.text,
                                  );

                                  if (authController.isAuthenticated &&
                                      mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Login successful!'),
                                        backgroundColor: Color(0xFF4CAF50),
                                      ),
                                    );
                                    // TODO: Navigate to home screen
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
                        Navigator.push(context, MaterialPageRoute<void>(builder: (context)=> SignUpScreen())),
                    child: RichText(
                      text: const TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8A94A6),
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
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
      ),
    );
  }
}
