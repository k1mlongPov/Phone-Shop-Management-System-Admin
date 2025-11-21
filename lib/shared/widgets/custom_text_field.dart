import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';
import 'package:phone_management_system_admin/shared/styles/app_style.dart';
import 'package:phone_management_system_admin/shared/widgets/reusable_text.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.keyboardType,
    this.controller,
    this.initialValue,
    this.hintText,
    this.label,
    this.errorText,
    this.onEditingComplete,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.maxLines = 1,
    this.readOnly = false,
    this.autovalidateMode,
    this.inputFormatters,
  }) : assert(controller == null || initialValue == null,
            'Cannot provide both a controller and an initialValue.');

  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final String? label;
  final String? errorText; // decoration override
  final VoidCallback? onEditingComplete;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final int maxLines;
  final bool readOnly;
  final AutovalidateMode? autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      keyboardType: keyboardType,
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      obscureText: obscureText,
      textInputAction: textInputAction,
      maxLines: maxLines,
      readOnly: readOnly,
      autovalidateMode: autovalidateMode,
      inputFormatters: inputFormatters,
      style: appStyle(14, AppColors.kDark, FontWeight.normal),
      validator: validator,
      cursorHeight: 16.h,
      cursorColor: AppColors.kPrimary,
      textAlignVertical: TextAlignVertical.center,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(width: .6, color: AppColors.kGray),
          borderRadius: BorderRadius.circular(12.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: .6, color: AppColors.kGray),
          borderRadius: BorderRadius.circular(12.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.kPrimary, width: 1.w),
          borderRadius: BorderRadius.circular(12.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: .6.w, color: AppColors.kRed),
          borderRadius: BorderRadius.circular(12.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: .6.w, color: AppColors.kRed),
          borderRadius: BorderRadius.circular(12.r),
        ),
        labelText: label,
        labelStyle: appStyle(12, AppColors.kGray, FontWeight.w600),
        hintText: hintText,
        hintStyle: appStyle(12, AppColors.kGray, FontWeight.normal),
        errorText: errorText,
        errorStyle: appStyle(12, Colors.red, FontWeight.normal),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      ),
    );
  }
}

/// Live validation wrapper that shows the error inside the decoration and also as a separate text below.
class CustomTextFieldWithError extends StatefulWidget {
  const CustomTextFieldWithError({
    super.key,
    required this.controller,
    this.hintText,
    this.label,
    this.keyboardType,
    this.validator,
    this.onEditingComplete,
    this.autovalidate = true,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback? onEditingComplete;
  final bool autovalidate;

  @override
  State<CustomTextFieldWithError> createState() =>
      _CustomTextFieldWithErrorState();
}

class _CustomTextFieldWithErrorState extends State<CustomTextFieldWithError> {
  String? errorText;

  @override
  void initState() {
    super.initState();
    if (widget.autovalidate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _validate(widget.controller.text);
      });
    }
  }

  void _validate(String value) {
    final res = widget.validator?.call(value);
    if (res != errorText) {
      setState(() => errorText = res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          hintText: widget.hintText,
          label: widget.label,
          onEditingComplete: widget.onEditingComplete,
          onChanged: (v) {
            if (widget.autovalidate) _validate(v);
          },
          errorText: errorText,
          autovalidateMode: widget.autovalidate
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
        ),
        if (errorText != null && errorText!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 6.h, left: 4.w),
            child: ReusableText(
              text: errorText!,
              style: appStyle(12, Colors.red, FontWeight.w600),
            ),
          ),
      ],
    );
  }
}
