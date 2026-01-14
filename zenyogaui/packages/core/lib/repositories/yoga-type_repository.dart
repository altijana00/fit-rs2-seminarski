
import '../dto/responses/yoga_type_response_dto.dart';
import '../models/yoga-type_model.dart';
import '../services/yoga-type_api_service.dart';


class YogaTypeRepository {
  final YogaTypeApiService api;

  YogaTypeRepository(this.api);

  Future<YogaTypeModel> getYogaType(int id) async {
    final json = await api.getYogaTypeById(id);
    return YogaTypeModel.fromJson(json);
  }

  Future<List<YogaTypeResponseDto>> getAllYogaTypes() async {
    final List<dynamic> jsonList = await api.getAllYogaTypes();
    return jsonList.map((json) => YogaTypeResponseDto.fromJson(json)).toList();
  }

}