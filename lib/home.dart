import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_friday/login.dart';
import 'package:flutter_friday/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<dynamic> cats = [];
  static bool fetch = false;
  final Dio dio = Dio();
  bool isloading = false;

  Future<void> fetchCats() async {
    if (isloading == true) {
      return;
    } else {
      setState(() {
        isloading = true;
      });
    }

    setState(() {
      isloading = true;
    });
    try {
      final response = await dio.get(
        "https://api.thecatapi.com/v1/images/search?limit=10",
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseCats = response.data;
        setState(() {
          cats.addAll(responseCats);
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to fecth data")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to fecth data")));
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCats();
    fetch = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home"), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 5),
              itemCount: cats.length,
              itemBuilder: (context, index) {
                final img = cats[index]['url'];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(width: 500, child: Image.network(img)),
                );
              },
            ),
          ),

          SafeArea(
            child: isloading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      fetchCats();
                    },

                    child: Text("more"),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: "profile",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Login"),
        ],
        currentIndex: 0,
        onTap: (value) async {
          if (value == 2) {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          }
          if (value == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
            );
          }
          if (value == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          }
        },
      ),
    );
  }
}
