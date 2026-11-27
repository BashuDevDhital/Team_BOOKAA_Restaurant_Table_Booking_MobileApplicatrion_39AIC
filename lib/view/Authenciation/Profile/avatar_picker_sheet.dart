import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../Widgets/app_theme.dart';

class AvatarPickerSheet extends StatelessWidget {
  final bool hasCurrentPhoto;
  final ValueChanged<File> onPhotoSelected;
  final VoidCallback onPhotoRemoved;
  final void Function(String message) onError;

  const AvatarPickerSheet({
    super.key,
    required this.hasCurrentPhoto,
    required this.onPhotoSelected,
    required this.onPhotoRemoved,
    required this.onError,
  });

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (pickedFile != null && context.mounted) {
        onPhotoSelected(File(pickedFile.path));
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        onError('Couldn\'t open ${source == ImageSource.camera ? 'camera' : 'gallery'}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
            'Profile photo',
            style: AppTheme.dmSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textCharcoal,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.bgCream,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt_outlined, color: AppColors.burntOrange, size: 20),
                  ),
                  title: Text(
                    'Take photo',
                    style: AppTheme.inter(fontWeight: FontWeight.w600, color: AppColors.textCharcoal),
                  ),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    _pickImage(context, ImageSource.camera);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 1, color: AppColors.inputBorder),
                ),
                ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.bgCream,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.photo_library_outlined, color: AppColors.burntOrange, size: 20),
                  ),
                  title: Text(
                    'Choose from gallery',
                    style: AppTheme.inter(fontWeight: FontWeight.w600, color: AppColors.textCharcoal),
                  ),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    _pickImage(context, ImageSource.gallery);
                  },
                ),
                if (hasCurrentPhoto) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(height: 1, color: AppColors.inputBorder),
                  ),
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFEBEE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFD32F2F), size: 20),
                    ),
                    title: Text(
                      'Remove photo',
                      style: AppTheme.inter(fontWeight: FontWeight.w600, color: const Color(0xFFD32F2F)),
                    ),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onPhotoRemoved();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
