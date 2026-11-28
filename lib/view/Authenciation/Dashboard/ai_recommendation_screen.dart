import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../Widgets/app_theme.dart';

// =============================================================================
// AI RECOMMENDATION MODELS
// =============================================================================
enum SenderType { ai, user }

class AiChatMessage {
  final String id;
  final String text;
  final SenderType sender;
  final RestaurantRecommendation? recommendation;

  AiChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    this.recommendation,
  });
}

class RestaurantRecommendation {
  final String id;
  final String name;
  final String cuisineAndDistance;
  final double rating;
  final int reviewCount;
  final String imagePath;
  final String priceEstimate;
  final String matchReason;
  final List<String> tags;

  RestaurantRecommendation({
    required this.id,
    required this.name,
    required this.cuisineAndDistance,
    required this.rating,
    required this.reviewCount,
    required this.imagePath,
    required this.priceEstimate,
    required this.matchReason,
    required this.tags,
  });
}

// =============================================================================
// AI RECOMMENDATION SCREEN (INTELLIGENT DUAL-ENGINE AI)
// =============================================================================
class AiRecommendationScreen extends StatefulWidget {
  final String userName;

  const AiRecommendationScreen({
    super.key,
    this.userName = 'Aayush',
  });

  @override
  State<AiRecommendationScreen> createState() => _AiRecommendationScreenState();
}

class _AiRecommendationScreenState extends State<AiRecommendationScreen> {
  // Safe API key placeholder (keeps git secure)
  static const String _geminiApiKey = '';

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  ChatSession? _chatSession;
  bool _isInitialized = false;
  bool _isLoading = false;

  // Restaurant Database Grounding Context
  final List<Map<String, dynamic>> _restaurantDatabase = [
    {
      'id': 'rec_1',
      'name': 'The Workshop Eatery',
      'cuisine': 'Continental • Asian',
      'location': 'Jhamsikhet',
      'distance': '1.2 km',
      'rating': 4.8,
      'reviewCount': 246,
      'imagePath': 'assets/images/restaurant_1.jpg',
      'price': 'Approx. Rs. 800/person',
      'numericPrice': 800,
      'tags': ['Friends Meetup', 'Approx. Rs. 800/person', 'Cozy Ambiance'],
    },
    {
      'id': 'rec_2',
      'name': 'Bao Basera',
      'cuisine': 'Asian Fusion • Bao & Dumplings',
      'location': 'Jhamsikhet',
      'distance': '1.5 km',
      'rating': 4.9,
      'reviewCount': 184,
      'imagePath': 'assets/images/restaurant_2.jpg',
      'price': 'Approx. Rs. 750/person',
      'numericPrice': 750,
      'tags': ['Group Friendly', 'Asian Fusion', 'Top Rated'],
    },
    {
      'id': 'rec_3',
      'name': 'Roadhouse Cafe',
      'cuisine': 'Italian & Wood-fired Pizza',
      'location': 'Thamel',
      'distance': '2.5 km',
      'rating': 4.7,
      'reviewCount': 210,
      'imagePath': 'assets/images/restaurant_2.jpg',
      'price': 'Approx. Rs. 950/person',
      'numericPrice': 950,
      'tags': ['Pizza', 'Date Night', 'Thamel'],
    },
    {
      'id': 'rec_4',
      'name': 'The Old House',
      'cuisine': 'French & Continental',
      'location': 'Durbar Marg',
      'distance': '3.1 km',
      'rating': 4.9,
      'reviewCount': 98,
      'imagePath': 'assets/images/restaurant_3.jpg',
      'price': 'Approx. Rs. 1,500/person',
      'numericPrice': 1500,
      'tags': ['Fine Dining', 'Celebrations', 'Luxury'],
    },
  ];

  late final List<AiChatMessage> _messages;

  final List<String> _quickChips = [
    'Best restaurants under NPR 1,000',
    'Best restaurants for a date',
    'Group & Friends Meetup',
    'Fine Dining & Celebrations',
  ];

  @override
  void initState() {
    super.initState();
    _messages = [
      AiChatMessage(
        id: '1',
        text: 'Namaste, ${widget.userName}! I am your Boo-KAA AI assistant. How may I help you discover a table or recommend a restaurant today?',
        sender: SenderType.ai,
      ),
    ];
    _initializeGemini();
  }

  void _initializeGemini() {
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _geminiApiKey,
      );
      _chatSession = model.startChat();
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = AiChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      sender: SenderType.user,
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    String aiResponseText = '';
    RestaurantRecommendation? matchedRec;

    try {
      if (_isInitialized && _chatSession != null) {
        final prompt = 'User ${widget.userName} asks: "$text". '
            'You are Boo-KAA AI restaurant assistant in Kathmandu. Respond naturally and helpfully. '
            'Available restaurants: '
            '${_restaurantDatabase.map((r) => "${r['name']} (${r['cuisine']}, ${r['location']}, ${r['price']}, Rating: ${r['rating']})").join('; ')}. '
            'If recommending a restaurant, mention its exact name.';
            
        final response = await _chatSession!.sendMessage(Content.text(prompt));
        aiResponseText = response.text ?? '';
      }
    } catch (_) {
      // Fallback to intelligent local AI engine if network or API key fails
      aiResponseText = '';
    }

    // If API failed or didn't return text, use intelligent local NLP matcher
    if (aiResponseText.isEmpty) {
      aiResponseText = _generateIntelligentFallbackResponse(text);
    }

    // Detect mentioned restaurant in AI response
    for (var r in _restaurantDatabase) {
      final rName = r['name'].toString();
      if (aiResponseText.toLowerCase().contains(rName.toLowerCase()) ||
          _matchesIntent(text, r)) {
        matchedRec = RestaurantRecommendation(
          id: r['id'],
          name: rName,
          cuisineAndDistance: '${r['cuisine']} • ${r['location']} • ${r['distance']}',
          rating: r['rating'],
          reviewCount: r['reviewCount'],
          imagePath: r['imagePath'],
          priceEstimate: r['price'],
          matchReason: 'Matched based on your query: "$text"',
          tags: List<String>.from(r['tags']),
        );
        break;
      }
    }

    setState(() {
      _messages.add(
        AiChatMessage(
          id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
          text: aiResponseText,
          sender: SenderType.ai,
          recommendation: matchedRec,
        ),
      );
      _isLoading = false;
    });
    _scrollToBottom();
  }

  bool _matchesIntent(String query, Map<String, dynamic> restaurant) {
    final q = query.toLowerCase();
    if (q.contains('1,000') || q.contains('1000') || q.contains('budget') || q.contains('cheap')) {
      return (restaurant['numericPrice'] as int) <= 1000;
    }
    if (q.contains('date') || q.contains('romantic') || q.contains('pizza')) {
      return restaurant['name'] == 'Roadhouse Cafe' || restaurant['name'] == 'The Old House';
    }
    if (q.contains('group') || q.contains('friends') || q.contains('meetup')) {
      return restaurant['name'] == 'The Workshop Eatery' || restaurant['name'] == 'Bao Basera';
    }
    if (q.contains('fine dining') || q.contains('celebration') || q.contains('luxury')) {
      return restaurant['name'] == 'The Old House';
    }
    return false;
  }

  String _generateIntelligentFallbackResponse(String query) {
    final q = query.toLowerCase();
    
    if (q.contains('hello') || q.contains('hi') || q.contains('namaste') || q.contains('hey')) {
      return 'Hello, ${widget.userName}! How may I help you find a great place to eat today? You can ask me for budget spots, date night restaurants, or group meetups.';
    }
    
    if (q.contains('1000') || q.contains('1,000') || q.contains('budget') || q.contains('cheap')) {
      return 'Here are the best dining options under NPR 1,000 in Kathmandu that offer great food and value:\n\n• The Workshop Eatery (Jhamsikhet) - NPR 800/person\n• Bao Basera (Jhamsikhet) - NPR 750/person\n• Roadhouse Cafe (Thamel) - NPR 950/person';
    }
    
    if (q.contains('date') || q.contains('romantic')) {
      return 'For a wonderful date night, I highly recommend Roadhouse Cafe in Thamel for wood-fired pizza and cozy ambiance, or The Old House in Durbar Marg for exquisite French & Continental dining.';
    }

    if (q.contains('group') || q.contains('friends') || q.contains('meetup')) {
      return 'For a group or friends meetup, The Workshop Eatery in Jhamsikhet is a fantastic choice with spacious seating and continental-Asian fusion dishes!';
    }

    if (q.contains('fine dining') || q.contains('celebration') || q.contains('luxury')) {
      return 'If you are looking for a luxurious celebration or fine dining experience, The Old House in Durbar Marg offers exceptional French cuisine and an upscale atmosphere.';
    }

    return 'I understand you are looking for "$query". Based on your preferences in Kathmandu, here is a top-matched recommendation for you:';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCream,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            _buildAppBar(context),

            // Chat Message List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageItem(_messages[index]);
                },
              ),
            ),

            // Typing indicator loader
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.auto_awesome, color: AppColors.white, size: 16),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.inputBorder, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryOrange),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Boo-KAA AI is thinking...',
                            style: AppTheme.dmSans(fontSize: 13, color: AppColors.mutedGray),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Quick Chips Row
            _buildQuickChipsRow(),

            // Bottom Input Bar
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.bgCream,
        border: Border(
          bottom: BorderSide(color: AppColors.inputBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.inputBorder, width: 1),
              ),
              child: const Icon(Icons.close_rounded, color: AppColors.textCharcoal, size: 20),
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryOrange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.auto_awesome, color: AppColors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Boo-KAA AI Assistant',
                style: AppTheme.dmSans(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textCharcoal),
              ),
              Text(
                'Personalized for ${widget.userName}',
                style: AppTheme.dmSans(fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.mutedGray),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(AiChatMessage message) {
    final isUser = message.sender == SenderType.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_awesome, color: AppColors.white, size: 16),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser ? AppColors.primaryOrange : AppColors.white,
                    borderRadius: BorderRadius.circular(18).copyWith(
                      topLeft: isUser ? const Radius.circular(18) : Radius.zero,
                      topRight: isUser ? Radius.zero : const Radius.circular(18),
                    ),
                    border: isUser ? null : Border.all(color: AppColors.inputBorder, width: 1),
                  ),
                  child: Text(
                    message.text,
                    style: AppTheme.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: isUser ? AppColors.white : AppColors.textCharcoal,
                      height: 1.4,
                    ),
                  ),
                ),
                if (message.recommendation != null) ...[
                  const SizedBox(height: 12),
                  _buildRecommendationCard(message.recommendation!),
                ],
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(RestaurantRecommendation rec) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.inputBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(
                  rec.imagePath,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 160,
                      color: AppColors.softCreamCard,
                      alignment: Alignment.center,
                      child: const Icon(Icons.restaurant, size: 40, color: AppColors.primaryOrange),
                    );
                  },
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'AI RECOMMENDED',
                    style: AppTheme.dmSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        rec.name,
                        style: AppTheme.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textCharcoal,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${rec.rating} · ${rec.reviewCount}',
                          style: AppTheme.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textCharcoal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  rec.cuisineAndDistance,
                  style: AppTheme.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.mutedGray,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: rec.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.softCreamCard,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tag,
                        style: AppTheme.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textCharcoal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF6F0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryOrange.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.auto_awesome, color: AppColors.primaryOrange, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Recommendation Note',
                              style: AppTheme.dmSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryOrange,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              rec.matchReason,
                              style: AppTheme.dmSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textCharcoal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price: ${rec.priceEstimate}',
                      style: AppTheme.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textCharcoal,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Opening ${rec.name} table booking...'), backgroundColor: AppColors.darkCard),
                        );
                      },
                      child: Text(
                        'Book Table >',
                        style: AppTheme.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChipsRow() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _quickChips.length,
        itemBuilder: (context, index) {
          final chip = _quickChips[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              backgroundColor: AppColors.white,
              side: const BorderSide(color: AppColors.inputBorder),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              label: Text(
                chip,
                style: AppTheme.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textCharcoal,
                ),
              ),
              onPressed: () {
                _sendMessage(chip);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.inputBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: AppTheme.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textCharcoal,
              ),
              decoration: InputDecoration(
                hintText: 'Ask Boo-KAA AI anything...',
                hintStyle: AppTheme.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.mutedGray,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _sendMessage(_controller.text),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
