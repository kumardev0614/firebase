import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  // User class to send user data to firebase storage
  String name;
  String profileImgStr;
  String email;
  String uid;

  User(
      // class constructor
      {
    required this.name,
    required this.email,
    required this.uid,
    required this.profileImgStr,
  });

  Map<String, dynamic> toJson() => {
        // method to Map User data to json format
        "name": name,
        "profilePhoto": profileImgStr,
        "email": email,
        "uid": uid,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      name: snapshot['name'],
      email: snapshot['email'],
      uid: snapshot['uid'],
      profileImgStr: snapshot['profilePhoto'],
    );
  }
}
