import 'package:core/dto/responses/paged_response.dart';
import 'package:core/dto/responses/studio_response_dto.dart';
import 'package:core/dto/responses/user_classes_response_dto.dart';
import 'package:dio/dio.dart';

import '../core/paging_defaults.dart';

class UserClassApiService {
  final Dio dio;

  UserClassApiService(this.dio);

  Future<PagedResponse<UserClassesResponseDto>> getAllUserClasses({int page = PagingDefaults.firstPage,
    int pageSize = PagingDefaults.pageSize}) async {
    final response = await dio.get('UserClass/getAll',
        queryParameters:
        {
          'page': page,
          'pageSize': pageSize
        });
    if(response.statusCode == 200) {
      return PagedResponse<UserClassesResponseDto>.fromJson(
          response.data,
              (json) => UserClassesResponseDto.fromJson(json));
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
      throw Exception('Falied to fetch user classes: ${response.data}');
    }
  }

  Future<List<Map<String, dynamic>>> getByUserId(int userId) async {
    final response = await dio.get('UserClass/getByUserId?userId=$userId');
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
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
    } else if (response.statusCode == 204) {
      return [];
    }
    else {
      throw Exception('Falied to fetch user: ${response.data}');
    }
  }

  Future<List<Map<String, dynamic>>> getUserRecommendedStudios(int userId) async {
    final response = await dio.get('UserClass/getUserRecommendedStudios?id=$userId'
    );
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    }else if (response.statusCode == 204) {
      return [];
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
    }
    else {
      throw Exception('Falied to fetch recommended studios: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> join(int classId, int userId) async {
    final response = await dio.post('UserClass/join?classId=$classId&userId=$userId',
        options: Options(
          validateStatus: (status) => true,
        ));

    if (response.statusCode == 200 || response.statusCode == 201) {
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
    }

    else {
      throw Exception("error");

    }
  }

  Future<Map<String, dynamic>> deleteClass(int classId, int userId) async {
    final response = await dio.delete(
      'UserClass/deleteUserClass?classId=$classId&userId=$userId',
        options: Options(
          validateStatus: (status) => true,
        )
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
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
      throw Exception('Failed to delete class: ${response.data}');
    }
  }




}