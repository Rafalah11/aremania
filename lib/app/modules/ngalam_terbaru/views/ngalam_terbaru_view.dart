import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/ngalam_terbaru_controller.dart';

class NgalamTerbaruView extends GetView<NgalamTerbaruController> {
  const NgalamTerbaruView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NgalamTerbaruView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'NgalamTerbaruView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
