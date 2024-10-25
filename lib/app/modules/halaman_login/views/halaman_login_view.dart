import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/controllers/auth_controller.dart';
import 'package:myapp/app/modules/halaman_daftar/views/halaman_daftar_view.dart';

class HalamanLoginView extends StatefulWidget {
  @override
  State<HalamanLoginView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<HalamanLoginView> {
  final AuthController _authController = Get.put(AuthController());
  final authC = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Light background
      appBar: AppBar(
        title: Text(
          'Login Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent, // AppBar color
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Text(
                "Login",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent, // Text color
                ),
              ),
              SizedBox(height: 40),
              // Email Input
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Password Input
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 40),
              // Login Button
              Obx(() {
                return ElevatedButton(
                  onPressed: () {
                    if (_emailController.text.isEmpty ||
                        _passwordController.text.isEmpty) {
                      Get.snackbar(
                          'Error', 'Email and password cannot be empty');
                    } else {
                      // Memanggil fungsi login jika validasi berhasil
                      authC.login(
                        _emailController.text,
                        _passwordController.text,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 80),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ), // Button color
                  ),
                  child: _authController.isLoading.value
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Text color
                          ),
                        ),
                );
              }),
              SizedBox(height: 20),
              // Register Redirect
              GestureDetector(
                onTap: () {
                  Get.to(HalamanDaftarView());
                },
                child: Text(
                  'Have you not an account? Register',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 22, 59),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
