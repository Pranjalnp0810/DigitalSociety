import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_society/models/user_role.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var role = Rxn<UserRole>();
  var name = ''.obs;
  var houseNo = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      if (doc.exists) {
        name.value = doc['name'];
        houseNo.value = doc['houseNo'];
        role.value =
            doc['role'] == 'chairman' ? UserRole.chairman : UserRole.member;
      }
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    role.value = null;
    name.value = '';
    houseNo.value = '';
    Get.offAllNamed('/');
  }
}
