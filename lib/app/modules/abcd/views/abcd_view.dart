import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/abcd_controller.dart';

class AbcdView extends GetView<AbcdController> {
  const AbcdView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AbcdView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AbcdView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
