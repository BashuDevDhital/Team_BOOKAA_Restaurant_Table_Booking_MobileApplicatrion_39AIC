import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Widgets/app_theme.dart';

class ReviewItem {
  final String id;
  final String restaurantName;
  final String date;
  double rating;
  String text;

  ReviewItem({
    required this.id,
    required this.restaurantName,
    required this.date,
    required this.rating,
    required this.text,
  });
}

class ReviewsPage extends StatefulWidget {
  final List<ReviewItem> initialReviews;
  final Function(List<ReviewItem>) onReviewsUpdated;

  const ReviewsPage({
    super.key,
    required this.initialReviews,
    required this.onReviewsUpdated,
  });

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  late List<ReviewItem> _reviews;

  @override
  void initState() {
    super.initState();
    _reviews = List.from(widget.initialReviews);
  }

  void _notifyParent() {
    widget.onReviewsUpdated(_reviews);
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

  double get _averageRating {
    if (_reviews.isEmpty) return 0.0;
    final total = _reviews.fold(0.0, (sum, item) => sum + item.rating);
    return total / _reviews.length;
  }

  void _openReviewModal({ReviewItem? existingReview}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ReviewEditBottomSheet(
        existingReview: existingReview,
        onSave: (rating, text, [restaurantName]) {
          setState(() {
            if (existingReview != null) {
              existingReview.rating = rating;
              existingReview.text = text;
            } else {
              _reviews.insert(
                0,
                ReviewItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  restaurantName: restaurantName ?? 'Boo-KAA Dining',
                  date: 'Just now',
                  rating: rating,
                  text: text,
                ),
              );
            }
          });
          _notifyParent();
          _showSnackBar(existingReview != null ? 'Review updated' : 'Review published');
        },
      ),
    );
  }

  void _deleteReview(ReviewItem review) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Delete Review?',
          style: AppTheme.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textCharcoal,
          ),
        ),
        content: Text(
          'Are you sure you want to delete your review for ${review.restaurantName}?',
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
              setState(() {
                _reviews.removeWhere((item) => item.id == review.id);
              });
              _notifyParent();
              _showSnackBar('Review deleted');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(
              'Delete',
              style: AppTheme.inter(fontWeight: FontWeight.w700, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRatingRow(double rating, {double iconSize = 18}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        return Icon(
          starValue <= rating
              ? Icons.star_rounded
              : (starValue - rating <= 0.5 ? Icons.star_half_rounded : Icons.star_outline_rounded),
          color: const Color(0xFFFFB300),
          size: iconSize,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              'YOUR VOICE',
              style: AppTheme.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.burntOrange,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              'My Reviews',
              style: AppTheme.dmSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textCharcoal,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openReviewModal(),
        backgroundColor: AppColors.primaryOrange,
        foregroundColor: AppColors.textCharcoal,
        elevation: 4,
        icon: const Icon(Icons.rate_review_rounded),
        label: Text(
          'Write a review',
          style: AppTheme.inter(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Rating Summary Header Card
            Container(
              padding: const EdgeInsets.all(20),
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.softCreamCard,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _averageRating.toStringAsFixed(1),
                          style: AppTheme.dmSans(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: AppColors.burntOrange,
                          ),
                        ),
                        Text(
                          'Average',
                          style: AppTheme.inter(fontSize: 12, color: AppColors.mutedGray),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStarRatingRow(_averageRating, iconSize: 22),
                        const SizedBox(height: 6),
                        Text(
                          'Based on ${_reviews.length} ${_reviews.length == 1 ? 'review' : 'reviews'}',
                          style: AppTheme.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textCharcoal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Review List
            if (_reviews.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: AppColors.softCreamCard,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.rate_review_outlined, size: 48, color: AppColors.burntOrange),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No reviews written yet',
                        style: AppTheme.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textCharcoal,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Share your dining experiences with Kathmandu foodies.',
                        textAlign: TextAlign.center,
                        style: AppTheme.inter(fontSize: 13, color: AppColors.mutedGray),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _reviews.length,
                itemBuilder: (context, index) {
                  final review = _reviews[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.inputBorder),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textCharcoal.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                review.restaurantName,
                                style: AppTheme.dmSans(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textCharcoal,
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert_rounded, color: AppColors.mutedGray),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              color: AppColors.bgCream,
                              onSelected: (action) {
                                if (action == 'edit') {
                                  _openReviewModal(existingReview: review);
                                } else if (action == 'delete') {
                                  _deleteReview(review);
                                }
                              },
                              itemBuilder: (ctx) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      const Icon(Icons.edit_outlined, size: 18, color: AppColors.textCharcoal),
                                      const SizedBox(width: 8),
                                      Text('Edit', style: AppTheme.inter(fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFD32F2F)),
                                      const SizedBox(width: 8),
                                      Text('Delete', style: AppTheme.inter(fontWeight: FontWeight.w600, color: const Color(0xFFD32F2F))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildStarRatingRow(review.rating, iconSize: 16),
                            const SizedBox(width: 8),
                            Text(
                              review.date,
                              style: AppTheme.inter(fontSize: 12, color: AppColors.mutedGray),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          review.text,
                          style: AppTheme.inter(
                            fontSize: 14,
                            color: AppColors.textCharcoal,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: 60), // Extra space for FAB
          ],
        ),
      ),
    );
  }
}

/// ReviewEditBottomSheet: Tappable 5-star rating selector + review text field (max 300 chars) + Save button.
class ReviewEditBottomSheet extends StatefulWidget {
  final String? restaurantName;
  final ReviewItem? existingReview;
  final void Function(double rating, String text, [String? restaurantName]) onSave;

  const ReviewEditBottomSheet({
    super.key,
    this.restaurantName,
    this.existingReview,
    required this.onSave,
  });

  @override
  State<ReviewEditBottomSheet> createState() => _ReviewEditBottomSheetState();
}

class _ReviewEditBottomSheetState extends State<ReviewEditBottomSheet> {
  late double _selectedRating;
  late TextEditingController _textController;
  late TextEditingController _restaurantController;

  String? _ratingError;
  String? _textError;

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.existingReview?.rating ?? 5.0;
    _textController = TextEditingController(text: widget.existingReview?.text ?? '');
    _restaurantController = TextEditingController(
      text: widget.restaurantName ?? widget.existingReview?.restaurantName ?? 'Roadhouse Cafe',
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _restaurantController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool isValid = true;
    setState(() {
      _ratingError = null;
      _textError = null;

      if (_selectedRating <= 0) {
        _ratingError = 'Please select a rating';
        isValid = false;
      }

      final textVal = _textController.text.trim();
      if (textVal.length < 10) {
        _textError = 'Review must be at least 10 characters';
        isValid = false;
      }
    });
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    final titleText = widget.existingReview != null
        ? 'Edit Review'
        : 'Write a Review for ${widget.restaurantName ?? _restaurantController.text}';

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
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
            titleText,
            style: AppTheme.dmSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textCharcoal,
            ),
          ),
          const SizedBox(height: 16),

          if (widget.existingReview == null && widget.restaurantName == null) ...[
            AppTextField(
              label: 'Restaurant Name',
              hint: 'e.g. Roadhouse Cafe',
              controller: _restaurantController,
            ),
            const SizedBox(height: 16),
          ],

          // 5-Star Tappable Rating Selector
          Text(
            'Your Rating',
            style: AppTheme.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textCharcoal,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starValue = (index + 1).toDouble();
              return IconButton(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedRating = starValue);
                },
                icon: Icon(
                  starValue <= _selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: const Color(0xFFFFB300),
                  size: 36,
                ),
              );
            }),
          ),
          if (_ratingError != null)
            Center(
              child: Text(
                _ratingError!,
                style: AppTheme.inter(fontSize: 12, color: const Color(0xFFD32F2F)),
              ),
            ),
          const SizedBox(height: 16),

          // Review Text Field (max 300 chars with counter)
          Text(
            'Your Review',
            style: AppTheme.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textCharcoal,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: _textError != null ? const Color(0xFFD32F2F) : AppColors.inputBorder,
              ),
            ),
            child: TextField(
              controller: _textController,
              maxLength: 300,
              maxLines: 4,
              style: AppTheme.inter(fontSize: 14, color: AppColors.textCharcoal),
              decoration: InputDecoration(
                hintText: 'Share details of your experience (food quality, ambiance, table service)...',
                hintStyle: AppTheme.inter(fontSize: 14, color: AppColors.mutedGray),
                contentPadding: const EdgeInsets.all(16),
                border: InputBorder.none,
              ),
            ),
          ),
          if (_textError != null) ...[
            const SizedBox(height: 4),
            Text(
              _textError!,
              style: AppTheme.inter(fontSize: 12, color: const Color(0xFFD32F2F)),
            ),
          ],
          const SizedBox(height: 24),

          PrimaryButton(
            label: 'Submit Review',
            onPressed: () {
              if (_validate()) {
                widget.onSave(
                  _selectedRating,
                  _textController.text.trim(),
                  _restaurantController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
