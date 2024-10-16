import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:social_media_app/models/message.dart';
import 'package:social_media_app/services/chat/chat_services.dart';
import 'package:path/path.dart' as p;

class ChatController extends GetxController {
  final ChatServices cs = ChatServices();
  final FirebaseAuth fba = FirebaseAuth.instance;
  final AudioRecorder audioRecorder = AudioRecorder();
  final String imageURL;
  final String userID;
  final String receiverUsername;
  final String receiverID;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  var isMessageFieldEmpty = true.obs;
  final FocusNode messageFocusNode = FocusNode();

  ChatController({
    required this.imageURL,
    required this.receiverID,
    required this.userID,
    required this.receiverUsername,
  });

  var messages = [].obs;
  var replyMessage = Rxn<Message?>();
  var recordingPath = Rxn<String?>();
  var isRecording = false.obs;
  // var isPlaying = false.obs;

  var audioPlayers = <String, AudioPlayer>{}.obs;
  var durations = <String, Duration>{}.obs;
  var positions = <String, Duration>{}.obs;
  var isPlaying = <String, bool>{}.obs;

  Future<void> getMessages() async {
    cs.getMessages(userID, receiverID).listen((messageSnapshot) {
      messages.value = messageSnapshot.docs;
    });
  }

  Future<void> playPauseAudio(String audioURL) async {

    if (audioPlayers[audioURL] == null) {
      debugPrint("Did not have an audio player");
      audioPlayers[audioURL] = AudioPlayer();
    }
    final player = audioPlayers[audioURL]!;

    // Set up listeners before playing
    player.onDurationChanged.listen((duration) {
      debugPrint("3 - Duration changed to: $duration");
      if (duration.inSeconds > 0) {
        durations[audioURL] = duration;
      }
      debugPrint("4");
    });

    player.onPositionChanged.listen((position) {
      debugPrint("5 - Position changed to: $position");
      positions[audioURL] = position;
      debugPrint("6");
    });

    player.onPlayerStateChanged.listen((state) {
      debugPrint("7 - Player state: $state");
      isPlaying[audioURL] = state == PlayerState.playing;
      debugPrint("8");
    });

    // Handle errors to understand playback issues
    player.printError();

    if (isPlaying[audioURL] ?? false) {
      debugPrint("Stopped");
      await player.pause();
      isPlaying[audioURL] = false;
    } else {
      debugPrint("Playing");

      // Start playing after listeners are set up
      try {
        await player.play(UrlSource(audioURL));
        debugPrint("1 - Playing audio");
        isPlaying[audioURL] = true;
        debugPrint("2");
      } catch (e) {
        debugPrint("Error playing audio: $e");
      }
    }
  }

  Future<void> sendMessage(String message) async {
    await cs.sendMessage(receiverID, message, replyMessage.value,
        audioURL: null);
    messageController.clear();
  }

  void setReplyMessage(Message? message) {
    replyMessage.value = message;
  }

  Future<void> recordVoiceMessage() async {
    if (isRecording.value) {
      String? filePath = await audioRecorder.stop();
      if (filePath != null) {
        isRecording.value = false;
        recordingPath.value = filePath;

        final File file = File(recordingPath.value!);
        final String fileName =
            DateTime.now().millisecondsSinceEpoch.toString();
        final Reference storageRef =
            FirebaseStorage.instance.ref().child('voice_messages/$fileName');

        try {
          await storageRef.putFile(file);

          final String downloadURL = await storageRef.getDownloadURL();

          cs.sendMessage(
            receiverID,
            "",
            replyMessage.value,
            audioURL: downloadURL,
          );
        } catch (e) {
          debugPrint("Error: $e");
        }
      }
    } else {
      try {
        if (await audioRecorder.hasPermission()) {
          final Directory appDocumentsDir =
              await getApplicationDocumentsDirectory();
          final String filePath = p.join(appDocumentsDir.path, 'recording.wav');
          await audioRecorder.start(const RecordConfig(), path: filePath);
          isRecording.value = true;
          recordingPath.value = null;
        }
      } catch (e) {
        debugPrint("Error: $e");
      }
    }
  }

  // Future<void> recordVoiceMessage() async {
  //   if (isRecording.value) {
  //     String? filePath = await audioRecorder.stop();
  //     if (filePath != null) {
  //       isRecording.value = false;
  //       recordingPath.value = filePath;
  //       final File file = File(recordingPath.value!);
  //       final Uint8List bytes = await file.readAsBytes();
  //       cs.sendMessage(receiverID, "", replyMessage.value, bytes);
  //     }
  //   } else {
  //     try {
  //       if (await audioRecorder.hasPermission()) {
  //         final Directory appDocumentsDir =
  //             await getApplicationDocumentsDirectory();
  //         final String filePath = p.join(appDocumentsDir.path, 'recording.wav');
  //         await audioRecorder.start(const RecordConfig(), path: filePath);
  //         isRecording.value = true;
  //         recordingPath.value = null;
  //       }
  //     } catch (e) {
  //       debugPrint("$e");
  //     }
  //   }
  // }

  @override
  void onInit() async {
    super.onInit();
    await getMessages();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });

    // Future.delayed(const Duration(milliseconds: 300), () {
    //   scrollController.jumpTo(scrollController.position.maxScrollExtent);
    // });
  }

  @override
  void dispose() {
    for (var player in audioPlayers.values) {
      player.dispose();
    }
    super.dispose();
  }

  Duration getDuration(String audioURL) => durations[audioURL] ?? Duration.zero;
  Duration getPosition(String audioURL) => positions[audioURL] ?? Duration.zero;
}
