import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/views/screens/auth/login_screen.dart';
import 'package:tiktok_clone/views/widgets/text_input_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // tiktok and Login text
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(
                        'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'),
                    backgroundColor: Colors.grey,
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: () => authController.pickImage(),
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                // Email textField widget
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  textInputController: _usernameController,
                  labelText: "Create Username",
                  icon: Icons.person,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                // Email textField widget
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  textInputController: _emailController,
                  labelText: "Enter Email",
                  icon: Icons.email,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                // password textField widget
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  textInputController: _passwordController,
                  labelText: "Create Password",
                  icon: Icons.password,
                  isObscure: true,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                // Our own login button
                width: MediaQuery.of(context).size.width - 40,
                height: 45,
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    authController.registerUser(
                      _usernameController.text,
                      _emailController.text,
                      _passwordController.text,
                      authController.profilePhoto,
                    );
                    Get.snackbar(
                        "Image", authController.profilePhoto!.path.toString());
                  },
                  child: const Center(
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                // Register line
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.to(() => LoginScreen()),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 20,
                        color: buttonColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     authController.checkFile(authController.profilePhoto);
              //   },
              //   child: Text('Check File'),
              // ),
              ElevatedButton(
                onPressed: () {
                  authController.signInWithFacebook();
                },
                child: Text('Facebook'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
