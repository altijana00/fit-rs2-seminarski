
import '../models/role_model.dart';
import '../services/role_api_service.dart';


class RoleRepository {
  final RoleApiService api;

  RoleRepository(this.api);

  Future<RoleModel> getRole(int id) async {
    final json = await api.getRoleById(id);
    return RoleModel.fromJson(json);
  }

  Future<List<RoleModel>> getAllRoles() async {
    final List<dynamic> jsonList = await api.getAllRoles();
    return jsonList.map((json) => RoleModel.fromJson(json)).toList();
  }

}