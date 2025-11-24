import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';
import 'package:phone_management_system_admin/features/inventory/logic/supplier_controller.dart';

class CreateSupplierBottomSheet extends StatefulWidget {
  const CreateSupplierBottomSheet({super.key});

  @override
  State<CreateSupplierBottomSheet> createState() =>
      _CreateSupplierBottomSheetState();
}

class _CreateSupplierBottomSheetState extends State<CreateSupplierBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  bool _loading = false;

  late final SupplierController _supCtrl;

  @override
  void initState() {
    super.initState();
    _supCtrl = Get.find<SupplierController>();
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
        // active = true by default (your backend)
        "active": true,
      };

      await _supCtrl.createSupplier(payload);
      Get.back(); // close bottom sheet
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
          top: 8.h,
          bottom: bottomInset,
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
                text: "Add Supplier",
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
                          hintText: "e.g. Kim Phones",
                          validator: (v) => v == null || v.trim().isEmpty
                              ? "Name is required"
                              : null,
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          controller: _contactCtrl,
                          label: "Contact Name",
                          hintText: "Person in charge",
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          controller: _phoneCtrl,
                          label: "Phone",
                          hintText: "e.g. 098 123 456",
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          controller: _emailCtrl,
                          label: "Email",
                          hintText: "example@email.com",
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          controller: _addressCtrl,
                          label: "Address",
                          hintText: "Street, City",
                          maxLines: 2,
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          controller: _notesCtrl,
                          label: "Notes",
                          hintText: "Optional notes",
                          maxLines: 3,
                        ),
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
                              ))
                          : ReusableText(
                              text: "Create",
                              style: appStyle(
                                  14, AppColors.kWhite, FontWeight.w500),
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
