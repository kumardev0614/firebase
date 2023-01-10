import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/controllers/video_controller.dart';
import 'package:tiktok_clone/views/screens/comment_screen.dart';
import 'package:tiktok_clone/views/widgets/circle_animation.dart';
import 'package:tiktok_clone/views/widgets/video_player_item.dart';

class VideoScreen extends StatelessWidget {
  VideoScreen({super.key});

  final VideoController videoController = Get.put(VideoController());

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ]),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(11),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final phoneSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Obx(() {
        return PageView.builder(
          itemCount: videoController.videoList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: ((context, index) {
            return Stack(
              children: [
                VideoPlayerItem(
                    videoUrl: videoController.videoList[index].videoUrl),
                Column(
                  children: [
                    const SizedBox(height: 100),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            // 1st children of Row
                            child: Container(
                              padding: const EdgeInsets.only(left: 13),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    videoController.videoList[index].username,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    videoController.videoList[index].caption,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.music_note,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        videoController
                                            .videoList[index].songName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            // 2nd children of Row
                            width: 75,
                            margin: EdgeInsets.only(top: phoneSize.height / 6),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildProfile(videoController
                                    .videoList[index].profilePhoto),
                                Column(
                                  children: [
                                    //-------------- Likes -------------------
                                    InkWell(
                                      onTap: () => videoController.likeVideo(
                                          videoController.videoList[index].id),
                                      child: Icon(
                                        Icons.favorite,
                                        size: 30,
                                        color: videoController
                                                .videoList[index].likes
                                                .contains(
                                                    authController.user.uid)
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                    ),

                                    Text(
                                      videoController
                                          .videoList[index].likes.length
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    //----------------- Comment --------------
                                    const SizedBox(height: 18),
                                    InkWell(
                                      onTap: () {
                                        Get.to(() => CommentScreen(),
                                            arguments: {
                                              "id": videoController
                                                  .videoList[index].id
                                            });
                                      },
                                      child: const Icon(
                                        Icons.comment,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      videoController
                                          .videoList[index].commentCount
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    //---------------- Share -----------------
                                    const SizedBox(height: 18),
                                    InkWell(
                                      onTap: () {},
                                      child: const Icon(
                                        Icons.share,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      videoController
                                          .videoList[index].shareCount
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                CircleAnimation(
                                  child: buildMusicAlbum(videoController
                                      .videoList[index].profilePhoto),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        );
      }),
    );
  }
}
