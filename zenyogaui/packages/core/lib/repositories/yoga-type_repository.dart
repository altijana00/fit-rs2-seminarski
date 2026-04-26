
import 'package:core/dto/requests/edit_yoga_type_dto.dart';

import '../dto/responses/yoga_type_response_dto.dart';
import '../models/yoga-type_model.dart';
import '../services/yoga-type_api_service.dart';


class YogaTypeRepository {
  final YogaTypeApiService api;

  YogaTypeRepository(this.api);

  Future<YogaTypeResponseDto> getYogaType(int id) async {
    final json = await api.getYogaTypeById(id);
    return YogaTypeResponseDto.fromJson(json);
  }

  Future<List<YogaTypeResponseDto>> getAllYogaTypes() async {
    final List<dynamic> jsonList = await api.getAllYogaTypes();
    return jsonList.map((json) => YogaTypeResponseDto.fromJson(json)).toList();
  }

  Future<List<YogaTypeResponseDto>> getYogaTypeQuery(String? search) async {
    final List<dynamic> jsonList = await api.getYogaTypesQuery(search);
    return jsonList.map((json) => YogaTypeResponseDto.fromJson(json)).toList();
  }

  Future<String> deleteYogaType(int? yogaTypeId) async {
    final json = await api.deleteYogaType(yogaTypeId!);
    return json.values.first;
  }

  Future<String> editYogaType(EditYogaTypeDto yogaType, int? yogaTypeId) async {
    final json =  await api.editYogaType(yogaType.toJson(), yogaTypeId!);
    return json.values.first;

  }





}