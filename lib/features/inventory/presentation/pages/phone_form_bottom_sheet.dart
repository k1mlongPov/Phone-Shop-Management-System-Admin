import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:phone_management_system_admin/core/services/api_service.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/phone_model.dart';
import 'package:phone_management_system_admin/features/inventory/logic/category_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/phone_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/subcategory_controller.dart';
import 'package:phone_management_system_admin/features/inventory/logic/supplier_controller.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/phone_widgets/camera_section.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/phone_widgets/display_section.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/images_section.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/phone_widgets/phone_basic_info_section.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/phone_widgets/phone_specs_section.dart';
import 'package:phone_management_system_admin/features/inventory/presentation/widgets/phone_widgets/variants_section.dart';
import 'package:phone_management_system_admin/shared/constants/app_size.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/app_snackbar.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

/// Local helper to hold variant form fields
class _VariantFormData {
  final TextEditingController storageCtrl;
  final TextEditingController colorCtrl;
  final TextEditingController purchaseCtrl;
  final TextEditingController sellingCtrl;
  final TextEditingController stockCtrl;
  String condition; // stored as ui-value: new | imported | used

  _VariantFormData({
    String? storage,
    String? color,
    String? purchase,
    String? selling,
    String? stock,
    dynamic condition, // may be backend value or UI value
  })  : storageCtrl = TextEditingController(text: storage),
        colorCtrl = TextEditingController(text: color),
        purchaseCtrl = TextEditingController(text: purchase),
        sellingCtrl = TextEditingController(text: selling),
        stockCtrl = TextEditingController(text: stock),
        condition = normalizeCondition(condition);

  /// Convert backend → UI values.
  static String normalizeCondition(dynamic c) {
    if (c == null) return 'new';

    final raw = c.toString().toLowerCase();

    if (raw.contains("company") || raw == "new_company") return "new";
    if (raw.contains("import") || raw == "new_import") return "imported";
    if (raw.contains("used") || raw == "used_local") return "used";

    return "new"; // fallback
  }
}

class PhoneFormBottomSheet extends StatefulWidget {
  /// If [phone] is null → create
  /// If [phone] is not null → edit
  final Phone? phone;

  const PhoneFormBottomSheet({super.key, this.phone});

  @override
  State<PhoneFormBottomSheet> createState() => _PhoneFormBottomSheetState();
}

class _PhoneFormBottomSheetState extends State<PhoneFormBottomSheet> {
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
  String _currency = 'USD';
  String? _selectedCategoryId;
  String? _selectedSupplierId;

  // variants
  final List<_VariantFormData> _variants = [];

  // images (new picked only – existing images stay on server)
  final ImagePicker picker = ImagePicker();
  final RxList<XFile> pickedImages = <XFile>[].obs;

  bool _isSubmitting = false;

  late final ApiService _api;
  late final PhoneController _phoneCtrl;
  late final CategoryController _catCtrl;
  late final SupplierController _supCtrl;

  bool get _isEdit => widget.phone != null;

  @override
  void initState() {
    super.initState();
    _api = Get.find<ApiService>();
    _phoneCtrl = Get.find<PhoneController>();
    _catCtrl = Get.find<CategoryController>();
    _supCtrl = Get.find<SupplierController>();
    final subCtrl = Get.find<SubCategoryController>();

    if (_catCtrl.rootCategories.isEmpty) {
      _catCtrl.loadRootCategories();
    }
    if (_supCtrl.suppliers.isEmpty) {
      _supCtrl.fetchSuppliers();
    }

    _initFromPhoneIfEdit();
    subCtrl.activeParentId.value = subCtrl.phoneParentId;
  }

  void _initFromPhoneIfEdit() {
    final p = widget.phone;
    if (p == null) {
      // create mode, start with empty one variant
      _variants.add(_VariantFormData());
      return;
    }

    // basic
    _brandCtrl.text = p.brand;
    _modelCtrl.text = p.model;
    _purchaseCtrl.text = p.pricing.purchasePrice.toString();
    _sellingCtrl.text = p.pricing.sellingPrice.toString();
    _currency = p.currency ?? 'USD';
    _selectedCategoryId = p.category;
    _selectedSupplierId = p.supplier;

    // specs
    _osCtrl.text = p.specs?.os ?? '';
    _chipsetCtrl.text = p.specs?.chipset ?? '';
    if (p.specs?.ram != null) {
      _ramCtrl.text = p.specs!.ram.toString();
    }
    if (p.specs?.chargingW != null) {
      _chargingCtrl.text = p.specs!.chargingW.toString();
    }

    // cameras
    _mainCamCtrl.text = p.specs?.cameras?.main ?? '';
    _frontCamCtrl.text = p.specs?.cameras?.front ?? '';

    // display
    if (p.specs?.display?.sizeIn != null) {
      _displaySizeCtrl.text = p.specs!.display!.sizeIn.toString();
    }
    _displayResCtrl.text = p.specs?.display?.resolution ?? '';
    _displayTypeCtrl.text = p.specs?.display?.type ?? '';
    if (p.specs?.display?.refreshRate != null) {
      _refreshRateCtrl.text = p.specs!.display!.refreshRate.toString();
    }

    // variants
    if (p.variants != null && p.variants!.isNotEmpty) {
      for (final v in p.variants!) {
        _variants.add(
          _VariantFormData(
            storage: v.storage,
            color: v.color,
            purchase: v.pricing?.purchasePrice.toString(),
            selling: v.pricing?.sellingPrice.toString(),
            stock: v.stock?.toString(),
            condition: v.condition, // String? from model
          ),
        );
      }
    } else {
      _variants.add(_VariantFormData());
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

    final title = _isEdit
        ? 'Edit: ${widget.phone!.brand} ${widget.phone!.model}'
        : 'Add Phone';

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
                        PhoneBasicInfoSection(
                          brandCtrl: _brandCtrl,
                          modelCtrl: _modelCtrl,
                          purchaseCtrl: _purchaseCtrl,
                          sellingCtrl: _sellingCtrl,
                          currency: _currency,
                          onCurrencyChanged: (val) {
                            setState(() => _currency = val);
                          },
                          selectedCategoryId: _selectedCategoryId,
                          onCategoryChanged: (val) {
                            setState(() => _selectedCategoryId = val);
                          },
                          selectedSupplierId: _selectedSupplierId,
                          onSupplierChanged: (val) {
                            setState(() => _selectedSupplierId = val);
                          },
                        ),
                        SpecsSection(
                          osCtrl: _osCtrl,
                          chipsetCtrl: _chipsetCtrl,
                          ramCtrl: _ramCtrl,
                          chargingCtrl: _chargingCtrl,
                        ),
                        CameraSection(
                          mainCamCtrl: _mainCamCtrl,
                          frontCamCtrl: _frontCamCtrl,
                        ),
                        DisplaySection(
                          sizeCtrl: _displaySizeCtrl,
                          resCtrl: _displayResCtrl,
                          typeCtrl: _displayTypeCtrl,
                          refreshCtrl: _refreshRateCtrl,
                        ),
                        VariantsSection(
                          variants: _variants,
                          onAddVariant: () {
                            setState(() {
                              _variants.add(_VariantFormData());
                            });
                          },
                          onRemoveVariant: (index) {
                            setState(() {
                              _variants.removeAt(index);
                            });
                          },
                          onChangeCondition: (index, condition) {
                            setState(() {
                              _variants[index].condition = condition;
                            });
                          },
                        ),
                        Obx(
                          () {
                            final newImages = pickedImages.toList();

                            return ImagesSection(
                              existingImages: widget.phone?.images ?? [],
                              pickedImages: newImages,
                              onPickImages: pickImages,
                              onRemoveExisting: (i) {
                                setState(() {
                                  widget.phone?.images?.removeAt(i);
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
                              text: _isEdit ? 'Save changes' : 'Create',
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

  // ----------------------------------------------------
  // IMAGE PICKER
  // ----------------------------------------------------
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

  void removeImage(int index) {
    pickedImages.removeAt(index);
  }

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
          _purchaseCtrl.text.trim().isEmpty ? '0' : _purchaseCtrl.text.trim(),
        ),
        MapEntry(
          'pricing[sellingPrice]',
          _sellingCtrl.text.trim().isEmpty ? '0' : _sellingCtrl.text.trim(),
        ),
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
        String mapConditionForBackend(String uiValue) {
          switch (uiValue) {
            case 'new':
              return 'new_company';
            case 'imported':
              return 'new_import';
            case 'used':
              return 'used_local';
            default:
              return 'new_company';
          }
        }

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

        form.fields.add(
          MapEntry('$prefix[condition]', mapConditionForBackend(v.condition)),
        );
      }

      // new images
      for (final x in pickedImages) {
        final file = await dio.MultipartFile.fromFile(
          x.path,
          filename: x.name,
        );
        form.files.add(MapEntry('images', file));
      }

      dio.Response res;
      if (_isEdit && widget.phone?.id != null) {
        // UPDATE
        res = await _api.put('/api/phones/${widget.phone!.id}', form);
      } else {
        // CREATE
        res = await _api.post('/api/phones', form);
      }

      final data = res.data;
      final success = (data is Map && data['success'] == true);

      if (!success) {
        AppSnackbar.error(
            title: 'Error',
            message:
                _isEdit ? 'Failed to update phone' : 'Failed to create phone');
      } else {
        // refresh list from server
        await _phoneCtrl.fetchPhones(reset: true);
        if (success) {
          AppSnackbar.success(
            title: 'Success',
            message: _isEdit
                ? 'Phone updated successfully'
                : 'Phone created successfully',
          );

          if (!mounted) return;
          Navigator.of(context).pop();

          Future.delayed(const Duration(milliseconds: 200), () {
            _phoneCtrl.fetchPhones(reset: true);
          });
        }
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
