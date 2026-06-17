
import 'package:core/dto/responses/studio_response_dto.dart';
import 'package:core/dto/responses/user_classes_response_dto.dart';
import '../dto/responses/class_response_dto.dart';
import '../services/user_class_api_service.dart';

class UserClassRepository {
  final UserClassApiService api;

  UserClassRepository(this.api);


  Future<List<UserClassesResponseDto>> getAllUserClasses() async {
    final List<dynamic> jsonList = await api.getAllUserClasses();
    return jsonList.map((json) => UserClassesResponseDto.fromJson(json)).toList();
  }

  Future<List<ClassResponseDto>> getByUserId(int userId) async {
    final List<dynamic> jsonList = await api.getByUserId(userId);
    return jsonList.map((json) => ClassResponseDto.fromJson(json)).toList();
  }

  Future<List<StudioResponseDto>> getUserRecommendedStudios(int userId) async {
    final List<dynamic> jsonList = await api.getUserRecommendedStudios(userId);
    return jsonList.map((json) => StudioResponseDto.fromJson(json)).toList();
  }

  Future<String> join(int classId, int userId) async {
    final json = await api.join(classId, userId);
    return json.values.first;
  }

  Future<String> deleteClass(int classId, int userId) async {
    final json = await api.deleteClass(classId, userId);
    return json.values.first;
  }

}