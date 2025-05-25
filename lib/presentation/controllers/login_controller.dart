// login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iffi_store/domain/repositories/auth_repository.dart';
import 'package:iffi_store/presentation/ui/sign_up/home/home_screen.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository;

  LoginController(this._authRepository);

  final isLoading = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signIn(BuildContext context) async {
    try {
      isLoading(true);

      final user = await _authRepository.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        Get.snackbar('Success', 'Login Successful');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      isLoading(true);

      final user = await _authRepository.signInWithGoogle();

      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        Get.snackbar('Success', 'Login Successful');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
