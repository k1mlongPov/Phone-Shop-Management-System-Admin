import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/category_model.dart';
import 'package:phone_management_system_admin/features/inventory/logic/category_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/subcategory_controller.dart';
import 'package:phone_management_system_admin/shared/constants/app_size.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/show_select_bottom_modal.dart';

class CreateCategoryBottomSheet extends StatefulWidget {
  const CreateCategoryBottomSheet({super.key});

  @override
  State<CreateCategoryBottomSheet> createState() =>
      _CreateCategoryBottomSheetState();
}

class _CreateCategoryBottomSheetState extends State<CreateCategoryBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();

  // Parent category (root) id
  String? _selectedParentId;

  // Image picker
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  bool _isSubmitting = false;

  late final ApiService _api;
  late final CategoryController _catCtrl;
  late final SubCategoryController _subCtrl;

  @override
  void initState() {
    super.initState();
    _api = Get.find<ApiService>();
    _catCtrl = Get.find<CategoryController>();
    _subCtrl = Get.find<SubCategoryController>();

    // ensure root categories loaded (for parent selection)
    if (_catCtrl.rootCategories.isEmpty) {
      _catCtrl.loadRootCategories();
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
        padding: EdgeInsets.only(
          left: 12.w,
          right: 12.w,
          top: 8.h,
          bottom: bottomInset,
        ),
        child: SizedBox(
          height: AppSize.height * 0.75,
          child: Column(
            children: [
              // Grab handle
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(top: 4.h, bottom: 8.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              ReusableText(
                text: 'Add Subcategory',
                style: appStyle(16, AppColors.kDark, FontWeight.w600),
              ),
              SizedBox(height: 8.h),
              const Divider(height: 1),

              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12.h),
                        _buildBasicFields(),
                        SizedBox(height: 12.h),
                        _buildParentSelector(),
                        SizedBox(height: 12.h),
                        _buildImagePicker(),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
              ),

              const Divider(height: 1),
              SizedBox(height: 8.h),

              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _isSubmitting ? null : () => Get.back(),
                      child: ReusableText(
                        text: 'Cancel',
                        style: appStyle(14, AppColors.kDark, FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
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
                              text: 'Create',
                              style: appStyle(
                                  14, AppColors.kWhite, FontWeight.w500),
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- UI SECTIONS ----------------

  Widget _buildBasicFields() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: 'Basic Info',
            style: appStyle(16, AppColors.kDark, FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          CustomTextField(
            controller: _nameCtrl,
            label: 'Name *',
            hintText: 'e.g. iPhone, Chargers, Cables',
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
          SizedBox(height: 10.h),
          CustomTextField(
            controller: _descCtrl,
            label: 'Description',
            hintText: 'Optional description',
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildParentSelector() {
    return Obx(() {
      final parents = _catCtrl.rootCategories;
      final selectedParent = parents.firstWhereOrNull(
          (c) => c.id == _selectedParentId); // needs collection

      final labelText = selectedParent?.name ?? 'Select parent category *';

      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.04),
              blurRadius: 6,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableText(
              text: 'Parent Category',
              style: appStyle(16, AppColors.kDark, FontWeight.w600),
            ),
            SizedBox(height: 8.h),
            CustomTextField(
              readOnly: true,
              label: 'Parent *',
              controller: TextEditingController(text: labelText),
              suffixIcon: const Icon(Icons.arrow_drop_down),
              validator: (_) {
                if (_selectedParentId == null || _selectedParentId!.isEmpty) {
                  return 'Please select a parent category';
                }
                return null;
              },
              onTap: () {
                if (parents.isEmpty) {
                  Get.snackbar(
                    'No categories',
                    'Please create a root category first',
                  );
                  return;
                }

                showSelectBottomSheet(
                  context: context,
                  title: 'Select Parent Category',
                  options: parents
                      .map((c) => {
                            'value': c.id,
                            'label': c.name ?? '',
                          })
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

  Widget _buildImagePicker() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: 'Image (optional)',
            style: appStyle(16, AppColors.kDark, FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.grey.shade400),
                    color: Colors.grey.shade100,
                  ),
                  child: _pickedImage == null
                      ? const Icon(Icons.add_a_photo_outlined)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.file(
                            File(_pickedImage!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ReusableText(
                  text:
                      'Pick an image to represent this subcategory (optional).',
                  style: appStyle(12, AppColors.kGray, FontWeight.normal),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- HELPERS ----------------

  Future<bool> _requestPhotoPermission() async {
    if (await Permission.photos.isGranted ||
        await Permission.photos.request().isGranted) {
      return true;
    }

    if (await Permission.storage.isGranted ||
        await Permission.storage.request().isGranted) {
      return true;
    }

    return false;
  }

  Future<void> _pickImage() async {
    final ok = await _requestPhotoPermission();
    if (!ok) {
      Get.snackbar('Permission denied', 'You must allow photo access');
      return;
    }

    try {
      final img = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (img != null) {
        setState(() {
          _pickedImage = img;
        });
      }
    } catch (e) {
      print('Image pick error: $e');
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedParentId == null || _selectedParentId!.isEmpty) {
      Get.snackbar('Missing parent', 'Please select a parent category');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final form = dio.FormData();

      // basic fields
      form.fields.addAll([
        MapEntry('name', _nameCtrl.text.trim()),
        MapEntry('description', _descCtrl.text.trim()),
        MapEntry('parent', _selectedParentId!),
      ]);

      // image (if any) — field name must match multerCategory .single('image')
      if (_pickedImage != null) {
        final file = await dio.MultipartFile.fromFile(
          _pickedImage!.path,
          filename: _pickedImage!.name,
        );
        form.files.add(MapEntry('image', file));
      }

      final res = await _api.post('/api/categories', form);
      final data = res.data;

      final ok = data is Map && data['success'] == true;
      if (!ok) {
        Get.snackbar('Error', 'Failed to create category');
        return;
      }

      // parse created category
      final createdJson =
          Map<String, dynamic>.from(data['data'] as Map<String, dynamic>);
      final created = CategoryModel.fromJson(createdJson);

      // Update controllers (so UI refreshes immediately)
      _catCtrl.subcategories.add(created);

      if (created.parentId != null && created.parentId!.isNotEmpty) {
        final parentId = created.parentId!;
        final list =
            _subCtrl.subcategoriesByParent[parentId] ?? <CategoryModel>[];
        list.add(created);
        _subCtrl.subcategoriesByParent[parentId] = list;
        _subCtrl.subcategoriesByParent.refresh();
      }

      Get.snackbar('Created', 'Subcategory created successfully');
      Get.back(); // close bottom sheet
    } catch (e, st) {
      print('CreateCategoryBottomSheet submit error: $e\n$st');
      Get.snackbar('Error', e.toString());
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
