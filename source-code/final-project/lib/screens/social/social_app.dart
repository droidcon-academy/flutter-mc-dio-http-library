import 'package:flutter/material.dart';
import '../../models/social/user.dart';
import '../auth/login_screen.dart';
import './memories_screen.dart';
import './post_list.dart';
import '../../services/auth_api.dart';
import '../../services/social_api.dart';
import './article_list.dart';

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
      drawer: Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: FutureBuilder(future: AuthApi().getAuthUserData(), builder: (context,AsyncSnapshot snapshot){
              if(snapshot.hasData){
                
                return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  snapshot.data['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.data['email'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            );
              }
              return const Center(child: CircularProgressIndicator(),);
            }),),
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: const Text('Articles'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const ArticleList()));
            },
          ),
            ListTile(
            leading: const Icon(Icons.image_outlined),
            title: const Text('Memories'),
            onTap: () {
               Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const MemoriesScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await AuthApi().logout();
              if(context.mounted){
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
              } 
            },
          ),
        ],
      ),
    ),
      body: FutureBuilder(
          future: SocialApi().getAllUsers(),
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
                  User user = snapshot.data[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage("images/droidcon_logo.png"),
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: const Icon(Icons.navigate_next),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostList(userData: user)));
                    },
                  );
                });
          }),
    );
  }
}
