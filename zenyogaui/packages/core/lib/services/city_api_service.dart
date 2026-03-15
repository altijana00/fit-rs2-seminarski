import 'package:core/dto/requests/edit_city_dto.dart';
import 'package:core/dto/responses/city_response_dto.dart';
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

  Future<List<Map<String, dynamic>>> getCitiesQuery(String? search) async {
    final response = await dio.get('City/getCitiesQuery',
      queryParameters: {
        if(search != null) 'search': search,
      },
    );
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Falied to fetch cities: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> deleteCity(int cityId) async {
    final response = await dio.delete(
      'City/delete?id=$cityId',
        options: Options(
          validateStatus: (status) => true,
        )
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(response.data);
    }  else if (response.statusCode == 500) {
      var resp = Map<String, dynamic>.from(response.data);
      throw Exception(resp["error"]);
    } else if (response.statusCode == 400) {
      throw (response.data["message"]);
    } else{
      throw Exception('Failed to edit city: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> editCity(Map<String, dynamic> cityData, int cityId) async {
    final response = await dio.put(
      'City/edit?id=$cityId',
      data: cityData,
        options: Options(
          validateStatus: (status) => true,
        )
    );

    if (response.statusCode == 200 || response.statusCode == 201){
      return response.data;

    } else if (response.statusCode == 500) {
      var resp = response.data;
      throw Exception(resp["error"]);

    } else{
      throw Exception('Failed to edit city: ${response.data}');
    }
  }


}