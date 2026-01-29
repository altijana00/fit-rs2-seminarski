import 'package:dio/dio.dart';

class InstructorApiService {
  final Dio dio;

  InstructorApiService(this.dio);

  Future<List<Map<String, dynamic>>> getAllInstructors() async {
    final response = await dio.get('Instructor/getAll');
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Failed to fetch instructors: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> getById(int id) async {
    final response = await dio.get('Instructor/getById?id=$id');
    if(response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Falied to fetch instructor: ${response.data}');
    }
  }

  Future<List<Map<String, dynamic>>> getByStudioId(int studioId) async {
    final response = await dio.get('Instructor/getByStudioId?studioId=$studioId');
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else if (response.statusCode == 204) {
      return [];
    }
    else{
        throw Exception('Falied to fetch instructors: ${response.data}');
      }
  }


  Future<Map<String, dynamic>> addInstructor(Map<String, dynamic> instructorData, String instructorEmail ,int studioId) async {
      final response = await dio.post(
          'Instructor/add?email=$instructorEmail&studioId=$studioId',
          data: instructorData,
        options: Options(
          validateStatus: (status) => true,
        )
      );

      if (response.statusCode == 200 || response.statusCode == 201){
        return Map<String, dynamic>.from(response.data);

      } else if (response.statusCode == 500) {
        var resp = Map<String, dynamic>.from(response.data);
        throw Exception(resp["error"]);

      } else{
        throw Exception('Failed to add instructor: ${response.data}');
      }
  }

  Future<Map<String, dynamic>> deleteInstructor(int instructorId) async {
    final response = await dio.delete(
      'Instructor/delete?id=$instructorId',
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Failed to delete instructor: ${response.data}');
    }
  }
}




