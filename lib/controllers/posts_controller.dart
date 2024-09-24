import 'package:get/get.dart';
import 'package:social_media_app/models/database/posts_firestore.dart';

class PostsController extends GetxController {
  FirestoreDatabase db = FirestoreDatabase();
  var posts = [].obs;

  Future<void> getPosts() async {
    final querySnapShot = await db.getPostsFuture();
    posts.value = querySnapShot.docs;
  }

  @override
  void onInit() async {
    super.onInit();
    getPosts();
  }
}
