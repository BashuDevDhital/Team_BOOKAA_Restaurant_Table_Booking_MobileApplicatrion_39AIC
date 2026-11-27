import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Widgets/app_theme.dart';

/// SectionHeader: Small orange eyebrow label above a bold section title.
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
      child: Text(
        title,
        style: AppTheme.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textCharcoal,
          letterSpacing: -0.3,
        ),
      ),
    );
  }
}

/// ProfileHeaderCard: Large initials or photo avatar with camera badge, user name, email, verified chip, and edit button.
class ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String email;
  final String memberSince;
  final File? photoFile;
  final VoidCallback onEditPressed;
  final VoidCallback onAvatarPressed;

  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.email,
    required this.memberSince,
    this.photoFile,
    required this.onEditPressed,
    required this.onAvatarPressed,
  });

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.inputBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.textCharcoal.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular Avatar with Badge
              Stack(
                children: [
                  Semantics(
                    label: 'Profile picture avatar',
                    child: Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: AppColors.softCreamCard,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryOrange.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      alignment: Alignment.center,
                      child: photoFile != null
                          ? Image.file(
                              photoFile!,
                              width: 76,
                              height: 76,
                              fit: BoxFit.cover,
                            )
                          : Text(
                              _initials,
                              style: AppTheme.dmSans(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: AppColors.burntOrange,
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onAvatarPressed();
                      },
                      child: Semantics(
                        button: true,
                        label: 'Change avatar picture',
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryOrange,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 14,
                            color: AppColors.textCharcoal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // User Info Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: AppTheme.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textCharcoal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: AppTheme.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.mutedGray,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.moodSage,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified_rounded,
                            size: 13,
                            color: AppColors.availabilityGreen,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            memberSince,
                            style: AppTheme.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.availabilityGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.inputBorder),
          const SizedBox(height: 12),

          // Edit Profile Button
          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton.icon(
              onPressed: () {
                HapticFeedback.selectionClick();
                onEditPressed();
              },
              icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.textCharcoal),
              label: Text(
                'Edit Profile',
                style: AppTheme.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textCharcoal,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.bgCream,
                side: const BorderSide(color: AppColors.inputBorder, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// StatCard: Compact summary card for Bookings, Saved, Reviews.
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Semantics(
          button: true,
          label: '$label count $value',
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.inputBorder, width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textCharcoal.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.softCreamCard,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20, color: AppColors.burntOrange),
                ),
                const SizedBox(height: 10),
                Text(
                  value,
                  style: AppTheme.dmSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textCharcoal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: AppTheme.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.mutedGray,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// PreferenceTile: Item tile with title, subtitle/trailing text, and optional switch or chevron.
class PreferenceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? valueText;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final VoidCallback? onTap;
  final bool showDivider;

  const PreferenceTile({
    super.key,
    required this.icon,
    required this.title,
    this.valueText,
    this.switchValue,
    this.onSwitchChanged,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onSwitchChanged != null
              ? () {
                  HapticFeedback.selectionClick();
                  onSwitchChanged!(!switchValue!);
                }
              : onTap != null
                  ? () {
                      HapticFeedback.selectionClick();
                      onTap!();
                    }
                  : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.bgCream,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20, color: AppColors.burntOrange),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textCharcoal,
                    ),
                  ),
                ),
                if (valueText != null) ...[
                  Text(
                    valueText!,
                    style: AppTheme.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.mutedGray,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                if (switchValue != null && onSwitchChanged != null)
                  Semantics(
                    toggled: switchValue,
                    label: title,
                    child: Switch(
                      value: switchValue!,
                      activeThumbColor: AppColors.white,
                      activeTrackColor: AppColors.primaryOrange,
                      inactiveThumbColor: AppColors.mutedGray,
                      inactiveTrackColor: AppColors.inputBorder,
                      onChanged: (val) {
                        HapticFeedback.selectionClick();
                        onSwitchChanged!(val);
                      },
                    ),
                  )
                else if (onTap != null)
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 22,
                    color: AppColors.mutedGray,
                  ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1, color: AppColors.inputBorder),
          ),
      ],
    );
  }
}

/// SettingsTile: Reusable tile for general settings section.
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback onTap;
  final bool showDivider;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return PreferenceTile(
      icon: icon,
      title: title,
      valueText: trailingText,
      onTap: onTap,
      showDivider: showDivider,
    );
  }
}

/// BudgetBottomSheet: RangeSlider for selecting budget per person (Rs. 200 - 5,000, step 100).
class BudgetBottomSheet extends StatefulWidget {
  final RangeValues initialValues;
  final ValueChanged<RangeValues> onSave;

  const BudgetBottomSheet({
    super.key,
    required this.initialValues,
    required this.onSave,
  });

  @override
  State<BudgetBottomSheet> createState() => _BudgetBottomSheetState();
}

class _BudgetBottomSheetState extends State<BudgetBottomSheet> {
  late RangeValues _currentRange;

  @override
  void initState() {
    super.initState();
    _currentRange = widget.initialValues;
  }

  @override
  Widget build(BuildContext context) {
    final start = _currentRange.start.round();
    final end = _currentRange.end.round();

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
            'Budget per person',
            style: AppTheme.dmSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textCharcoal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Select your preferred dining price range',
            style: AppTheme.inter(
              fontSize: 13,
              color: AppColors.mutedGray,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Center(
              child: Text(
                'Rs. $start – Rs. $end',
                style: AppTheme.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.burntOrange,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primaryOrange,
              inactiveTrackColor: AppColors.inputBorder,
              thumbColor: AppColors.burntOrange,
              overlayColor: AppColors.primaryOrange.withValues(alpha: 0.15),
              valueIndicatorTextStyle: AppTheme.inter(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            child: RangeSlider(
              values: _currentRange,
              min: 200,
              max: 5000,
              divisions: 48,
              labels: RangeLabels('Rs. $start', 'Rs. $end'),
              onChanged: (values) {
                HapticFeedback.selectionClick();
                setState(() {
                  _currentRange = values;
                });
              },
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Save Budget Preference',
            onPressed: () {
              widget.onSave(_currentRange);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

/// CuisineBottomSheet: ChoiceChips for selecting multi-select cuisines.
class CuisineBottomSheet extends StatefulWidget {
  final List<String> initialSelected;
  final ValueChanged<List<String>> onSave;

  const CuisineBottomSheet({
    super.key,
    required this.initialSelected,
    required this.onSave,
  });

  @override
  State<CuisineBottomSheet> createState() => _CuisineBottomSheetState();
}

class _CuisineBottomSheetState extends State<CuisineBottomSheet> {
  static const List<String> _allCuisines = [
    'Nepali',
    'Newari',
    'Italian',
    'Chinese',
    'Indian',
    'Continental',
    'Asian',
    'Fast Food',
    'Cafe',
  ];

  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.initialSelected);
  }

  @override
  Widget build(BuildContext context) {
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
            'Favorite Cuisines',
            style: AppTheme.dmSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textCharcoal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose the types of food you enjoy most',
            style: AppTheme.inter(
              fontSize: 13,
              color: AppColors.mutedGray,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: _allCuisines.map((cuisine) {
              final isSelected = _selected.contains(cuisine);
              return ChoiceChip(
                label: Text(
                  cuisine,
                  style: AppTheme.inter(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppColors.textCharcoal : AppColors.textCharcoal,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.primaryOrange,
                backgroundColor: AppColors.white,
                side: BorderSide(
                  color: isSelected ? AppColors.primaryOrange : AppColors.inputBorder,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onSelected: (selected) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    if (selected) {
                      _selected.add(cuisine);
                    } else {
                      _selected.remove(cuisine);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            label: 'Save Cuisines (${_selected.length})',
            onPressed: () {
              widget.onSave(_selected.toList());
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

/// EditProfileBottomSheet: Modal bottom sheet for updating user Name and Email with form validation.
class EditProfileBottomSheet extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final void Function(String name, String email) onSave;

  const EditProfileBottomSheet({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.onSave,
  });

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  String? _nameError;
  String? _emailError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool isValid = true;
    setState(() {
      _nameError = null;
      _emailError = null;

      final nameVal = _nameController.text.trim();
      if (nameVal.isEmpty) {
        _nameError = 'Name is required';
        isValid = false;
      }

      final emailVal = _emailController.text.trim();
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (emailVal.isEmpty) {
        _emailError = 'Email is required';
        isValid = false;
      } else if (!emailRegex.hasMatch(emailVal)) {
        _emailError = 'Please enter a valid email address';
        isValid = false;
      }
    });
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
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
      child: Form(
        key: _formKey,
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
              'Edit Profile',
              style: AppTheme.dmSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textCharcoal,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Update your account details below',
              style: AppTheme.inter(
                fontSize: 13,
                color: AppColors.mutedGray,
              ),
            ),
            const SizedBox(height: 20),
            AppTextField(
              label: 'Full Name',
              hint: 'Enter your name',
              controller: _nameController,
              errorText: _nameError,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Email Address',
              hint: 'Enter your email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: _emailError,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Save Changes',
              onPressed: () {
                if (_validate()) {
                  widget.onSave(
                    _nameController.text.trim(),
                    _emailController.text.trim(),
                  );
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
