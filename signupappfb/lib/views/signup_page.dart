import 'package:flutter/material.dart';
import 'package:signupappfb/controllers/auth_controller.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    // print("w = $w");
    double h = MediaQuery.of(context).size.height;
    // print("h = $h");

    List images = ["g.png", "f.png", "t.png"];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // Theme Image with profile avatar
              width: w,
              height: h * 0.33,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("img/signup.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: h * 0.17),
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage("img/profile1.png"),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: w,
              height: h * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  SizedBox(
                    // Email textField  - 1
                    height: 50,
                    child: TextField(
                      controller: emailController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.all(0),
                        hintText: "Enter Email",
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.orange[300],
                        ),
                        focusColor: Colors.grey[350],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    // Email textField  - 2
                    height: 50,
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.all(0),
                        hintText: "Create Password",
                        prefixIcon: Icon(
                          Icons.password,
                          color: Colors.orange[300],
                        ),
                        focusColor: Colors.grey[350],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 0),
            GestureDetector(
              onTap: () {
                AuthController.instance.registerUser(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
              },
              child: Container(
                // Signup Button
                width: w * 0.45,
                height: h * 0.09,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(
                    image: AssetImage("img/loginbtn.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: w * 0.15),
            RichText(
              // Or sign up Text
              text: const TextSpan(
                text: "Or sign up using",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                AuthController.instance.signInWithGoogle();
              },
              child: Wrap(
                // Google Facebook Twitter logos
                children: List<Widget>.generate(
                  3,
                  (index) => Container(
                    padding: const EdgeInsets.all(7),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[350],
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage("img/${images[index]}"),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
