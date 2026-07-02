
import 'package:core/dto/requests/edit_yoga_type_dto.dart';
import '../core/paging_defaults.dart';
import '../dto/requests/add_yoga_type_dto.dart';
import '../dto/responses/paged_response.dart';
import '../dto/responses/yoga_type_response_dto.dart';
import '../services/yoga-type_api_service.dart';


class YogaTypeRepository {
  final YogaTypeApiService api;

  YogaTypeRepository(this.api);

  Future<YogaTypeResponseDto> getYogaType(int id) async {
    final json = await api.getYogaTypeById(id);
    return YogaTypeResponseDto.fromJson(json);
  }

  Future<PagedResponse<YogaTypeResponseDto>> getAllYogaTypes({
    int page = PagingDefaults.firstPage,
    int pageSize = PagingDefaults.pageSize}) async {

    return api.getAllYogaTypes(page: page, pageSize: pageSize);
  }

  Future<PagedResponse<YogaTypeResponseDto>> getYogaTypeQuery(String? search, {
    int page = PagingDefaults.firstPage,
    int pageSize = PagingDefaults.pageSize}) async {
    return api.getAllYogaTypes(page: page, pageSize: pageSize);
  }

  Future<String> deleteYogaType(int? yogaTypeId) async {
    final json = await api.deleteYogaType(yogaTypeId!);
    return json.values.first;
  }

  Future<String> editYogaType(EditYogaTypeDto yogaType, int? yogaTypeId) async {
    final json =  await api.editYogaType(yogaType.toJson(), yogaTypeId!);
    return json.values.first;

  }

  Future<String> addYogaType(AddYogaTypeDto yogaType) async {
    final json =  await api.addYogaType(yogaType.toJson());
    return json.values.first;

  }





}