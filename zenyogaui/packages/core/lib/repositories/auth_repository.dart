import '../models/user_login_model.dart';

import '../services/auth_api_service.dart';

class AuthRepository {
  final AuthApiService api;

  AuthRepository(this.api);

  Future<UserLoginModel> login(String email, String password) async {
    final json = await api.login(email, password);
    return UserLoginModel.fromJson(json);
  }




}