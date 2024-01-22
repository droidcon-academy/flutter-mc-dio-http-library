
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import '../models/social/post.dart';
import '../utils/custom_exceptions.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import '../models/social/user.dart';

class SocialApi {

  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://jsonplaceholder.typicode.com",
    contentType: 'application/json; charset=utf-8',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    responseType: ResponseType.json,
  ))..interceptors.add(DioCacheInterceptor(
    options: CacheOptions(
      store: HiveCacheStore(null),
      policy: CachePolicy.forceCache,
      maxStale: const Duration(hours: 1),
      hitCacheOnErrorExcept: [401, 403],
    ),
  ),);
  


  Future<List<User>> getAllUsers() async {
    try {
      Response allUsers = await _dio.get('/users');
      List<User> result = [];
      for (var user in allUsers.data) {
        result.add(User.fromJson(user));
      }
      return result;
    } on DioException catch (e) {
      final errorMessage = CustomException.fromDio(e).toString();
      throw Exception(errorMessage);
    }
  }

  Future<List<Post>> getPostsByUserId(int userId) async {
    try {
      Response allPosts = await _dio.get('/users/$userId/posts');
      List<Post> result = [];
      for (var post in allPosts.data) {
        result.add(Post.fromJson(post));
      }

      return result;
    } on DioException catch (e) {
      final errorMessage = CustomException.fromDio(e).toString();
      throw Exception(errorMessage);
    }
  }

  Future<Post> createNewPost({required Post postData}) async {
    try {
      Response response = await _dio.post(
        '/posts',
        data: postData.toJson(),
      );
      Post newCreatedPost = Post.fromJson(response.data);
      return newCreatedPost;
    } on DioException catch (e) {
      final errorMessage = CustomException.fromDio(e).toString();
      throw Exception(errorMessage);
    }
  }

  Future<Post> updateAPost({required Post postData}) async {
    try {
      Response response = await _dio.put(
        '/posts/${postData.id}',
        data: postData.toJson(),
      );
      Post updatedPost = Post.fromJson(response.data);
      return updatedPost;
    } on DioException catch (e) {
      final errorMessage = CustomException.fromDio(e).toString();
      throw Exception(errorMessage);
    }
  }

  Future<void> deletePost({required int id}) async {
    try {
      await _dio.delete('/posts/$id');
    } on DioException catch (e) {
      final errorMessage = CustomException.fromDio(e).toString();
      throw Exception(errorMessage);
    }
  }
}
