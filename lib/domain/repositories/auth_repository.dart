import 'package:iffi_store/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signUpWithEmailAndPassword(
    String name,
    String email,
    String password,
  );

  Future<UserEntity> signInWithGoogle();

  Future<void> signOut();

  Future<UserEntity> signInWithEmailAndPassword(String email, String password);
}
