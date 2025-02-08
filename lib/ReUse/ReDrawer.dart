import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReuseDrawer extends StatelessWidget {
  const ReuseDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Center(child: Text('Menu',style: TextStyle(fontSize: 25),),),
          ),
          ListTile(
            leading: Icon(Icons.post_add),
            title: Text("Post a Status"),
            onTap: (){
              Get.toNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.post_add),
            title: Text("Past Status"),
            onTap: (){
              Get.toNamed('/all');
            },
          )
        ],
      ),
    );
  }
}