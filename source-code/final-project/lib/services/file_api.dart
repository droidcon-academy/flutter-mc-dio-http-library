import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/custom_exceptions.dart';

class FileApi {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://api.imgbb.com/1",
  ));

  // Enter your own API key
  String apiKey = "b2978903791a2b10aab5f44955ac811e";

  Future<void> uploadImage(File imageFile) async {
    try {
      FormData formData = FormData.fromMap({
        'key': apiKey,
        'image': await MultipartFile.fromFile(imageFile.path)
      });

      Response response = await _dio.post("/upload", data: formData);

      await saveImageToSharedPreferences(response.data['data']['image']['url']);
    } on DioException catch (e) {
      final errorMessage = CustomException.fromDio(e).toString();
      throw Exception(errorMessage);
    }
  }

  Future<void> saveImageToSharedPreferences(String imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? getMemoriesJson = prefs.getString('memories');

    // Decode the JSON string into a list
    List<dynamic> decodedList = List.from(json.decode(getMemoriesJson!));
    // Add the new imageUrl to the list
    decodedList.add(imageUrl);
    // Convert the list of strings to a JSON-encoded string
    String jsonString = json.encode(decodedList);
    // Save the updated string back to SharedPreferences
    prefs.setString('memories', jsonString);
  }

  Future<List> fetchAllMemories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? getMemoriesJson = prefs.getString('memories');
    if (getMemoriesJson == null) {
      await prefs.setString('memories', "[]");
      getMemoriesJson = prefs.getString('memories');
    }
    List<dynamic> decodedList = List.from(json.decode(getMemoriesJson!));
    return decodedList;
  }

  Future<void> downloadImage(String imageUrl) async {
  
    String fileName = imageUrl.split('/').last;

    try {
      var storagePermission = await Permission.storage.status;

      if (!storagePermission.isGranted) {
        await Permission.storage.request();
      }

      final dir = await getTemporaryDirectory();

      final filePath = '${dir.path}/$fileName';

      await Dio().download(imageUrl, filePath);
      await ImageGallerySaver.saveFile(
        filePath,
      );
    } on DioException catch (e) {
      final errorMessage = CustomException.fromDio(e).toString();
      throw Exception(errorMessage);
    }
  }
}
