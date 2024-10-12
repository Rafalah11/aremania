import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/halaman_login_controller.dart';

class HalamanLoginView extends GetView<HalamanLoginController> {
  const HalamanLoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HalamanLoginView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HalamanLoginView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
