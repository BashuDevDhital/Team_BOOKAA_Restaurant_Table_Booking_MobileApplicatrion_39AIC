import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppColors defines the exact color palette for Boo-KAA.
abstract class AppColors {
  // Main palette
  static const Color bgCream = Color(0xFFFFF9F0);
  static const Color primaryOrange = Color(0xFFFF6B0F);
  static const Color burntOrange = Color(0xFFB84A00);
  static const Color textCharcoal = Color(0xFF1F1D1A);
  static const Color mutedGray = Color(0xFF7A756C);
  static const Color white = Color(0xFFFFFFFF);
  static const Color inputBorder = Color(0xFFEDE6DA);
  static const Color softCreamCard = Color(0xFFFFF4E0);
  static const Color darkCard = Color(0xFF2A2826);
  static const Color availabilityGreen = Color(0xFF2E9B5A);

  // Mood chip pastels
  static const Color moodPeach = Color(0xFFFFE3D6);
  static const Color moodSage = Color(0xFFE4EFE4);
  static const Color moodTaupe = Color(0xFFECE6DA);
  static const Color moodButter = Color(0xFFFFF0CC);
  static const Color moodBlush = Color(0xFFF6E6EE);
}

/// AppTheme builds the ThemeData and provides shared text styles.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.bgCream,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryOrange,
        secondary: AppColors.burntOrange,
        surface: AppColors.bgCream,
        onSurface: AppColors.textCharcoal,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primaryOrange,
        selectionColor: Color(0x33FF6B0F),
        selectionHandleColor: AppColors.primaryOrange,
      ),
    );
  }

  // Inter typography (for Auth screens)
  static TextStyle inter({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = AppColors.textCharcoal,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // DM Sans typography (for Home screen)
  static TextStyle dmSans({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = AppColors.textCharcoal,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.dmSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}

/// Shared Primary Button: Pill-shaped orange button with CHARCOAL text.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double height;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 54.0,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext meContext) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: AppColors.textCharcoal,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.textCharcoal),
                ),
              )
            : Text(
                label,
                style: AppTheme.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textCharcoal, // Charcoal text on orange per instructions
                ),
              ),
      ),
    );
  }
}

/// Shared Secondary Button: Pill-shaped outlined button (cream/white fill, border #EDE6DA).
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double height;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 54.0,
  });

  @override
  Widget build(BuildContext meContext) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.textCharcoal,
          elevation: 0,
          side: const BorderSide(color: AppColors.inputBorder, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          label,
          style: AppTheme.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textCharcoal,
          ),
        ),
      ),
    );
  }
}

/// Shared App Text Field: Labeled pill-shaped input field with optional error text & suffix icon.
class AppTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? errorText;
  final String? helperText;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.errorText,
    this.helperText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textCharcoal,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: errorText != null ? const Color(0xFFD32F2F) : AppColors.inputBorder,
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: AppTheme.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textCharcoal,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTheme.inter(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.mutedGray,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              suffixIcon: suffixIcon,
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText!,
              style: AppTheme.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFD32F2F),
              ),
            ),
          ),
        ] else if (helperText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              helperText!,
              style: AppTheme.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.mutedGray,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Shared Logo Display Widget: Safely loads asset images with fallback.
class AppLogoWidget extends StatelessWidget {
  final double width;
  final double? height;

  const AppLogoWidget({
    super.key,
    this.width = 240,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/Boo-KAA Logo.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Second attempt fallback to lowercase filename
        return Image.asset(
          'assets/images/boo_kaa_logo.png',
          width: width,
          height: height,
          fit: BoxFit.contain,
          errorBuilder: (context, error2, stackTrace2) {
            // Elegant vector fallback if logo file isn't found
            return Container(
              width: width,
              height: height ?? width * 0.8,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      size: 38,
                      color: AppColors.textCharcoal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Boo-KAA',
                    style: AppTheme.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textCharcoal,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
