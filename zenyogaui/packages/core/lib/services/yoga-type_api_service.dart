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

  Future<List<Map<String, dynamic>>> getYogaTypesQuery(String? search) async {
    final response = await dio.get('YogaType/getYogaTypesQuery',
      queryParameters: {
        if(search != null) 'search': search,
      },
    );
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Falied to fetch yoga types: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> deleteYogaType(int yogaTypeId) async {
    final response = await dio.delete(
      'YogaType/delete?id=$yogaTypeId',
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
      throw Exception('Failed to delete yoga type: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> editYogaType(Map<String, dynamic> yogaTypeData, int yogaTypeId) async {
    final response = await dio.put(
        'YogaType/edit?id=$yogaTypeId',
        data: yogaTypeData,
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
      throw Exception('Failed to edit yoga type: ${response.data}');
    }
  }


}