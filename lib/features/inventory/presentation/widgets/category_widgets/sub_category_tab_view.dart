// file: features/inventory/presentation/widgets/category_widgets/sub_category_tab_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/features/inventory/logic/category_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/subcategory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/category_model.dart';

class SubCategoryTabView extends StatelessWidget {
  final CategoryModel parent;
  SubCategoryTabView({super.key, required this.parent});

  final SubCategoryController subCtrl = Get.find<SubCategoryController>();
  final CategoryController catCtrl = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    final parentId = parent.id ?? '';

    // DO NOT call setActiveParent here — tab selection is driven by CategoryPage's TabController listener.

    return Obx(() {
      final isLoading = subCtrl.isLoading.value;
      final list = subCtrl.getSubcategories(parentId);

      if (isLoading && list.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (list.isEmpty) {
        return const Center(child: Text("No subcategories"));
      }

      return RefreshIndicator(
        onRefresh: () async {
          await subCtrl.fetchSubcategories(parentId, force: true);
        },
        child: ListView.separated(
          padding: EdgeInsets.all(12.r),
          itemCount: list.length,
          separatorBuilder: (_, __) => SizedBox(height: 8.h),
          itemBuilder: (_, index) {
            final c = list[index];

            return Slidable(
              key: ValueKey(c.id),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) => _onEdit(c),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                  ),
                  SlidableAction(
                    onPressed: (_) => _confirmDelete(context, c),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: ListTile(
                leading: _leadingImage(c),
                title: Text(c.name ?? '-'),
                subtitle: (c.description != null && c.description!.isNotEmpty)
                    ? Text(c.description!)
                    : null,
              ),
            );
          },
        ),
      );
    });
  }

  Widget _leadingImage(CategoryModel c) {
    if (c.image != null && c.image!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6.r),
        child: Image.network(
          c.image!,
          width: 48.w,
          height: 48.h,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.image_not_supported, size: 36.r),
        ),
      );
    }

    return Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Icon(Icons.category, size: 26.r, color: Colors.grey),
    );
  }

  void _onEdit(CategoryModel c) {
    Get.toNamed('/categories/edit', arguments: c);
  }

  Future<void> _confirmDelete(BuildContext context, CategoryModel c) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Delete subcategory'),
        content: Text('Delete "${c.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await catCtrl.deleteCategory(c.id ?? '');
      await subCtrl.fetchSubcategories(parent.id ?? '', force: true);
    }
  }
}
