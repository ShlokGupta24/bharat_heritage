import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_theme.dart';
import '../../features/auth/domain/auth_provider.dart';
import '../../features/passport/domain/passport_provider.dart';
import '../../features/monuments/domain/monuments_provider.dart';
import '../../features/monuments/data/models/wikipedia_image_widget.dart';
import '../../features/monuments/data/models/monument.dart';
import '../../features/weather/domain/aqi_provider.dart';

// ───────────────────────────────────────────────
// Providers
// ───────────────────────────────────────────────

/// Tracks whether the app is in dark mode. Persisted via SharedPreferences.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _load();
    return ThemeMode.dark;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? true;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggle() async {
    final prefs = await SharedPreferences.getInstance();
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = newMode;
    await prefs.setBool('isDarkMode', newMode == ThemeMode.dark);
  }
}

/// Bool pref notifier for toggleable settings.
class BoolPrefNotifier extends Notifier<bool> {
  final String _key;
  final bool _defaultValue;
  BoolPrefNotifier(this._key, this._defaultValue);

  @override
  bool build() {
    _load();
    return _defaultValue;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? _defaultValue;
  }

  Future<void> toggle() async {
    final prefs = await SharedPreferences.getInstance();
    state = !state;
    await prefs.setBool(_key, state);
  }
}

final notifArrivalProvider = NotifierProvider<BoolPrefNotifier, bool>(() => BoolPrefNotifier('notif_arrival', true));
final notifMilestoneProvider = NotifierProvider<BoolPrefNotifier, bool>(() => BoolPrefNotifier('notif_milestone', true));
final locationMaskingProvider = NotifierProvider<BoolPrefNotifier, bool>(() => BoolPrefNotifier('priv_location_masking', false));
final dataEncryptionProvider = NotifierProvider<BoolPrefNotifier, bool>(() => BoolPrefNotifier('priv_data_encryption', true));
final analyticsProvider = NotifierProvider<BoolPrefNotifier, bool>(() => BoolPrefNotifier('priv_analytics', true));


class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  bool _isUploadingPhoto = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Photo picker ──────────────────────────────
  Future<void> _pickAndUploadPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
    );
    if (picked == null) return;

    setState(() => _isUploadingPhoto = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Upload to Firebase Storage
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_avatars/${user.uid}.jpg');
      await ref.putFile(File(picked.path));
      final url = await ref.getDownloadURL();

      // Update Firebase Auth profile
      await user.updatePhotoURL(url);
      await user.reload();
      // Force rebuild to reflect new photoURL
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        _showSnack('Failed to update photo: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isUploadingPhoto = false);
    }
  }

  // ── Edit Name / Bio dialog ────────────────────
  void _showEditProfileDialog() {
    final user = FirebaseAuth.instance.currentUser;
    final nameCtrl = TextEditingController(text: user?.displayName ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.notoSerif(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dialogField(nameCtrl, 'Display Name', Icons.person_outline),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) return;
              try {
                await user.updateDisplayName(nameCtrl.text.trim());
                await user.reload();
                if (mounted) {
                  setState(() {});
                  _showSnack('Profile updated!');
                }
              } catch (e) {
                if (mounted) _showSnack('Update failed: $e', isError: true);
              }
            },
            child: Text('Save', style: GoogleFonts.manrope(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _dialogField(TextEditingController ctrl, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        style: GoogleFonts.manrope(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
          prefixIcon: Icon(icon, color: AppColors.onSurfaceVariant),
          filled: true,
          fillColor: AppColors.surfaceContainerLowest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  // ── Notification sheet ────────────────────────
  void _showNotificationsSheet() {
    final arrival = ref.read(notifArrivalProvider);
    final milestone = ref.read(notifMilestoneProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Consumer(
        builder: (context, ref, _) {
          final arrivalOn = ref.watch(notifArrivalProvider);
          final milestoneOn = ref.watch(notifMilestoneProvider);
          return _glassSheet(
            context: context,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sheetHandle(),
                _sheetTitle('Notification Preferences', Icons.notifications),
                const SizedBox(height: 8),
                Text(
                  'Manage when Bharat Heritage can send you alerts.',
                  style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 13),
                ),
                const SizedBox(height: 24),
                _notifTile(
                  icon: Icons.location_on,
                  title: 'Arrival Alerts',
                  subtitle: 'Get notified when you are near a heritage site',
                  value: arrivalOn,
                  onChanged: (_) => ref.read(notifArrivalProvider.notifier).toggle(),
                ),
                const SizedBox(height: 12),
                _notifTile(
                  icon: Icons.military_tech,
                  title: 'Milestone Updates',
                  subtitle: 'Be alerted when you earn a new explorer rank',
                  value: milestoneOn,
                  onChanged: (_) => ref.read(notifMilestoneProvider.notifier).toggle(),
                ),
                const SizedBox(height: 24),
                // Recent notifications section
                Text(
                  'Recent Notifications',
                  style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),
                if (!arrival && !milestone)
                  _emptyNotifications()
                else
                  _noRecentNotifications(),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _noRecentNotifications() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_none, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'No new notifications. Explore heritage sites to earn alerts!',
              style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyNotifications() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_off, color: AppColors.outline),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'All notifications are off. Enable above to receive alerts.',
              style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _notifTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? AppColors.primary.withValues(alpha: 0.3) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: value ? AppColors.primary : AppColors.onSurfaceVariant, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.manrope(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                Text(subtitle, style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 12)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primaryContainer,
          ),
        ],
      ),
    );
  }

  // ── Privacy & Security sheet ──────────────────
  void _showPrivacySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Consumer(
        builder: (context, ref, _) {
          final locationMasking = ref.watch(locationMaskingProvider);
          final encryption = ref.watch(dataEncryptionProvider);
          final analytics = ref.watch(analyticsProvider);
          return _glassSheet(
            context: context,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sheetHandle(),
                _sheetTitle('Privacy & Security', Icons.shield),
                const SizedBox(height: 8),
                Text(
                  'Control how your data is used within the app.',
                  style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 13),
                ),
                const SizedBox(height: 24),
                _privacyToggleTile(
                  icon: Icons.location_off,
                  title: 'Location Masking',
                  subtitle: 'Hide your precise GPS from server analytics',
                  value: locationMasking,
                  onChanged: (_) => ref.read(locationMaskingProvider.notifier).toggle(),
                ),
                const SizedBox(height: 12),
                _privacyToggleTile(
                  icon: Icons.lock,
                  title: 'Local Data Encryption',
                  subtitle: 'Encrypt passport stamps stored on this device',
                  value: encryption,
                  onChanged: (_) => ref.read(dataEncryptionProvider.notifier).toggle(),
                ),
                const SizedBox(height: 12),
                _privacyToggleTile(
                  icon: Icons.bar_chart,
                  title: 'Usage Analytics',
                  subtitle: 'Share anonymous usage data to improve the app',
                  value: analytics,
                  onChanged: (_) => ref.read(analyticsProvider.notifier).toggle(),
                ),
                const SizedBox(height: 24),
                // Data actions
                Text(
                  'Data Actions',
                  style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),
                _dataActionTile(
                  icon: Icons.download,
                  label: 'Export My Data',
                  color: AppColors.primary,
                  onTap: () {
                    Navigator.pop(ctx);
                    _exportUserData();
                  },
                ),
                const SizedBox(height: 8),
                _dataActionTile(
                  icon: Icons.delete_outline,
                  label: 'Delete Account & All Data',
                  color: AppColors.error,
                  onTap: () {
                    Navigator.pop(ctx);
                    _confirmDeleteAccount();
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _privacyToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? AppColors.primary.withValues(alpha: 0.3) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: value ? AppColors.primary : AppColors.onSurfaceVariant, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.manrope(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                Text(subtitle, style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 12)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primaryContainer,
          ),
        ],
      ),
    );
  }

  Widget _dataActionTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Text(label, style: GoogleFonts.manrope(color: color, fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Account?',
          style: GoogleFonts.notoSerif(color: AppColors.error, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'This will permanently delete your account, all stamps, and profile data. This action cannot be undone.',
          style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                final user = FirebaseAuth.instance.currentUser;
                await user?.delete();
                if (mounted) context.go('/login');
              } catch (e) {
                if (mounted) _showSnack('Please re-login before deleting account.', isError: true);
              }
            },
            child: Text('Delete', style: GoogleFonts.manrope(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────
  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.bold)),
      backgroundColor: isError ? AppColors.error : AppColors.tertiary,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  void _exportUserData() {
    final user = FirebaseAuth.instance.currentUser;
    final stamps = ref.read(passportEntriesProvider).value ?? [];
    if (user == null) {
      _showSnack('Not logged in.', isError: true);
      return;
    }

    final buffer = StringBuffer();
    buffer.writeln('Bharat Heritage — Exported Data');
    buffer.writeln('================================');
    buffer.writeln('Name   : ${user.displayName ?? 'Explorer'}');
    buffer.writeln('Email  : ${user.email ?? 'N/A'}');
    buffer.writeln('UID    : ${user.uid}');
    buffer.writeln();
    buffer.writeln('--- Visited Sites (${stamps.length}) ---');
    for (final stamp in stamps) {
      buffer.writeln('• ${stamp.monumentName}  [${stamp.visitedAt.toLocal().toString().split('.').first}]');
    }
    buffer.writeln();
    buffer.writeln('Exported on: ${DateTime.now().toLocal().toString().split('.').first}');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Your Data', style: GoogleFonts.notoSerif(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(buffer.toString(), style: GoogleFonts.robotoMono(color: AppColors.onSurfaceVariant, fontSize: 12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: GoogleFonts.manrope(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _glassSheet({required BuildContext context, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: SingleChildScrollView(child: child),
    );
  }

  Widget _sheetHandle() {
    return Center(
      child: Container(
        width: 40, height: 4,
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: AppColors.outlineVariant,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _sheetTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.tertiary),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────
  // BUILD
  // ───────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    ref.watch(authProvider);
    final user = FirebaseAuth.instance.currentUser;
    final stamps = ref.watch(passportEntriesProvider).value ?? [];
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    final userName = user?.displayName?.isNotEmpty == true ? user!.displayName! : 'Explorer';
    final userEmail = user?.email ?? 'preserving the past';
    final userPhoto = user?.photoURL;
    final stampCount = stamps.length;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: isDark ? AppColors.surface : const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Background ambient glows
          Positioned(
            top: -100, right: -100,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.tertiary.withValues(alpha: isDark ? 0.15 : 0.06), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50, left: -50,
            child: Container(
              width: 400, height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.primaryContainer.withValues(alpha: isDark ? 0.1 : 0.04), Colors.transparent],
                ),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                _buildAppBar(userPhoto, isDark),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildHeroSection(userName, userEmail, userPhoto, isDark),
                      const SizedBox(height: 32),
                      _buildStatsGrid(stampCount, isDark),
                      const SizedBox(height: 32),
                      _buildSettingsSection(isDark),
                      const SizedBox(height: 40),
                      _buildLogoutButton(isDark),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          _buildBottomNavBar(),
          if (_isSearching) _buildSearchOverlay(),
        ],
      ),
    );
  }

  // ── AppBar ────────────────────────────────────
  Widget _buildAppBar(String? photoUrl, bool isDark) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: (isDark ? AppColors.surface : const Color(0xFFF5F5F5)).withValues(alpha: 0.5),
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(color: Colors.transparent),
        ),
      ),
      title: Row(
        children: [
          Image.asset('design/screen.png', height: 26),
          const SizedBox(width: 10),
          Text(
            'BharatHeritage',
            style: GoogleFonts.notoSerif(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: isDark ? AppColors.onSurface : const Color(0xFF1A1A1A),
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.onSurfaceVariant),
          onPressed: () {
            // Since searching is usually on home/map, we'll just show the overlay if we implement it, 
            // or navigate to home with search open. For now, let's just make it consistent with the UI.
            setState(() => _isSearching = true);
          },
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_border, color: AppColors.onSurfaceVariant),
          onPressed: () => context.push('/bookmarks'),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _showEditProfileDialog,
          child: Stack(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.3)),
                  image: photoUrl != null
                      ? DecorationImage(image: NetworkImage(photoUrl), fit: BoxFit.cover)
                      : null,
                  color: isDark ? AppColors.surfaceContainerHigh : const Color(0xFFE0E0E0),
                ),
                child: photoUrl == null
                    ? const Icon(Icons.person, color: AppColors.onSurfaceVariant, size: 20)
                    : null,
              ),
              Positioned(
                right: 0, bottom: 0,
                child: Container(
                  width: 12, height: 12,
                  decoration: const BoxDecoration(
                    color: AppColors.tertiary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 8, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  // ── Hero section ──────────────────────────────
  Widget _buildHeroSection(String name, String email, String? photoUrl, bool isDark) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Transform.rotate(
              angle: 0.052,
              child: Container(
                width: 170, height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.2), width: 2),
                ),
              ),
            ),
            Transform.rotate(
              angle: -0.105,
              child: Container(
                width: 170, height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
                ),
              ),
            ),
            // Profile avatar
            GestureDetector(
              onTap: _isUploadingPhoto ? null : _pickAndUploadPhoto,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 160, height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: isDark ? AppColors.surfaceContainerHigh : const Color(0xFFE0E0E0),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 20, spreadRadius: 5),
                      ],
                      image: photoUrl != null
                          ? DecorationImage(image: NetworkImage(photoUrl), fit: BoxFit.cover)
                          : null,
                    ),
                    alignment: Alignment.bottomCenter,
                    child: photoUrl == null
                        ? Icon(Icons.person, size: 64, color: AppColors.onSurfaceVariant.withValues(alpha: 0.4))
                        : null,
                  ),
                  // Overlay: upload indicator or camera
                  Container(
                    width: 160, height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black.withValues(alpha: _isUploadingPhoto ? 0.5 : 0.0),
                    ),
                    child: _isUploadingPhoto
                        ? const Center(child: CircularProgressIndicator(color: AppColors.tertiary))
                        : null,
                  ),
                  // Camera badge
                  if (!_isUploadingPhoto)
                    Positioned(
                      bottom: 8, right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.tertiary,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 4)],
                        ),
                        child: const Icon(Icons.camera_alt, size: 14, color: Colors.black),
                      ),
                    ),
                  // VERIFIED label
                  if (photoUrl != null)
                    Positioned(
                      bottom: 0, left: 0, right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter, end: Alignment.topCenter,
                            colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                          ),
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                        ),
                        child: Text(
                          'VERIFIED EXPLORER',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(color: AppColors.tertiary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              bottom: -15, right: -15,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified, color: AppColors.tertiary, size: 14),
                    const SizedBox(width: 6),
                    Text('VERIFIED', style: GoogleFonts.manrope(color: AppColors.tertiary, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: GoogleFonts.notoSerif(
                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _showEditProfileDialog,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, size: 14, color: AppColors.tertiary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(email, style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 13)),
        const SizedBox(height: 16),
      ],
    );
  }

  // ── Stats grid ────────────────────────────────
  Widget _buildStatsGrid(int stampCount, bool isDark) {
    final cardBg = isDark ? AppColors.surfaceContainerLow : Colors.white;
    final positionAsync = ref.watch(currentPositionProvider);

    String aqiDisplay = '—';
    String aqiLabel = 'Fetching...';
    positionAsync.when(
      data: (position) {
        if (position != null) {
          final coords = Coordinates(lat: position.latitude, lon: position.longitude);
          final aqiAsync = ref.watch(aqiProvider(coords));
          aqiAsync.when(
            data: (aqi) {
              aqiDisplay = '${aqi.aqi}';
              aqiLabel = aqi.category;
            },
            loading: () {
              aqiDisplay = '…';
              aqiLabel = 'Loading';
            },
            error: (_, __) {
              aqiDisplay = 'N/A';
              aqiLabel = 'Unavailable';
            },
          );
        } else {
          aqiDisplay = 'N/A';
          aqiLabel = 'No Location';
        }
      },
      loading: () {
        aqiDisplay = '…';
        aqiLabel = 'Loading';
      },
      error: (_, __) {
        aqiDisplay = 'N/A';
        aqiLabel = 'Error';
      },
    );

    return Column(
      children: [
        _buildLargeStatCard('Total Sites Visited', '$stampCount', 'Sanctuaries', Icons.castle, AppColors.primary, AppColors.primaryContainer, isDark),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildSmallStatCard('Clean Air Exp.', aqiDisplay, Icons.air, AppColors.secondary, cardBg, subtitle: aqiLabel)),
            const SizedBox(width: 16),
            Expanded(child: _buildSmallStatCard('Stamps Unlocked', '$stampCount', Icons.stars, AppColors.tertiary, cardBg)),
          ],
        ),
        const SizedBox(height: 16),
        _buildMilestoneCard(isDark, stampCount),
      ],
    );
  }

  Widget _buildLargeStatCard(String title, String value, String subtitle, IconData icon, Color color, Color bgColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? bgColor.withValues(alpha: 0.2) : bgColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(right: -20, top: -20, child: Icon(icon, size: 120, color: color.withValues(alpha: 0.05))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title.toUpperCase(), style: GoogleFonts.manrope(color: color, fontSize: 10, letterSpacing: 2)),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(value, style: GoogleFonts.notoSerif(color: isDark ? const Color(0xFFe1e0ff) : AppColors.primaryContainer, fontSize: 64, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Text(subtitle, style: GoogleFonts.manrope(color: color.withValues(alpha: 0.6), fontSize: 14)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 4, width: double.infinity,
                decoration: BoxDecoration(color: AppColors.outlineVariant.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2)),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.6,
                  child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStatCard(String title, String value, IconData icon, Color color, Color bg, {String? subtitle}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 16),
          Text(title.toUpperCase(), style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 10, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Text(value, style: GoogleFonts.notoSerif(color: color, fontSize: 32)),
          if (subtitle != null)
            Text(subtitle, style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 10, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  Widget _buildMilestoneCard(bool isDark, int stampCount) {
    final milestone = stampCount < 5
        ? 'Visit ${5 - stampCount} more UNESCO sites to unlock Trailblazer'
        : stampCount < 10
            ? 'Visit ${10 - stampCount} more sites to reach Legacy Keeper'
            : stampCount < 20
                ? 'Visit ${20 - stampCount} more sites to reach Grand Archivist'
                : 'You have reached the highest explorer rank! 🏆';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceContainerHigh : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: AppColors.tertiaryContainer.withValues(alpha: 0.3),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.2)),
            ),
            child: const Icon(Icons.military_tech, color: AppColors.tertiary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Next Milestone', style: GoogleFonts.manrope(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(milestone,
                    style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () => context.go('/map'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('MAP', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
          ),
        ],
      ),
    );
  }

  // ── Settings ──────────────────────────────────
  Widget _buildSettingsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Preferences', style: GoogleFonts.notoSerif(color: isDark ? Colors.white : Colors.black87, fontSize: 24)),
        const SizedBox(height: 16),
        Divider(color: AppColors.outlineVariant, height: 1),
        const SizedBox(height: 16),

        // Language — English only, show dialog that says English is the only option
        _buildTappableTile(
          icon: Icons.translate,
          title: 'Language',
          subtitle: 'English',
          isDark: isDark,
          onTap: _showLanguageDialog,
        ),
        const SizedBox(height: 8),

        // Notifications
        _buildTappableTile(
          icon: Icons.notifications,
          title: 'Notification Preferences',
          subtitle: 'Arrival alerts, Milestone updates',
          isDark: isDark,
          onTap: _showNotificationsSheet,
        ),
        const SizedBox(height: 8),

        // Privacy
        _buildTappableTile(
          icon: Icons.shield,
          title: 'Privacy & Security',
          subtitle: 'Location masking, Data encryption',
          isDark: isDark,
          onTap: _showPrivacySheet,
        ),
      ],
    );
  }

  Widget _buildTappableTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceContainerLowest : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.onSurfaceVariant, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.manrope(color: isDark ? Colors.white : Colors.black87, fontSize: 14, fontWeight: FontWeight.w500)),
                  Text(subtitle, style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.translate, color: AppColors.tertiary),
            const SizedBox(width: 12),
            Text('Language', style: GoogleFonts.notoSerif(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text('English', style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const Spacer(),
                  Text('Active', style: GoogleFonts.manrope(color: AppColors.primary, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'More languages (Hindi, Tamil, Bengali) are coming soon!',
              style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: Text('Got it', style: GoogleFonts.manrope(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ── Logout ────────────────────────────────────
  Widget _buildLogoutButton(bool isDark) {
    bool isLoggingOut = false;
    return Center(
      child: StatefulBuilder(
        builder: (ctx, setState) => TextButton.icon(
          onPressed: isLoggingOut ? null : () async {
            setState(() => isLoggingOut = true);
            await ref.read(authProvider.notifier).logout();
            if (mounted) context.go('/login');
          },
          icon: isLoggingOut
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.error))
              : const Icon(Icons.logout, color: AppColors.error, size: 16),
          label: Text(
            'LOGOUT & ARCHIVE SESSION',
            style: GoogleFonts.manrope(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
        ),
      ),
    );
  }

  // ── Bottom nav ────────────────────────────────
  Widget _buildBottomNavBar() {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.6),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => context.go('/'), child: _buildNavItem(Icons.home, 'Home', false)),
                GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => context.go('/map'), child: _buildNavItem(Icons.map, 'Map', false)),
                GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => context.go('/passport'), child: _buildNavItem(Icons.auto_stories, 'Passport', false)),
                GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => context.go('/profile'), child: _buildNavItem(Icons.person, 'Profile', true)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Search overlay ──────────────────────────
  Widget _buildSearchOverlay() {
    final filtered = ref.watch(filteredMonumentsProvider);
    return Positioned.fill(
      child: Container(
        color: AppColors.surface.withValues(alpha: 0.95),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search Heritage...',
                      hintStyle: const TextStyle(color: AppColors.onSurfaceVariant),
                      prefixIcon: const Icon(Icons.search, color: AppColors.tertiary),
                      filled: true,
                      fillColor: AppColors.surfaceContainerHigh,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                    onChanged: (val) => ref.read(searchQueryProvider.notifier).updateQuery(val),
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    setState(() => _isSearching = false);
                    ref.read(searchQueryProvider.notifier).updateQuery('');
                    _searchController.clear();
                  },
                  child: const Text('CANCEL', style: TextStyle(color: AppColors.onSurfaceVariant)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: filtered.when(
                data: (list) => ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final m = list[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      leading: SizedBox(
                        width: 60, height: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: m.imageUrl != null && m.imageUrl!.isNotEmpty
                              ? WikipediaImage(monumentName: m.name, fit: BoxFit.cover, fallbackAsset: 'design/tajmahal.avif')
                              : Container(color: AppColors.surfaceContainerHigh,
                                  child: const Icon(Icons.landscape, color: AppColors.tertiary, size: 24)),
                        ),
                      ),
                      title: Text(m.name, style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(m.shortDescription, maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 12)),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.outline, size: 14),
                      onTap: () {
                        context.push('/monument/${m.id}');
                        setState(() => _isSearching = false);
                      },
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => const Center(child: Text('Search failed')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? AppColors.tertiary : AppColors.onSurfaceVariant, size: 24),
        const SizedBox(height: 4),
        Text(label.toUpperCase(),
            style: GoogleFonts.manrope(color: isActive ? AppColors.tertiary : AppColors.onSurfaceVariant,
                fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
      ],
    );
  }
}
