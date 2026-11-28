import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Widgets/app_theme.dart';
import 'bookings_page.dart';

class BookAgainPage extends StatefulWidget {
  final BookingItem previousBooking;
  final Function(BookingItem newBooking) onBookingCreated;

  const BookAgainPage({
    super.key,
    required this.previousBooking,
    required this.onBookingCreated,
  });

  @override
  State<BookAgainPage> createState() => _BookAgainPageState();
}

class _BookAgainPageState extends State<BookAgainPage> {
  late DateTime _selectedDate;
  String? _selectedTime;
  late int _guestsCount;
  final TextEditingController _specialRequestsController = TextEditingController();
  bool _repeatPreOrder = true;

  final List<Map<String, dynamic>> _timeSlots = [
    {'time': '12:00 PM', 'isFull': false},
    {'time': '1:00 PM', 'isFull': false},
    {'time': '2:30 PM', 'isFull': true},
    {'time': '6:00 PM', 'isFull': false},
    {'time': '7:00 PM', 'isFull': false},
    {'time': '8:00 PM', 'isFull': true},
    {'time': '9:00 PM', 'isFull': false},
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(const Duration(days: 1));
    _guestsCount = widget.previousBooking.guests;
    _selectedTime = '7:00 PM';
  }

  @override
  void dispose() {
    _specialRequestsController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }

  void _showSuccessDialog(BookingItem newBooking) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.moodSage,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.availabilityGreen,
                size: 56,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Booking Confirmed!',
              style: AppTheme.dmSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textCharcoal,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your table at ${newBooking.restaurantName} is reserved.',
              textAlign: TextAlign.center,
              style: AppTheme.inter(fontSize: 13, color: AppColors.mutedGray),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Booking ID', style: AppTheme.inter(fontSize: 12, color: AppColors.mutedGray)),
                      Text(newBooking.bookingId, style: AppTheme.inter(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.burntOrange)),
                    ],
                  ),
                  const Divider(height: 16, color: AppColors.inputBorder),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Date & Time', style: AppTheme.inter(fontSize: 12, color: AppColors.mutedGray)),
                      Text('${newBooking.date} @ ${newBooking.time}', style: AppTheme.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
                    ],
                  ),
                  const Divider(height: 16, color: AppColors.inputBorder),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Guests', style: AppTheme.inter(fontSize: 12, color: AppColors.mutedGray)),
                      Text('${newBooking.guests} Guests', style: AppTheme.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'View My Bookings',
              onPressed: () {
                Navigator.pop(ctx); // Close dialog
                Navigator.pop(context, newBooking); // Return to BookingsPage
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmBooking() {
    if (_selectedTime == null) return;
    HapticFeedback.mediumImpact();

    final newBookingId = 'BK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final newBooking = BookingItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      restaurantName: widget.previousBooking.restaurantName,
      location: widget.previousBooking.location,
      bookingId: newBookingId,
      date: _formatDate(_selectedDate),
      time: _selectedTime!,
      guests: _guestsCount,
      status: BookingStatus.upcoming,
    );

    widget.onBookingCreated(newBooking);
    _showSuccessDialog(newBooking);
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
              'BOOK AGAIN',
              style: AppTheme.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.burntOrange,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              widget.previousBooking.restaurantName,
              style: AppTheme.dmSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textCharcoal,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.softCreamCard,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.restaurant_rounded, color: AppColors.burntOrange, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.previousBooking.restaurantName,
                          style: AppTheme.dmSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textCharcoal),
                        ),
                        Text(
                          'Last visited: ${widget.previousBooking.date}',
                          style: AppTheme.inter(fontSize: 12, color: AppColors.mutedGray),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Date Picker Field
            Text('Select Date', style: AppTheme.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textCharcoal)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now().add(const Duration(days: 1)),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDate(_selectedDate), style: AppTheme.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textCharcoal)),
                    const Icon(Icons.calendar_month_rounded, color: AppColors.burntOrange),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Time Slots
            Text('Select Time Slot', style: AppTheme.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textCharcoal)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _timeSlots.map((slot) {
                final String time = slot['time'];
                final bool isFull = slot['isFull'];
                final bool isSelected = _selectedTime == time;

                return ChoiceChip(
                  label: Text(
                    isFull ? '$time (Full)' : time,
                    style: AppTheme.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isFull ? AppColors.mutedGray : AppColors.textCharcoal,
                    ),
                  ),
                  selected: isSelected && !isFull,
                  selectedColor: AppColors.primaryOrange,
                  backgroundColor: isFull ? AppColors.inputBorder.withValues(alpha: 0.5) : AppColors.white,
                  side: BorderSide(color: isSelected ? AppColors.primaryOrange : AppColors.inputBorder),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  onSelected: isFull
                      ? null
                      : (selected) {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedTime = time);
                        },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Guests Stepper
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Guests Count', style: AppTheme.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textCharcoal)),
                    Text('Suggested: Table for $_guestsCount', style: AppTheme.inter(fontSize: 12, color: AppColors.burntOrange)),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.softCreamCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: _guestsCount > 1
                            ? () {
                                HapticFeedback.selectionClick();
                                setState(() => _guestsCount--);
                              }
                            : null,
                      ),
                      Text(
                        '$_guestsCount',
                        style: AppTheme.dmSans(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.burntOrange),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: _guestsCount < 12
                            ? () {
                                HapticFeedback.selectionClick();
                                setState(() => _guestsCount++);
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Pre-order Checkbox
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              activeColor: AppColors.primaryOrange,
              title: Text('Repeat my previous pre-order', style: AppTheme.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textCharcoal)),
              subtitle: Text('Pork Bao Buns x 2, Ramen x 1 (Rs. 1,550)', style: AppTheme.inter(fontSize: 12, color: AppColors.mutedGray)),
              value: _repeatPreOrder,
              onChanged: (val) {
                HapticFeedback.selectionClick();
                setState(() => _repeatPreOrder = val ?? false);
              },
            ),
            const SizedBox(height: 16),

            // Special Requests Input
            Text('Special Requests (Optional)', style: AppTheme.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textCharcoal)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: TextField(
                controller: _specialRequestsController,
                maxLength: 150,
                maxLines: 3,
                style: AppTheme.inter(fontSize: 14, color: AppColors.textCharcoal),
                decoration: InputDecoration(
                  hintText: 'e.g. Quiet table, high chair needed...',
                  hintStyle: AppTheme.inter(fontSize: 14, color: AppColors.mutedGray),
                  contentPadding: const EdgeInsets.all(16),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.inputBorder)),
        ),
        child: PrimaryButton(
          label: 'Confirm Booking',
          onPressed: _selectedTime != null ? _confirmBooking : () {},
        ),
      ),
    );
  }
}
