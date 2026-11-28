import 'package:flutter/material.dart';
import 'book_table_screen.dart';
import 'dart:async';

/// Change this one line to switch the currency symbol everywhere.
const String currency = '\$';

class _C {
  static const cream = Color(0xFFFFFAF3);
  static const ink = Color(0xFF1B1B1F);
  static const muted = Color(0xFF6B6B76);
  static const accent = Color(0xFFC2410C);
  static const border = Color(0xFFE9E3D8);
  static const open = Color(0xFF2F6B4F);
  static const badge = Color(0xFFFFF1E0);
}

// ---------------------------------------------------------------------------
// DATA  (edit names, dishes, prices and image paths here)
//
// Every dish has an image path as its 4th value:
//   MenuItem('Name', 'Description', price, 'assets/images/file.png')
// Put the photo in assets/images/ with exactly that file name, or change the
// path to the name of your own photo.
// ---------------------------------------------------------------------------

class MenuItem {
  final String name;
  final String description;
  final double price;
  final String imageAsset;

  const MenuItem(this.name, this.description, this.price, this.imageAsset);
}

class MenuSection {
  final String title;
  final List<MenuItem> items;

  const MenuSection(this.title, this.items);
}

class Restaurant {
  final String name;
  final String tag; // small orange label above the name
  final String cuisine;
  final String area;
  final String address;
  final String hours;
  final String tagline;
  final String speciality; // what the restaurant is known for
  final String description;
  final String imageAsset; // big photo at the top
  final Color tint; // only used if the big photo fails to load
  final List<MenuItem> specials;
  final List<MenuSection> menu;

  const Restaurant({
    required this.name,
    required this.tag,
    required this.cuisine,
    required this.area,
    required this.address,
    required this.hours,
    required this.tagline,
    required this.speciality,
    required this.description,
    required this.imageAsset,
    required this.tint,
    required this.specials,
    required this.menu,
  });
}

const List<Restaurant> restaurants = [
  // ------------------------------------------------------------ Olive Room
  Restaurant(
    name: 'The Olive Room',
    tag: 'ITALIAN · CASUAL DINING',
    cuisine: 'Italian',
    area: 'City Centre',
    address: '24 Park Street, City Centre',
    hours: 'Open today · 12:00 PM – 10:00 PM',
    tagline: 'A little taste of Italy',
    speciality: 'Handmade pasta & wood-fired pizza',
    description:
    'Seasonal Italian plates, warm interiors and good company. A welcoming '
        'spot for your next lunch, catch-up or evening out.',
    tint: Color(0xFF5B6E4F),
    imageAsset: 'assets/images/img.png',
    specials: [
      MenuItem('Truffle Tagliatelle', 'Fresh pasta, black truffle', 18.50,
          'assets/images/img_7.png'),
      MenuItem('Wood-fired Margherita', 'San Marzano, fior di latte', 14.00,
          'assets/images/img_8.png'),
      MenuItem('Tiramisu', 'Classic, made daily', 7.50,
          'assets/images/img_9.png'),
    ],
    menu: [
      MenuSection('Starters', [
        MenuItem('Burrata & Tomato', 'Creamy burrata, heirloom tomato, basil',
            9.00, 'assets/images/img_9.png'),
        MenuItem('Bruschetta', 'Grilled sourdough, garlic, olive oil', 7.00,
            'assets/images/img_8.png'),
      ]),
      MenuSection('Mains', [
        MenuItem('Truffle Tagliatelle', 'Fresh pasta, black truffle', 18.50,
            'assets/images/img_7.png'),
        MenuItem('Osso Buco', 'Slow-braised veal, saffron risotto', 24.00,
            'assets/images/img_18.png'),
        MenuItem('Wood-fired Margherita', 'San Marzano, fior di latte', 14.00,
            'assets/images/img_8.png'),
      ]),
      MenuSection('Desserts', [
        MenuItem('Tiramisu', 'Classic, made daily', 7.50,
            'assets/images/img_9.png'),
        MenuItem('Panna Cotta', 'Vanilla, seasonal berries', 6.50,
            'assets/images/img_15.png'),
      ]),
    ],
  ),

  // ----------------------------------------------------------- Basil Garden
  Restaurant(
    name: 'The Basil Garden',
    tag: 'PLANT-BASED · GARDEN DINING',
    cuisine: 'Plant-based',
    area: 'Old Town',
    address: '12 Garden Lane, Old Town',
    hours: 'Open today · 11:00 AM – 9:30 PM',
    tagline: 'Fresh, green and seasonal',
    speciality: 'Seasonal plant-based cooking',
    description:
    'A bright courtyard restaurant where the menu follows the seasons. '
        'Vegetables, herbs and grains take the lead in every dish.',
    tint: Color(0xFF3F7D4E),
    imageAsset: 'assets/images/img_2.png',
    specials: [
      MenuItem('Pesto Gnocchi', 'Basil pesto, pine nuts', 14.50,
          'assets/images/img_10.png'),
      MenuItem('Roasted Beet Salad', 'Goat cheese, walnuts', 11.00,
          'assets/images/img_11.png'),
      MenuItem('Mushroom Risotto', 'Wild mushrooms, thyme', 15.50,
          'assets/images/img_12.png'),
    ],
    menu: [
      MenuSection('Small plates', [
        MenuItem('Whipped Feta & Herbs', 'Warm flatbread', 8.00,
            'assets/images/img_18.png'),
        MenuItem('Grilled Sweetcorn', 'Chilli butter, lime', 7.00,
            'assets/images/img_19.png'),
      ]),
      MenuSection('Mains', [
        MenuItem('Pesto Gnocchi', 'Basil pesto, pine nuts', 14.50,
            'assets/images/img_10.png'),
        MenuItem('Mushroom Risotto', 'Wild mushrooms, thyme', 15.50,
            'assets/images/img_12.png'),
        MenuItem('Harvest Bowl', 'Grains, roasted veg, tahini', 13.50,
            'assets/images/img_15.png'),
      ]),
      MenuSection('Desserts', [
        MenuItem('Lemon & Basil Sorbet', 'Light and fresh', 5.50,
            'assets/images/img_21.png'),
        MenuItem('Chocolate Avocado Mousse', 'Dairy-free', 6.50,
            'assets/images/img_9.png'),
      ]),
    ],
  ),

  // ----------------------------------------------------------- Copper Spoon
  Restaurant(
    name: 'The Copper Spoon',
    tag: 'BRITISH · MODERN COMFORT FOOD',
    cuisine: 'British',
    area: 'Market Square',
    address: '5 Market Square',
    hours: 'Open today · 10:00 AM – 10:30 PM',
    tagline: 'Comfort food, done properly',
    speciality: 'Sunday roast & hearty comfort food',
    description:
    'Generous, honest British cooking in a cosy room with an open kitchen. '
        'Perfect for long lunches and cold evenings.',
    tint: Color(0xFF8A5A2F),
    imageAsset: 'assets/images/img_3.png',
    specials: [
      MenuItem('Sunday Roast', 'Roast beef, Yorkshire pudding', 19.50,
          'assets/images/img_13.png'),
      MenuItem('Fish & Chips', 'Beer-battered cod, mushy peas', 16.00,
          'assets/images/img_14.png'),
      MenuItem('Sticky Toffee Pudding', 'Toffee sauce, vanilla ice cream', 7.00,
          'assets/images/img_15.png'),
    ],
    menu: [
      MenuSection('Starters', [
        MenuItem('Tomato Soup', 'Cheddar toastie soldiers', 7.50,
            'assets/images/img_16.png'),
        MenuItem('Scotch Egg', 'Piccalilli', 8.00,
            'assets/images/img_17.png'),
      ]),
      MenuSection('Mains', [
        MenuItem('Sunday Roast', 'Roast beef, Yorkshire pudding', 19.50,
            'assets/images/img_13.png'),
        MenuItem('Fish & Chips', 'Beer-battered cod, mushy peas', 16.00,
            'assets/images/img_14.png'),
        MenuItem('Steak & Ale Pie', 'Mash, gravy, greens', 17.50,
            'assets/images/img_15.png'),
      ]),
      MenuSection('Desserts', [
        MenuItem('Sticky Toffee Pudding', 'Toffee sauce, vanilla ice cream',
            7.00, 'assets/images/img_9.png'),
        MenuItem('Apple Crumble', 'Custard', 6.50,
            'assets/images/img_21.png'),
      ]),
    ],
  ),

  // ------------------------------------------------------------ Golden Fig
  Restaurant(
    name: 'The Golden Fig',
    tag: 'MEDITERRANEAN · MEZZE & GRILL',
    cuisine: 'Mediterranean',
    area: 'Harbour Road',
    address: '31 Harbour Road',
    hours: 'Open today · 12:00 PM – 11:00 PM',
    tagline: 'Sharing plates by the sea',
    speciality: 'Mezze sharing plates & charcoal grill',
    description:
    'Colourful mezze, charcoal-grilled meats and warm bread, made for '
        'sharing. A relaxed spot near the harbour.',
    tint: Color(0xFFB07A1F),
    imageAsset: 'assets/images/img_4.png',
    specials: [
      MenuItem('Mixed Mezze Platter', 'Hummus, falafel, dolmades', 18.00,
          'assets/images/img_18.png'),
      MenuItem('Lamb Souvlaki', 'Charcoal grilled, tzatziki', 19.50,
          'assets/images/img_19.png'),
      MenuItem('Baklava', 'Honey, pistachio, filo', 6.50,
          'assets/images/img_20.png'),
    ],
    menu: [
      MenuSection('Mezze', [
        MenuItem('Hummus & Warm Pita', 'Olive oil, paprika', 6.50,
            'assets/images/img_14.png'),
        MenuItem('Falafel', 'Tahini, pickles', 7.50,
            'assets/images/img_19.png'),
        MenuItem('Grilled Halloumi', 'Honey, thyme', 8.00,
            'assets/images/img_20.png'),
      ]),
      MenuSection('From the grill', [
        MenuItem('Lamb Souvlaki', 'Charcoal grilled, tzatziki', 19.50,
            'assets/images/img_19.png'),
        MenuItem('Grilled Sea Bream', 'Lemon, oregano', 21.00,
            'assets/images/img_17.png'),
      ]),
      MenuSection('Desserts', [
        MenuItem('Baklava', 'Honey, pistachio, filo', 6.50,
            'assets/images/img_20.png'),
        MenuItem('Yoghurt & Honey', 'Walnuts', 5.50,
            'assets/images/img_21.png'),
      ]),
    ],
  ),

  // ------------------------------------------------------- Rosemary Kitchen
  Restaurant(
    name: 'The Rosemary Kitchen',
    tag: 'FRENCH · BISTRO',
    cuisine: 'French',
    area: 'Old Quarter',
    address: '9 Hill Street, Old Quarter',
    hours: 'Open today · 5:00 PM – 11:00 PM',
    tagline: 'A corner of Paris',
    speciality: 'Classic, slow-cooked French bistro dishes',
    description:
    'Candlelit tables, a short wine list and slow-cooked French classics. '
        'A romantic choice for dinner.',
    tint: Color(0xFF6B4E71),
    imageAsset: 'assets/images/img_5.png',
    specials: [
      MenuItem('Coq au Vin', 'Red wine, mushrooms, lardons', 21.00,
          'assets/images/img_12.png'),
      MenuItem('French Onion Soup', 'Gruyère croûton', 9.50,
          'assets/images/img_14.png'),
      MenuItem('Crème Brûlée', 'Vanilla bean', 7.50,
          'assets/images/img_18.png'),
    ],
    menu: [
      MenuSection('Starters', [
        MenuItem('French Onion Soup', 'Gruyère croûton', 9.50,
            'assets/images/img_14.png'),
        MenuItem('Escargots', 'Garlic and parsley butter', 11.00,
            'assets/images/img_21.png'),
      ]),
      MenuSection('Mains', [
        MenuItem('Coq au Vin', 'Red wine, mushrooms, lardons', 21.00,
            'assets/images/img_12.png'),
        MenuItem('Steak Frites', 'Peppercorn sauce', 26.00,
            'assets/images/img_19.png'),
        MenuItem('Ratatouille Tart', 'Provençal vegetables', 16.00,
            'assets/images/img_9.png'),
      ]),
      MenuSection('Desserts', [
        MenuItem('Crème Brûlée', 'Vanilla bean', 7.50,
            'assets/images/img_18.png'),
        MenuItem('Tarte Tatin', 'Caramelised apple', 8.00,
            'assets/images/img_21.png'),
      ]),
    ],
  ),

  // ----------------------------------------------------------- Blue Lantern
  Restaurant(
    name: 'The Blue Lantern',
    tag: 'ASIAN FUSION · NOODLES & DUMPLINGS',
    cuisine: 'Asian fusion',
    area: 'Night Market',
    address: '16 Lantern Street, Night Market',
    hours: 'Open today · 4:00 PM – 12:00 AM',
    tagline: 'Street-food flavours after dark',
    speciality: 'Noodles & dumplings, made to order',
    description:
    'A lively late-night spot under paper lanterns. Hand-pulled noodles, '
        'steaming dumplings and bold street-food flavours.',
    tint: Color(0xFF245A78),
    imageAsset: 'assets/images/img_6.png',
    specials: [
      MenuItem('Dan Dan Noodles', 'Chilli oil, minced pork', 13.50,
          'assets/images/img_7.png'),
      MenuItem('Pork & Chive Dumplings', 'Pan-fried, black vinegar', 9.50,
          'assets/images/img_14.png'),
      MenuItem('Mango Sticky Rice', 'Coconut cream', 7.00,
          'assets/images/img_16.png'),
    ],
    menu: [
      MenuSection('Small plates', [
        MenuItem('Pork & Chive Dumplings', 'Pan-fried, black vinegar', 9.50,
            'assets/images/img_14.png'),
        MenuItem('Crispy Spring Rolls', 'Sweet chilli dip', 7.50,
            'assets/images/img_9.png'),
      ]),
      MenuSection('Noodles & rice', [
        MenuItem('Dan Dan Noodles', 'Chilli oil, minced pork', 13.50,
            'assets/images/img_7.png'),
        MenuItem('Pad Thai', 'Prawns, peanuts, lime', 14.50,
            'assets/images/img_18.png'),
        MenuItem('Egg Fried Rice', 'Spring onion, soy', 9.00,
            'assets/images/img_16.png'),
      ]),
      MenuSection('Desserts', [
        MenuItem('Mango Sticky Rice', 'Coconut cream', 7.00,
            'assets/images/img_16.png'),
        MenuItem('Mochi Ice Cream', 'Three flavours', 6.50,
            'assets/images/img_21.png'),
      ]),
    ],
  ),
];

// ---------------------------------------------------------------------------
// SCREEN: swipe the top image to change the restaurant
// ---------------------------------------------------------------------------

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final PageController _controller = PageController();
  final ScrollController _scroll = ScrollController();
  int _index = 0;

  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();

    _autoSlideTimer = Timer.periodic(
      const Duration(seconds: 3),
          (timer) {
        if (!_controller.hasClients) return;

        // Stop auto-changing while the person has scrolled down to read the menu.
        if (_scroll.hasClients && _scroll.offset > 120) return;

        final nextIndex = (_index + 1) % restaurants.length;

        _controller.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _scroll.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = restaurants[_index];
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scroll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _hero(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  // Everything below the image changes with the restaurant.
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: KeyedSubtree(
                      key: ValueKey(_index),
                      child: _details(context, r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookTableScreen(
                    restaurant: r.name,
                    subtitle: '${r.cuisine} · ${r.area}',
                    imageAsset: r.imageAsset,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.accent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              child: const Text('Book a table'),
            ),
          ),
        ),
      ],
    );
  }

  // ---------- Swipeable image ----------

  Widget _hero() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      child: SizedBox(
        height: 250,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: restaurants.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) => _slideImage(restaurants[i]),
            ),
            Positioned(
              top: 14,
              left: 14,
              child: IgnorePointer(
                child: _chip(const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.swipe, size: 14, color: Colors.white),
                    SizedBox(width: 6),
                    Text('Swipe for more',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ],
                )),
              ),
            ),
            Positioned(
              top: 14,
              right: 14,
              child: IgnorePointer(
                child: _chip(Text(
                  '${_index + 1} / ${restaurants.length}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                )),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 14,
              child: IgnorePointer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    restaurants.length,
                        (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: i == _index ? 22 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: i == _index ? Colors.white : Colors.white54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Just the photo: no color tint, no dark gradient, no text on top.
  Widget _slideImage(Restaurant r) {
    return Image.asset(
      r.imageAsset,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [r.tint, Colors.black87],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _chip(Widget child) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.black54,
      borderRadius: BorderRadius.circular(99),
    ),
    child: child,
  );

  // ---------- Details (change with the restaurant) ----------

  Widget _details(BuildContext context, Restaurant r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          r.tag,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: _C.accent,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          r.name,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: _C.ink,
          ),
        ),
        const SizedBox(height: 14),
        _infoRow(Icons.place_outlined, r.address, _C.muted),
        const SizedBox(height: 8),
        _infoRow(Icons.schedule, r.hours, _C.open),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(height: 1, color: _C.border),
        ),
        Text(
          r.tagline,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _C.ink,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          r.description,
          style: const TextStyle(fontSize: 14, height: 1.5, color: _C.muted),
        ),
        const SizedBox(height: 24),
        const Text(
          "Chef's specials",
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w600, color: _C.ink),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _C.badge,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, size: 18, color: _C.accent),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Speciality: ${r.speciality}',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _C.accent),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: r.specials.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => _SpecialCard(item: r.specials[i]),
          ),
        ),
        const SizedBox(height: 20),
        _MenuList(restaurant: r),
        const SizedBox(height: 14),
        const Text(
          'Choose your date, time and party size next.',
          style: TextStyle(fontSize: 12, color: _C.muted),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String text, Color color) => Row(
    children: [
      Icon(icon, size: 18, color: _C.muted),
      const SizedBox(width: 10),
      Expanded(
        child: Text(text, style: TextStyle(fontSize: 14, color: color)),
      ),
    ],
  );
}

// ---------------------------------------------------------------------------
// WIDGETS
// ---------------------------------------------------------------------------

class _SpecialCard extends StatelessWidget {
  final MenuItem item;

  const _SpecialCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FoodImage(item: item, size: 85, width: double.infinity),
          const Spacer(),
          Text(
            item.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _C.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$currency${item.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _C.accent,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dish photo. If the file is missing, a plain icon shows (no emoji).
class _FoodImage extends StatelessWidget {
  final MenuItem item;
  final double size;
  final double? width;

  const _FoodImage({required this.item, required this.size, this.width});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        item.imageAsset,
        height: size,
        width: width ?? size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: size,
          width: width ?? size,
          alignment: Alignment.center,
          color: _C.badge,
          child: Icon(Icons.restaurant, size: size * 0.4, color: _C.accent),
        ),
      ),
    );
  }
}

/// The full menu, shown inline when you scroll down. Each dish has a photo,
/// a short description and its price.
class _MenuList extends StatelessWidget {
  final Restaurant restaurant;

  const _MenuList({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Explore the menu',
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w600, color: _C.ink),
        ),
        for (final section in restaurant.menu) ...[
          const SizedBox(height: 18),
          Text(
            section.title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: _C.accent,
            ),
          ),
          const SizedBox(height: 8),
          for (final item in section.items)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _C.border),
              ),
              child: Row(
                children: [
                  _FoodImage(item: item, size: 64),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _C.ink,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12, height: 1.3, color: _C.muted),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$currency${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _C.accent,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}