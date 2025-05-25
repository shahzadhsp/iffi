import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iffi_store/domain/repositories/auth_repository.dart';
import 'package:iffi_store/presentation/ui/sign_up/home/home_screen.dart';

class SignupController extends GetxController {
  final AuthRepository _authRepository;

  SignupController(this._authRepository);

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> signUp(String name, String email, String password) async {
    try {
      isLoading(true);
      errorMessage('');

      await _authRepository.signUpWithEmailAndPassword(name, email, password);

      Get.offAllNamed('/home'); // Navigate to home after successful signup
    } catch (e) {
      errorMessage(e.toString());
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      isLoading(true);
      errorMessage('');

      await _authRepository.signInWithGoogle();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      errorMessage(e.toString());
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }
}
