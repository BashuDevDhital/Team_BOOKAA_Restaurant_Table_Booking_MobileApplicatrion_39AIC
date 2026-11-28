import 'package:flutter/material.dart';
import 'booking_details_screen.dart';

/// Colors used only by this screen.
class _C {
  static const cream = Color(0xFFFFFAF3);
  static const ink = Color(0xFF1B1B1F);
  static const muted = Color(0xFF6B6B76);
  static const accent = Color(0xFFC2410C); // use 0xFFF97316 for the brighter Figma orange
  static const border = Color(0xFFE9E3D8);
  static const green = Color(0xFF2F6B4F); // the tick
  static const greenSoft = Color(0xFFE3EFE8); // circle behind the tick
}

/// "You're all booked!" screen shown after the booking is confirmed.
class BookingConfirmedScreen extends StatelessWidget {
  final String restaurant;
  final String address;
  final String imageAsset;
  final DateTime date;
  final String time; // e.g. '7:00 PM'
  final int guests;
  final String bookingId; // e.g. 'BK-1024'

  /// Called when "View my booking" is tapped. If you leave it empty, the
  /// Booking details screen opens.
  final VoidCallback? onViewBooking;

  const BookingConfirmedScreen({
    super.key,
    required this.restaurant,
    required this.address,
    required this.imageAsset,
    required this.date,
    required this.time,
    required this.guests,
    required this.bookingId,
    this.onViewBooking,
  });

  static const _dayNames = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];
  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  String get _dateText =>
      '${_dayNames[date.weekday - 1]}, ${date.day} '
          '${_monthNames[date.month - 1]} ${date.year}';

  void _viewBooking(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingDetailsScreen(
          restaurant: restaurant,
          address: address,
          date: date,
          time: time,
          guests: guests,
          bookingId: bookingId,
        ),
      ),
    );
  }

  void _goHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.cream,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 16),
                child: Column(
                  children: [
                    _checkCircle(),
                    const SizedBox(height: 24),
                    const Text(
                      "You're all booked!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: _C.ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Good food and good company await.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: _C.muted),
                    ),
                    const SizedBox(height: 28),
                    _detailsCard(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: onViewBooking ?? () => _viewBooking(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _C.accent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      child: const Text('View my booking'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => _goHome(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: _C.ink,
                        side: const BorderSide(color: _C.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      child: const Text('Back to home'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Pieces ----------

  Widget _checkCircle() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.6, end: 1),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutBack,
      builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
      child: Container(
        width: 88,
        height: 88,
        decoration: const BoxDecoration(
          color: _C.greenSoft,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 44, color: _C.green),
      ),
    );
  }

  Widget _detailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _C.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF7A8F6E), Color(0xFF2F4A3A)],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _C.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      address,
                      style: const TextStyle(fontSize: 12, color: _C.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: _C.border),
          ),
          _infoRow(Icons.calendar_today_outlined, _dateText),
          const SizedBox(height: 14),
          _infoRow(Icons.schedule, time),
          const SizedBox(height: 14),
          _infoRow(Icons.group_outlined, guests == 1 ? '1 guest' : '$guests guests'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: _C.border),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'BOOKING ID',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: _C.muted,
                ),
              ),
              Text(
                bookingId,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _C.ink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _C.muted),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: _C.ink),
          ),
        ),
      ],
    );
  }
}