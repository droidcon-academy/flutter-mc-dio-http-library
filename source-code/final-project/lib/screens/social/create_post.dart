import 'package:flutter/material.dart';
import '../../services/social_api.dart';
import '../../models/social/post.dart';
import '../../models/social/user.dart';

class CreatePost extends StatefulWidget {
  final User userData;
  const CreatePost({super.key, required this.userData});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    bodyController.dispose();
  }

  Future<void> _submitPost() async {
    if (titleController.text.isEmpty || bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Both fields are required'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      Post newPost = await SocialApi().createNewPost(
        postData: Post(
          userId: widget.userData.id,
          title: titleController.text,
          body: bodyController.text,
        ),
      );

      if (context.mounted) {
        FocusScope.of(context).unfocus(); 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Post created successfully! ID: ${newPost.id}'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$e"), backgroundColor: Colors.red));
      }
    } finally {
      setState(() {
        titleController.text = "";
        bodyController.text = "";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a Post"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              minLines: 1,
              maxLines: 2,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: bodyController,
              minLines: 1,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Body'),
            ),
            const SizedBox(height: 20.0),
            isLoading
                ? const SizedBox(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: _submitPost,
                    child: const Text('Submit'),
                  ),
          ],
        ),
      ),
    );
  }
}
