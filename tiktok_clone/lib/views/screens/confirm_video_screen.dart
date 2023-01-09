import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/upload_video_controller.dart';
import 'package:tiktok_clone/views/widgets/text_input_field.dart';
import 'package:video_player/video_player.dart';
import 'dart:developer' as developer;

class ConfirmVideoScreen extends StatefulWidget {
  final File videoFile = Get.arguments["videoFile"];
  final String videoPath = Get.arguments["videoPath"];
  ConfirmVideoScreen({super.key});

  @override
  State<ConfirmVideoScreen> createState() => _ConfirmVideoScreenState();
}

class _ConfirmVideoScreenState extends State<ConfirmVideoScreen> {
  late VideoPlayerController videoPlayer;
  TextEditingController songController = TextEditingController();
  TextEditingController captionController = TextEditingController();

  UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());

  @override
  void initState() {
    super.initState();
    // setState(() {
    videoPlayer = VideoPlayerController.file(widget.videoFile);
    // });
    videoPlayer.initialize();
    videoPlayer.play();
    videoPlayer.setVolume(0.5);
    videoPlayer.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 1.6,
          child: VideoPlayer(videoPlayer),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                width: MediaQuery.of(context).size.width - 20,
                child: TextInputField(
                  textInputController: songController,
                  labelText: "Song Name",
                  icon: Icons.music_note,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                width: MediaQuery.of(context).size.width - 20,
                child: TextInputField(
                  textInputController: captionController,
                  labelText: "Caption",
                  icon: Icons.closed_caption,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  videoPlayer.pause();
                  await uploadVideoController.uploadVideo(songController.text,
                      captionController.text, widget.videoPath);
                  videoPlayer.dispose();
                  // developer.log("\x1B[32m=============================\x1B[0m");
                  // developer.log("\x1B[32m========== Disposed =========\x1B[0m");
                  // developer.log("\x1B[32m=============================\x1B[0m");
                }, // share video
                child: const Text(
                  "Share!",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
    ));
  }
}
