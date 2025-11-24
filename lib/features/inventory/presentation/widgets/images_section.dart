import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class ImagesSection extends StatelessWidget {
  /// URLs from backend (existing images)
  final List<String> existingImages;

  /// Locally picked images
  final List<XFile> pickedImages;

  /// Callbacks
  final VoidCallback onPickImages;

  /// Remove *AN EXISTING* image (by index)
  final Function(int index) onRemoveExisting;

  /// Remove *A NEW PICKED* image (by index)
  final Function(int index) onRemovePicked;

  const ImagesSection({
    super.key,
    required this.existingImages,
    required this.pickedImages,
    required this.onPickImages,
    required this.onRemoveExisting,
    required this.onRemovePicked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: 'Images',
            style: appStyle(16, AppColors.kDark, FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // ----------------------------
              // EXISTING IMAGES (from server)
              // ----------------------------
              ...List.generate(
                existingImages.length,
                (i) {
                  final url = existingImages[i];
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          url,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: () => onRemoveExisting(i),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black54,
                            ),
                            padding: const EdgeInsets.all(2),
                            child: const Icon(Icons.close,
                                color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              // ----------------------------
              // NEWLY ADDED IMAGES (XFile)
              // ----------------------------
              ...List.generate(
                pickedImages.length,
                (i) {
                  final x = pickedImages[i];
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(x.path),
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: () => onRemovePicked(i),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black54,
                            ),
                            padding: const EdgeInsets.all(2),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              // ----------------------------
              // ADD BUTTON
              // ----------------------------
              GestureDetector(
                onTap: onPickImages,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                    color: Colors.grey.shade100,
                  ),
                  child: const Icon(Icons.add_a_photo_outlined),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
