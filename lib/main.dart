import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'ReUse/ReDrawer.dart';
import 'dart:convert';

void main(){
  runApp(const MyApp());
}

class PostController extends GetxController {
  final TextEditingController textController = TextEditingController();
  var posts = <Map<String, dynamic>>[].obs; // Store posts as observable list

  Future<void> postStatus() async {
    String text = textController.text.trim();
    if (text.isEmpty) {
      Get.snackbar("Error", "Please enter a status before posting!",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    String url = "https://67a33fa931d0d3a6b782d474.mockapi.io/fbPost/U1/A";

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": text}),
      );

      if (response.statusCode == 201) {
        Get.snackbar("Success", "Status posted successfully!",
            snackPosition: SnackPosition.BOTTOM);
        textController.clear();
        fetchPosts(); // Fetch updated posts
      } else {
        Get.snackbar("Error", "Failed to post status. Try again!",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> fetchPosts() async {
    String url = "https://67a33fa931d0d3a6b782d474.mockapi.io/fbPost/U1/A";

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        posts.value = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        Get.snackbar("Error", "Failed to load posts", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e", snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchPosts(); // Fetch posts when the controller is initialized
  }
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Status(),
        '/all':(context) => AllStatus(),
      },
    );
  }
}

class Status extends StatelessWidget{
  final PostController postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Post a status"),),
      drawer: ReuseDrawer(),
      body: Column(
        children: [
          Center(
            child: SizedBox(
              width: 400,
              child: TextField(
                controller: postController.textController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: "Write what's on your mind",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            onPressed: (){
              postController.postStatus();
            },
            child: Text("Post", style: TextStyle(color: Colors.black),),
          ),
        ],
      ),
    );
  }
}

class AllStatus extends StatelessWidget {
  final PostController postController = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("See previous status")),
      drawer: ReuseDrawer(),
      body: Obx(() {
        if (postController.posts.isEmpty) {
          return Center(child: Text("No posts available."));
        }
        return ListView.builder(
          itemCount: postController.posts.length,
          itemBuilder: (context, index) {
            var post = postController.posts[index];
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text(post["status"] ?? "No status"),
                subtitle: Text("ID: ${post["id"]}"),
              ),
            );
          },
        );
      }),
    );
  }
}


