import 'dart:convert';
import 'package:dio/dio.dart';
import '../utils/custom_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://apingweb.com/api",
    contentType: 'application/json; charset=utf-8',
    responseType: ResponseType.json,
  ))
    ..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));

  Future<void> register(String name, String email, String password) async {
    try {
      Response response = await _dio.post('/register', data: {
        "name": name,
        "email": email,
        "phone": "0000000000",
        "password": password,
        "password_confirmation": password
      });

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', name);
      await prefs.setString('email', email);
      await prefs.setString('token', '${response.data['token']}');
    } on DioException catch (e) {
      final errorMessage = CustomException.fromDio(e).toString();
      throw Exception(errorMessage);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      Response response = await _dio.post('/login', data: {
        "email": email,
        "password": password,
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', '${response.data['result']['name']}');
      await prefs.setString('email', '${response.data['result']['email']}');
      await prefs.setString('token', '${response.data['token']}');
    } on DioException catch (e) {
      final errorMessage = CustomException.fromDio(e).toString();
      throw Exception(errorMessage);
    }
  }

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map> getAuthUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {'name': prefs.getString('name'), 'email': prefs.getString('email')};
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("name");
    await prefs.remove("email");
  }

  Future<Map> fetchArticles(CancelToken cancelToken) async {
    try {
      Response response = await _dio.get(
        '/articles',
        cancelToken: cancelToken
      );
      return response.data;
    } on DioException catch (e) {
      final errorMessage = CustomException.fromDio(e).toString();
      throw Exception(errorMessage);
    }
  }

  // Testing Basic Authentication
   Future<void> fetchUsers() async {
    try {
      String username = "admin";
      String password = "12345";
      String basicAuth = "Basic ${base64Encode(utf8.encode('$username:$password'))}"; 

      Response response = await Dio().get(
        'https://apingweb.com/api/auth/users',
        options: Options(
          headers: {
            'Authorization':basicAuth
          }
        )
      );
      print(response.data);
    } on DioException catch (e) {
      print(e);
    }
  }
}
