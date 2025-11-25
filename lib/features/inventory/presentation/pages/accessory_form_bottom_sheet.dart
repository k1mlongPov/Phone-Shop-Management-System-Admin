import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/accessory_model.dart';
import 'package:phone_management_system_admin/features/inventory/logic/accessory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/category_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/subcategory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/supplier_controller.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/accessory_widgets/accessory_attributes_section.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/accessory_widgets/accessory_basic_info_section.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/accessory_widgets/accessory_compatibility_section.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/images_section.dart';
import 'package:phone_management_system_admin/shared/constants/app_size.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/app_snackbar.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class AccessoryFormBottomSheet extends StatefulWidget {
  final Accessory? accessory;

  const AccessoryFormBottomSheet({super.key, this.accessory});

  @override
  State<AccessoryFormBottomSheet> createState() =>
      _AccessoryFormBottomSheetState();
}

class _AccessoryFormBottomSheetState extends State<AccessoryFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  // Basic fields
  final _nameCtrl = TextEditingController();
  final _typeCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  final _purchaseCtrl = TextEditingController();
  final _sellingCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _lowStockCtrl = TextEditingController(text: '10');

  // Compatibility (comma separated)
  final _compatibilityCtrl = TextEditingController();

  // Currency, category, supplier
  String _currency = 'USD';
  String? _selectedCategoryId;
  String? _selectedSupplierId;

  // Dynamic attributes
  final List<AttributeRow> _attributes = [AttributeRow()];

  // Images
  final RxList<XFile> pickedImages = <XFile>[].obs;

  bool _isSubmitting = false;
  late final bool _isEdit;

  late final AccessoryController _accessoryCtrl;
  late final CategoryController _catCtrl;
  late final SubCategoryController _subCtrl;
  late final SupplierController _supCtrl;

  @override
  void initState() {
    super.initState();

    _accessoryCtrl = Get.find<AccessoryController>();
    _catCtrl = Get.find<CategoryController>();
    _subCtrl = Get.find<SubCategoryController>();
    _supCtrl = Get.find<SupplierController>();

    _isEdit = widget.accessory != null;
    final subCtrl = Get.find<SubCategoryController>();

    // Ensure categories & suppliers loaded
    if (_catCtrl.rootCategories.isEmpty) {
      _catCtrl.loadRootCategories();
    }
    if (_supCtrl.suppliers.isEmpty) {
      _supCtrl.fetchSuppliers();
    }

    // Make sure we have Accessory subcategories + set active parent to Accessory
    Future.microtask(() async {
      if (_catCtrl.rootCategories.isEmpty) return;

      final accessoryParent = _catCtrl.rootCategories.firstWhereOrNull(
        (c) => (c.name ?? '').toLowerCase().contains('accessory'),
      );

      if (accessoryParent != null) {
        await _subCtrl.loadSubcategories(accessoryParent.id ?? '',
            force: false);
      }
    });

    // If you added this helper field in SubCategoryController
    // (otherwise you can remove this line)
    subCtrl.activeParentId.value = subCtrl.accessoryParentId;

    // Prefill data when editing
    if (_isEdit) {
      final a = widget.accessory!;
      _nameCtrl.text = a.name;
      _typeCtrl.text = a.type;
      _brandCtrl.text = a.brand ?? '';
      _purchaseCtrl.text = a.pricing.purchasePrice.toString();
      _sellingCtrl.text = a.pricing.sellingPrice.toString();
      _stockCtrl.text = a.stock.toString();
      _lowStockCtrl.text = a.lowStockThreshold.toString();
      _currency = a.currency;
      _selectedCategoryId = a.categoryId;
      _selectedSupplierId = a.supplierId;

      // Compatibility
      if (a.compatibility != null && a.compatibility!.isNotEmpty) {
        _compatibilityCtrl.text = a.compatibility!.join(', ');
      }

      // Attributes
      _attributes.clear();
      if (a.attributes != null && a.attributes!.isNotEmpty) {
        a.attributes!.forEach((key, value) {
          final row = AttributeRow();
          row.keyCtrl.text = key;
          row.valueCtrl.text = value?.toString() ?? '';
          _attributes.add(row);
        });
      } else {
        _attributes.add(AttributeRow());
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _typeCtrl.dispose();
    _brandCtrl.dispose();
    _purchaseCtrl.dispose();
    _sellingCtrl.dispose();
    _stockCtrl.dispose();
    _lowStockCtrl.dispose();
    _compatibilityCtrl.dispose();

    for (final a in _attributes) {
      a.keyCtrl.dispose();
      a.valueCtrl.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final title = _isEdit
        ? 'Edit: ${widget.accessory?.name ?? 'Accessory'}'
        : 'Add Accessory';

    final primaryLabel = _isEdit ? 'Update' : 'Create';

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 12.w,
          right: 12.w,
          top: 8.h,
          bottom: bottomInset,
        ),
        child: SizedBox(
          height: AppSize.height * 0.9,
          child: Column(
            children: [
              // handle
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
                text: title,
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
                        AccessoryBasicInfoSection(
                          nameCtrl: _nameCtrl,
                          typeCtrl: _typeCtrl,
                          brandCtrl: _brandCtrl,
                          purchaseCtrl: _purchaseCtrl,
                          sellingCtrl: _sellingCtrl,
                          stockCtrl: _stockCtrl,
                          lowStockCtrl: _lowStockCtrl,
                          currency: _currency,
                          onSelectCurrency: (val) =>
                              setState(() => _currency = val),
                          selectedCategoryId: _selectedCategoryId,
                          onSelectCategory: (val) =>
                              setState(() => _selectedCategoryId = val),
                          selectedSupplierId: _selectedSupplierId,
                          onSelectSupplier: (val) =>
                              setState(() => _selectedSupplierId = val),
                        ),
                        AccessoryCompatibilitySection(
                          compatibilityCtrl: _compatibilityCtrl,
                        ),
                        AccessoryAttributesSection(
                          attributes: _attributes,
                          onAddAttribute: () {
                            setState(() => _attributes.add(AttributeRow()));
                          },
                          onRemoveAttribute: (i) {
                            setState(() => _attributes.removeAt(i));
                          },
                        ),
                        Obx(
                          () {
                            final newImages = pickedImages.toList();

                            return ImagesSection(
                              existingImages: widget.accessory?.images ?? [],
                              pickedImages: newImages,
                              onPickImages: pickImages,
                              onRemoveExisting: (i) {
                                setState(() {
                                  widget.accessory?.images?.removeAt(i);
                                });
                              },
                              onRemovePicked: (i) {
                                pickedImages.removeAt(i);
                              },
                            );
                          },
                        ),
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
                              text: primaryLabel,
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

  //  IMAGE PICKING
  Future<bool> requestPhotoPermission() async {
    if (await Permission.photos.isGranted ||
        await Permission.photos.request().isGranted) return true;

    if (await Permission.storage.isGranted ||
        await Permission.storage.request().isGranted) return true;

    return false;
  }

  Future<void> pickImages() async {
    final ok = await requestPhotoPermission();
    if (!ok) {
      Get.snackbar("Permission denied", "You must allow photo access");
      return;
    }

    final imgs = await ImagePicker().pickMultiImage(imageQuality: 80);
    if (imgs.isNotEmpty) pickedImages.addAll(imgs);
  }

  //  SUBMIT
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      // BUILD INPUT MAP
      final name = _nameCtrl.text.trim();
      final type = _typeCtrl.text.trim();
      final brand =
          _brandCtrl.text.trim().isNotEmpty ? _brandCtrl.text.trim() : null;

      final purchasePrice = double.tryParse(_purchaseCtrl.text.trim()) ?? 0.0;
      final sellingPrice = double.tryParse(_sellingCtrl.text.trim()) ?? 0.0;

      final stock = int.tryParse(_stockCtrl.text.trim()) ?? 0;
      final lowStockThreshold = int.tryParse(_lowStockCtrl.text.trim()) ?? 10;

      final categoryId = _selectedCategoryId ?? "";
      final supplierId = _selectedSupplierId ?? "";

      // ATTRIBUTES
      final Map<String, dynamic> attributes = {};
      for (final row in _attributes) {
        final k = row.keyCtrl.text.trim();
        final v = row.valueCtrl.text.trim();
        if (k.isNotEmpty && v.isNotEmpty) {
          attributes[k] = v;
        }
      }

      // COMPATIBILITY
      List<String>? compatibility;
      if (_compatibilityCtrl.text.trim().isNotEmpty) {
        compatibility = _compatibilityCtrl.text
            .trim()
            .split(',')
            .map((x) => x.trim())
            .where((x) => x.isNotEmpty)
            .toList();
      }

      // CONTROLLER CALL
      bool ok = false;

      if (_isEdit && widget.accessory?.id != null) {
        ok = await _accessoryCtrl.updateAccessory(
          widget.accessory!.id!,
          name: name,
          type: type,
          brand: brand,
          purchasePrice: purchasePrice,
          sellingPrice: sellingPrice,
          currency: _currency,
          categoryId: categoryId,
          supplierId: supplierId,
          attributes: attributes.isNotEmpty ? attributes : null,
          compatibility: compatibility,
          imagePaths: pickedImages.isEmpty
              ? null
              : pickedImages.map((f) => f.path).toList(),
          stock: stock,
          lowStockThreshold: lowStockThreshold,
        );
      } else {
        ok = await _accessoryCtrl.createAccessory(
          name: name,
          type: type,
          brand: brand,
          purchasePrice: purchasePrice,
          sellingPrice: sellingPrice,
          currency: _currency,
          categoryId: categoryId,
          supplierId: supplierId,
          attributes: attributes.isNotEmpty ? attributes : null,
          compatibility: compatibility,
          imagePaths: pickedImages.isEmpty
              ? null
              : pickedImages.map((f) => f.path).toList(),
          stock: stock,
          lowStockThreshold: lowStockThreshold,
        );
      }

      // RESULT
      if (!ok) {
        AppSnackbar.error(
          title: "Error",
          message: _isEdit
              ? "Failed to update accessory"
              : "Failed to create accessory",
        );
        return;
      }

      AppSnackbar.success(
        title: _isEdit ? "Updated" : "Created",
        message: _isEdit
            ? "Accessory updated successfully"
            : "Accessory created successfully",
      );

      if (!mounted) return;
      Navigator.of(context).pop();

      Future.delayed(const Duration(milliseconds: 200), () {
        _accessoryCtrl.fetchAccessories(reset: true);
      });
    } catch (e, st) {
      print("Accessory submit error: $e\n$st");
      Get.snackbar("Error", e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
