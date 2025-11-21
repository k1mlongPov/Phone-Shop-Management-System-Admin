import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/logic/category_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/phone_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/supplier_controller.dart';
import 'package:phone_management_system_admin/shared/constants/app_size.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

/// Local helper model just for the form UI
class _VariantFormData {
  final TextEditingController storageCtrl;
  final TextEditingController colorCtrl;
  final TextEditingController purchaseCtrl;
  final TextEditingController sellingCtrl;
  final TextEditingController stockCtrl;
  String condition;

  _VariantFormData({
    String? storage,
    String? color,
    String? purchase,
    String? selling,
    String? stock,
    this.condition = 'used',
  })  : storageCtrl = TextEditingController(text: storage),
        colorCtrl = TextEditingController(text: color),
        purchaseCtrl = TextEditingController(text: purchase),
        sellingCtrl = TextEditingController(text: selling),
        stockCtrl = TextEditingController(text: stock);
}

class CreatePhoneBottomSheet extends StatefulWidget {
  const CreatePhoneBottomSheet({super.key});

  @override
  State<CreatePhoneBottomSheet> createState() => _CreatePhoneBottomSheetState();
}

class _CreatePhoneBottomSheetState extends State<CreatePhoneBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  // controllers
  final _brandCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _purchaseCtrl = TextEditingController();
  final _sellingCtrl = TextEditingController();

  // specs
  final _osCtrl = TextEditingController();
  final _chipsetCtrl = TextEditingController();
  final _ramCtrl = TextEditingController();
  final _chargingCtrl = TextEditingController();

  // cameras
  final _mainCamCtrl = TextEditingController();
  final _frontCamCtrl = TextEditingController();

  // display
  final _displaySizeCtrl = TextEditingController();
  final _displayResCtrl = TextEditingController();
  final _displayTypeCtrl = TextEditingController();
  final _refreshRateCtrl = TextEditingController();

  // dropdowns
  String _currency = 'USD'; // USD / KHR
  String? _selectedCategoryId;
  String? _selectedSupplierId;

  // variants
  final List<_VariantFormData> _variants = [
    _VariantFormData(),
  ];

  // images
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _pickedImages = [];

  bool _isSubmitting = false;

  late final ApiService _api;
  late final PhoneController _phoneCtrl;
  late final CategoryController _catCtrl;
  late final SupplierController _supCtrl;

  @override
  void initState() {
    super.initState();
    _api = Get.find<ApiService>();
    _phoneCtrl = Get.find<PhoneController>();
    _catCtrl = Get.find<CategoryController>();
    _supCtrl = Get.find<SupplierController>();

    // Ensure categories & suppliers are loaded
    if (_catCtrl.rootCategories.isEmpty) {
      _catCtrl.loadRootCategories();
    }
    if (_supCtrl.suppliers.isEmpty) {
      _supCtrl.fetchSuppliers();
    }
  }

  @override
  void dispose() {
    _brandCtrl.dispose();
    _modelCtrl.dispose();
    _purchaseCtrl.dispose();
    _sellingCtrl.dispose();

    _osCtrl.dispose();
    _chipsetCtrl.dispose();
    _ramCtrl.dispose();
    _chargingCtrl.dispose();

    _mainCamCtrl.dispose();
    _frontCamCtrl.dispose();

    _displaySizeCtrl.dispose();
    _displayResCtrl.dispose();
    _displayTypeCtrl.dispose();
    _refreshRateCtrl.dispose();

    for (final v in _variants) {
      v.storageCtrl.dispose();
      v.colorCtrl.dispose();
      v.purchaseCtrl.dispose();
      v.sellingCtrl.dispose();
      v.stockCtrl.dispose();
    }
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
          height: AppSize.height * 0.9, // tall sheet
          child: Column(
            children: [
              // grab handle + title
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
                text: 'Add Phone',
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
                        _buildNormalDetails(),
                        SizedBox(height: 12.h),
                        _buildSpecsSection(),
                        SizedBox(height: 8.h),
                        _buildCameraSection(),
                        SizedBox(height: 8.h),
                        _buildDisplaySection(),
                        SizedBox(height: 8.h),
                        _buildVariantsSection(),
                        SizedBox(height: 8.h),
                        _buildImagesSection(),
                      ],
                    ),
                  ),
                ),
              ),

              const Divider(height: 1),
              SizedBox(height: 8.h),

              // ACTION BUTTONS
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

  // ---------------------------------------------------------------------------
  // NORMAL DETAILS
  // ---------------------------------------------------------------------------
  Widget _buildNormalDetails() {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: 'Basic Info',
            style: appStyle(14, AppColors.kDark, FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          CustomTextField(
            controller: _brandCtrl,
            label: 'Brand *',
            hintText: 'e.g. iPhone, Samsung',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Brand is required' : null,
          ),
          SizedBox(height: 10.h),
          CustomTextField(
            controller: _modelCtrl,
            label: 'Model *',
            hintText: 'e.g. 13 Pro Max',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Model is required' : null,
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _purchaseCtrl,
                  label: 'Purchase price *',
                  hintText: '0',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Required';
                    }
                    final d = double.tryParse(v);
                    if (d == null) return 'Invalid';
                    if (d < 0) return 'Must be >= 0';
                    return null;
                  },
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: CustomTextField(
                  controller: _sellingCtrl,
                  label: 'Selling price *',
                  hintText: '0',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Required';
                    }
                    final d = double.tryParse(v);
                    if (d == null) return 'Invalid';
                    if (d < 0) return 'Must be >= 0';
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _currency,
                  decoration: InputDecoration(
                    labelText: 'Currency',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'USD',
                      child: Text('USD (\$)'),
                    ),
                    DropdownMenuItem(
                      value: 'KHR',
                      child: Text('KHR (៛)'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _currency = val);
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          // Category & Supplier dropdowns
          GetX<CategoryController>(
            builder: (cat) {
              final subs = cat.subcategories;
              return DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                decoration: InputDecoration(
                  labelText: 'Category (subcategory)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('None'),
                  ),
                  ...subs.map(
                    (c) => DropdownMenuItem(
                      value: c.id,
                      child: Text(c.name ?? ''),
                    ),
                  ),
                ],
                onChanged: (val) {
                  setState(() => _selectedCategoryId = val);
                },
              );
            },
          ),
          SizedBox(height: 10.h),
          GetX<SupplierController>(
            builder: (sup) {
              final list = sup.suppliers;
              return DropdownButtonFormField<String>(
                value: _selectedSupplierId,
                decoration: InputDecoration(
                  labelText: 'Supplier (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('None'),
                  ),
                  ...list.map(
                    (s) => DropdownMenuItem(
                      value: s.id,
                      child: Text(s.name ?? ''),
                    ),
                  ),
                ],
                onChanged: (val) {
                  setState(() => _selectedSupplierId = val);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SPECS
  // ---------------------------------------------------------------------------
  Widget _buildSpecsSection() {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: ReusableText(
        text: 'Specifications (optional)',
        style: appStyle(14, AppColors.kDark, FontWeight.w600),
      ),
      children: [
        SizedBox(height: 4.h),
        CustomTextField(
          controller: _osCtrl,
          label: 'OS',
          hintText: 'e.g. iOS 18, Android 14',
        ),
        SizedBox(height: 8.h),
        CustomTextField(
          controller: _chipsetCtrl,
          label: 'Chipset',
          hintText: 'e.g. A15 Bionic, Snapdragon 8 Gen 2',
        ),
        SizedBox(height: 8.h),
        CustomTextField(
          controller: _ramCtrl,
          label: 'RAM (GB)',
          keyboardType: TextInputType.number,
          hintText: 'e.g. 8',
        ),
        SizedBox(height: 8.h),
        CustomTextField(
          controller: _chargingCtrl,
          label: 'Charging (Watt)',
          keyboardType: TextInputType.number,
          hintText: 'e.g. 67',
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // CAMERA
  // ---------------------------------------------------------------------------
  Widget _buildCameraSection() {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: ReusableText(
        text: 'Camera (optional)',
        style: appStyle(14, AppColors.kDark, FontWeight.w600),
      ),
      children: [
        SizedBox(height: 4.h),
        CustomTextField(
          controller: _mainCamCtrl,
          label: 'Main camera',
          hintText: 'e.g. 50MP f/1.8 OIS',
        ),
        SizedBox(height: 8.h),
        CustomTextField(
          controller: _frontCamCtrl,
          label: 'Front camera',
          hintText: 'e.g. 16MP selfie',
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // DISPLAY
  // ---------------------------------------------------------------------------
  Widget _buildDisplaySection() {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: ReusableText(
        text: 'Display (optional)',
        style: appStyle(14, AppColors.kDark, FontWeight.w600),
      ),
      children: [
        SizedBox(height: 4.h),
        CustomTextField(
          controller: _displaySizeCtrl,
          label: 'Size (inches)',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          hintText: 'e.g. 6.7',
        ),
        SizedBox(height: 8.h),
        CustomTextField(
          controller: _displayResCtrl,
          label: 'Resolution',
          hintText: 'e.g. 1080x2400',
        ),
        SizedBox(height: 8.h),
        CustomTextField(
          controller: _displayTypeCtrl,
          label: 'Type',
          hintText: 'e.g. AMOLED, IPS',
        ),
        SizedBox(height: 8.h),
        CustomTextField(
          controller: _refreshRateCtrl,
          label: 'Refresh rate (Hz)',
          keyboardType: TextInputType.number,
          hintText: 'e.g. 120',
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // VARIANTS
  // ---------------------------------------------------------------------------
  Widget _buildVariantsSection() {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: 'Variants',
            style: appStyle(14, AppColors.kDark, FontWeight.w600),
          ),
          SizedBox(height: 6.h),
          Text(
            'Add multiple storage / color / condition options. Each variant has its own price & stock.',
            style: appStyle(11, AppColors.kGray, FontWeight.w400),
          ),
          SizedBox(height: 10.h),
          // list of variant cards
          Column(
            children: List.generate(_variants.length, (i) {
              final v = _variants[i];
              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.grey.shade300, width: 0.6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ReusableText(
                          text: 'Variant ${i + 1}',
                          style: appStyle(13, AppColors.kDark, FontWeight.w600),
                        ),
                        const Spacer(),
                        if (_variants.length > 1)
                          IconButton(
                            icon: Icon(Icons.delete_outline,
                                size: 20.r, color: AppColors.kRed),
                            onPressed: () {
                              setState(() {
                                _variants.removeAt(i);
                              });
                            },
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: v.storageCtrl,
                            label: 'Storage',
                            hintText: 'e.g. 128GB',
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: CustomTextField(
                            controller: v.colorCtrl,
                            label: 'Color',
                            hintText: 'e.g. Black',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: v.purchaseCtrl,
                            label: 'Purchase',
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            hintText: '0',
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: CustomTextField(
                            controller: v.sellingCtrl,
                            label: 'Selling',
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            hintText: '0',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: v.stockCtrl,
                            label: 'Stock',
                            keyboardType: TextInputType.number,
                            hintText: '0',
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _buildConditionChips(v),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
          SizedBox(height: 4.h),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _variants.add(_VariantFormData());
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('Add variant'),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionChips(_VariantFormData v) {
    const conditions = ['used', 'new', 'imported'];
    const labels = ['Used', 'New', 'Imported'];

    return Wrap(
      spacing: 4.w,
      children: List.generate(conditions.length, (index) {
        final c = conditions[index];
        final selected = v.condition == c;
        return ChoiceChip(
          label: Text(labels[index]),
          selected: selected,
          onSelected: (val) {
            setState(() {
              v.condition = c;
            });
          },
        );
      }),
    );
  }

  // ---------------------------------------------------------------------------
  // IMAGES
  // ---------------------------------------------------------------------------
  Widget _buildImagesSection() {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: 'Images',
            style: appStyle(14, AppColors.kDark, FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              ..._pickedImages.map(
                (x) => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.file(
                        File(x.path),
                        width: 70.w,
                        height: 70.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 2,
                      top: 2,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _pickedImages.remove(x);
                          });
                        },
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
                ),
              ),
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  width: 70.w,
                  height: 70.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.grey.shade400),
                    color: Colors.grey.shade100,
                  ),
                  child: const Icon(Icons.add_a_photo_outlined),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickImages() async {
    final res = await _picker.pickMultiImage();
    if (res.isNotEmpty) {
      setState(() {
        _pickedImages.addAll(res);
      });
    }
  }

  // ---------------------------------------------------------------------------
  // SUBMIT
  // ---------------------------------------------------------------------------
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final form = dio.FormData();

      // base fields
      form.fields.addAll([
        MapEntry('brand', _brandCtrl.text.trim()),
        MapEntry('model', _modelCtrl.text.trim()),
        MapEntry(
            'pricing[purchasePrice]',
            _purchaseCtrl.text.trim().isEmpty
                ? '0'
                : _purchaseCtrl.text.trim()),
        MapEntry('pricing[sellingPrice]',
            _sellingCtrl.text.trim().isEmpty ? '0' : _sellingCtrl.text.trim()),
        MapEntry('currency', _currency),
      ]);

      if (_selectedCategoryId != null && _selectedCategoryId!.isNotEmpty) {
        form.fields.add(MapEntry('category', _selectedCategoryId!));
      }
      if (_selectedSupplierId != null && _selectedSupplierId!.isNotEmpty) {
        form.fields.add(MapEntry('supplier', _selectedSupplierId!));
      }

      // specs
      if (_osCtrl.text.trim().isNotEmpty) {
        form.fields.add(MapEntry('specs[os]', _osCtrl.text.trim()));
      }
      if (_chipsetCtrl.text.trim().isNotEmpty) {
        form.fields.add(MapEntry('specs[chipset]', _chipsetCtrl.text.trim()));
      }
      if (_ramCtrl.text.trim().isNotEmpty) {
        form.fields.add(MapEntry('specs[ram]', _ramCtrl.text.trim()));
      }
      if (_chargingCtrl.text.trim().isNotEmpty) {
        form.fields
            .add(MapEntry('specs[chargingW]', _chargingCtrl.text.trim()));
      }

      // cameras
      if (_mainCamCtrl.text.trim().isNotEmpty) {
        form.fields
            .add(MapEntry('specs[cameras][main]', _mainCamCtrl.text.trim()));
      }
      if (_frontCamCtrl.text.trim().isNotEmpty) {
        form.fields
            .add(MapEntry('specs[cameras][front]', _frontCamCtrl.text.trim()));
      }

      // display
      if (_displaySizeCtrl.text.trim().isNotEmpty) {
        form.fields.add(
            MapEntry('specs[display][sizeIn]', _displaySizeCtrl.text.trim()));
      }
      if (_displayResCtrl.text.trim().isNotEmpty) {
        form.fields.add(MapEntry(
            'specs[display][resolution]', _displayResCtrl.text.trim()));
      }
      if (_displayTypeCtrl.text.trim().isNotEmpty) {
        form.fields.add(
            MapEntry('specs[display][type]', _displayTypeCtrl.text.trim()));
      }
      if (_refreshRateCtrl.text.trim().isNotEmpty) {
        form.fields.add(MapEntry(
            'specs[display][refreshRate]', _refreshRateCtrl.text.trim()));
      }

      // variants
      for (int i = 0; i < _variants.length; i++) {
        final v = _variants[i];
        final prefix = 'variants[$i]';

        if (v.storageCtrl.text.trim().isNotEmpty) {
          form.fields
              .add(MapEntry('$prefix[storage]', v.storageCtrl.text.trim()));
        }
        if (v.colorCtrl.text.trim().isNotEmpty) {
          form.fields.add(MapEntry('$prefix[color]', v.colorCtrl.text.trim()));
        }

        if (v.purchaseCtrl.text.trim().isNotEmpty) {
          form.fields.add(MapEntry(
              '$prefix[pricing][purchasePrice]', v.purchaseCtrl.text.trim()));
        }
        if (v.sellingCtrl.text.trim().isNotEmpty) {
          form.fields.add(MapEntry(
              '$prefix[pricing][sellingPrice]', v.sellingCtrl.text.trim()));
        }
        if (v.stockCtrl.text.trim().isNotEmpty) {
          form.fields.add(MapEntry('$prefix[stock]', v.stockCtrl.text.trim()));
        }

        // condition: "used" | "new" | "imported"
        form.fields.add(MapEntry('$prefix[condition]', v.condition));
      }

      // images
      for (final x in _pickedImages) {
        final file = await dio.MultipartFile.fromFile(
          x.path,
          filename: x.name,
        );

        form.files.add(
          MapEntry('images', file),
        );
      }

      // call backend
      final res = await _api.post('/api/phones', form);
      final data = res.data;
      final success = (data is Map && data['success'] == true);

      if (!success) {
        Get.snackbar('Error', 'Failed to create phone');
      } else {
        Get.snackbar('Created', 'Phone created successfully');
        // refresh list
        await _phoneCtrl.fetchPhones(reset: true);
        Get.back(); // close bottom sheet
      }
    } catch (e, st) {
      print('CreatePhoneBottomSheet submit error: $e\n$st');
      Get.snackbar('Error', e.toString());
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
