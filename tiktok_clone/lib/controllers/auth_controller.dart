import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/user_data.dart' as model;
import 'package:firebase_core/firebase_core.dart' as core;

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<File?> _pickedImage;
  File? get profilePhoto => _pickedImage.value;

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar("Profile Picture", "Profile Pic Selected");
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  // Upload Image and get it's URL
  Future<String> _uploadImageToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child("profilePics")
        .child(firebaseAuth.currentUser!.uid);
    // taken the reference of current user's UID

    // Uploading the Image using Current ref UID
    try {
      UploadTask uploadTask = ref.putFile(image);

      // Now we will take snapshot of our Upload Task
      TaskSnapshot snap = await uploadTask;

      // Now this snapshot contains the url of our uploaded image
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      Get.snackbar("putFile error", e.toString());
      return "";
      // handle the error
    }
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
        // 1) Saving in auth
        UserCredential userCredentials = await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);

        String downloadUrl = await _uploadImageToStorage(image);

        // Now we will save all this user data and image in firebase database
        // Notice we are saving image as String by using it's URL
        // We need a structure to pass all this data in firebase
        // So we will create a user class in models folder
        // 2) saving in firestore database
        model.User user = model.User(
          name: username,
          email: email,
          uid: userCredentials.user!.uid,
          profilePhoto: downloadUrl,
        );
        firestore
            .collection("users")
            .doc(userCredentials.user!.uid)
            .set(user.toJson());
      } else {
        Get.snackbar("Error Creating Account", "Please enter all the fields");
      }
    } catch (e) {
      Get.snackbar("Error Creating Account", e.toString());
    }
  }
}
