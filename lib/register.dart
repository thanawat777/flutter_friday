import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_friday/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmpasswordController;
  late TextEditingController imageURLConttoller;
  String _imageurl = "https://storage-wp.thaipost.net/2025/01/ink-2.jpg";

  //Setup imagepicker
  // final ImagePicker _picker = ImagePicker();
  //   File? _image;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmpasswordController = TextEditingController();
    imageURLConttoller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    imageURLConttoller.dispose();
  }

  Future<void> registerUser() async {
    final inputName = nameController.text.trim();
    final inputEmail = emailController.text.trim();
    final inputPassword = passwordController.text.trim();
    final inputConfirmPassword = confirmpasswordController.text.trim();
    final inputimageURL = imageURLConttoller.text.trim();

    if (inputPassword != inputConfirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("password and confirmpassword not match")),
      );
      return;
    }
    try {
      UserCredential userInfo = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: inputEmail,
            password: inputPassword,
          );
      if (userInfo.user != null) {
        final String uid = userInfo.user!.uid;
        await FirebaseFirestore.instance.collection("members").doc(uid).set({
          "name": inputName,
          "email": inputEmail,
          "profile_picture": inputimageURL,
          "createdAt": FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Register complete")));
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Sometime when wrong")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(_imageurl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: -4,
                right: -4,

                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _imageurl = imageURLConttoller.text;
                    });
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Username",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "email",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "password",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: confirmpasswordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "confirm password",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: imageURLConttoller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Image URL",
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () {}, child: Text("Cancle")),
              ElevatedButton(
                onPressed: () {
                  registerUser();
                },
                child: Text("Login"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
