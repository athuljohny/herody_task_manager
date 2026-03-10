import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<UserCredential> signUpWithEmailAndPassword(
    String email,
    String password,
  );
  Future<void> signOut();
  User? get currentUser;
}
