import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/abc_controller.dart';

class AbcView extends GetView<AbcController> {
  const AbcView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AbcView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AbcView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
