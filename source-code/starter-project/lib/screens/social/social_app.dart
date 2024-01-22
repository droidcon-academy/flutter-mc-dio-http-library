import 'post_list.dart';
import 'package:flutter/material.dart';


class SocialApp extends StatelessWidget {
  const SocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("The Social"),
        centerTitle: true,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: 15,
        itemBuilder: (context,index) => ListTile(
          leading: const CircleAvatar(backgroundImage: AssetImage("images/droidcon_logo.png"),),
          title: Text("Dummy Username"),
          subtitle: Text("dummy@gmail.com"),
          trailing: const Icon(Icons.navigate_next),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const PostList()));
          },
        )),
    );
  }
}