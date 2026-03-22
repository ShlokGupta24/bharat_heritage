import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
      if (mounted) {
        context.go(widget.from ?? '/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
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
          // Background Jaali Pattern & Gradient
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
                    AppColors.primaryContainer.withAlpha(50),
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
                      'Join the\nArchivists',
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
                      'Step into a living museum where history is not just stored, but experienced.',
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
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                                fontFamily: 'Noto Serif',
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Sign in to access your curated collections.',
                              style: TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 32),
                            
                            _buildTextField('Email or Username', _emailController, hint: 'archivist@heritage.in'),
                            const SizedBox(height: 20),
                            _buildTextField('Secret Key', _passwordController, hint: '••••••••', obscureText: true),
                            const SizedBox(height: 32),
                            
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryContainer,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                elevation: 8,
                                shadowColor: Colors.black45,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: _isLoading ? null : _handleLogin,
                              child: _isLoading 
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text('UNFOLD THE ARCHIVES', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward_rounded, size: 20),
                                    ],
                                  ),
                            ),
                            const SizedBox(height: 24),
                            
                            Row(
                              children: [
                                Expanded(child: Divider(color: AppColors.outlineVariant.withAlpha(100))),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text('VAULT ACCESS', style: TextStyle(color: AppColors.outline, fontSize: 10, letterSpacing: 1.5)),
                                ),
                                Expanded(child: Divider(color: AppColors.outlineVariant.withAlpha(100))),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            _buildSocialBtn('Google Sign-In', Icons.g_mobiledata),
                            const SizedBox(height: 32),
                            
                            Center(
                              child: GestureDetector(
                                onTap: () => context.go('/signup'),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Not yet an archivist? ',
                                    style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
                                    children: const [
                                      TextSpan(
                                        text: 'Initiate Membership',
                                        style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold),
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

  Widget _buildSocialBtn(String text, IconData icon) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.onSurface,
        side: BorderSide(color: AppColors.outlineVariant.withAlpha(150)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.surfaceContainerHighest.withAlpha(50),
      ),
      onPressed: () {},
      icon: Icon(icon, size: 24),
      label: Text(text.toUpperCase(), style: const TextStyle(fontSize: 12, letterSpacing: 1.0, fontWeight: FontWeight.w600)),
    );
  }
}

class JaaliPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryContainer.withAlpha(40)
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
