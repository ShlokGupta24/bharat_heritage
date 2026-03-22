import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bharat_heritage/core/theme/app_theme.dart';
import 'package:bharat_heritage/core/theme/glassmorphic_card.dart';
import '../../features/auth/domain/auth_provider.dart';
import 'login_screen.dart'; // For JaaliPainter

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleSignUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      // Assuming authProvider.notifier has a signUp method (to be implemented)
      await ref.read(authProvider.notifier).signUp(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _nameController.text.trim(),
          );
      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: AppColors.surface,
              child: CustomPaint(
                painter: JaaliPainter(),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.surface,
                    AppColors.surface.withAlpha(200),
                    AppColors.secondary.withAlpha(30),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'EST. 2024 • DIGITAL PRESERVATION',
                      style: TextStyle(
                        color: AppColors.tertiary,
                        fontSize: 10,
                        letterSpacing: 2.5,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Initiate\nMembership',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 56,
                        fontFamily: 'Noto Serif',
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Become a guardian of India\'s timeless heritage.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 16,
                        fontFamily: 'Manrope',
                      ),
                    ),
                    const SizedBox(height: 48),
                    
                    GlassmorphicCard(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Begin Your Journey',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                                fontFamily: 'Noto Serif',
                              ),
                            ),
                            const SizedBox(height: 32),
                            
                            _buildTextField('Full Name', _nameController, hint: 'Archivist Name'),
                            const SizedBox(height: 20),
                            _buildTextField('Email Address', _emailController, hint: 'archivist@heritage.in'),
                            const SizedBox(height: 20),
                            _buildTextField('Secret Key', _passwordController, hint: '••••••••', obscureText: true),
                            const SizedBox(height: 20),
                            _buildTextField('Confirm Secret Key', _confirmPasswordController, hint: '••••••••', obscureText: true),
                            const SizedBox(height: 32),
                            
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondary,
                                foregroundColor: AppColors.onSecondary,
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                elevation: 8,
                                shadowColor: Colors.black45,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: _isLoading ? null : _handleSignUp,
                              child: _isLoading 
                                ? const CircularProgressIndicator(color: AppColors.onSecondary)
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text('ENROLL NOW', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                                      SizedBox(width: 8),
                                      Icon(Icons.how_to_reg_rounded, size: 20),
                                    ],
                                  ),
                            ),
                            const SizedBox(height: 24),
                            
                            Center(
                              child: GestureDetector(
                                onTap: () => context.go('/login'),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Already an archivist? ',
                                    style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
                                    children: const [
                                      TextSpan(
                                        text: 'Sign In',
                                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {String? hint, bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.outline.withAlpha(150)),
            filled: true,
            fillColor: AppColors.surfaceContainerHigh.withAlpha(100),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: const TextStyle(color: AppColors.onSurface),
        ),
      ],
    );
  }
}
