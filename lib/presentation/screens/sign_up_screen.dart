import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields.');
      return;
    }

    if (password != confirm) {
      _showError('Secret keys do not match.');
      return;
    }

    if (password.length < 6) {
      _showError('Secret key must be at least 6 characters.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).signUp(email, password, name);
      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      if (mounted) _showError('Sign up failed: ${e.toString().replaceAll('Exception: ', '')}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // Background Pattern
          const Positioned.fill(child: _JaaliBackground()),
          
          Row(
            children: [
              if (isWide) ...[
                // Left Side: Editorial Context
                Expanded(
                  flex: 7,
                  child: Container(
                    padding: const EdgeInsets.all(60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const _BrandingBadge(),
                        const SizedBox(height: 24),
                        Text(
                          'Initiate\nMembership',
                          style: GoogleFonts.notoSerif(
                            color: AppColors.onSurface,
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Become a guardian of India\'s timeless heritage.\nYour contribution as an archivist starts here.',
                          style: GoogleFonts.manrope(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 18,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 48),
                        const _TrustBanner(),
                      ],
                    ),
                  ),
                ),
              ],
              
              // Right Side: Auth Card
              Expanded(
                flex: isWide ? 5 : 1,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 450),
                      child: GlassmorphicCard(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Create Account',
                                style: GoogleFonts.notoSerif(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Join the global community of archivists.',
                                style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
                              ),
                              const SizedBox(height: 32),
                              
                              _buildTextField(
                                label: 'FULL NAME',
                                controller: _nameController,
                                hint: 'Archivist Name',
                              ),
                              const SizedBox(height: 20),
                              
                              _buildTextField(
                                label: 'EMAIL ADDRESS',
                                controller: _emailController,
                                hint: 'archivist@heritage.in',
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 20),
                              
                              _buildTextField(
                                label: 'SECRET KEY',
                                controller: _passwordController,
                                hint: '••••••••',
                                obscureText: _obscurePassword,
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: AppColors.outline,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              _buildTextField(
                                label: 'CONFIRM SECRET KEY',
                                controller: _confirmPasswordController,
                                hint: '••••••••',
                                obscureText: _obscurePassword,
                              ),
                              
                              const SizedBox(height: 32),
                              
                              _AuthButton(
                                label: 'ENROLL AS ARCHIVIST',
                                isLoading: _isLoading,
                                onPressed: _handleSignUp,
                              ),
                              
                              const SizedBox(height: 32),
                              _LoginLink(onTap: () => context.go('/login')),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    Widget? suffix,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(color: AppColors.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.outline.withAlpha(100)),
            suffixIcon: suffix,
            filled: true,
            fillColor: AppColors.surfaceContainerHigh.withAlpha(100),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}

class _TrustBanner extends StatelessWidget {
  const _TrustBanner();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SECURE ARCHIVAL PROTOCOL',
          style: TextStyle(color: AppColors.tertiary, fontSize: 10, letterSpacing: 2.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Your data is protected by industry-standard encryption.',
          style: TextStyle(color: AppColors.onSurfaceVariant.withAlpha(200), fontSize: 14),
        ),
      ],
    );
  }
}

class _LoginLink extends StatelessWidget {
  final VoidCallback onTap;
  const _LoginLink({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: RichText(
          text: const TextSpan(
            text: 'Already an archivist? ',
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
            children: [
              TextSpan(
                text: 'Sign In',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandingBadge extends StatelessWidget {
  const _BrandingBadge();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.tertiary.withAlpha(100)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'EST. 2024 • DIGITAL PRESERVATION',
        style: TextStyle(color: AppColors.tertiary, fontSize: 10, letterSpacing: 2.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  const _AuthButton({required this.label, required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(colors: [AppColors.secondaryContainer, AppColors.secondary]),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(60), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: AppColors.onSecondary, strokeWidth: 2))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label, style: const TextStyle(color: AppColors.onSecondary, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(width: 8),
                  const Icon(Icons.how_to_reg_rounded, color: AppColors.onSecondary, size: 18),
                ],
              ),
      ),
    );
  }
}

class _JaaliBackground extends StatelessWidget {
  const _JaaliBackground();
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: JaaliPainter());
  }
}
