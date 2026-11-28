import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Widgets/app_theme.dart';

class SavedRestaurant {
  final String id;
  final String name;
  final String cuisine;
  final String location;
  final String distance;
  final double rating;
  final int reviewCount;
  final String priceForTwo;
  final String availabilityText;
  final String category;

  SavedRestaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.location,
    required this.distance,
    required this.rating,
    required this.reviewCount,
    required this.priceForTwo,
    required this.availabilityText,
    required this.category,
  });
}

class SavedPage extends StatefulWidget {
  final List<SavedRestaurant> initialSavedList;
  final Function(List<SavedRestaurant>) onListUpdated;

  const SavedPage({
    super.key,
    required this.initialSavedList,
    required this.onListUpdated,
  });

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  late List<SavedRestaurant> _savedList;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Cafes', 'Fine Dining', 'Family', 'Fast Food'];

  @override
  void initState() {
    super.initState();
    _savedList = List.from(widget.initialSavedList);
  }

  void _notifyParent() {
    widget.onListUpdated(_savedList);
  }

  void _removeRestaurant(SavedRestaurant restaurant, int originalIndex) {
    HapticFeedback.selectionClick();
    setState(() {
      _savedList.removeWhere((item) => item.id == restaurant.id);
    });
    _notifyParent();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Removed ${restaurant.name} from saved',
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
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppColors.primaryOrange,
          onPressed: () {
            setState(() {
              _savedList.insert(originalIndex < _savedList.length ? originalIndex : _savedList.length, restaurant);
            });
            _notifyParent();
          },
        ),
      ),
    );
  }

  List<SavedRestaurant> get _filteredList {
    return _savedList.where((item) {
      final matchesQuery = item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.cuisine.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredList;

    return Scaffold(
      backgroundColor: AppColors.bgCream,
      appBar: AppBar(
        backgroundColor: AppColors.bgCream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textCharcoal),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'YOUR FAVOURITES',
              style: AppTheme.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.burntOrange,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              'Saved Restaurants',
              style: AppTheme.dmSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textCharcoal,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search & Filter Bar Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                // Search TextField
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: AppTheme.inter(fontSize: 14, color: AppColors.textCharcoal),
                    decoration: InputDecoration(
                      hintText: 'Search saved places or cuisines...',
                      hintStyle: AppTheme.inter(fontSize: 14, color: AppColors.mutedGray),
                      border: InputBorder.none,
                      icon: const Icon(Icons.search_rounded, color: AppColors.burntOrange, size: 22),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.mutedGray),
                              onPressed: () => setState(() => _searchQuery = ''),
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Category Chips Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: _categories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            cat,
                            style: AppTheme.inter(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: AppColors.textCharcoal,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.primaryOrange,
                          backgroundColor: AppColors.white,
                          side: BorderSide(
                            color: isSelected ? AppColors.primaryOrange : AppColors.inputBorder,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          onSelected: (selected) {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedCategory = cat);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Saved List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(22),
                            decoration: const BoxDecoration(
                              color: AppColors.softCreamCard,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.bookmark_remove_rounded,
                              size: 48,
                              color: AppColors.burntOrange,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No saved places found',
                            style: AppTheme.dmSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textCharcoal,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tap the heart icon on any restaurant to save it to your favourites.',
                            textAlign: TextAlign.center,
                            style: AppTheme.inter(fontSize: 13, color: AppColors.mutedGray),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final restaurant = filtered[index];
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          key: ValueKey(restaurant.id),
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.inputBorder),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.textCharcoal.withValues(alpha: 0.03),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Image Placeholder
                              Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [AppColors.primaryOrange, AppColors.burntOrange],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Icon(
                                  Icons.restaurant_rounded,
                                  color: AppColors.white,
                                  size: 36,
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Info Column
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            restaurant.name,
                                            style: AppTheme.dmSans(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textCharcoal,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                          visualDensity: VisualDensity.compact,
                                          constraints: const BoxConstraints(),
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(
                                            Icons.favorite_rounded,
                                            color: Color(0xFFD32F2F),
                                            size: 22,
                                          ),
                                          onPressed: () {
                                            _removeRestaurant(restaurant, index);
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${restaurant.cuisine} • ${restaurant.location} (${restaurant.distance})',
                                      style: AppTheme.inter(
                                        fontSize: 12,
                                        color: AppColors.mutedGray,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFB300)),
                                        const SizedBox(width: 2),
                                        Text(
                                          '${restaurant.rating} (${restaurant.reviewCount}+)',
                                          style: AppTheme.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textCharcoal,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '•  ${restaurant.priceForTwo}',
                                          style: AppTheme.inter(
                                            fontSize: 12,
                                            color: AppColors.mutedGray,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.moodSage,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        restaurant.availabilityText,
                                        style: AppTheme.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.availabilityGreen,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
