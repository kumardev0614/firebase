import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';

class AuthController extends GetxController {
  // Upload Image and get it's URL
  Future<String> _uploadImageToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child("profilePics")
        .child(firebaseAuth.currentUser!.uid);
    // taken the reference of current user's UID

    // Uploading the Image using Current ref UID
    UploadTask uploadTask = ref.putFile(image);

    // Now we will take snapshot of our Upload Task
    TaskSnapshot snap = await uploadTask;

    // Now this snapshot contains the url of our uploaded image
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // register the user
  void registerUser(
      File? image, String username, String email, String password) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        // save out user to auth and firebase firestore
        await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);

        String downloadUrl = await _uploadImageToStorage(image);

        // Now we will save all this user data and image in firebase database
        // Notice we are saving image as String by using it's URL
        // We need a structure to pass all this data in firebase
        // So we will create a user class in models folder


      }
    } catch (e) {
      Get.snackbar("Error Creating Account", e.toString());
    }
  }
}
