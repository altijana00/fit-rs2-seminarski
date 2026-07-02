import 'package:core/dto/responses/paged_response.dart';
import 'package:core/dto/responses/yoga_type_response_dto.dart';
import 'package:dio/dio.dart';

import '../core/paging_defaults.dart';

class YogaTypeApiService {
  final Dio dio;

  YogaTypeApiService(this.dio);

  Future<Map<String, dynamic>> getYogaTypeById(int id) async {
    final response = await dio.get('YogaType/getById?id=$id');
    if(response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    } else if (response.statusCode == 400) {
      final data = Map<String, dynamic>.from(response.data);

      if (data['message'] is List) {
        final messages = (data['message'] as List)
            .map((e) => e.toString())
            .join('\n');

        throw Exception(messages);
      }

      if (data['error'] != null) {
        throw Exception(data['error'].toString());
      }
      throw (response.data["message"]);
    } else {
      throw Exception('Falied to fetch yoga types: ${response.data}');
    }
  }

  Future<PagedResponse<YogaTypeResponseDto>> getAllYogaTypes({int page = PagingDefaults.firstPage,
    int pageSize = PagingDefaults.pageSize}) async {

    final response = await dio.get('YogaType/getAll',
    queryParameters:
      {
        'page': page,
        'pageSize': pageSize
      });
    if(response.statusCode == 200) {
      return PagedResponse<YogaTypeResponseDto>.fromJson(
          response.data,
              (json) => YogaTypeResponseDto.fromJson(json));
    } else if (response.statusCode == 400) {
      final data = Map<String, dynamic>.from(response.data);

      if (data['message'] is List) {
        final messages = (data['message'] as List)
            .map((e) => e.toString())
            .join('\n');

        throw Exception(messages);
      }

      if (data['error'] != null) {
        throw Exception(data['error'].toString());
      }
      throw (response.data["message"]);
    } else {
      throw Exception('Falied to fetch yoga types: ${response.data}');
    }
  }

  Future<PagedResponse<YogaTypeResponseDto>> getYogaTypesQuery(String? search, {int page = PagingDefaults.firstPage,
    int pageSize = PagingDefaults.pageSize}) async {
    final response = await dio.get('YogaType/getYogaTypesQuery',
      queryParameters: {
        if(search != null) 'search': search,
        'page': page,
        'pageSize': pageSize

      },
        options: Options(
          validateStatus: (status) => true,
        )
    );
    if(response.statusCode == 200) {
      return PagedResponse<YogaTypeResponseDto>.fromJson(
          response.data,
              (json) => YogaTypeResponseDto.fromJson(json));
    } else if (response.statusCode == 400) {
      final data = Map<String, dynamic>.from(response.data);

      if (data['message'] is List) {
        final messages = (data['message'] as List)
            .map((e) => e.toString())
            .join('\n');

        throw Exception(messages);
      }

      if (data['error'] != null) {
        throw Exception(data['error'].toString());
      }
      throw (response.data["message"]);
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
      final data = Map<String, dynamic>.from(response.data);

      if (data['message'] is List) {
        final messages = (data['message'] as List)
            .map((e) => e.toString())
            .join('\n');

        throw Exception(messages);
      }

      if (data['error'] != null) {
        throw Exception(data['error'].toString());
      }
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

    } else if (response.statusCode == 400) {
      final data = Map<String, dynamic>.from(response.data);

      if (data['message'] is List) {
        final messages = (data['message'] as List)
            .map((e) => e.toString())
            .join('\n');

        throw Exception(messages);
      }

      if (data['error'] != null) {
        throw Exception(data['error'].toString());
      }
      throw (response.data["message"]);
    } else if (response.statusCode == 500) {
      var resp = response.data;
      throw Exception(resp["error"]);

    } else{
      throw Exception('Failed to edit yoga type: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> addYogaType(Map<String, dynamic> yogaTypeData) async {
    final response = await dio.post(
        'YogaType/add',
        data: yogaTypeData,
        options: Options(
          validateStatus: (status) => true,
        )
    );

    if (response.statusCode == 200 || response.statusCode == 201){
      return response.data;

    } else if (response.statusCode == 400) {
      final data = Map<String, dynamic>.from(response.data);

      if (data['message'] is List) {
        final messages = (data['message'] as List)
            .map((e) => e.toString())
            .join('\n');

        throw Exception(messages);
      }

      if (data['error'] != null) {
        throw Exception(data['error'].toString());
      }
      throw (response.data["message"]);
    } else if (response.statusCode == 500) {
      var resp = response.data;
      throw Exception(resp["error"]);

    } else{
      throw Exception('Failed to add yoga type: ${response.data}');
    }
  }


}