import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';
import 'package:phone_management_system_admin/shared/widgets/custom_text_field.dart';
import 'package:phone_management_system_admin/shared/widgets/app_snackbar.dart';

import 'package:phone_management_system_admin/features/customers/domain/models/customer_model.dart';
import 'package:phone_management_system_admin/features/customers/logic/customers_controller.dart';

class CustomerFormBottomSheet extends StatefulWidget {
  final Customer? customer;

  const CustomerFormBottomSheet({super.key, this.customer});

  bool get isEdit => customer != null;

  @override
  State<CustomerFormBottomSheet> createState() =>
      _CustomerFormBottomSheetState();
}

class _CustomerFormBottomSheetState extends State<CustomerFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  bool _loading = false;
  late final CustomersController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<CustomersController>();

    if (widget.isEdit) {
      final c = widget.customer!;
      _nameCtrl.text = c.name;
      _phoneCtrl.text = c.phone ?? "";
      _emailCtrl.text = c.email ?? "";
      _addressCtrl.text = c.address ?? "";
      _notesCtrl.text = c.notes ?? "";
    }

    _ctrl.loadTabData();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
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
        "phone": _phoneCtrl.text.trim(),
        "email": _emailCtrl.text.trim(),
        "address": _addressCtrl.text.trim(),
        "notes": _notesCtrl.text.trim(),
      };

      if (!widget.isEdit) {
        // CREATE
        await _ctrl.createCustomer(
          Customer.fromJson(payload),
        );

        AppSnackbar.success(
          title: "Customer Created",
          message: "Customer added successfully",
        );
      } else {
        // UPDATE
        await _ctrl.updateCustomer(widget.customer!.id!, payload);

        AppSnackbar.success(
          title: "Customer Updated",
          message: "Customer updated successfully",
        );
      }

      if (!mounted) return;
      Navigator.pop(context);

      Future.delayed(const Duration(milliseconds: 200), () {
        _ctrl.loadTabData();
      });
    } catch (e) {
      AppSnackbar.error(title: "Error", message: e.toString());
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
          height: MediaQuery.of(context).size.height * 0.72,
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

              /// Title
              ReusableText(
                text: widget.isEdit ? "Edit Customer" : "New Customer",
                style: appStyle(16, AppColors.kDark, FontWeight.w600),
              ),
              const Divider(height: 20),

              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        /// NAME
                        CustomTextField(
                          controller: _nameCtrl,
                          label: "Full Name *",
                          validator: (v) => v == null || v.trim().isEmpty
                              ? "Name is required"
                              : null,
                        ),
                        SizedBox(height: 12.h),

                        /// PHONE
                        CustomTextField(
                          controller: _phoneCtrl,
                          label: "Phone Number *",
                          keyboardType: TextInputType.phone,
                          validator: (v) => v == null || v.trim().isEmpty
                              ? "Phone number required"
                              : null,
                        ),
                        SizedBox(height: 12.h),

                        /// EMAIL
                        CustomTextField(
                          controller: _emailCtrl,
                          label: "Email (optional)",
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 12.h),

                        /// ADDRESS
                        CustomTextField(
                          controller: _addressCtrl,
                          label: "Address",
                          maxLines: 2,
                        ),
                        SizedBox(height: 12.h),

                        /// NOTES
                        CustomTextField(
                          controller: _notesCtrl,
                          label: "Notes",
                          maxLines: 3,
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),

              const Divider(height: 20),

              /// BUTTONS
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
