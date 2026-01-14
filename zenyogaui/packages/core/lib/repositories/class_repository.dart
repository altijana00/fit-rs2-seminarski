
import 'package:core/dto/responses/groupped_classes.dart';

import '../dto/requests/add_class_dto.dart';
import '../dto/requests/edit_class_dto.dart';
import '../dto/responses/class_response_dto.dart';
import '../services/class_api_service.dart';


class ClassRepository {
  final ClassApiService api;

  ClassRepository(this.api);

  Future<List<ClassResponseDto>> getByInstructorId(int id, {String? search, int? yogaTypeId}) async {
    final List<dynamic> jsonList = await api.getByInstructorId(id, search: search, yogaTypeId: yogaTypeId);
    return jsonList.map((json) => ClassResponseDto.fromJson(json)).toList();
  }

  Future<GrouppedClasses> getStudioGroupped(int studioId) async {
    final json = await api.getStudioGroupped(studioId);
    return GrouppedClasses.fromJson(json);
  }
  Future<String> addClass(AddClassDto addClassDto, int instructorId) async {
    final json = await api.addClass(addClassDto.toJson(), instructorId);
    return json.values.first;
  }

  Future<String> editClass(EditClassDto classModel, int? classId) async {
    final json = await api.editClass(classModel.toJson(), classId!);
    return json.values.first;
  }

  Future<String> deleteClass(int? classId) async {
    final json = await api.deleteClass(classId!);
    return json.values.first;
  }
}