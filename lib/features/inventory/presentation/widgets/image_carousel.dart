// features/inventory/presentation/widgets/image_carousel.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';

typedef ImageTapCallback = void Function(int index, String url);

class ImageCarousel extends StatelessWidget {
  final List<String>? images;

  final PageController? pageController;
  final RxInt activeIndex;
  final ImageTapCallback? onTap;
  final double height;
  final BoxFit fit;
  final double borderRadius;
  final Widget? placeholder;

  const ImageCarousel({
    super.key,
    required this.activeIndex,
    this.images,
    this.pageController,
    this.onTap,
    this.height = 240,
    this.fit = BoxFit.cover,
    this.borderRadius = 12,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final imgs = (images ?? <String>[]);
    final pc = pageController ?? PageController();

    return SizedBox(
      height: height.h,
      child: Column(
        children: [
          Expanded(
            child: imgs.isEmpty
                ? _buildPlaceholder(context)
                : PageView.builder(
                    controller: pc,
                    itemCount: imgs.length,
                    onPageChanged: (i) => activeIndex.value = i,
                    itemBuilder: (ctx, idx) {
                      final url = imgs[idx];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 8.h),
                        child: GestureDetector(
                          onTap: () {
                            if (onTap != null) onTap!(idx, url);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(borderRadius.r),
                            child: Image.network(
                              url,
                              fit: fit,
                              width: double.infinity,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHigh,
                                  child: Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 40.r,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // indicator dots (only if multiple images)
          if (imgs.length > 1) SizedBox(height: 8.h),
          if (imgs.length > 1)
            Obx(
              () {
                final active = activeIndex.value;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    imgs.length,
                    (i) {
                      final isActive = i == active;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.symmetric(horizontal: 3.w),
                        width: isActive ? 16.w : 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color:
                              isActive ? AppColors.kPrimary : AppColors.kGray,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return placeholder ??
        Container(
          margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
          child: Center(
            child: Icon(
              Icons.image_not_supported,
              size: 48.r,
              color: Colors.grey,
            ),
          ),
        );
  }
}
