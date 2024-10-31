import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ubah_kata_sandi_controller.dart';

class UbahKataSandiView extends GetView<UbahKataSandiController> {
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final statusMessage = ''.obs; // Observable untuk menampilkan pesan status

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Kata Sandi'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Masukkan email Anda',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.trim();
                if (email.isNotEmpty) {
                  // Memanggil resetPassword di controller
                  AuthStatus status =
                      await controller.resetPassword(email: email);
                  if (status == AuthStatus.successful) {
                    statusMessage.value =
                        "Email reset password berhasil dikirim.";
                    await Future.delayed(Duration(seconds: 2));
                    Get.back();
                  } else {
                    statusMessage.value =
                        "Gagal mengirim email reset password.";
                  }
                } else {
                  statusMessage.value = "Email tidak boleh kosong.";
                }
              },
              child: const Text('Reset Password'),
            ),
            const SizedBox(height: 20),
            Obx(() => Text(
                  statusMessage.value,
                  style: TextStyle(
                    color: statusMessage.value.contains('berhasil')
                        ? Colors.green
                        : Colors.red,
                    fontSize: 16,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
