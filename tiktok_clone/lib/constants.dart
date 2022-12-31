import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/controllers/auth_controller.dart';
import 'package:tiktok_clone/views/screens/add_video_screen.dart';

// COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

// Firebase Constants
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestoreDatabase = FirebaseFirestore.instance;

// Controllers
var authController = AuthController.instance;

// Home Screen Pages
const homeScreenPages = [
  Text("Home Screen"),
  Text("Search Screen"),
  AddVideoScreen(),
  Text("Meassages Screen"),
  Text("Profile Screen"),
];
