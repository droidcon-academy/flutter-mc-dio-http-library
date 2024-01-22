import 'package:flutter/material.dart';
import '../../models/social/post.dart';
import '../../models/social/user.dart';
import './edit_post.dart';
import '../../services/social_api.dart';
import 'create_post.dart';

class PostList extends StatelessWidget {
  final User userData; // Accept in constructor
  const PostList({super.key, required this.userData});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${userData.name}'s Posts"), 
        centerTitle: true,
        elevation: 1,
      ),
      body: FutureBuilder(
          future: SocialApi().getPostsByUserId(userData.id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "${snapshot.error} \nPlease try again later",
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
              );
            }

            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  Post post = snapshot.data[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    post.title,
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditPost(
                                                    postData: post,
                                                  )));
                                    },
                                    icon: const Icon(Icons.edit))
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              post.body,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreatePost(
                          userData: userData,
                        )));
          }),
    );
  }
}
