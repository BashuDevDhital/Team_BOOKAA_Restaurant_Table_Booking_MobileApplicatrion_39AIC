import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Widgets/app_theme.dart';
import 'bookings_page.dart';
import 'directions_sheet.dart';

class BookingDetailsPage extends StatefulWidget {
  final BookingItem booking;
  final Function(BookingItem updatedBooking) onBookingUpdated;
  final VoidCallback onBookingCancelled;

  const BookingDetailsPage({
    super.key,
    required this.booking,
    required this.onBookingUpdated,
    required this.onBookingCancelled,
  });

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  late BookingItem _booking;

  @override
  void initState() {
    super.initState();
    _booking = widget.booking;
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

  void _openEditBookingModal() {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 2));
    String selectedTime = _booking.time;
    int guestsCount = _booking.guests;

    final timeSlots = ['12:00 PM', '1:00 PM', '6:00 PM', '7:00 PM', '8:00 PM', '9:00 PM'];

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
                    'Edit Booking',
                    style: AppTheme.dmSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textCharcoal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _booking.restaurantName,
                    style: AppTheme.inter(
                      fontSize: 14,
                      color: AppColors.burntOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Date Picker Tile
                  Text(
                    'Select Date',
                    style: AppTheme.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textCharcoal),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                      );
                      if (picked != null) {
                        setModalState(() {
                          selectedDate = picked;
                        });
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
                          Text(
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                            style: AppTheme.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textCharcoal),
                          ),
                          const Icon(Icons.calendar_month_rounded, color: AppColors.burntOrange),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Time Slots
                  Text(
                    'Select Time Slot',
                    style: AppTheme.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textCharcoal),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: timeSlots.map((slot) {
                      final isSelected = selectedTime == slot;
                      return ChoiceChip(
                        label: Text(slot, style: AppTheme.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                        selected: isSelected,
                        selectedColor: AppColors.primaryOrange,
                        backgroundColor: AppColors.white,
                        side: BorderSide(color: isSelected ? AppColors.primaryOrange : AppColors.inputBorder),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        onSelected: (selected) {
                          HapticFeedback.selectionClick();
                          setModalState(() => selectedTime = slot);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Guests Stepper
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Guests Count',
                        style: AppTheme.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textCharcoal),
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
                              onPressed: guestsCount > 1
                                  ? () {
                                      HapticFeedback.selectionClick();
                                      setModalState(() => guestsCount--);
                                    }
                                  : null,
                            ),
                            Text(
                              '$guestsCount',
                              style: AppTheme.dmSans(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.burntOrange),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: guestsCount < 12
                                  ? () {
                                      HapticFeedback.selectionClick();
                                      setModalState(() => guestsCount++);
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  PrimaryButton(
                    label: 'Save Changes',
                    onPressed: () {
                      final dateStr = '${_getMonthName(selectedDate.month)} ${selectedDate.day.toString().padLeft(2, '0')}, ${selectedDate.year}';
                      setState(() {
                        _booking = BookingItem(
                          id: _booking.id,
                          restaurantName: _booking.restaurantName,
                          location: _booking.location,
                          bookingId: _booking.bookingId,
                          date: dateStr,
                          time: selectedTime,
                          guests: guestsCount,
                          status: _booking.status,
                        );
                      });
                      widget.onBookingUpdated(_booking);
                      Navigator.pop(ctx);
                      _showSnackBar('Booking updated');
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  void _openDirectionsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DirectionsSheet(
        restaurantName: _booking.restaurantName,
        location: _booking.location,
      ),
    );
  }

  Widget _buildQrCodeGrid() {
    return Container(
      width: 140,
      height: 140,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder, width: 2),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
        ),
        itemCount: 49,
        itemBuilder: (context, index) {
          final isBlack = (index * 7 + index % 3) % 2 == 0 || index < 7 || index % 7 == 0 || index > 42;
          return Container(
            decoration: BoxDecoration(
              color: isBlack ? AppColors.textCharcoal : AppColors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        },
      ),
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
          onPressed: () => Navigator.pop(context, _booking),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BOOKING DETAILS',
              style: AppTheme.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.burntOrange,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              _booking.restaurantName,
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
          children: [
            // Status Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.moodSage,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.availabilityGreen.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.availabilityGreen, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reservation Confirmed',
                          style: AppTheme.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.availabilityGreen),
                        ),
                        Text(
                          'Booking ID: ${_booking.bookingId}',
                          style: AppTheme.inter(fontSize: 12, color: AppColors.textCharcoal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.calendar_today_rounded, 'Date', _booking.date),
                  const Divider(height: 20, color: AppColors.inputBorder),
                  _buildInfoRow(Icons.access_time_rounded, 'Time', _booking.time),
                  const Divider(height: 20, color: AppColors.inputBorder),
                  _buildInfoRow(Icons.person_outline_rounded, 'Guests', '${_booking.guests} Guests'),
                  const Divider(height: 20, color: AppColors.inputBorder),
                  _buildInfoRow(Icons.table_restaurant_rounded, 'Assigned Table', 'Table T-07'),
                  const Divider(height: 20, color: AppColors.inputBorder),
                  _buildInfoRow(Icons.location_on_outlined, 'Location', _booking.location),
                  const Divider(height: 20, color: AppColors.inputBorder),
                  _buildInfoRow(Icons.event_note_rounded, 'Booked On', 'Nov 22, 2026'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Show at Restaurant QR Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Column(
                children: [
                  Text(
                    'Show at the restaurant',
                    style: AppTheme.dmSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textCharcoal),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Present this QR code to the host upon arrival',
                    style: AppTheme.inter(fontSize: 12, color: AppColors.mutedGray),
                  ),
                  const SizedBox(height: 16),
                  _buildQrCodeGrid(),
                  const SizedBox(height: 12),
                  Text(
                    _booking.bookingId,
                    style: AppTheme.inter(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.burntOrange, letterSpacing: 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Pre-ordered food card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pre-ordered Items',
                    style: AppTheme.dmSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textCharcoal),
                  ),
                  const SizedBox(height: 12),
                  _buildFoodRow('Pork Bao Buns x 2', 'Rs. 700'),
                  const SizedBox(height: 8),
                  _buildFoodRow('Chicken Tonkotsu Ramen x 1', 'Rs. 850'),
                  const Divider(height: 20, color: AppColors.inputBorder),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Paid', style: AppTheme.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
                      Text('Rs. 1,550', style: AppTheme.dmSans(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.burntOrange)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Special Requests Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Special Request',
                    style: AppTheme.dmSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textCharcoal),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Window seat preferred if available.',
                    style: AppTheme.inter(fontSize: 14, color: AppColors.mutedGray),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _openEditBookingModal,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.inputBorder),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('Edit Booking', style: AppTheme.inter(fontWeight: FontWeight.w600, color: AppColors.textCharcoal)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _openDirectionsModal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('Directions', style: AppTheme.inter(fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.burntOrange),
        const SizedBox(width: 12),
        Text(label, style: AppTheme.inter(fontSize: 14, color: AppColors.mutedGray)),
        const Spacer(),
        Text(value, style: AppTheme.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
      ],
    );
  }

  Widget _buildFoodRow(String item, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(item, style: AppTheme.inter(fontSize: 13, color: AppColors.textCharcoal)),
        Text(price, style: AppTheme.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textCharcoal)),
      ],
    );
  }
}
