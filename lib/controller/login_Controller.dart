import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  
  final email = ''.obs;
  final password = ''.obs;

  void setEmail(String value) {
    email.value = value;
  }

  void setPassword(String value) {
    password.value = value;
  }
}