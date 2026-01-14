import 'package:dio/dio.dart';

class ClassApiService {
  final Dio dio;

  ClassApiService(this.dio);

  Future<List<Map<String, dynamic>>> getByInstructorId(int id, {String? search, int? yogaTypeId}) async {
    final response = await dio.get('Class/getByInstructorId?instructorId=$id',
    queryParameters: {
      if(search != null) 'search': search,
      if(yogaTypeId != null) 'yogaTypeId': yogaTypeId,
    },
    );
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Failed to fetch classes: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> getStudioGroupped(int studioId) async {
    final response = await dio.get('Class/studioGroupped?studioId=$studioId');
    if(response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Falied to fetch grouped classes: ${response.data}');
    }
  }


  Future<Map<String, dynamic>> addClass(Map<String, dynamic> classData, int instructorId) async {
    final response = await dio.post(
      'Class/add?instructorId=$instructorId',
      data: classData,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Failed to add class: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> editClass(Map<String, dynamic> classData, int classId) async {
    final response = await dio.put(
      'Class/edit?id=$classId',
      data: classData,
    );

    if (response.statusCode == 200 || response.statusCode == 201){
      return Map<String, dynamic>.from(response.data);

    } else if (response.statusCode == 500) {
      var resp = Map<String, dynamic>.from(response.data);
      throw Exception(resp["error"]);

    } else{
      throw Exception('Failed to edit class: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> deleteClass(int classId) async {
    final response = await dio.delete(
      'Class/delete?id=$classId',
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Failed to delete class: ${response.data}');
    }
  }
}