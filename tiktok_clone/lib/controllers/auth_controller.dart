import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/user_data.dart' as model;
import 'package:tiktok_clone/views/screens/auth/login_screen.dart';
import 'package:tiktok_clone/views/screens/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<User?> _user;
  User get user => _user.value!;

  late Rx<File?> _pickedImage;
  File? get profilePhoto => _pickedImage.value;

  late Rx<File?> finalImage;

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

  // void pickImage() async {
  //   final pickedImage =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickedImage != null) {
  //     Get.snackbar('Profile Picture',
  //         'You have successfully selected your profile picture!');
  //   }
  //   _pickedImage = Rx<File?>(File(pickedImage!.path));
  // }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final imageFile = File(pickedImage.path.toString());

      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
        ],
      );

      if (croppedFile != Null) {
        log("Image is cropped!!!");
        log("Pathe of cropped file is: ${croppedFile!.path.toString()}");
      }
      final imageFile2 = File(croppedFile!.path.toString());
      log('Before Compress but cropped ${imageFile2.lengthSync() / 1024} kb');

      // ------- compress --------------
      final filePath = imageFile2.absolute.path;

      final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
      final splitted = filePath.substring(0, (lastIndex));
      final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
      var compressedImage = await FlutterImageCompress.compressAndGetFile(
        imageFile2.absolute.path,
        outPath,
        quality: 25,
      );

      log('After Compress: ${compressedImage!.lengthSync() / 1024} kb');

      if (compressedImage != Null) {
        log("Image is compressed!!!");
        log("Pathe of compressed file is: ${compressedImage.path.toString()}");
      }

      // ----------------------------
      Get.snackbar('Profile Picture', 'Cropped and Compressed!!!');

      _pickedImage = Rx<File?>(File(compressedImage.path));
      log("fianl image data: ${_pickedImage.value.toString()}");
      accessImage();
    }
  }

  accessImage() {
    log("picked Image: $_pickedImage");
  }

  //upload to firebase storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // registering the user
  void registerUser(
      String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        // save out user to our ath and firebase firestore
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(
          name: username,
          email: email,
          uid: cred.user!.uid,
          profilePhoto: downloadUrl,
        );
        await firestoreDatabase
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        Get.snackbar(
          backgroundColor: Colors.green[300],
          'Sign up',
          'Registered successfully',
        );
      } else {
        Get.snackbar(
          'Error Creating Account',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Creating Account',
        e.toString(),
      );
      log("Error Creating Account ${e.toString()}");
    }
  }

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

  void signOut() async {
    await firebaseAuth.signOut();
  }
}
