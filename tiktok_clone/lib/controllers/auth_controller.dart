import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/user_data.dart' as model;
import 'package:tiktok_clone/views/screens/auth/login_screen.dart';
import 'package:tiktok_clone/views/screens/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<User?> _user;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => HomeScreen());
    }
  }
  // late Rx<File?> _pickedImage;

  // File? get profilePhoto => _pickedImage.value;

  // void pickImage() async {
  //   final pickedImage =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickedImage != null) {
  //     Get.snackbar('Profile Picture',
  //         'You have successfully selected your profile picture!');
  //   }
  //   _pickedImage = Rx<File?>(File(pickedImage!.path));
  // }

  // upload to firebase storage
  // Future<String> _uploadToStorage(File image) async {
  //   Reference ref = firebaseStorage
  //       .ref()
  //       .child('profilePics')
  //       .child(firebaseAuth.currentUser!.uid);

  //   UploadTask uploadTask = ref.putFile(image);
  //   TaskSnapshot snap = await uploadTask;
  //   String downloadUrl = await snap.ref.getDownloadURL();
  //   return downloadUrl;
  // }

  // registering the user
  void registerUser(String username, String email, String password) async {
    try {
      // save out user to our ath and firebase firestore
      UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // String downloadUrl = await _uploadToStorage(image);
      model.User user = model.User(
        name: username,
        email: email,
        uid: cred.user!.uid,
        // profilePhoto: downloadUrl,
      );
      await firestore
          .collection('users')
          .doc(cred.user!.uid)
          .set(user.toJson());
      Get.snackbar(
        backgroundColor: Colors.green[300],
        'Registration',
        'Successfully Registered!!!',
      );
    } catch (e) {
      if (e.toString() ==
          "[firebase_auth/unknown] Given String is empty or null") {
        Get.snackbar(
          backgroundColor: Colors.red[300],
          'Error Creating Account',
          "Please enter all the fields",
        );
      } else {
        Get.snackbar(
          backgroundColor: Colors.red[300],
          'Error Creating Account',
          e.toString(),
        );
      }
    }
  } // registerUser

  void loginUser(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      Get.snackbar(
        backgroundColor: Colors.green[300],
        'Login',
        'Successfully Logged in',
      );
    } catch (e) {
      if (e.toString() ==
          "[firebase_auth/unknown] Given String is empty or null") {
        Get.snackbar(
          backgroundColor: Colors.red[300],
          'Error Logging in',
          "Please enter all the fields",
        );
      } else {
        Get.snackbar(
          backgroundColor: Colors.red[300],
          'Error Logging in',
          e.toString(),
        );
      }
    }
  }
}
