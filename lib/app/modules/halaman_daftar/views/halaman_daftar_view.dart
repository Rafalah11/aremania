import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/halaman_daftar_controller.dart';

class HalamanDaftarView extends GetView<HalamanDaftarController> {
  const HalamanDaftarView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HalamanDaftarView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HalamanDaftarView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
