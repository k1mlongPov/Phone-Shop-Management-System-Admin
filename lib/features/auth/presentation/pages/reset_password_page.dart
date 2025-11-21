import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/features/auth/logic/auth_controller.dart';

class ResetPasswordPage extends StatefulWidget {
  final String token;
  final String email;

  const ResetPasswordPage(
      {super.key, required this.token, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final passController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: passController,
                validator: (v) => v!.length < 8 ? "Min 8 characters" : null,
                obscureText: true,
                decoration: const InputDecoration(labelText: "New Password"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text("Change Password"),
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;

                  // await auth.repository.resetPassword(
                  //   email: widget.email,
                  //   token: widget.token,
                  //   newPassword: passController.text,
                  // );

                  Get.snackbar("Success", "Password changed successfully");
                  Get.offAllNamed("/login");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
