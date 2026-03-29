import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharat_heritage/core/theme/app_theme.dart';
import 'package:bharat_heritage/core/theme/glassmorphic_card.dart';
import '../../features/auth/domain/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final String? from;
  const LoginScreen({super.key, this.from});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter both email and secret key.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).login(email, password);
      if (mounted) {
        context.go(widget.from ?? '/');
      }
    } catch (e) {
      if (mounted)
        _showError(
          'Login failed: ${e.toString().replaceAll('Exception: ', '')}',
        );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).signInWithGoogle();
      if (mounted) {
        context.go(widget.from ?? '/');
      }
    } catch (e) {
      if (mounted) _showError('Google Sign-In failed: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleForgotPassword() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showError('Please enter your email to reset the secret key.');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Reset Secret Key',
          style: GoogleFonts.notoSerif(fontWeight: FontWeight.bold),
        ),
        content: Text('Send a reset link to $email?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CANCEL',
              style: TextStyle(color: AppColors.outline),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryContainer,
            ),
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref
                    .read(authProvider.notifier)
                    .sendPasswordResetEmail(email);
                if (mounted) _showSuccess('Reset link sent to your email.');
              } catch (e) {
                if (mounted) _showError('Failed to send reset email.');
              }
            },
            child: const Text('SEND LINK'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
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
                          'Join the\nArchivists',
                          style: GoogleFonts.notoSerif(
                            color: AppColors.onSurface,
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Step into a living museum where history is\nnot just stored, but experienced.',
                          style: GoogleFonts.manrope(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 18,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Row(
                          children: [
                            _buildStat('12,400+', 'ARTIFACTS SAVED'),
                            const SizedBox(width: 40),
                            Container(
                              width: 1,
                              height: 40,
                              color: AppColors.outlineVariant.withAlpha(50),
                            ),
                            const SizedBox(width: 40),
                            _buildStat('452', 'ACTIVE SITES'),
                          ],
                        ),
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
                                'Welcome Back',
                                style: GoogleFonts.notoSerif(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Sign in to access your curated collections.',
                                style: TextStyle(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 32),

                              _buildTextField(
                                label: 'EMAIL ADDRESS',
                                controller: _emailController,
                                hint: 'archivist@heritage.in',
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 24),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'SECRET KEY',
                                        style: TextStyle(
                                          color: AppColors.onSurfaceVariant,
                                          fontSize: 10,
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _handleForgotPassword,
                                        child: const Text(
                                          'FORGOT?',
                                          style: TextStyle(
                                            color: AppColors.tertiary,
                                            fontSize: 10,
                                            letterSpacing: 1.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    style: const TextStyle(
                                      color: AppColors.onSurface,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '••••••••',
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: AppColors.outline,
                                          size: 20,
                                        ),
                                        onPressed: () => setState(
                                          () => _obscurePassword =
                                              !_obscurePassword,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: AppColors.surfaceContainerHigh
                                          .withAlpha(100),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 32),

                              _AuthButton(
                                label: 'UNFOLD THE ARCHIVES',
                                isLoading: _isLoading,
                                onPressed: _handleLogin,
                              ),

                              const SizedBox(height: 24),
                              const _OrDivider(),
                              const SizedBox(height: 24),

                              _SocialButton(
                                label: 'Google Sign-In',
                                icon:
                                    'assets/google_logo.png', // Assuming logo exists
                                onPressed: _handleGoogleSignIn,
                              ),

                              const SizedBox(height: 32),
                              _SignUpLink(onTap: () => context.go('/signup')),
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

  Widget _buildStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.tertiary,
            fontSize: 10,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.notoSerif(
            color: AppColors.onSurface,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 10,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: AppColors.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.outline.withAlpha(100)),
            filled: true,
            fillColor: AppColors.surfaceContainerHigh.withAlpha(100),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
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
        style: TextStyle(
          color: AppColors.tertiary,
          fontSize: 10,
          letterSpacing: 2.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  const _AuthButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [AppColors.primaryContainer, Color(0xFF373A9B)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // FIX: Remove default padding so our Row controls the layout
          padding: const EdgeInsets.symmetric(horizontal: 10),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // FIX: Flexible + FittedBox lets the text shrink if it's
                  // too wide instead of overflowing by 3.4px
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 17,
                  ),
                ],
              ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final String icon;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: AppColors.outlineVariant.withAlpha(80)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.surfaceContainerHighest.withAlpha(30),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.g_mobiledata,
            size: 28,
            color: AppColors.onSurface,
          ), // Fallback icon
          const SizedBox(width: 12),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 12,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.outlineVariant.withAlpha(50))),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'VAULT ACCESS',
            style: TextStyle(
              color: AppColors.outline,
              fontSize: 9,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.outlineVariant.withAlpha(50))),
      ],
    );
  }
}

class _SignUpLink extends StatelessWidget {
  final VoidCallback onTap;
  const _SignUpLink({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: RichText(
          text: const TextSpan(
            text: 'Not yet an archivist? ',
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
            children: [
              TextSpan(
                text: 'Initiate Membership',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
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

class JaaliPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryContainer.withAlpha(30)
      ..strokeWidth = 0.5;

    const spacing = 32.0;
    for (double i = 0; i < size.width; i += spacing) {
      for (double j = 0; j < size.height; j += spacing) {
        canvas.drawCircle(Offset(i, j), 0.8, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
