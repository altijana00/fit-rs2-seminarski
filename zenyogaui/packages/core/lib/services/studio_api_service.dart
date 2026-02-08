import 'dart:io';

import 'package:dio/dio.dart';

class StudioApiService {
  final Dio dio;

  StudioApiService(this.dio);

  Future<List<Map<String, dynamic>>> getStudioByOwner(int id) async {
    final response = await dio.get('Studio/getByOwner?ownerId=$id');
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Falied to fetch studios: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> getStudioByInstructor(int id) async {
    final response = await dio.get('Studio/getByInstructor?instructorId=$id');
    if(response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Falied to fetch studio: ${response.data}');
    }
  }

  Future<double> getPayments(int studioId) async {
    final response = await dio.get('StudioAnalytics/getByStudio?studioId=$studioId');
    if(response.statusCode == 200) {
      return (response.data as num).toDouble();
    }else {
      throw Exception('Falied to fetch studio payments: ${response.data}');
    }
  }

  Future<int> getParticipants(int studioId) async {
    final response = await dio.get('StudioAnalytics/getNumberofParticipants?studioId=$studioId');
    if(response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Falied to fetch studio participants: ${response.data}');
    }
  }



  Future<Map<String, dynamic>> getStudioByOwnerAndStudioName(int id, String name) async {
    final response = await dio.get('Studio/getByOwnerAndStudioName?ownerId=$id&name=$name');
    if(response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Falied to fetch studio: ${response.data}');
    }
  }

  Future<List<Map<String, dynamic>>> getAllStudios() async {
    final response = await dio.get('Studio/getAll');
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Falied to fetch studios: ${response.data}');
    }
  }

  Future<List<Map<String, dynamic>>> getStudiosQuery(String? search, int? cityId) async {
    final response = await dio.get('Studio/getStudiosQuery',
      queryParameters: {
        if(search != null) 'search': search,
        if(cityId != null) 'cityId' : cityId,
      },
    );
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Falied to fetch studios: ${response.data}');
    }
  }

  Future<List<String>> getStudioGalleryPhotos(int studioId) async {
    final response = await dio.get('Studio/getStudioGalleryPhotos?studioId=$studioId');

    if (response.statusCode == 200) {
      final data = response.data;
      
      if (data is List) {
        return data.map((e) => e.toString()).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to fetch studio gallery: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> editStudio(Map<String, dynamic> studioData, int studioId) async {
    final response = await dio.put(
      'Studio/edit?id=$studioId',
      data: studioData,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Failed to edit studio: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> deleteStudio(int studioId) async {
    final response = await dio.delete(
      'Studio/delete?id=$studioId',
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Failed to delete studio: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> deleteStudioGalleryPhoto(String photoURL, int studioId) async {
    final response = await dio.delete(
      'Studio/deleteStudioGalleryPhoto?photoURL=$photoURL&studioId=$studioId',
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Failed to delete gallery photo: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> addStudio(Map<String, dynamic> studioData) async {
    final response = await dio.post(
      'Studio/add?',
      data: studioData,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(response.data);
    } else if (response.statusCode == 400) {
      var resp = Map<String, dynamic>.from(response.data);
      throw Exception(resp["error"]);

    } else if (response.statusCode == 500) {
      var resp = Map<String, dynamic>.from(response.data);
      throw Exception(resp["error"]);

    } else {
      throw Exception('Failed to add studio: ${response.data}');
    }
  }

  Future<String> uploadStudioPhoto(File imageFile) async {
    final fileName = imageFile.path.split('/').last;

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
      ),
    });

    final response = await dio.post(
      'Studio/uploadStudioPhoto',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to upload photo');
    }
  }

  Future<String> editStudioPhoto(String photoURL, int studioId) async {
    final response = await dio.patch(
      'Studio/editStudioPhoto?photoUrl=$photoURL&studioId=$studioId'
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Failed to edit studio: ${response.data}');
    }
  }

  Future<String> uploadStudioGalleryPhoto(int studioId, File imageFile,) async {
    final fileName = imageFile.path.split('/').last;

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
      ),
    });

    final response = await dio.post(
      'Studio/uploadStudioGalleryPhoto?studioId=$studioId',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to upload photo');
    }
  }

}