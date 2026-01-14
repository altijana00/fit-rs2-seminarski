import 'package:dio/dio.dart';

class CityApiService {
  final Dio dio;

  CityApiService(this.dio);

  Future<Map<String, dynamic>> getCityById(int id) async {
    final response = await dio.get('City/getById?id=$id');
    if(response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Falied to fetch city: ${response.data}');
    }
  }

  Future<List<Map<String, dynamic>>> getAllCities() async {
    final response = await dio.get('City/getAll');
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Falied to fetch cities: ${response.data}');
    }
  }


}