import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/category_model.dart';
import 'package:phone_management_system_admin/features/inventory/logic/category_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/subcategory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/show_select_bottom_modal.dart';
import 'package:phone_management_system_admin/shared/constants/app_size.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/app_snackbar.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class CategoryFormBottomSheet extends StatefulWidget {
  final CategoryModel? category; // null = create mode

  const CategoryFormBottomSheet({super.key, this.category});

  @override
  State<CategoryFormBottomSheet> createState() =>
      _CategoryFormBottomSheetState();
}

class _CategoryFormBottomSheetState extends State<CategoryFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();

  String? _selectedParentId;

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  bool _isSubmitting = false;

  late final CategoryController _catCtrl;

  bool get isEdit => widget.category != null;

  @override
  void initState() {
    super.initState();
    _catCtrl = Get.find<CategoryController>();

    if (_catCtrl.rootCategories.isEmpty) {
      _catCtrl.loadRootCategories();
    }

    // --------- EDIT MODE: Load existing values ---------
    if (isEdit) {
      final c = widget.category!;
      _nameCtrl.text = c.name ?? "";
      _descCtrl.text = c.description ?? "";
      _selectedParentId = c.parentId;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 12, right: 12, bottom: bottomInset),
        child: SizedBox(
          height: AppSize.height * 0.75,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: [
                        _buildBasicFields(),
                        const SizedBox(height: 12),
                        _buildParentSelector(),
                        const SizedBox(height: 12),
                        _buildImagePicker(),
                      ],
                    ),
                  ),
                ),
              ),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // HEADER
  // ----------------------------------------------------
  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.only(top: 6, bottom: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        ReusableText(
          text: isEdit ? "Update Category" : "Add Category",
          style: appStyle(16, AppColors.kDark, FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
      ],
    );
  }

  // ----------------------------------------------------
  // BASIC FIELDS
  // ----------------------------------------------------
  Widget _buildBasicFields() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: "Basic Info",
            style: appStyle(16, AppColors.kDark, FontWeight.w600),
          ),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _nameCtrl,
            label: "Name *",
            validator: (v) =>
                v == null || v.trim().isEmpty ? "Name is required" : null,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: _descCtrl,
            label: "Description",
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // PARENT SELECTOR
  // ----------------------------------------------------
  Widget _buildParentSelector() {
    return Obx(() {
      final parents = _catCtrl.rootCategories;
      final selected =
          parents.firstWhereOrNull((c) => c.id == _selectedParentId);

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: _box(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableText(
              text: "Parent Category",
              style: appStyle(16, AppColors.kDark, FontWeight.w600),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              readOnly: true,
              controller: TextEditingController(text: selected?.name ?? ""),
              label: "Parent *",
              suffixIcon: const Icon(Icons.arrow_drop_down),
              validator: (_) =>
                  _selectedParentId == null ? "Please select parent" : null,
              onTap: () {
                showSelectBottomSheet(
                  context: context,
                  title: "Select Parent",
                  options: parents
                      .map((c) => {"value": c.id, "label": c.name ?? ""})
                      .toList(),
                  onSelected: (val) {
                    setState(() => _selectedParentId = val);
                  },
                );
              },
            ),
          ],
        ),
      );
    });
  }

  // ----------------------------------------------------
  // IMAGE PICKER
  // ----------------------------------------------------
  Widget _buildImagePicker() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: "Image (optional)",
            style: appStyle(16, AppColors.kDark, FontWeight.w600),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade400),
                color: Colors.grey.shade100,
              ),
              child: _pickedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(File(_pickedImage!.path),
                          fit: BoxFit.cover),
                    )
                  : widget.category?.image != null && isEdit
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget.category!.image!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.add_a_photo_outlined),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // ACTION BUTTONS
  // ----------------------------------------------------
  Widget _buildActions() {
    return Column(
      children: [
        const Divider(height: 1),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: _isSubmitting ? null : () => Get.back(),
                child: ReusableText(
                  text: "Cancel",
                  style: appStyle(14, AppColors.kDark, FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : ReusableText(
                        text: isEdit ? "Update" : "Create",
                        style: appStyle(14, AppColors.kWhite, FontWeight.w500),
                      ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  BoxDecoration _box() => BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      );

  // ----------------------------------------------------
  // Image picker
  // ----------------------------------------------------
  Future<void> _pickImage() async {
    try {
      final img = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (img != null) {
        setState(() => _pickedImage = img);
      }
    } catch (e) {
      Get.snackbar("Error", "Image pick failed");
    }
  }

  // ----------------------------------------------------
  // SUBMIT
  // ----------------------------------------------------
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedParentId == null) {
      Get.snackbar("Missing parent", "Please select a parent category");
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      bool ok = false;

      dio.MultipartFile? file;
      if (_pickedImage != null) {
        file = await dio.MultipartFile.fromFile(
          _pickedImage!.path,
          filename: _pickedImage!.name,
        );
      }

      if (isEdit) {
        await _catCtrl.updateCategory(
          widget.category!.id!,
          name: _nameCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          parentId: _selectedParentId!,
          imageFile: file,
        );
        ok = true;
      } else {
        await _catCtrl.createCategory(
          name: _nameCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          parentId: _selectedParentId!,
          imageFile: file,
        );
        ok = true;
      }

      if (!ok) {
        AppSnackbar.error(
          title: 'Error',
          message: isEdit
              ? 'Failed to update category'
              : 'Failed to create category',
        );
        return;
      }

      AppSnackbar.success(
        title: 'Success',
        message: isEdit
            ? 'Category updated successfully'
            : 'Category created successfully',
      );

      final subCtrl = Get.find<SubCategoryController>();
      await subCtrl.refetchSubcategories(_selectedParentId!);

      if (!mounted) return;
      Navigator.of(context).pop();

      // Still keep your optional refresh for root categories
      Future.delayed(const Duration(milliseconds: 150), () {
        _catCtrl.fetchCategories(reset: true);
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
