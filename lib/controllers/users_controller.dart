import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controllers/profile_controller.dart';

import '../services/chat/chat_services.dart';

class UsersController extends GetxController {
  ChatServices cs = ChatServices();
  FirebaseAuth fba = FirebaseAuth.instance;
  ProfileController? profileController;
  var users = [].obs;

  UsersController() {
    profileController = Get.put(ProfileController());
  }

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
