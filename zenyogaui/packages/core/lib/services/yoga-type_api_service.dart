import 'package:dio/dio.dart';

class YogaTypeApiService {
  final Dio dio;

  YogaTypeApiService(this.dio);

  Future<Map<String, dynamic>> getYogaTypeById(int id) async {
    final response = await dio.get('YogaType/getById?id=$id');
    if(response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Falied to fetch yoga types: ${response.data}');
    }
  }

  Future<List<Map<String, dynamic>>> getAllYogaTypes() async {
    final response = await dio.get('YogaType/getAll');
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Falied to fetch yoga types: ${response.data}');
    }
  }


}