import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../domain/repositories/auth_repository.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import 'task_controller.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  AuthController(this._authRepository);

  final Rx<User?> _user = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  User? get user => _user.value;

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(_authRepository.authStateChanges);
  }

  Future<void> signUp(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Email and password cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading(true);
    try {
      await _authRepository.signUpWithEmailAndPassword(email, password);
      Get.offAll(() => const HomePage());
    } on FirebaseAuthException catch (e) {
      String message = "Sign up failed.";
      if (e.code == 'email-already-in-use') {
        message = "This email is already registered.";
      } else if (e.code == 'weak-password') {
        message = "Password is too weak (min. 6 characters).";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email address.";
      }
      Get.snackbar("Error", message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<void> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Email and password cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading(true);
    try {
      await _authRepository.signInWithEmailAndPassword(email, password);
      Get.offAll(() => const HomePage());
    } on FirebaseAuthException catch (e) {
      String message = "Sign in failed.";
      if (e.code == 'user-not-found') {
        message = "No account found with this email.";
      } else if (e.code == 'wrong-password') {
        message = "Incorrect password.";
      } else if (e.code == 'invalid-credential') {
        message = "Invalid credentials. Check email and password.";
      }
      Get.snackbar("Error", message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading(true);
    try {
      await _authRepository.signInWithGoogle();
      Get.offAll(() => const HomePage());
    } on FirebaseAuthException catch (e) {
      String message = "Sign in failed.";
      if (e.code == 'ERROR_ABORTED_BY_USER') {
        message = "Sign in was cancelled.";
      }
      Get.snackbar("Error", message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      // Clear tasks so the next user doesn't see stale data
      Get.find<TaskController>().tasks.clear();
      await _authRepository.signOut();
      Get.offAll(() => const LoginPage());
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to sign out: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
