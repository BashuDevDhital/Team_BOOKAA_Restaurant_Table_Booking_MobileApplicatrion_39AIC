import 'package:flutter/material.dart';
import 'book_table_screen.dart';
import 'explore_screen.dart';

void main() => runApp(const BookingApp());

/// ---------- Theme ----------
class AppColors {
  static const cream = Color(0xFFFFFAF3);
  static const ink = Color(0xFF1B1B1F);
  static const muted = Color(0xFF6B6B76);
  static const accent = Color(0xFFC2410C);
  static const border = Color(0xFFE9E3D8);
  static const track = Color(0xFFEFEBE3);
  static const confirmedBg = Color(0xFFE3EFE8);
  static const confirmedFg = Color(0xFF2F6B4F);
  static const completedBg = Color(0xFFEDEDF0);
  static const completedFg = Color(0xFF4A4A55);
}

class BookingApp extends StatelessWidget {
  const BookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bookings',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.cream,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent),
        // Tip: add google_fonts and set fontFamily to Inter for an exact match.
      ),
      home: const HomeShell(),
    );
  }
}

/// ---------- Model ----------
enum BookingStatus { confirmed, completed }

class Booking {
  final String restaurant;
  final String imageAsset;
  final BookingStatus status;
  final DateTime dateTime;
  final int guests;
  final String reference;

  const Booking({
    required this.restaurant,
    required this.imageAsset,
    required this.status,
    required this.dateTime,
    required this.guests,
    required this.reference,
  });

  bool get isUpcoming => status == BookingStatus.confirmed;
}

final List<Booking> sampleBookings = [
  Booking(
    restaurant: 'The Olive Room',
    imageAsset: 'assets/images/img.png',
    status: BookingStatus.confirmed,
    dateTime: DateTime(2026, 11, 27, 19, 0),
    guests: 2,
    reference: 'BK-1024',
  ),
  Booking(
    restaurant: 'Caravan Bankside',
    imageAsset: 'assets/images/img_1.png',
    status: BookingStatus.completed,
    dateTime: DateTime(2026, 10, 12, 20, 15),
    guests: 4,
    reference: 'BK-0987',
  ),
];

String formatDateTime(DateTime d) {
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  final hour12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final minute = d.minute.toString().padLeft(2, '0');
  final suffix = d.hour >= 12 ? 'PM' : 'AM';
  return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year}'
      ' · $hour12:$minute $suffix';
}

/// ---------- Shell with bottom navigation ----------
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0; // Bookings tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _index,
          children: const [
            ExploreScreen(),
            MyBookingsScreen(),
            Center(child: Text('Profile')),
          ],


        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Colors.transparent,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? AppColors.accent : AppColors.muted,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return IconThemeData(
              color: selected ? AppColors.accent : AppColors.muted,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_outlined), label: 'Explore'),
            NavigationDestination(
                icon: Icon(Icons.event_available_outlined), label: 'Bookings'),
            NavigationDestination(
                icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

/// ---------- My bookings screen ----------
class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  bool _showUpcoming = true;

  @override
  Widget build(BuildContext context) {
    final items =
    sampleBookings.where((b) => b.isUpcoming == _showUpcoming).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      children: [
        const Text(
          'My bookings',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Good plans, all in one place.',
          style: TextStyle(fontSize: 14, color: AppColors.muted),
        ),
        const SizedBox(height: 20),
        SegmentToggle(
          leftLabel: 'Upcoming',
          rightLabel: 'Past',
          leftSelected: _showUpcoming,
          onChanged: (left) => setState(() => _showUpcoming = left),
        ),
        const SizedBox(height: 20),
        for (final b in items) ...[
          BookingCard(
            booking: b,
            onTap: () {
              // TODO: navigate to booking details
            },
          ),
          const SizedBox(height: 16),
        ],
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text('No bookings here yet.',
                  style: TextStyle(color: AppColors.muted)),
            ),
          ),
        const SizedBox(height: 8),
        const Text(
          'Your next great meal is on the calendar.',
          style: TextStyle(fontSize: 13, color: AppColors.muted),
        ),
      ],
    );
  }
}

/// ---------- Segmented toggle (Upcoming / Past) ----------
class SegmentToggle extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final bool leftSelected;
  final ValueChanged<bool> onChanged;

  const SegmentToggle({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.leftSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.track,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _segment(leftLabel, leftSelected, () => onChanged(true)),
          _segment(rightLabel, !leftSelected, () => onChanged(false)),
        ],
      ),
    );
  }

  Widget _segment(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: selected
                ? const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              )
            ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.ink : AppColors.muted,
            ),
          ),
        ),
      ),
    );
  }
}

/// ---------- Booking card ----------
class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onTap;

  const BookingCard({super.key, required this.booking, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 130,
                width: double.infinity,
                child: Image.asset(
                  booking.imageAsset,
                  fit: BoxFit.cover,
                  // Shows a gradient if the image asset is missing.
                  errorBuilder: (_, __, ___) => const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF7A8F6E), Color(0xFF2F4A3A)],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.restaurant,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 10),
                    StatusPill(status: booking.status),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formatDateTime(booking.dateTime),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${booking.guests} guests · ${booking.reference}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            color: AppColors.ink),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------- Status pill ----------
class StatusPill extends StatelessWidget {
  final BookingStatus status;

  const StatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final confirmed = status == BookingStatus.confirmed;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
      decoration: BoxDecoration(
        color: confirmed ? AppColors.confirmedBg : AppColors.completedBg,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        confirmed ? 'Confirmed' : 'Completed',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: confirmed ? AppColors.confirmedFg : AppColors.completedFg,
        ),
      ),
    );
  }
}