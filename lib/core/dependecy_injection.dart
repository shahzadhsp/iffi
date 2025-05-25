import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iffi_store/data/repositories/user_repositoreis_impl.dart';
import 'package:iffi_store/domain/repositories/auth_repository.dart';
import 'package:iffi_store/presentation/controllers/login_controller.dart';
import 'package:iffi_store/presentation/controllers/sign_up_controller.dart';

Future<void> init() async {
  // Initialize Firebase
  await Firebase.initializeApp();

  // Repositories
  Get.lazyPut<AuthRepository>(
    () => AuthRepositoryImpl(FirebaseAuth.instance, FirebaseFirestore.instance),
    fenix: true,
  );

  // Controllers
  Get.lazyPut<SignupController>(
    () => SignupController(Get.find<AuthRepository>()),
    fenix: true,
  );
  Get.lazyPut<LoginController>(
    () => LoginController(Get.find<AuthRepository>()),
    fenix: true,
  );
}
