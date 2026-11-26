import 'package:flutter/material.dart';
import '../Widgets/app_theme.dart';
import '../Profile/profile_screen.dart';

// =============================================================================
// RESTAURANT DATA MODEL
// =============================================================================
class RestaurantModel {
  final String id;
  final String name;
  final String cuisineAndDistance;
  final double rating;
  final int reviewCount;
  final String imagePath;
  final String availabilityText;
  bool isFavorite;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.cuisineAndDistance,
    required this.rating,
    required this.reviewCount,
    required this.imagePath,
    required this.availabilityText,
    this.isFavorite = false,
  });
}

// =============================================================================
// HOME SCREEN
// =============================================================================
class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({
    super.key,
    this.userName = 'Aayush',
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _selectedMoodIndex = 0;

  // Placeholder data for Kathmandu restaurants (can easily be replaced with API data)
  final List<RestaurantModel> _restaurants = [
    RestaurantModel(
      id: '1',
      name: 'Bao Basera',
      cuisineAndDistance: 'Asian Fusion • Jhamsikhet • 1.2 km',
      rating: 4.8,
      reviewCount: 142,
      imagePath: 'assets/images/restaurant_1.jpg',
      availabilityText: 'Tables available',
      isFavorite: false,
    ),
    RestaurantModel(
      id: '2',
      name: 'Roadhouse Cafe',
      cuisineAndDistance: 'Italian & Pizza • Thamel • 2.5 km',
      rating: 4.7,
      reviewCount: 210,
      imagePath: 'assets/images/restaurant_2.jpg',
      availabilityText: '3 tables left',
      isFavorite: true,
    ),
    RestaurantModel(
      id: '3',
      name: 'The Old House',
      cuisineAndDistance: 'French & Continental • Durbar Marg • 3.1 km',
      rating: 4.9,
      reviewCount: 98,
      imagePath: 'assets/images/restaurant_3.jpg',
      availabilityText: 'Tables available',
      isFavorite: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCream,
      body: SafeArea(
        child: _selectedIndex == 0
            ? _buildHomeBody()
            : _selectedIndex == 3
                ? const ProfileScreen()
                : _buildPlaceholderTab(['Home', 'Explore', 'My Bookings', 'Profile'][_selectedIndex]),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(
            top: BorderSide(
              color: AppColors.inputBorder,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: AppColors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryOrange,
          unselectedItemColor: AppColors.mutedGray,
          selectedLabelStyle: AppTheme.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: AppTheme.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              activeIcon: Icon(Icons.search_rounded),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today_rounded),
              label: 'My Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the primary Home tab view
  Widget _buildHomeBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          _HeaderRow(userName: widget.userName),

          const SizedBox(height: 20),

          // Greeting Section
          _GreetingSection(userName: widget.userName),

          const SizedBox(height: 20),

          // Search Bar
          const _SearchBarWidget(),

          const SizedBox(height: 20),

          // AI Banner Card
          const _AiBannerCard(),

          const SizedBox(height: 28),

          // Mood Chips Section
          _MoodSection(
            selectedIndex: _selectedMoodIndex,
            onSelect: (index) {
              setState(() {
                _selectedMoodIndex = index;
              });
            },
          ),

          const SizedBox(height: 28),

          // Available Near You Section
          _AvailableNearYouSection(
            restaurants: _restaurants,
            onFavoriteToggle: (index) {
              setState(() {
                _restaurants[index].isFavorite = !_restaurants[index].isFavorite;
              });
            },
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Placeholder widget for non-home tabs
  Widget _buildPlaceholderTab(String tabName) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.softCreamCard,
              shape: BoxShape.circle,
            ),
            child: Icon(
              tabName == 'Explore'
                  ? Icons.explore_outlined
                  : tabName == 'My Bookings'
                      ? Icons.bookmark_border_rounded
                      : Icons.person_outline_rounded,
              size: 44,
              color: AppColors.primaryOrange,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            tabName,
            style: AppTheme.dmSans(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textCharcoal,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Coming soon',
            style: AppTheme.dmSans(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.mutedGray,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PRIVATE HOME SCREEN WIDGETS
// =============================================================================

/// Header Row: Logo tile, Location, User Avatar
class _HeaderRow extends StatelessWidget {
  final String userName;

  const _HeaderRow({required this.userName});

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || parts[0].isEmpty) return 'BK';
    if (parts.length == 1) {
      return parts[0].length >= 2
          ? parts[0].substring(0, 2).toUpperCase()
          : parts[0].toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Boo-KAA Logo Tile (44x44, rounded)
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.softCreamCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.inputBorder, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Image.asset(
              'assets/images/Boo-KAA Logo.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/boo_kaa_logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error2, stackTrace2) {
                    return Container(
                      color: AppColors.primaryOrange,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.restaurant_menu_rounded,
                        color: AppColors.textCharcoal,
                        size: 22,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),

        // Location Block
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_on_rounded,
              color: AppColors.primaryOrange,
              size: 18,
            ),
            const SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Your location',
                  style: AppTheme.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.mutedGray,
                  ),
                ),
                Text(
                  'Kathmandu, Nepal',
                  style: AppTheme.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textCharcoal,
                  ),
                ),
              ],
            ),
          ],
        ),

        // User Avatar Circle (44px dark charcoal)
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.darkCard,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            _getInitials(userName),
            style: AppTheme.dmSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}

/// Greeting Section: "Namaste, `userName`" + "Where are we eating today?"
class _GreetingSection extends StatelessWidget {
  final String userName;

  const _GreetingSection({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Namaste, $userName',
          style: AppTheme.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.burntOrange,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Where are we\neating today?',
          style: AppTheme.dmSans(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.textCharcoal,
            height: 1.15,
          ),
        ),
      ],
    );
  }
}

/// Search Bar: White rounded pill with soft shadow & filter button
class _SearchBarWidget extends StatelessWidget {
  const _SearchBarWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.only(left: 16, right: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.inputBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            color: AppColors.primaryOrange,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: AppTheme.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textCharcoal,
              ),
              decoration: InputDecoration(
                hintText: 'Restaurant, cuisine or location',
                hintStyle: AppTheme.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppColors.mutedGray,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          // Filter Button (Small cream rounded square)
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.softCreamCard,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.tune_rounded,
                color: AppColors.textCharcoal,
                size: 20,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Filter options coming soon!'),
                    backgroundColor: AppColors.darkCard,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// AI Banner Card: Dark card with BOO-KAA AI recommendations
class _AiBannerCard extends StatelessWidget {
  const _AiBannerCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Open AI recommendation screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('BOO-KAA AI Recommendations coming soon!'),
            backgroundColor: AppColors.darkCard,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Orange Sparkle Tile
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: AppColors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BOO-KAA AI',
                    style: AppTheme.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryOrange,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tell us your budget.\nWe\'ll find your place.',
                    style: AppTheme.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Try smart recommendations',
                    style: AppTheme.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9E988E),
                    ),
                  ),
                ],
              ),
            ),

            // Right Chevron
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

/// Mood Section: "What's the mood?" + Horizontally scrolling mood chips
class _MoodSection extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _MoodSection({
    required this.selectedIndex,
    required this.onSelect,
  });

  static const List<Map<String, dynamic>> _moods = [
    {
      'label': 'Cafes',
      'color': AppColors.moodPeach,
      'icon': Icons.coffee_outlined,
    },
    {
      'label': 'Family\nDining',
      'color': AppColors.moodSage,
      'icon': Icons.roofing_outlined,
    },
    {
      'label': 'Fine\nDining',
      'color': AppColors.moodTaupe,
      'icon': Icons.auto_awesome_outlined,
    },
    {
      'label': 'Fast\nFood',
      'color': AppColors.moodButter,
      'icon': Icons.ramen_dining_outlined,
    },
    {
      'label': 'Celebrations',
      'color': AppColors.moodBlush,
      'icon': Icons.cake_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What\'s the mood?',
          style: AppTheme.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textCharcoal,
          ),
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(_moods.length, (index) {
              final mood = _moods[index];
              final isSelected = selectedIndex == index;

              return Padding(
                padding: const EdgeInsets.only(right: 14),
                child: GestureDetector(
                  onTap: () => onSelect(index),
                  child: Column(
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: mood['color'] as Color,
                          borderRadius: BorderRadius.circular(20),
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.primaryOrange,
                                  width: 2.5,
                                )
                              : null,
                        ),
                        child: Icon(
                          mood['icon'] as IconData,
                          size: 32,
                          color: AppColors.textCharcoal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 76,
                        child: Text(
                          mood['label'] as String,
                          style: AppTheme.dmSans(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: AppColors.textCharcoal,
                            height: 1.15,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

/// Available Near You Section: Header with "See all" + horizontal restaurant cards
class _AvailableNearYouSection extends StatelessWidget {
  final List<RestaurantModel> restaurants;
  final ValueChanged<int> onFavoriteToggle;

  const _AvailableNearYouSection({
    required this.restaurants,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row: "Available near you" & "See all >"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Available near you',
              style: AppTheme.dmSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textCharcoal,
              ),
            ),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All restaurants list coming soon!'),
                    backgroundColor: AppColors.darkCard,
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'See all',
                    style: AppTheme.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.burntOrange,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: AppColors.burntOrange,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Horizontal Restaurant Cards List
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(restaurants.length, (index) {
              final restaurant = restaurants[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _RestaurantCard(
                  restaurant: restaurant,
                  onFavoritePressed: () => onFavoriteToggle(index),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

/// Single Restaurant Card Widget (~240 wide, ~170 photo height, radius 24)
class _RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback onFavoritePressed;

  const _RestaurantCard({
    required this.restaurant,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to restaurant details page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${restaurant.name} booking coming soon!'),
            backgroundColor: AppColors.darkCard,
          ),
        );
      },
      child: SizedBox(
        width: 240,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo Container
            Container(
              height: 170,
              width: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: AppColors.softCreamCard,
              ),
              child: Stack(
                children: [
                  // Photo with fallback errorBuilder
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      restaurant.imagePath,
                      width: 240,
                      height: 170,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Stylish photo placeholder if image asset is not present
                        return Container(
                          width: 240,
                          height: 170,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF3A342D),
                                AppColors.darkCard,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.restaurant_rounded,
                                  size: 42,
                                  color: AppColors.primaryOrange,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  restaurant.name,
                                  style: AppTheme.dmSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Top-Right Circular Heart Button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: onFavoritePressed,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          restaurant.isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: restaurant.isFavorite
                              ? const Color(0xFFE53935)
                              : AppColors.textCharcoal,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  // Bottom-Left Availability Badge
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: AppColors.availabilityGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            restaurant.availabilityText,
                            style: AppTheme.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textCharcoal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Restaurant Name
            Text(
              restaurant.name,
              style: AppTheme.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textCharcoal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 2),

            // Cuisine and Distance
            Text(
              restaurant.cuisineAndDistance,
              style: AppTheme.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.mutedGray,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Rating Row
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.primaryOrange,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  '${restaurant.rating}',
                  style: AppTheme.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textCharcoal,
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  '(${restaurant.reviewCount}+)',
                  style: AppTheme.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.mutedGray,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
