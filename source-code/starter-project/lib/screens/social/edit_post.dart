import 'package:flutter/material.dart';


class EditPost extends StatelessWidget {
  const EditPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Post"),
        centerTitle: true,
        actions: [IconButton(onPressed: (){}, icon: const Icon(Icons.delete), color: Colors.red,)],
      ),
    );
  }
}