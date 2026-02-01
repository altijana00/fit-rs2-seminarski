
import 'package:core/dto/responses/instructor_response_dto.dart';

import '../dto/requests/add_instructor_dto.dart';
import '../dto/requests/edit_instructor_dto.dart';
import '../models/instructor_model.dart';
import '../services/instructor_api_service.dart';


class InstructorRepository {
  final InstructorApiService api;

  InstructorRepository(this.api);

  Future<List<InstructorResponseDto>> getAllInstructors() async {
    final List<dynamic> jsonList = await api.getAllInstructors();
    return jsonList.map((json) => InstructorResponseDto.fromJson(json)).toList();
  }

  Future<List<InstructorResponseDto>> getByStudioId(int studioId) async {
    final List<dynamic> jsonList = await api.getByStudioId(studioId);
    return jsonList.map((json) => InstructorResponseDto.fromJson(json)).toList();
  }

  Future<InstructorResponseDto> getById(int id) async {
    final json = await api.getById(id);
    return InstructorResponseDto.fromJson(json);
  }

  Future<String> addInstructor(AddInstructorDto addInstructorModelDto, String email, int studioId) async {

      final json = await api.addInstructor(
          addInstructorModelDto.toJson(), email, studioId);
      return json.values.first;
  }

  Future<String> deleteInstructor(int? instructorId) async {
    final json = await api.deleteInstructor(instructorId!);
    return json.values.first;
  }

  Future<String> editInstructor(EditInstructorDto instructor, int instructorId) async {
    final json = await api.editInstructor(instructor.toJson(), instructorId);
    return json.values.first;
  }

}