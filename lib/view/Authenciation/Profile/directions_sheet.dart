import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Widgets/app_theme.dart';

class DirectionsSheet extends StatelessWidget {
  final String restaurantName;
  final String location;

  const DirectionsSheet({
    super.key,
    required this.restaurantName,
    required this.location,
  });

  Future<void> _openGoogleMaps(BuildContext context) async {
    final query = Uri.encodeComponent('$restaurantName, $location');
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else if (context.mounted) {
        _showSnackBar(context, 'Couldn\'t open Maps');
      }
    } catch (_) {
      if (context.mounted) {
        _showSnackBar(context, 'Couldn\'t open Maps');
      }
    }
  }

  void _copyAddress(BuildContext context) {
    Clipboard.setData(ClipboardData(text: location));
    _showSnackBar(context, 'Address copied');
  }

  void _showSnackBar(BuildContext context, String message) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
            'Directions',
            style: AppTheme.dmSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textCharcoal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            restaurantName,
            style: AppTheme.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.burntOrange,
            ),
          ),
          const SizedBox(height: 16),

          // Map Placeholder Card
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2A2826), Color(0xFF423E3B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryOrange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: AppColors.textCharcoal,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Map View Preview',
                        style: AppTheme.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.bgCream,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Address & Travel Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.place_outlined, color: AppColors.burntOrange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        location,
                        style: AppTheme.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textCharcoal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: AppColors.inputBorder),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.two_wheeler_rounded, color: AppColors.mutedGray, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '12 min by bike  •  2.4 km',
                      style: AppTheme.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.mutedGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    _copyAddress(context);
                  },
                  icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.textCharcoal),
                  label: Text(
                    'Copy Address',
                    style: AppTheme.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textCharcoal,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    side: const BorderSide(color: AppColors.inputBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    _openGoogleMaps(context);
                  },
                  icon: const Icon(Icons.map_rounded, size: 18, color: AppColors.textCharcoal),
                  label: Text(
                    'Google Maps',
                    style: AppTheme.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textCharcoal,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
