import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Dashboard/auth_screens.dart';
import '../Widgets/app_theme.dart';
import 'avatar_picker_sheet.dart';
import 'bookings_page.dart';
import 'profile_widgets.dart';
import 'reviews_page.dart';
import 'saved_page.dart';

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
  File? _profilePhotoFile;

  // Initial Sample Bookings (10 items)
  late List<BookingItem> _sampleBookings;

  // Initial Sample Saved Restaurants (5 items)
  late List<SavedRestaurant> _sampleSaved;

  // Initial Sample Reviews (3 items)
  late List<ReviewItem> _sampleReviews;

  // Preferences State
  bool _isVegetarianFriendly = false;
  RangeValues _budgetRange = const RangeValues(500, 2500);
  List<String> _favoriteCuisines = ['Nepali', 'Newari', 'Asian'];

  // Notifications State
  bool _tableReadyAlerts = true;
  bool _queuePositionUpdates = true;
  bool _bookingReminders = true;
  bool _offersAndPromotions = false;

  // General State
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    _sampleBookings = [
      BookingItem(
        id: '1',
        restaurantName: 'The Workshop Eatery',
        location: 'Jhamsikhet, Lalitpur',
        bookingId: 'BK-2407',
        date: 'Nov 28, 2026',
        time: '7:00 PM',
        guests: 4,
        status: BookingStatus.upcoming,
      ),
      BookingItem(
        id: '2',
        restaurantName: 'Toran Dining',
        location: 'Dwarika\'s, Battisputali',
        bookingId: 'BK-2408',
        date: 'Dec 02, 2026',
        time: '8:15 PM',
        guests: 2,
        status: BookingStatus.upcoming,
      ),
      BookingItem(
        id: '3',
        restaurantName: 'Roadhouse Cafe',
        location: 'Thamel, Kathmandu',
        bookingId: 'BK-2409',
        date: 'Dec 05, 2026',
        time: '6:30 PM',
        guests: 6,
        status: BookingStatus.upcoming,
      ),
      BookingItem(
        id: '4',
        restaurantName: 'Bao Basera',
        location: 'Jhamsikhet, Lalitpur',
        bookingId: 'BK-2390',
        date: 'Nov 20, 2026',
        time: '7:30 PM',
        guests: 2,
        status: BookingStatus.completed,
      ),
      BookingItem(
        id: '5',
        restaurantName: 'The Old House',
        location: 'Durbar Marg, Kathmandu',
        bookingId: 'BK-2385',
        date: 'Nov 15, 2026',
        time: '8:00 PM',
        guests: 4,
        status: BookingStatus.completed,
      ),
      BookingItem(
        id: '6',
        restaurantName: 'Kaiser Cafe',
        location: 'Garden of Dreams, Thamel',
        bookingId: 'BK-2371',
        date: 'Nov 10, 2026',
        time: '1:00 PM',
        guests: 2,
        status: BookingStatus.completed,
      ),
      BookingItem(
        id: '7',
        restaurantName: 'Krishnarpan',
        location: 'Battisputali, Kathmandu',
        bookingId: 'BK-2362',
        date: 'Nov 02, 2026',
        time: '7:00 PM',
        guests: 5,
        status: BookingStatus.completed,
      ),
      BookingItem(
        id: '8',
        restaurantName: 'Attic Bar',
        location: 'Lazimpat, Kathmandu',
        bookingId: 'BK-2350',
        date: 'Oct 28, 2026',
        time: '8:30 PM',
        guests: 3,
        status: BookingStatus.completed,
      ),
      BookingItem(
        id: '9',
        restaurantName: 'Fire and Ice Pizzeria',
        location: 'Thamel, Kathmandu',
        bookingId: 'BK-2340',
        date: 'Oct 18, 2026',
        time: '6:00 PM',
        guests: 4,
        status: BookingStatus.cancelled,
      ),
      BookingItem(
        id: '10',
        restaurantName: 'Mezze by Roadhouse',
        location: 'Durbar Marg, Kathmandu',
        bookingId: 'BK-2331',
        date: 'Oct 12, 2026',
        time: '7:30 PM',
        guests: 2,
        status: BookingStatus.cancelled,
      ),
    ];

    _sampleSaved = [
      SavedRestaurant(
        id: '1',
        name: 'Bao Basera',
        cuisine: 'Asian Fusion',
        location: 'Jhamsikhet',
        distance: '1.2 km',
        rating: 4.8,
        reviewCount: 142,
        priceForTwo: 'Rs. 1,200 for two',
        availabilityText: 'Tables available',
        category: 'Fine Dining',
      ),
      SavedRestaurant(
        id: '2',
        name: 'Roadhouse Cafe',
        cuisine: 'Italian & Pizza',
        location: 'Thamel',
        distance: '2.5 km',
        rating: 4.7,
        reviewCount: 210,
        priceForTwo: 'Rs. 1,500 for two',
        availabilityText: '3 tables left',
        category: 'Cafes',
      ),
      SavedRestaurant(
        id: '3',
        name: 'The Old House',
        cuisine: 'French & Continental',
        location: 'Durbar Marg',
        distance: '3.1 km',
        rating: 4.9,
        reviewCount: 98,
        priceForTwo: 'Rs. 2,800 for two',
        availabilityText: 'Tables available',
        category: 'Fine Dining',
      ),
      SavedRestaurant(
        id: '4',
        name: 'Himalayan Java',
        cuisine: 'Coffee & Bakery',
        location: 'Patan Durbar',
        distance: '0.8 km',
        rating: 4.6,
        reviewCount: 320,
        priceForTwo: 'Rs. 800 for two',
        availabilityText: 'Tables available',
        category: 'Cafes',
      ),
      SavedRestaurant(
        id: '5',
        name: 'Bhojan Griha',
        cuisine: 'Authentic Newari',
        location: 'Dilli Bazar',
        distance: '2.0 km',
        rating: 4.8,
        reviewCount: 180,
        priceForTwo: 'Rs. 2,200 for two',
        availabilityText: '2 tables left',
        category: 'Family',
      ),
    ];

    _sampleReviews = [
      ReviewItem(
        id: '1',
        restaurantName: 'Roadhouse Cafe',
        date: '2 days ago',
        rating: 5.0,
        text: 'Best wood-fired pizza in Kathmandu! Great ambiance and polite staff.',
      ),
      ReviewItem(
        id: '2',
        restaurantName: 'Bao Basera',
        date: '1 week ago',
        rating: 4.5,
        text: 'Delicious pork bao buns and ramen. Booking with Boo-KAA saved us 30 mins wait.',
      ),
      ReviewItem(
        id: '3',
        restaurantName: 'The Old House',
        date: '2 weeks ago',
        rating: 4.5,
        text: 'Beautiful courtyards and exquisite French cuisine. Perfect anniversary dinner.',
      ),
    ];
  }

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

  void _openAvatarPickerModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AvatarPickerSheet(
        hasCurrentPhoto: _profilePhotoFile != null,
        onPhotoSelected: (file) {
          setState(() => _profilePhotoFile = file);
          _showSnackBar('Profile photo updated');
        },
        onPhotoRemoved: () {
          setState(() => _profilePhotoFile = null);
          _showSnackBar('Photo removed');
        },
        onError: (err) => _showSnackBar(err),
      ),
    );
  }

  void _navigateToBookings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingsPage(
          initialBookings: _sampleBookings,
          onBookingsUpdated: (updatedList) {
            setState(() {
              _sampleBookings = updatedList;
            });
          },
          onReviewAdded: (newReview) {
            setState(() {
              _sampleReviews.insert(0, newReview);
            });
          },
        ),
      ),
    );
  }

  void _navigateToSaved() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SavedPage(
          initialSavedList: _sampleSaved,
          onListUpdated: (updatedList) {
            setState(() {
              _sampleSaved = updatedList;
            });
          },
        ),
      ),
    );
  }

  void _navigateToReviews() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewsPage(
          initialReviews: _sampleReviews,
          onReviewsUpdated: (updatedList) {
            setState(() {
              _sampleReviews = updatedList;
            });
          },
        ),
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
          setState(() => _budgetRange = newRange);
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
          setState(() => _favoriteCuisines = newList);
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
              tileColor: AppColors.softCreamCard,
              title: Text('English', style: AppTheme.inter(fontWeight: FontWeight.w600)),
              trailing: const Icon(Icons.check_circle_rounded, color: AppColors.primaryOrange),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.pop(ctx);
              },
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                'More languages will be added later.',
                style: AppTheme.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.mutedGray,
                ),
              ),
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
          style: AppTheme.inter(fontSize: 14, color: AppColors.textCharcoal),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTheme.inter(fontWeight: FontWeight.w600, color: AppColors.mutedGray),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(
              'Log Out',
              style: AppTheme.inter(fontWeight: FontWeight.w700, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final budgetText = 'Rs. ${_budgetRange.start.round()} - ${_budgetRange.end.round()}';
    final cuisineText = _favoriteCuisines.isEmpty ? 'None selected' : _favoriteCuisines.join(', ');

    // Live counts
    final bookingsCount = _sampleBookings.where((b) => b.status != BookingStatus.cancelled).length;
    final savedCount = _sampleSaved.length;
    final reviewsCount = _sampleReviews.length;

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
                // 1. Eyebrow & Title
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

                // 2. Profile Card with Camera Badge & Avatar
                ProfileHeaderCard(
                  name: _userName,
                  email: _userEmail,
                  memberSince: _memberSince,
                  photoFile: _profilePhotoFile,
                  onEditPressed: _openEditProfileModal,
                  onAvatarPressed: _openAvatarPickerModal,
                ),
                const SizedBox(height: 20),

                // 3. Stats Row
                Row(
                  children: [
                    StatCard(
                      label: 'Bookings',
                      value: '$bookingsCount',
                      icon: Icons.calendar_today_rounded,
                      onTap: _navigateToBookings,
                    ),
                    const SizedBox(width: 12),
                    StatCard(
                      label: 'Saved',
                      value: '$savedCount',
                      icon: Icons.bookmark_border_rounded,
                      onTap: _navigateToSaved,
                    ),
                    const SizedBox(width: 12),
                    StatCard(
                      label: 'Reviews',
                      value: '$reviewsCount',
                      icon: Icons.star_border_rounded,
                      onTap: _navigateToReviews,
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // 4. Dining Preferences Section
                const SectionHeader(title: 'Dining Preferences'),
                Text(
                  'Used by Boo-KAA AI to suggest places for you.',
                  style: AppTheme.inter(fontSize: 13, color: AppColors.mutedGray),
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
                        showDivider: false,
                        onTap: _openCuisineModal,
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
                        onTap: _navigateToSaved,
                      ),
                      SettingsTile(
                        icon: Icons.history_rounded,
                        title: 'Booking history',
                        onTap: _navigateToBookings,
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
