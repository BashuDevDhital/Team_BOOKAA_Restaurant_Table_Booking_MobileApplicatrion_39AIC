import 'package:flutter/material.dart';
import 'dart:async';
import 'explore_screen.dart'; // gives us the `restaurants` list
import 'booking_confirmed_screen.dart';

/// Colors used only by this screen (kept private so they never clash
/// with the AppColors class in main.dart).
class _C {
  static const cream = Color(0xFFFFFAF3);
  static const ink = Color(0xFF1B1B1F);
  static const muted = Color(0xFF6B6B76);
  static const accent = Color(0xFFC2410C); // use 0xFFF97316 for the brighter Figma orange
  static const border = Color(0xFFE9E3D8);
  static const summaryBg = Color(0xFFFFF1E0);
}

class BookTableScreen extends StatefulWidget {
  /// The restaurant that was opened. The photos start on this one, and the
  /// name below changes as you swipe to another restaurant.
  final String restaurant;
  final String subtitle;
  final String imageAsset;

  const BookTableScreen({
    super.key,
    this.restaurant = 'The Olive Room',
    this.subtitle = 'Italian · City Centre',
    this.imageAsset = 'assets/images/img.png',
  });

  @override
  State<BookTableScreen> createState() => _BookTableScreenState();
}

class _BookTableScreenState extends State<BookTableScreen> {
  static const _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  static const _times = [
    '6:00 PM', '6:30 PM', '7:00 PM', '7:30 PM', '8:00 PM', '8:30 PM'
  ];

  late final PageController _pageController;
  int _restaurantIndex = 0;
  Timer? _autoSlideTimer;

  late final List<DateTime> _dates;
  int _dateIndex = 0;
  int _guests = 2;
  int _timeIndex = 2;

  // The restaurant currently shown in the photos.
  Restaurant get _current => restaurants[_restaurantIndex];

  @override
  void initState() {
    super.initState();

    // Start on the restaurant that was opened from the Explore screen.
    final start = restaurants.indexWhere((r) => r.name == widget.restaurant);
    _restaurantIndex = start == -1 ? 0 : start;
    _pageController = PageController(initialPage: _restaurantIndex);
    _startAutoSlide();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _dates = List.generate(5, (i) => today.add(Duration(days: i)));
  }

  /// Moves to the next restaurant every 3 seconds. Calling this again
  /// restarts the 3-second countdown (used when the user swipes).
  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_pageController.hasClients) return;
      final next = (_restaurantIndex + 1) % restaurants.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  DateTime get _selectedDate => _dates[_dateIndex];

  String get _summary {
    final d = _selectedDate;
    final month = _monthNames[d.month - 1].substring(0, 3);
    final guests = _guests == 1 ? '1 guest' : '$_guests guests';
    return '${_dayNames[d.weekday - 1]}, ${d.day} $month · '
        '${_times[_timeIndex]} · $guests';
  }

  void _confirm() {
    // TODO: send the booking to your backend / database here.
    final r = _current;
    final bookingId = 'BK-${1000 + DateTime.now().millisecondsSinceEpoch % 9000}';

    // pushReplacement: pressing Back on the confirmation goes to Explore,
    // not back into the booking form.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BookingConfirmedScreen(
          restaurant: r.name,
          address: r.address,
          imageAsset: r.imageAsset,
          date: _selectedDate,
          time: _times[_timeIndex],
          guests: _guests,
          bookingId: bookingId,
        ),
      ),
    );
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Photo goes edge to edge (full screen width).
                    _photoCarousel(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _restaurantRow(),
                          const SizedBox(height: 24),
                          _dateSection(),
                          const SizedBox(height: 20),
                          _guestsRow(),
                          const SizedBox(height: 24),
                          _timeSection(),
                          const SizedBox(height: 20),
                          _summaryCard(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _confirm,
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
                  child: const Text('Confirm booking'),
                ),
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
            'Book a table',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: _C.ink),
          ),
        ],
      ),
    );
  }

  /// Big swipeable photos. The name below follows the photo you are on.
  Widget _photoCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 240,
          // Touching the photo restarts the 3-second timer, so it does not
          // jump away right after you swipe.
          child: Listener(
            onPointerDown: (_) => _startAutoSlide(),
            child: PageView.builder(
              controller: _pageController,
              itemCount: restaurants.length,
              onPageChanged: (i) => setState(() => _restaurantIndex = i),
              itemBuilder: (context, i) {
                return Image.asset(
                  restaurants[i].imageAsset,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: const Text('Image not found'),
                    );
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            restaurants.length,
                (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _restaurantIndex == i ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color:
                _restaurantIndex == i ? _C.accent : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _restaurantRow() {
    final r = _current;
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 56,
            height: 56,
            child: Image.asset(
              r.imageAsset,
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
                r.name,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w600, color: _C.ink),
              ),
              const SizedBox(height: 2),
              Text(
                '${r.cuisine} · ${r.area}',
                style: const TextStyle(fontSize: 13, color: _C.muted),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String text) => Text(
    text,
    style: const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: _C.ink),
  );

  Widget _dateSection() {
    final d = _selectedDate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionTitle('Choose a date'),
            Text(
              '${_monthNames[d.month - 1]} ${d.year}',
              style: const TextStyle(fontSize: 12, color: _C.muted),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (int i = 0; i < _dates.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(child: _dateChip(i)),
            ],
          ],
        ),
      ],
    );
  }

  Widget _dateChip(int i) {
    final d = _dates[i];
    final selected = i == _dateIndex;
    return Material(
      color: selected ? _C.ink : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => _dateIndex = i),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: selected ? _C.ink : _C.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _dayNames[d.weekday - 1],
                style: TextStyle(
                    fontSize: 12,
                    color: selected ? Colors.white70 : _C.muted),
              ),
              const SizedBox(height: 4),
              Text(
                '${d.day}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : _C.ink),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _guestsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _sectionTitle('Guests'),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _C.border),
          ),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Fewer guests',
                onPressed:
                _guests > 1 ? () => setState(() => _guests--) : null,
                icon: const Icon(Icons.remove, size: 20),
                color: _C.ink,
              ),
              SizedBox(
                width: 28,
                child: Text(
                  '$_guests',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _C.ink),
                ),
              ),
              IconButton(
                tooltip: 'More guests',
                onPressed:
                _guests < 10 ? () => setState(() => _guests++) : null,
                icon: const Icon(Icons.add, size: 20),
                color: _C.ink,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _timeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Choose a time'),
        const SizedBox(height: 4),
        Text(
          'Available times for $_guests ${_guests == 1 ? 'guest' : 'guests'}',
          style: const TextStyle(fontSize: 12, color: _C.muted),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.5,
          children: [
            for (int i = 0; i < _times.length; i++) _timeChip(i),
          ],
        ),
      ],
    );
  }

  Widget _timeChip(int i) {
    final selected = i == _timeIndex;
    return Material(
      color: selected ? _C.accent : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _timeIndex = i),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? _C.accent : _C.border),
          ),
          child: Text(
            _times[i],
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : _C.ink,
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _C.summaryBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your table',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: _C.accent),
          ),
          const SizedBox(height: 4),
          Text(
            _summary,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: _C.ink),
          ),
        ],
      ),
    );
  }
}