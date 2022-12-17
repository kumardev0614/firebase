import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:signupappfb/views/login_page.dart';
import 'package:signupappfb/views/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  // Globaly available instance of our controller
  static AuthController instance = Get.find();

  // to save user data
  late Rx<User?> _user;

  // Firebase auth instance
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    // identifying current user
    _user = Rx<User?>(auth.currentUser);

    //creating a data stream between app and Firebase
    _user.bindStream(auth.userChanges());

    // listener to take action on changes in _user data
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      // because user is not logged in yet, _user will be null
      // so redirect our app to login page
      Get.offAll(() => LoginPage());
    } else {
      // Now if user is connected to firebase
      // _user will not be null
      // means user is logged in so redirect the app tp welcome page
      Get.offAll(() => WelcomePage(email: user.email!));
    }
  } // initialScreen

  void registerUser(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      // To show error msg to user
      Get.snackbar(
        "About User",
        "User Message",
        backgroundColor: Colors.redAccent,
        titleText: const Text(
          "Registration Failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  } // regidterUser

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>['email']).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // print("------------------------ $credential --------------------------");
    // return auth.signInWithCredential(credential);

    try {
      await auth.signInWithCredential(credential);
      // print("------------------------ $_user --------------------------");
    } catch (e) {
      // To show error msg to user
      Get.snackbar(
        "About Google Login",
        "Login Message",
        backgroundColor: Colors.redAccent,
        titleText: const Text(
          "Google Login Failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }

  void login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      // To show error msg to user
      Get.snackbar(
        "About Login",
        "Login Message",
        backgroundColor: Colors.redAccent,
        titleText: const Text(
          "Login Failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  } // login

  void logout() async {
    await auth.signOut();
  } // logout
}
