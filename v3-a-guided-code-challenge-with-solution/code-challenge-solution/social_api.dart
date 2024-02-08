
import 'package:dio/dio.dart';
import '../models/social/user.dart';

class SocialApi {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://jsonplaceholder.typicode.com"));
  
  Future<List<User>> getAllUsers() async {
      Response allUsers = await _dio.get('/users');
      List<User> result = [];

      for (var user in allUsers.data) {
        result.add(User.fromJson(user));
      }
      return result;
  }

  Future<List<Post>> getPostsByUserId(int userId) async {
      Response allPosts = await _dio.get('/users/$userId/posts');
      List<Post> result = [];

      for (var post in allPosts.data) {
        result.add(Post.fromJson(post));
      }
      return result;
  }
}
