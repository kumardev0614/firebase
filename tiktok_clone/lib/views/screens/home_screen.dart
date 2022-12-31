import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/controllers/bottom_nav_controller.dart';
import 'package:tiktok_clone/views/widgets/custom_icon.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bottomNavController = BottomNavController();

  @override
  void initState() {
    super.initState();
    Get.put(bottomNavController);
  }

  @override
  Widget build(BuildContext context) {
    return GetX<BottomNavController>(builder: (BottomNavController controller) {
      return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          // onTap: (index) {
          //   setState(() {
          //     tabIndex = index;
          //   });
          onTap: (index) {
            controller.pageIndex.value = index;
          },
          backgroundColor: backgroundColor,
          selectedItemColor: buttonColor,
          currentIndex: controller.pageIndex.value,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 30),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: CustomIcon(),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message, size: 30),
              label: "Messages",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30),
              label: "Profile",
            ),
          ],
        ),
        body: homeScreenPages[controller.pageIndex.value],
      );
    });
  }
}
