import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iffi_store/data/services/models/user_model.dart';
import 'package:iffi_store/domain/entities/user_entity.dart';
import 'package:iffi_store/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._firebaseAuth, this._firestore);

  @override
  Future<UserEntity> signUpWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Save user data to Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });

        return UserModel(
          id: userCredential.user!.uid,
          name: name,
          email: email,
        );
      }
      throw Exception('User is null after registration');
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw Exception('Google sign in cancelled');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      if (userCredential.user != null) {
        // Check if user exists in Firestore
        final userDoc =
            await _firestore
                .collection('users')
                .doc(userCredential.user!.uid)
                .get();

        if (!userDoc.exists) {
          // Save new user to Firestore
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
                'name': userCredential.user!.displayName ?? 'No Name',
                'email': userCredential.user!.email ?? '',
                'createdAt': FieldValue.serverTimestamp(),
              });
        }

        return UserModel(
          id: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? 'No Name',
          email: userCredential.user!.email ?? '',
        );
      }
      throw Exception('User is null after Google sign in');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Get additional user data from Firestore
        final userDoc =
            await _firestore
                .collection('users')
                .doc(userCredential.user!.uid)
                .get();

        if (userDoc.exists) {
          return UserModel(
            id: userCredential.user!.uid,
            name: userDoc.data()?['name'] ?? 'No Name',
            email: userCredential.user!.email ?? email,
          );
        } else {
          // If user document doesn't exist (legacy user), create one
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
                'name': userCredential.user!.displayName ?? 'No Name',
                'email': userCredential.user!.email ?? email,
                'createdAt': FieldValue.serverTimestamp(),
              });

          return UserModel(
            id: userCredential.user!.uid,
            name: userCredential.user!.displayName ?? 'No Name',
            email: userCredential.user!.email ?? email,
          );
        }
      }
      throw Exception('User is null after sign in');
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Authentication failed');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }
}
