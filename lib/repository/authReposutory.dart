import 'package:farmacio_app/screens/home_screen.dart';
import 'package:farmacio_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late final Rx<User?> _firebaseUser;
  var verificationId = ''.obs;

  User? get firebaseUser => _firebaseUser.value;

  @override
  void onReady() {
    super.onReady();
    _firebaseUser = Rx<User?>(_firebaseAuth.currentUser);
    _firebaseUser.bindStream(_firebaseAuth.authStateChanges());
    setInitialScreen(_firebaseUser.value);
  }

  void setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      _firebaseUser.value != null
          ? Get.offAll(() => const HomeScreen())
          : Get.offAll(() => const LoginScreen());
    }
    on FirebaseAuthException catch (e) {
      final ex = SignUpFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    } catch (_) {
      const ex = SignUpFailure();
      print('EXCEPTION - ${ex.message}');
      throw ex;
    }
     
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String?> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("Usuario no encontrado");
        return 'Usuario no encontrado para o email';
      } else if (e.code == 'wrong-password') {
        print("Senha incorreta");
        return 'Senha incorreta.';
      } else if (e.code == 'invalid-email') {
        print("Email inválido: $email");
        return 'Email inválido.';
      } else if (e.code == 'network-request-failed') {
        print("Falha na conexao de rede");
        return 'Falha na conexao de rede.';
      } else {
        print("Erro nao tratado: ${e.message}");
        return "Ocorreu um erro inesperado. Por favor, tente novamente mais tarde.";
      }
    } catch (e) {
      print("Erro inesperado");
      return "Ocorreu um erro durante o login.";
    }
}

