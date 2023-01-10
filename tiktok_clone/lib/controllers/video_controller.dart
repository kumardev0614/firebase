import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/video.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);
  List<Video> get videoList => _videoList.value;

  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(firestoreDatabase
        .collection("videos")
        .snapshots()
        .map((QuerySnapshot query) {
      List<Video> returnValue = [];
      for (var snap in query.docs) {
        returnValue.add(Video.fromSnap(snap));
      }
      return returnValue;
    }));
  }

  likeVideo(String id) async {
    DocumentSnapshot docSnap =
        await firestoreDatabase.collection("videos").doc(id).get();

    var uid = authController.user.uid;
    // if likes [] already has the uid of user who has clicked the like icon
    // then remove his uid from the list, means Dislike the video
    // remember we are showing length of list likes[] as value
    if ((docSnap.data()! as dynamic)['likes'].contains(uid)) {
      await firestoreDatabase.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      // add the uid in likes[]
      // means liking the video
      await firestoreDatabase.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
