import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  //-------------------------------- video -------------------------------------
  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.MediumQuality);
    return compressedVideo!.file;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);

    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    // UploadTask uploadTask = ref.putFile(File(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }

  //------------------------------- Thumbnail ----------------------------------
  _createThumbnail(String videoPath) async {
    return await VideoCompress.getFileThumbnail(videoPath);
  }

  Future<String> _uploadThumbnail(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _createThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // ---------------------  compress and upload video --------------------------
  uploadVideo(String songName, String caption, String videoPath) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestoreDatabase.collection("users").doc(uid).get();
      // getting User data using current UID

      // creating id using length of document
      var allDocs = await firestoreDatabase.collection('videos').get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbnailUrl = await _uploadThumbnail("Video $len", videoPath);

      Video video = Video(
          username: (userDoc.data()! as Map<String, dynamic>)['name'],
          uid: uid,
          id: "Video $len",
          likes: [],
          commentCount: 0,
          shareCount: 0,
          songName: songName,
          caption: caption,
          videoUrl: videoUrl,
          profilePhoto:
              (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
          thumbnail: thumbnailUrl);

      await firestoreDatabase
          .collection('videos')
          .doc('Video $len')
          .set(video.toJson());
      Get.back();
    } catch (e) {
      Get.snackbar("Error Uploading Video", e.toString());
    }
  }
}
