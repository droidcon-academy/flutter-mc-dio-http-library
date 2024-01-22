import 'package:flutter/material.dart';
import '../../models/social/post.dart';
import '../../services/social_api.dart';

class EditPost extends StatefulWidget {
  final Post postData;
  const EditPost({super.key, required this.postData});

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.postData.title;
    bodyController.text = widget.postData.body;
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    bodyController.dispose();
  }

  Future<void> _updatePost() async {
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
      Post updatedPost = await SocialApi().updateAPost(
        postData: Post(
          userId: widget.postData.userId,
          id: widget.postData.id,
          title: titleController.text,
          body: bodyController.text,
        ),
      );

      if (context.mounted) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Post Updated successfully! ID: ${updatedPost.id}'), // Changed
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
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Post"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await SocialApi().deletePost(id: widget.postData.id!);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Post Deleted !")));
                  Navigator.pop(context);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("$e"), backgroundColor: Colors.red));
                }
              }
            },
            icon: const Icon(Icons.delete),
            color: Colors.red,
          )
        ],
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
                    onPressed: _updatePost,
                    child: const Text('Update'),
                  ),
          ],
        ),
      ),
    );
  }
}
