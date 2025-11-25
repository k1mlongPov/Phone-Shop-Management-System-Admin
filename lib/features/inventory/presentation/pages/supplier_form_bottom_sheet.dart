import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/widgets/app_snackbar.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';
import 'package:phone_management_system_admin/features/inventory/logic/supplier_controller.dart';
import 'package:phone_management_system_admin/features/inventory/domain/models/supplier_model.dart';

class SupplierFormBottomSheet extends StatefulWidget {
  final SupplierModel? supplier; // null = create, not null = update

  const SupplierFormBottomSheet({super.key, this.supplier});

  bool get isEdit => supplier != null;

  @override
  State<SupplierFormBottomSheet> createState() =>
      _SupplierFormBottomSheetState();
}

class _SupplierFormBottomSheetState extends State<SupplierFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  bool _loading = false;
  bool _isActive = true; // Only used in edit mode

  late final SupplierController _supCtrl;

  @override
  void initState() {
    super.initState();
    _supCtrl = Get.find<SupplierController>();

    if (widget.isEdit) {
      final s = widget.supplier!;
      _nameCtrl.text = s.name ?? "";
      _contactCtrl.text = s.contactName ?? "";
      _phoneCtrl.text = s.phone ?? "";
      _emailCtrl.text = s.email ?? "";
      _addressCtrl.text = s.address ?? "";
      _notesCtrl.text = s.notes ?? "";
      _isActive = s.active;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _contactCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final payload = {
        "name": _nameCtrl.text.trim(),
        "contactName": _contactCtrl.text.trim(),
        "phone": _phoneCtrl.text.trim(),
        "email": _emailCtrl.text.trim(),
        "address": _addressCtrl.text.trim(),
        "notes": _notesCtrl.text.trim(),
        "active": widget.supplier == null ? true : _isActive,
      };

      SupplierModel? result;

      if (widget.supplier == null) {
        result = await _supCtrl.createSupplier(payload);
      } else {
        result = await _supCtrl.updateSupplier(widget.supplier!.id!, payload);
      }

      if (result == null) {
        AppSnackbar.error(
          title: "Error",
          message: widget.supplier == null
              ? "Failed to create supplier"
              : "Failed to update supplier",
        );
        return;
      }

      AppSnackbar.success(
        title: widget.supplier == null ? "Created" : "Updated",
        message: widget.supplier == null
            ? "Supplier created successfully"
            : "Supplier updated successfully",
      );

      if (!mounted) return;
      Navigator.pop(context, result);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 12.w,
          right: 12.w,
          bottom: bottomInset,
          top: 8.h,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              SizedBox(height: 6.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(height: 8.h),
              ReusableText(
                text: widget.isEdit ? "Edit Supplier" : "Add Supplier",
                style: appStyle(16, AppColors.kDark, FontWeight.w600),
              ),
              const Divider(height: 20),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _nameCtrl,
                          label: "Supplier Name *",
                          validator: (v) => v == null || v.trim().isEmpty
                              ? "Name is required"
                              : null,
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          controller: _contactCtrl,
                          label: "Contact Name",
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          controller: _phoneCtrl,
                          label: "Phone",
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          controller: _emailCtrl,
                          label: "Email",
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          controller: _addressCtrl,
                          label: "Address",
                          maxLines: 2,
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          controller: _notesCtrl,
                          label: "Notes",
                          maxLines: 3,
                        ),

                        /// ACTIVE / INACTIVE TOGGLE
                        if (widget.isEdit) ...[
                          SizedBox(height: 20.h),
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: AppColors.kWhite,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.05),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ReusableText(
                                  text: "Status",
                                  style: appStyle(
                                      14, AppColors.kDark, FontWeight.w600),
                                ),
                                Switch(
                                  value: _isActive,
                                  activeColor: AppColors.kPrimary,
                                  onChanged: (v) {
                                    setState(() => _isActive = v);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _loading ? null : () => Get.back(),
                      child: ReusableText(
                        text: "Cancel",
                        style: appStyle(14, AppColors.kDark, FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: _loading ? null : _submit,
                      child: _loading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : ReusableText(
                              text: widget.isEdit ? "Update" : "Create",
                              style: appStyle(
                                14,
                                AppColors.kWhite,
                                FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
