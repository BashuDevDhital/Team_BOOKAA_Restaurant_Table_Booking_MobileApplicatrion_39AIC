import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Widgets/app_theme.dart';
import 'book_again_page.dart';
import 'booking_details_page.dart';
import 'directions_sheet.dart';
import 'reviews_page.dart';

enum BookingStatus { upcoming, completed, cancelled }

class BookingItem {
  final String id;
  final String restaurantName;
  final String location;
  final String bookingId;
  final String date;
  final String time;
  final int guests;
  BookingStatus status;

  BookingItem({
    required this.id,
    required this.restaurantName,
    required this.location,
    required this.bookingId,
    required this.date,
    required this.time,
    required this.guests,
    required this.status,
  });
}

class BookingsPage extends StatefulWidget {
  final List<BookingItem> initialBookings;
  final Function(List<BookingItem>) onBookingsUpdated;
  final Function(ReviewItem review)? onReviewAdded;

  const BookingsPage({
    super.key,
    required this.initialBookings,
    required this.onBookingsUpdated,
    this.onReviewAdded,
  });

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<BookingItem> _bookings;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _bookings = List.from(widget.initialBookings);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _notifyParent() {
    widget.onBookingsUpdated(_bookings);
  }

  void _showSnackBar(String message, {VoidCallback? onUndo}) {
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
        duration: const Duration(seconds: 3),
        action: onUndo != null
            ? SnackBarAction(
                label: 'Undo',
                textColor: AppColors.primaryOrange,
                onPressed: onUndo,
              )
            : null,
      ),
    );
  }

  void _openCancelModal(BookingItem booking) {
    String? selectedReason;
    final reasons = [
      'Change of plans',
      'Found another place',
      'Booked by mistake',
      'Other',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                    'Cancel Booking?',
                    style: AppTheme.dmSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textCharcoal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${booking.restaurantName} • ${booking.bookingId}',
                    style: AppTheme.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.burntOrange,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Policy note
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.softCreamCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.burntOrange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Free cancellation up to 2 hours before your booking.',
                            style: AppTheme.inter(fontSize: 12, color: AppColors.textCharcoal),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Reason for cancellation',
                    style: AppTheme.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textCharcoal),
                  ),
                  const SizedBox(height: 8),

                  Column(
                    children: reasons.map((reason) {
                      return RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: Text(reason, style: AppTheme.inter(fontSize: 14, color: AppColors.textCharcoal)),
                        value: reason,
                        groupValue: selectedReason,
                        activeColor: AppColors.primaryOrange,
                        onChanged: (val) {
                          HapticFeedback.selectionClick();
                          setModalState(() => selectedReason = val);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.inputBorder),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text('Keep Booking', style: AppTheme.inter(fontWeight: FontWeight.w600, color: AppColors.textCharcoal)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: selectedReason != null
                              ? () {
                                  Navigator.pop(ctx);
                                  setState(() {
                                    booking.status = BookingStatus.cancelled;
                                  });
                                  _notifyParent();
                                  _showSnackBar(
                                    'Booking ${booking.bookingId} cancelled',
                                    onUndo: () {
                                      setState(() {
                                        booking.status = BookingStatus.upcoming;
                                      });
                                      _notifyParent();
                                    },
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD32F2F),
                            disabledBackgroundColor: AppColors.inputBorder,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text('Yes, Cancel', style: AppTheme.inter(fontWeight: FontWeight.w700, color: AppColors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openDirectionsModal(BookingItem booking) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DirectionsSheet(
        restaurantName: booking.restaurantName,
        location: booking.location,
      ),
    );
  }

  void _openDetailsPage(BookingItem booking) async {
    final updated = await Navigator.push<BookingItem>(
      context,
      MaterialPageRoute(
        builder: (_) => BookingDetailsPage(
          booking: booking,
          onBookingUpdated: (updatedBooking) {
            setState(() {
              final index = _bookings.indexWhere((b) => b.id == updatedBooking.id);
              if (index != -1) {
                _bookings[index] = updatedBooking;
              }
            });
            _notifyParent();
          },
          onBookingCancelled: () {
            setState(() {
              booking.status = BookingStatus.cancelled;
            });
            _notifyParent();
          },
        ),
      ),
    );

    if (updated != null) {
      setState(() {
        final index = _bookings.indexWhere((b) => b.id == updated.id);
        if (index != -1) {
          _bookings[index] = updated;
        }
      });
      _notifyParent();
    }
  }

  void _openBookAgainPage(BookingItem booking) async {
    final newBooking = await Navigator.push<BookingItem>(
      context,
      MaterialPageRoute(
        builder: (_) => BookAgainPage(
          previousBooking: booking,
          onBookingCreated: (createdBooking) {
            setState(() {
              _bookings.insert(0, createdBooking);
            });
            _notifyParent();
          },
        ),
      ),
    );

    if (newBooking != null) {
      _tabController.animateTo(0); // Switch to Upcoming tab
    }
  }

  void _openReviewModal(BookingItem booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ReviewEditBottomSheet(
        restaurantName: booking.restaurantName,
        onSave: (rating, text, [restaurantName]) {
          if (widget.onReviewAdded != null) {
            final newReview = ReviewItem(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              restaurantName: booking.restaurantName,
              date: 'Just now',
              rating: rating,
              text: text,
            );
            widget.onReviewAdded!(newReview);
          }
          _showSnackBar('Review published for ${booking.restaurantName}');
        },
      ),
    );
  }

  Widget _buildBookingCard(BookingItem booking) {
    Color statusBg;
    Color statusText;
    String statusLabel;

    switch (booking.status) {
      case BookingStatus.upcoming:
        statusBg = AppColors.moodSage;
        statusText = AppColors.availabilityGreen;
        statusLabel = 'Reserved';
        break;
      case BookingStatus.completed:
        statusBg = AppColors.softCreamCard;
        statusText = AppColors.burntOrange;
        statusLabel = 'Completed';
        break;
      case BookingStatus.cancelled:
        statusBg = const Color(0xFFFFEBEE);
        statusText = const Color(0xFFD32F2F);
        statusLabel = 'Cancelled';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.inputBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.textCharcoal.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryOrange, AppColors.burntOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.restaurant_rounded,
                  color: AppColors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.restaurantName,
                      style: AppTheme.dmSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textCharcoal,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.mutedGray),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            booking.location,
                            style: AppTheme.inter(fontSize: 12, color: AppColors.mutedGray),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusLabel,
                  style: AppTheme.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: statusText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.inputBorder),
          const SizedBox(height: 14),

          // Details Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem(Icons.confirmation_number_outlined, 'ID: ${booking.bookingId}'),
              _buildDetailItem(Icons.calendar_today_outlined, booking.date),
              _buildDetailItem(Icons.access_time_rounded, booking.time),
              _buildDetailItem(Icons.person_outline_rounded, '${booking.guests} guests'),
            ],
          ),

          // Action Buttons
          if (booking.status == BookingStatus.upcoming) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _openCancelModal(booking),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFD32F2F),
                      side: const BorderSide(color: Color(0xFFFFCDD2)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text('Cancel', style: AppTheme.inter(fontWeight: FontWeight.w600, color: const Color(0xFFD32F2F))),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _openDirectionsModal(booking),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textCharcoal,
                      side: const BorderSide(color: AppColors.inputBorder),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text('Directions', style: AppTheme.inter(fontWeight: FontWeight.w600, color: AppColors.textCharcoal)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _openDetailsPage(booking),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: AppColors.textCharcoal,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text('Details', style: AppTheme.inter(fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
                  ),
                ),
              ],
            ),
          ] else if (booking.status == BookingStatus.completed) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openReviewModal(booking),
                    icon: const Icon(Icons.star_outline_rounded, size: 16, color: AppColors.burntOrange),
                    label: Text('Leave Review', style: AppTheme.inter(fontWeight: FontWeight.w600, color: AppColors.textCharcoal)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.inputBorder),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _openBookAgainPage(booking),
                    icon: const Icon(Icons.replay_rounded, size: 16, color: AppColors.textCharcoal),
                    label: Text('Book Again', style: AppTheme.inter(fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.burntOrange),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTheme.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textCharcoal,
          ),
        ),
      ],
    );
  }

  Widget _buildTabList(BookingStatus status) {
    final filtered = _bookings.where((b) => b.status == status).toList();

    if (filtered.isEmpty) {
      String emptyTitle;
      String emptyDesc;
      IconData icon;

      switch (status) {
        case BookingStatus.upcoming:
          emptyTitle = 'No upcoming bookings';
          emptyDesc = 'Your active table reservations will show up here.';
          icon = Icons.event_available_rounded;
          break;
        case BookingStatus.completed:
          emptyTitle = 'No completed bookings';
          emptyDesc = 'Past dining experiences will appear here.';
          icon = Icons.history_rounded;
          break;
        case BookingStatus.cancelled:
          emptyTitle = 'No cancelled bookings';
          emptyDesc = 'Cancelled reservations will be archived here.';
          icon = Icons.event_busy_rounded;
          break;
      }

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.softCreamCard,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 48, color: AppColors.burntOrange),
              ),
              const SizedBox(height: 16),
              Text(
                emptyTitle,
                style: AppTheme.dmSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textCharcoal,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                emptyDesc,
                textAlign: TextAlign.center,
                style: AppTheme.inter(fontSize: 13, color: AppColors.mutedGray),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: KeyedSubtree(
            key: ValueKey(filtered[index].id),
            child: _buildBookingCard(filtered[index]),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final upcomingCount = _bookings.where((b) => b.status == BookingStatus.upcoming).length;
    final completedCount = _bookings.where((b) => b.status == BookingStatus.completed).length;
    final cancelledCount = _bookings.where((b) => b.status == BookingStatus.cancelled).length;

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
              'YOUR PLANS',
              style: AppTheme.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.burntOrange,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              'My Bookings',
              style: AppTheme.dmSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textCharcoal,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.primaryOrange,
                borderRadius: BorderRadius.circular(16),
              ),
              labelColor: AppColors.textCharcoal,
              unselectedLabelColor: AppColors.mutedGray,
              labelStyle: AppTheme.inter(fontSize: 13, fontWeight: FontWeight.w700),
              unselectedLabelStyle: AppTheme.inter(fontSize: 13, fontWeight: FontWeight.w500),
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: 'Upcoming ($upcomingCount)'),
                Tab(text: 'Completed ($completedCount)'),
                Tab(text: 'Cancelled ($cancelledCount)'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabList(BookingStatus.upcoming),
          _buildTabList(BookingStatus.completed),
          _buildTabList(BookingStatus.cancelled),
        ],
      ),
    );
  }
}
