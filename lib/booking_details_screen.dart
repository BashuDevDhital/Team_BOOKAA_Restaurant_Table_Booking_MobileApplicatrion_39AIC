import 'package:flutter/material.dart';

/// Colors used only by this screen.
class _C {
  static const cream = Color(0xFFFFFAF3);
  static const ink = Color(0xFF1B1B1F);
  static const muted = Color(0xFF6B6B76);
  static const accent = Color(0xFFC2410C); // use 0xFFF97316 for the brighter Figma orange
  static const border = Color(0xFFE9E3D8);
  static const green = Color(0xFF2F6B4F);
  static const greenSoft = Color(0xFFE3EFE8);
  static const noteBg = Color(0xFFFFF1E0);
}

/// "Booking details" screen: one booking with its date, time, guests and ID.
class BookingDetailsScreen extends StatelessWidget {
  final String restaurant;
  final String address;
  final DateTime date;
  final String time; // e.g. '7:00 PM'
  final int guests;
  final String bookingId; // e.g. 'BK-1024'
  final String status; // e.g. 'Confirmed'

  const BookingDetailsScreen({
    super.key,
    required this.restaurant,
    required this.address,
    required this.date,
    required this.time,
    required this.guests,
    required this.bookingId,
    this.status = 'Confirmed',
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

  /// Asks "are you sure?" and, if yes, goes back to the first screen.
  Future<void> _askCancel(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Cancel this booking?',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: _C.ink),
        ),
        content: Text(
          '$restaurant\n$_dateText · $time',
          style: const TextStyle(fontSize: 14, height: 1.5, color: _C.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep booking',
                style: TextStyle(color: _C.ink)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cancel booking',
                style: TextStyle(
                    color: _C.accent, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (yes == true) {
      // TODO: tell your backend / database that this booking is cancelled.
      navigator.popUntil((route) => route.isFirst);
      messenger.showSnackBar(
        const SnackBar(content: Text('Your booking was cancelled.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.cream,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _statusPill(),
                    const SizedBox(height: 14),
                    Text(
                      restaurant,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: _C.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address,
                      style: const TextStyle(fontSize: 13, color: _C.muted),
                    ),
                    const _Line(),
                    _infoRow(Icons.calendar_today_outlined, 'DATE', _dateText),
                    const SizedBox(height: 18),
                    _infoRow(Icons.schedule, 'TIME', time),
                    const SizedBox(height: 18),
                    _infoRow(Icons.group_outlined, 'PARTY SIZE',
                        guests == 1 ? '1 guest' : '$guests guests'),
                    const _Line(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Booking ID',
                          style: TextStyle(fontSize: 13, color: _C.muted),
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
                    const SizedBox(height: 24),
                    _expectedNote(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => _askCancel(context),
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
                      child: const Text('Cancel booking'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'You can cancel before your booked time.',
                    style: TextStyle(fontSize: 11, color: _C.muted),
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

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.chevron_left, color: _C.ink, size: 28),
          ),
          const Text(
            'Booking details',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: _C.ink),
          ),
        ],
      ),
    );
  }

  Widget _statusPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _C.greenSoft,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        status,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _C.green,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: _C.muted),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: _C.muted,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _C.ink,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _expectedNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _C.noteBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "You're expected.",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _C.ink,
            ),
          ),
          SizedBox(height: 3),
          Text(
            'Please show this booking when you arrive.',
            style: TextStyle(fontSize: 12, color: _C.muted),
          ),
        ],
      ),
    );
  }
}

/// A thin divider line with space around it.
class _Line extends StatelessWidget {
  const _Line();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 18),
      child: Divider(height: 1, color: _C.border),
    );
  }
}