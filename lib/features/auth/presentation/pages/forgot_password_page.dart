import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_management_system_admin/features/auth/logic/auth_controller.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final AuthController auth = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) => v!.isEmpty ? "Email cannot be empty" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text("Send Reset Link"),
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;

                  // await auth.repository
                  //     .requestPasswordReset(emailController.text);

                  Get.snackbar("Success",
                      "If email exists, a reset link has been sent.");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
