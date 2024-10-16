import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controllers/chat_controller.dart';

class MyVoiceMessageBubble extends StatelessWidget {
  final bool isCurrentUser;
  final String audioURL;
  final Timestamp timestamp;
  final String status;
  const MyVoiceMessageBubble({
    super.key,
    required this.isCurrentUser,
    required this.audioURL,
    required this.timestamp,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.find();
    DateTime dateTime = timestamp.toDate();

    return IntrinsicWidth(
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isCurrentUser
                ? Get.theme.colorScheme.inversePrimary
                : Get.theme.colorScheme.primary),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () async {
                      debugPrint("ENTERED");
                      await controller.playPauseAudio(audioURL);
                    },
                    icon: Icon(controller.isPlaying[audioURL] ?? false
                        ? Icons.pause
                        : Icons.play_arrow)),
                Expanded(
                    child: Obx(() => Slider(
                        min: 0,
                        max: controller
                            .getDuration(audioURL)
                            .inSeconds
                            .toDouble(),
                        value: controller
                            .getPosition(audioURL)
                            .inSeconds
                            .toDouble(),
                        onChanged: (value) {
                          controller.audioPlayers[audioURL]
                              ?.seek(Duration(seconds: value.toInt()));
                        })))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${dateTime.hour}:${dateTime.minute}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(
                  width: 4,
                ),
                isCurrentUser
                    ? Icon(
                        Icons.check,
                        color:
                            status == 'seen' ? Colors.blue[300] : Colors.grey,
                        size: 16,
                      )
                    : Container()
              ],
            )
          ],
        ),
      ),
    );
  }
}
