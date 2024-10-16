import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controllers/chat_controller.dart';

class MyVoiceMessageButton extends StatelessWidget {
  final void Function()? onTap;
  const MyVoiceMessageButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10, bottom: 10, top: 5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Get.theme.colorScheme.inversePrimary),
        child: Obx(() => Icon(
              Icons.mic,
              color: controller.isRecording.value ? Colors.red : Colors.black,
            )),
      ),
    );
  }
}
