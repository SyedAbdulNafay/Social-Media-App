import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../services/chat/chat_services.dart';

class UsersController extends GetxController {
  ChatServices cs = ChatServices();
  FirebaseAuth fba = FirebaseAuth.instance;
  var users = [].obs;

  Future<void> getUsers() async {
    cs.usersStream.listen((usersSnapshot) {
      users.value = usersSnapshot.docs;
    });
  }

  @override
  void onInit() {
    super.onInit();
    getUsers();
  }
}
