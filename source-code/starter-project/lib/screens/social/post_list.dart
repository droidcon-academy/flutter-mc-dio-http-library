import 'package:flutter/material.dart';
import 'create_post.dart';


class PostList extends StatelessWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
        centerTitle: true,
        elevation: 1,
      ),
      body: null,
      floatingActionButton: FloatingActionButton(child: const Icon(Icons.add),onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const CreatePost()));
      }),
    );
  }
}