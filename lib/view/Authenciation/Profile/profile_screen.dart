import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Dashboard/auth_screens.dart';
import '../Widgets/app_theme.dart';
import 'profile_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // User Profile State
  String _userName = 'Aayush Shrestha';
  String _userEmail = 'aayush.shrestha@example.com';
  final String _memberSince = 'Member since 2026';

  // Stats State
  final int _bookingsCount = 12;
  final int _savedCount = 5;
  final int _reviewsCount = 3;

  // Preferences State
  bool _isVegetarianFriendly = false;
  RangeValues _budgetRange = const RangeValues(500, 2500);
  List<String> _favoriteCuisines = ['Nepali', 'Newari', 'Asian'];
  int _defaultGroupSize = 2;

  // Notifications State
  bool _tableReadyAlerts = true;
  bool _queuePositionUpdates = true;
  bool _bookingReminders = true;
  bool _offersAndPromotions = false;

  // General State
  String _selectedLanguage = 'English';

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTheme.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.textCharcoal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openEditProfileModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => EditProfileBottomSheet(
        initialName: _userName,
        initialEmail: _userEmail,
        onSave: (newName, newEmail) {
          setState(() {
            _userName = newName;
            _userEmail = newEmail;
          });
          _showSnackBar('Profile updated');
        },
      ),
    );
  }

  void _openBudgetModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BudgetBottomSheet(
        initialValues: _budgetRange,
        onSave: (newRange) {
          setState(() {
            _budgetRange = newRange;
          });
          _showSnackBar('Preferences updated');
        },
      ),
    );
  }

  void _openCuisineModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CuisineBottomSheet(
        initialSelected: _favoriteCuisines,
        onSave: (newList) {
          setState(() {
            _favoriteCuisines = newList;
          });
          _showSnackBar('Preferences updated');
        },
      ),
    );
  }

  void _openLanguageModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.bgCream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.inputBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select Language',
              style: AppTheme.dmSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textCharcoal,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              tileColor: _selectedLanguage == 'English' ? AppColors.softCreamCard : AppColors.white,
              title: Text('English', style: AppTheme.inter(fontWeight: FontWeight.w600)),
              trailing: _selectedLanguage == 'English'
                  ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryOrange)
                  : null,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedLanguage = 'English');
                Navigator.pop(ctx);
                _showSnackBar('Language set to English');
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              tileColor: _selectedLanguage == 'Nepali' ? AppColors.softCreamCard : AppColors.white,
              title: Text('नेपाली (Nepali)', style: AppTheme.inter(fontWeight: FontWeight.w600)),
              trailing: _selectedLanguage == 'Nepali'
                  ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryOrange)
                  : null,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedLanguage = 'Nepali');
                Navigator.pop(ctx);
                _showSnackBar('Language set to Nepali');
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Log Out',
          style: AppTheme.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textCharcoal,
          ),
        ),
        content: Text(
          'Are you sure you want to log out of Boo-KAA?',
          style: AppTheme.inter(
            fontSize: 14,
            color: AppColors.textCharcoal,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTheme.inter(
                fontWeight: FontWeight.w600,
                color: AppColors.mutedGray,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              'Log Out',
              style: AppTheme.inter(
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final budgetText = 'Rs. ${_budgetRange.start.round()} - ${_budgetRange.end.round()}';
    final cuisineText = _favoriteCuisines.isEmpty
        ? 'None selected'
        : _favoriteCuisines.join(', ');

    return Scaffold(
      backgroundColor: AppColors.bgCream,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 400),
            tween: Tween<double>(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Section
                Text(
                  'YOUR SPACE',
                  style: AppTheme.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.burntOrange,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Profile',
                  style: AppTheme.dmSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textCharcoal,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Profile Header Card
                ProfileHeaderCard(
                  name: _userName,
                  email: _userEmail,
                  memberSince: _memberSince,
                  onEditPressed: _openEditProfileModal,
                  onAvatarPressed: () => _showSnackBar('Coming soon'),
                ),
                const SizedBox(height: 20),

                // 3. Stats Row
                Row(
                  children: [
                    StatCard(
                      label: 'Bookings',
                      value: '$_bookingsCount',
                      icon: Icons.calendar_today_rounded,
                      onTap: () => _showSnackBar('Coming soon'),
                    ),
                    const SizedBox(width: 12),
                    StatCard(
                      label: 'Saved',
                      value: '$_savedCount',
                      icon: Icons.bookmark_border_rounded,
                      onTap: () => _showSnackBar('Coming soon'),
                    ),
                    const SizedBox(width: 12),
                    StatCard(
                      label: 'Reviews',
                      value: '$_reviewsCount',
                      icon: Icons.star_border_rounded,
                      onTap: () => _showSnackBar('Coming soon'),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // 4. Dining Preferences Section
                const SectionHeader(title: 'Dining Preferences'),
                Text(
                  'Used by Boo-KAA AI to suggest places for you.',
                  style: AppTheme.inter(
                    fontSize: 13,
                    color: AppColors.mutedGray,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.inputBorder, width: 1),
                  ),
                  child: Column(
                    children: [
                      PreferenceTile(
                        icon: Icons.eco_outlined,
                        title: 'Vegetarian friendly',
                        switchValue: _isVegetarianFriendly,
                        onSwitchChanged: (val) {
                          setState(() => _isVegetarianFriendly = val);
                          _showSnackBar('Preferences updated');
                        },
                      ),
                      PreferenceTile(
                        icon: Icons.payments_outlined,
                        title: 'Budget per person',
                        valueText: budgetText,
                        onTap: _openBudgetModal,
                      ),
                      PreferenceTile(
                        icon: Icons.restaurant_outlined,
                        title: 'Favorite cuisines',
                        valueText: cuisineText.length > 20
                            ? '${cuisineText.substring(0, 18)}...'
                            : cuisineText,
                        onTap: _openCuisineModal,
                      ),
                      // Group size stepper tile
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: AppColors.bgCream,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.group_outlined,
                                size: 20,
                                color: AppColors.burntOrange,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                'Default group size',
                                style: AppTheme.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textCharcoal,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.softCreamCard,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.inputBorder),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                    icon: const Icon(Icons.remove, size: 18, color: AppColors.textCharcoal),
                                    onPressed: _defaultGroupSize > 1
                                        ? () {
                                            HapticFeedback.selectionClick();
                                            setState(() => _defaultGroupSize--);
                                            _showSnackBar('Preferences updated');
                                          }
                                        : null,
                                  ),
                                  Text(
                                    '$_defaultGroupSize',
                                    style: AppTheme.dmSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.burntOrange,
                                    ),
                                  ),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                    icon: const Icon(Icons.add, size: 18, color: AppColors.textCharcoal),
                                    onPressed: _defaultGroupSize < 20
                                        ? () {
                                            HapticFeedback.selectionClick();
                                            setState(() => _defaultGroupSize++);
                                            _showSnackBar('Preferences updated');
                                          }
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // 5. Notifications Section
                const SectionHeader(title: 'Notifications'),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.inputBorder, width: 1),
                  ),
                  child: Column(
                    children: [
                      PreferenceTile(
                        icon: Icons.table_restaurant_outlined,
                        title: 'Table ready alerts',
                        switchValue: _tableReadyAlerts,
                        onSwitchChanged: (val) => setState(() => _tableReadyAlerts = val),
                      ),
                      PreferenceTile(
                        icon: Icons.format_list_numbered_rounded,
                        title: 'Queue position updates',
                        switchValue: _queuePositionUpdates,
                        onSwitchChanged: (val) => setState(() => _queuePositionUpdates = val),
                      ),
                      PreferenceTile(
                        icon: Icons.alarm_rounded,
                        title: 'Booking reminders',
                        switchValue: _bookingReminders,
                        onSwitchChanged: (val) => setState(() => _bookingReminders = val),
                      ),
                      PreferenceTile(
                        icon: Icons.local_offer_outlined,
                        title: 'Offers and promotions',
                        switchValue: _offersAndPromotions,
                        onSwitchChanged: (val) => setState(() => _offersAndPromotions = val),
                        showDivider: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // 6. General Section
                const SectionHeader(title: 'General'),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.inputBorder, width: 1),
                  ),
                  child: Column(
                    children: [
                      SettingsTile(
                        icon: Icons.bookmark_outline_rounded,
                        title: 'Saved restaurants',
                        onTap: () => _showSnackBar('Coming soon'),
                      ),
                      SettingsTile(
                        icon: Icons.history_rounded,
                        title: 'Booking history',
                        onTap: () => _showSnackBar('Coming soon'),
                      ),
                      SettingsTile(
                        icon: Icons.payment_outlined,
                        title: 'Payment methods',
                        onTap: () => _showSnackBar('Coming soon'),
                      ),
                      SettingsTile(
                        icon: Icons.language_rounded,
                        title: 'Language',
                        trailingText: _selectedLanguage,
                        onTap: _openLanguageModal,
                      ),
                      SettingsTile(
                        icon: Icons.help_outline_rounded,
                        title: 'Help and support',
                        onTap: () => _showSnackBar('Coming soon'),
                      ),
                      SettingsTile(
                        icon: Icons.info_outline_rounded,
                        title: 'About Boo-KAA',
                        showDivider: false,
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'Boo-KAA',
                            applicationVersion: 'v1.0.0',
                            applicationIcon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryOrange,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.restaurant_menu,
                                color: AppColors.textCharcoal,
                              ),
                            ),
                            children: [
                              const SizedBox(height: 12),
                              Text(
                                'Boo-KAA is Kathmandu Valley’s premier restaurant table booking platform. Good food. Better plans.',
                                style: AppTheme.inter(fontSize: 13),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 7. Log Out Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: _showLogoutDialog,
                    icon: const Icon(Icons.logout_rounded, size: 18, color: Color(0xFFD32F2F)),
                    label: Text(
                      'Log Out',
                      style: AppTheme.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFD32F2F),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      side: const BorderSide(color: Color(0xFFFFCDD2), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // 8. Footer
                Center(
                  child: Text(
                    'Boo-KAA v1.0.0',
                    style: AppTheme.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.mutedGray,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
