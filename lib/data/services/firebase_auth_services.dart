// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  // Sign out
  Future<void> googleSignOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  static const String adminEmail = 'irfan@123';
  static const String adminPassword = 'irfan1010';
  // Sign up with email and password
  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Sign up error: $e");
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      // Check for admin credentials first
      if (email == adminEmail && password == adminPassword) {
        // Sign in with admin credentials
        UserCredential result = await _auth.signInWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword,
        );
        return result.user;
      } else {
        // Regular user sign in
        UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return result.user;
      }
    } catch (e) {
      print("Sign in error: $e");
      return null;
    }
  }

  // isAdmin
  bool isAdmin(User? user) {
    return user?.email == adminEmail;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
