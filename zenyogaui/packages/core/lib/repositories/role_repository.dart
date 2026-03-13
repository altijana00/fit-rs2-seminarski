
import '../dto/responses/role_response_dto.dart';
import '../models/role_model.dart';
import '../services/role_api_service.dart';


class RoleRepository {
  final RoleApiService api;

  RoleRepository(this.api);

  Future<RoleResponseDto> getRole(int id) async {
    final json = await api.getRoleById(id);
    return RoleResponseDto.fromJson(json);
  }

  Future<List<RoleResponseDto>> getAllRoles() async {
    final List<dynamic> jsonList = await api.getAllRoles();
    return jsonList.map((json) => RoleResponseDto.fromJson(json)).toList();
  }

  Future<List<RoleResponseDto>> getRolesQuery(String? search) async {
    final List<dynamic> jsonList = await api.getRolesQuery(search);
    return jsonList.map((json) => RoleResponseDto.fromJson(json)).toList();
  }

  Future<String> deleteRole(int? roleId) async {
    final json = await api.deleteRole(roleId!);
    return json.values.first;
  }

}